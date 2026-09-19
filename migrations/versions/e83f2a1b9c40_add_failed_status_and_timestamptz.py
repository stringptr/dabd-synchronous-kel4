"""add failed status failure_reason and timestamptz

Revision ID: e83f2a1b9c40
Revises: c74b1e5a2981
Create Date: 2026-09-19 13:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e83f2a1b9c40'
down_revision: Union[str, None] = 'c74b1e5a2981'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # 1. Add failure_code and failure_reason to stock_reservations
    op.add_column('stock_reservations', sa.Column('failure_code', sa.String(length=50), nullable=True))
    op.add_column('stock_reservations', sa.Column('failure_reason', sa.String(length=255), nullable=True))

    # 2. Update status check constraint to include PENDING and FAILED
    op.drop_constraint('chk_stock_reservations_status', 'stock_reservations', type_='check')
    op.create_check_constraint(
        'chk_stock_reservations_status',
        'stock_reservations',
        "status IN ('PENDING', 'ACTIVE', 'CONFIRMED', 'RELEASED', 'EXPIRED', 'FAILED')"
    )

    # 3. Convert timestamp columns to TIMESTAMP WITH TIME ZONE using explicit UTC conversion
    op.execute("ALTER TABLE stock_reservations ALTER COLUMN expires_at TYPE TIMESTAMP WITH TIME ZONE USING expires_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE stock_reservations ALTER COLUMN created_at TYPE TIMESTAMP WITH TIME ZONE USING created_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE stock_reservations ALTER COLUMN updated_at TYPE TIMESTAMP WITH TIME ZONE USING updated_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE stock_reservation_items ALTER COLUMN created_at TYPE TIMESTAMP WITH TIME ZONE USING created_at AT TIME ZONE 'UTC'")


def downgrade() -> None:
    """Safe downgrade of e83f2a1b9c40.
    
    Supported downgrade conditions:
    - Allowed ONLY when stock_reservations contains NO records with status 'PENDING' or 'FAILED'.
    - If incompatible records exist, this downgrade aborts immediately without modifying
      tables, deleting records, or rewriting reservation history.
    """
    bind = op.get_bind()

    # Precondition check: verify no incompatible status values exist
    incompatible_count = bind.execute(
        sa.text("SELECT COUNT(*) FROM stock_reservations WHERE status IN ('PENDING', 'FAILED')")
    ).scalar()

    if incompatible_count and incompatible_count > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot safely downgrade e83f2a1b9c40 because stock_reservations contains "
            f"{incompatible_count} record(s) with status 'PENDING' or 'FAILED'. "
            "Reverting to check constraint ('ACTIVE', 'CONFIRMED', 'RELEASED', 'EXPIRED') on populated "
            "data would cause a constraint violation or require destructive data loss. "
            "Downgrade is aborted to protect data integrity."
        )

    # 1. Convert timestamp columns back to TIMESTAMP WITHOUT TIME ZONE
    op.execute("ALTER TABLE stock_reservation_items ALTER COLUMN created_at TYPE TIMESTAMP WITHOUT TIME ZONE USING created_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE stock_reservations ALTER COLUMN updated_at TYPE TIMESTAMP WITHOUT TIME ZONE USING updated_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE stock_reservations ALTER COLUMN created_at TYPE TIMESTAMP WITHOUT TIME ZONE USING created_at AT TIME ZONE 'UTC'")
    op.execute("ALTER TABLE stock_reservations ALTER COLUMN expires_at TYPE TIMESTAMP WITHOUT TIME ZONE USING expires_at AT TIME ZONE 'UTC'")

    # 2. Revert status check constraint
    op.drop_constraint('chk_stock_reservations_status', 'stock_reservations', type_='check')
    op.create_check_constraint(
        'chk_stock_reservations_status',
        'stock_reservations',
        "status IN ('ACTIVE', 'CONFIRMED', 'RELEASED', 'EXPIRED')"
    )

    # 3. Drop failure_reason and failure_code columns
    op.drop_column('stock_reservations', 'failure_reason')
    op.drop_column('stock_reservations', 'failure_code')
