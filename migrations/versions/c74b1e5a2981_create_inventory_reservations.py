"""create_inventory_reservations

Revision ID: c74b1e5a2981
Revises: 3b98a300aa73
Create Date: 2026-09-19 12:45:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'c74b1e5a2981'
down_revision: Union[str, Sequence[str], None] = '3b98a300aa73'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema - add reserved_quantity to inventory and create reservation tables."""
    # 1. Add reserved_quantity to inventory with default and constraints
    op.add_column(
        'inventory',
        sa.Column('reserved_quantity', sa.Integer(), server_default='0', nullable=False)
    )
    op.create_check_constraint(
        'chk_inventory_reserved_non_negative',
        'inventory',
        'reserved_quantity >= 0'
    )
    op.create_check_constraint(
        'chk_inventory_reserved_le_on_hand',
        'inventory',
        'reserved_quantity <= quantity_on_hand'
    )
    op.create_check_constraint(
        'chk_inventory_quantity_on_hand_non_negative',
        'inventory',
        'quantity_on_hand >= 0'
    )

    # 2. Create stock_reservations table
    op.create_table(
        'stock_reservations',
        sa.Column('reservation_id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('operation_id', sa.String(length=100), nullable=False),
        sa.Column('request_fingerprint', sa.String(length=64), nullable=False),
        sa.Column('status', sa.String(length=20), nullable=False),
        sa.Column('expires_at', sa.DateTime(), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.PrimaryKeyConstraint('reservation_id'),
        sa.UniqueConstraint('operation_id', name='uq_stock_reservations_operation_id'),
        sa.CheckConstraint(
            "status IN ('ACTIVE', 'CONFIRMED', 'RELEASED', 'EXPIRED')",
            name='chk_stock_reservations_status'
        )
    )
    op.create_index(
        'ix_stock_reservations_status_expires',
        'stock_reservations',
        ['status', 'expires_at']
    )

    # 3. Create stock_reservation_items table with restrictive referential integrity
    op.create_table(
        'stock_reservation_items',
        sa.Column('reservation_item_id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('reservation_id', sa.Integer(), nullable=False),
        sa.Column('product_id', sa.Integer(), nullable=False),
        sa.Column('warehouse_id', sa.Integer(), nullable=False),
        sa.Column('quantity', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.PrimaryKeyConstraint('reservation_item_id'),
        sa.ForeignKeyConstraint(
            ['reservation_id'],
            ['stock_reservations.reservation_id'],
            ondelete='CASCADE',
            name='fk_reservation_items_reservation'
        ),
        sa.ForeignKeyConstraint(
            ['product_id', 'warehouse_id'],
            ['inventory.product_id', 'inventory.warehouse_id'],
            ondelete='RESTRICT',
            name='fk_reservation_items_inventory'
        ),
        sa.CheckConstraint('quantity > 0', name='chk_reservation_item_quantity_positive')
    )
    op.create_index(
        'ix_reservation_items_reservation_id',
        'stock_reservation_items',
        ['reservation_id']
    )
    op.create_index(
        'ix_reservation_items_inventory',
        'stock_reservation_items',
        ['product_id', 'warehouse_id']
    )


def downgrade() -> None:
    """Downgrade schema - remove reservation tables and reserved_quantity if safe.
    
    Fail-closed preconditions:
    - Rejects downgrade if any stock_reservations record exists (prevents audit loss).
    - Rejects downgrade if any stock_reservation_items record exists.
    - Rejects downgrade if any inventory record has non-zero reserved_quantity.
    """
    bind = op.get_bind()

    # Precondition 1: Reject if any reservation history exists in stock_reservations
    has_reservations = bind.execute(
        sa.text("SELECT COUNT(*) FROM stock_reservations")
    ).scalar()
    if has_reservations and has_reservations > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot downgrade migration c74b1e5a2981 because {has_reservations} "
            "reservation record(s) exist in stock_reservations. Downgrading would permanently destroy "
            "reservation history. Data preservation policy prohibits dropping tables containing data. "
            "Downgrade is aborted to protect data integrity."
        )

    # Precondition 2: Reject if any reservation items exist
    has_items = bind.execute(
        sa.text("SELECT COUNT(*) FROM stock_reservation_items")
    ).scalar()
    if has_items and has_items > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot downgrade migration c74b1e5a2981 because {has_items} "
            "reservation item(s) exist in stock_reservation_items. Downgrading would permanently destroy "
            "reservation item history. Downgrade is aborted to protect data integrity."
        )

    # Precondition 3: Reject if any inventory record has non-zero reserved_quantity
    has_nonzero_reserved = bind.execute(
        sa.text("SELECT COUNT(*) FROM inventory WHERE reserved_quantity > 0")
    ).scalar()
    if has_nonzero_reserved and has_nonzero_reserved > 0:
        raise RuntimeError(
            f"Precondition failed: Cannot downgrade migration c74b1e5a2981 because {has_nonzero_reserved} "
            "inventory record(s) have non-zero reserved_quantity. Downgrading would drop the reserved_quantity "
            "column and silently lose active inventory holds. Downgrade is aborted to protect data integrity."
        )

    # All preconditions passed: safe to remove tables and column
    op.drop_index('ix_reservation_items_inventory', table_name='stock_reservation_items')
    op.drop_index('ix_reservation_items_reservation_id', table_name='stock_reservation_items')
    op.drop_table('stock_reservation_items')

    op.drop_index('ix_stock_reservations_status_expires', table_name='stock_reservations')
    op.drop_table('stock_reservations')

    op.drop_constraint('chk_inventory_quantity_on_hand_non_negative', 'inventory', type_='check')
    op.drop_constraint('chk_inventory_reserved_le_on_hand', 'inventory', type_='check')
    op.drop_constraint('chk_inventory_reserved_non_negative', 'inventory', type_='check')
    op.drop_column('inventory', 'reserved_quantity')

