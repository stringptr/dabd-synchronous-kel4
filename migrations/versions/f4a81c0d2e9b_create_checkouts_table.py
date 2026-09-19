"""create checkouts table for durable checkout orchestration

Revision ID: f4a81c0d2e9b
Revises: e83f2a1b9c40
Create Date: 2026-09-19 16:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = 'f4a81c0d2e9b'
down_revision: Union[str, None] = 'e83f2a1b9c40'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Create checkouts table
    op.create_table(
        'checkouts',
        sa.Column('checkout_id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('operation_id', sa.String(length=64), nullable=False),
        sa.Column('idempotency_key', sa.String(length=128), nullable=False),
        sa.Column('request_fingerprint', sa.String(length=64), nullable=False),
        sa.Column('reservation_op_id', sa.String(length=64), nullable=False),
        sa.Column('status', sa.String(length=32), nullable=False),
        sa.Column('order_id', sa.Integer(), nullable=True),
        sa.Column('total_amount', sa.Numeric(precision=10, scale=2), nullable=False),
        sa.Column('items_snapshot', postgresql.JSONB(astext_type=sa.Text()), nullable=False),
        sa.Column('failure_code', sa.String(length=64), nullable=True),
        sa.Column('failure_reason', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.DateTime(timezone=True), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ondelete='RESTRICT', name='fk_checkouts_user'),
        sa.ForeignKeyConstraint(['order_id'], ['orders.order_id'], ondelete='SET NULL', name='fk_checkouts_order'),
        sa.PrimaryKeyConstraint('checkout_id', name='pk_checkouts'),
        sa.UniqueConstraint('operation_id', name='uq_checkouts_operation_id'),
        sa.UniqueConstraint('reservation_op_id', name='uq_checkouts_reservation_op_id'),
        sa.UniqueConstraint('user_id', 'idempotency_key', name='uq_checkouts_user_idempotency'),
        sa.UniqueConstraint('order_id', name='uq_checkouts_order_id'),
        sa.CheckConstraint(
            "status IN ('INITIATED', 'RESERVING', 'RESERVED', 'UNKNOWN', 'FAILED', 'COMPENSATION_REQUIRED', 'CANCELLED')",
            name='chk_checkouts_status'
        ),
        sa.CheckConstraint('total_amount >= 0', name='chk_checkouts_total_positive')
    )

    op.create_index('ix_checkouts_user_id', 'checkouts', ['user_id'], unique=False)
    op.create_index('ix_checkouts_operation_id', 'checkouts', ['operation_id'], unique=False)
    op.create_index('ix_checkouts_reservation_op_id', 'checkouts', ['reservation_op_id'], unique=False)
    op.create_index('ix_checkouts_status', 'checkouts', ['status'], unique=False)

    # Synchronize serial sequences with existing maximum IDs to ensure safe auto-increment
    op.execute("SELECT setval('orders_order_id_seq', (SELECT COALESCE(MAX(order_id), 1) FROM orders))")
    op.execute("SELECT setval('order_items_order_item_id_seq', (SELECT COALESCE(MAX(order_item_id), 1) FROM order_items))")
    op.execute("SELECT setval('carts_cart_id_seq', (SELECT COALESCE(MAX(cart_id), 1) FROM carts))")
    op.execute("SELECT setval('cart_items_cart_item_id_seq', (SELECT COALESCE(MAX(cart_item_id), 1) FROM cart_items))")
    op.execute("SELECT setval('products_product_id_seq', (SELECT COALESCE(MAX(product_id), 1) FROM products))")


def downgrade() -> None:
    """Safe downgrade of f4a81c0d2e9b.
    
    Fail-closed downgrade safety:
    Rejects downgrade if ANY checkout records exist in the table, preserving
    all durable checkout audit history.
    """
    bind = op.get_bind()

    total_checkouts = bind.execute(
        sa.text("SELECT COUNT(*) FROM checkouts")
    ).scalar()

    if total_checkouts and total_checkouts > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot safely downgrade f4a81c0d2e9b because {total_checkouts} checkout "
            "audit record(s) exist in 'checkouts'. Downgrade aborted to prevent loss of durable checkout history."
        )

    op.drop_index('ix_checkouts_status', table_name='checkouts')
    op.drop_index('ix_checkouts_reservation_op_id', table_name='checkouts')
    op.drop_index('ix_checkouts_operation_id', table_name='checkouts')
    op.drop_index('ix_checkouts_user_id', table_name='checkouts')
    op.drop_table('checkouts')
