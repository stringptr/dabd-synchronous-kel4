"""create payment_attempts, order_cancellations and add lease/expiry to checkouts

Revision ID: b2e4f6a8c0d2
Revises: f4a81c0d2e9b
Create Date: 2026-09-19 22:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = 'b2e4f6a8c0d2'
down_revision: Union[str, None] = 'f4a81c0d2e9b'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Update checkouts table with lease, backoff, and expiration tracking
    op.add_column('checkouts', sa.Column('reservation_expires_at', sa.DateTime(timezone=True), nullable=True))
    op.add_column('checkouts', sa.Column('lease_worker_id', sa.String(length=64), nullable=True))
    op.add_column('checkouts', sa.Column('lease_expires_at', sa.DateTime(timezone=True), nullable=True))
    op.add_column('checkouts', sa.Column('reconcile_attempts', sa.Integer(), server_default='0', nullable=False))
    op.add_column('checkouts', sa.Column('next_reconcile_at', sa.DateTime(timezone=True), nullable=True))

    op.create_index('ix_checkouts_reservation_expires_at', 'checkouts', ['reservation_expires_at'], unique=False)
    op.create_index('ix_checkouts_next_reconcile_at', 'checkouts', ['next_reconcile_at'], unique=False)

    # Update checkouts status check constraint to include 'COMPLETED'
    op.drop_constraint('chk_checkouts_status', 'checkouts', type_='check')
    op.create_check_constraint(
        'chk_checkouts_status',
        'checkouts',
        "status IN ('INITIATED', 'RESERVING', 'RESERVED', 'UNKNOWN', 'FAILED', 'COMPENSATION_REQUIRED', 'CANCELLED', 'COMPLETED')"
    )

    # 2. Create payment_attempts table
    op.create_table(
        'payment_attempts',
        sa.Column('attempt_id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('order_id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('operation_id', sa.String(length=64), nullable=False),
        sa.Column('idempotency_key', sa.String(length=128), nullable=False),
        sa.Column('request_fingerprint', sa.String(length=64), nullable=False),
        sa.Column('amount', sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column('method', sa.String(length=32), nullable=False),
        sa.Column('simulated_outcome', sa.String(length=32), server_default='SUCCESS', nullable=False),
        sa.Column('status', sa.String(length=32), nullable=False),
        sa.Column('stage', sa.String(length=32), server_default='INITIATED', nullable=False),
        sa.Column('failure_code', sa.String(length=64), nullable=True),
        sa.Column('failure_reason', sa.Text(), nullable=True),
        sa.Column('lease_worker_id', sa.String(length=64), nullable=True),
        sa.Column('lease_expires_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('reconcile_attempts', sa.Integer(), server_default='0', nullable=False),
        sa.Column('next_reconcile_at', sa.DateTime(timezone=True), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.PrimaryKeyConstraint('attempt_id', name='pk_payment_attempts'),
        sa.ForeignKeyConstraint(['order_id'], ['orders.order_id'], ondelete='RESTRICT', name='fk_payment_attempts_order'),
        sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ondelete='RESTRICT', name='fk_payment_attempts_user'),
        sa.UniqueConstraint('operation_id', name='uq_payment_attempts_operation_id'),
        sa.UniqueConstraint('order_id', 'idempotency_key', name='uq_payment_attempts_order_idempotency'),
        sa.CheckConstraint('amount >= 0', name='chk_payment_attempts_amount'),
        sa.CheckConstraint("method IN ('Credit Card', 'PayPal', 'Bank Transfer', 'Gift Card')", name='chk_payment_attempts_method'),
        sa.CheckConstraint("simulated_outcome IN ('SUCCESS', 'DECLINE', 'TIMEOUT')", name='chk_payment_attempts_outcome'),
        sa.CheckConstraint(
            "status IN ('INITIATED', 'PROCESSING', 'CONFIRMING', 'SUCCEEDED', 'FAILED', 'UNKNOWN', 'EXPIRED')",
            name='chk_payment_attempts_status'
        ),
        sa.CheckConstraint(
            "stage IN ('INITIATED', 'SIMULATED_DECLINE', 'CONFIRM_NOT_SENT', 'CONFIRM_IN_FLIGHT', 'CONFIRM_VERIFIED', 'LOCAL_FINALIZE_PENDING', 'FINALIZED')",
            name='chk_payment_attempts_stage'
        )
    )

    op.create_index('ix_payment_attempts_order_id', 'payment_attempts', ['order_id'], unique=False)
    op.create_index('ix_payment_attempts_user_id', 'payment_attempts', ['user_id'], unique=False)
    op.create_index('ix_payment_attempts_operation_id', 'payment_attempts', ['operation_id'], unique=False)
    op.create_index('ix_payment_attempts_status', 'payment_attempts', ['status'], unique=False)
    op.create_index('ix_payment_attempts_next_reconcile_at', 'payment_attempts', ['next_reconcile_at'], unique=False)

    # 3. Create order_cancellations table
    op.create_table(
        'order_cancellations',
        sa.Column('cancellation_id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('order_id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('operation_id', sa.String(length=64), nullable=False),
        sa.Column('idempotency_key', sa.String(length=128), nullable=False),
        sa.Column('request_fingerprint', sa.String(length=64), nullable=False),
        sa.Column('status', sa.String(length=32), nullable=False),
        sa.Column('reason', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.PrimaryKeyConstraint('cancellation_id', name='pk_order_cancellations'),
        sa.ForeignKeyConstraint(['order_id'], ['orders.order_id'], ondelete='RESTRICT', name='fk_order_cancellations_order'),
        sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ondelete='RESTRICT', name='fk_order_cancellations_user'),
        sa.UniqueConstraint('order_id', name='uq_order_cancellations_order_id'),
        sa.UniqueConstraint('user_id', 'idempotency_key', name='uq_order_cancellations_user_idempotency'),
        sa.UniqueConstraint('operation_id', name='uq_order_cancellations_operation_id'),
        sa.CheckConstraint("status IN ('PROCESSING', 'SUCCEEDED', 'FAILED', 'UNKNOWN')", name='chk_order_cancellations_status')
    )

    op.create_index('ix_order_cancellations_order_id', 'order_cancellations', ['order_id'], unique=False)
    op.create_index('ix_order_cancellations_user_id', 'order_cancellations', ['user_id'], unique=False)


def downgrade() -> None:
    """Fail-closed downgrade safety:
    Rejects downgrade if ANY payment_attempts, order_cancellations, or COMPLETED checkouts exist.
    """
    bind = op.get_bind()

    pa_count = bind.execute(sa.text("SELECT COUNT(*) FROM payment_attempts")).scalar()
    if pa_count and pa_count > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot safely downgrade b2e4f6a8c0d2 because {pa_count} payment_attempt "
            "record(s) exist. Downgrade aborted to protect payment audit history."
        )

    canc_count = bind.execute(sa.text("SELECT COUNT(*) FROM order_cancellations")).scalar()
    if canc_count and canc_count > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot safely downgrade b2e4f6a8c0d2 because {canc_count} order_cancellation "
            "record(s) exist. Downgrade aborted to protect cancellation audit history."
        )

    completed_count = bind.execute(
        sa.text("SELECT COUNT(*) FROM checkouts WHERE status = 'COMPLETED'")
    ).scalar()
    if completed_count and completed_count > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot safely downgrade b2e4f6a8c0d2 because {completed_count} checkout(s) "
            "with status 'COMPLETED' exist. Downgrade aborted to protect checkout audit history."
        )

    # Drop order_cancellations
    op.drop_index('ix_order_cancellations_user_id', table_name='order_cancellations')
    op.drop_index('ix_order_cancellations_order_id', table_name='order_cancellations')
    op.drop_table('order_cancellations')

    # Drop payment_attempts
    op.drop_index('ix_payment_attempts_next_reconcile_at', table_name='payment_attempts')
    op.drop_index('ix_payment_attempts_status', table_name='payment_attempts')
    op.drop_index('ix_payment_attempts_operation_id', table_name='payment_attempts')
    op.drop_index('ix_payment_attempts_user_id', table_name='payment_attempts')
    op.drop_index('ix_payment_attempts_order_id', table_name='payment_attempts')
    op.drop_table('payment_attempts')

    # Revert checkouts check constraint
    op.drop_constraint('chk_checkouts_status', 'checkouts', type_='check')
    op.create_check_constraint(
        'chk_checkouts_status',
        'checkouts',
        "status IN ('INITIATED', 'RESERVING', 'RESERVED', 'UNKNOWN', 'FAILED', 'COMPENSATION_REQUIRED', 'CANCELLED')"
    )

    # Drop checkouts lease and expiration columns and indexes
    op.drop_index('ix_checkouts_next_reconcile_at', table_name='checkouts')
    op.drop_index('ix_checkouts_reservation_expires_at', table_name='checkouts')
    op.drop_column('checkouts', 'next_reconcile_at')
    op.drop_column('checkouts', 'reconcile_attempts')
    op.drop_column('checkouts', 'lease_expires_at')
    op.drop_column('checkouts', 'lease_worker_id')
    op.drop_column('checkouts', 'reservation_expires_at')
