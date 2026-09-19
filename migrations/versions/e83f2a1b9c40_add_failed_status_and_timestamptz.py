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
    # 1. Add failure_reason to stock_reservations
    op.add_column('stock_reservations', sa.Column('failure_reason', sa.String(length=255), nullable=True))

    # 2. Update status check constraint to include FAILED
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

    # 3. Drop failure_reason column
    op.drop_column('stock_reservations', 'failure_reason')
