"""create_carts_and_cart_items

Revision ID: 3b98a300aa73
Revises: cf95d0e3a541
Create Date: 2026-09-18 22:41:50.288879

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '3b98a300aa73'
down_revision: Union[str, Sequence[str], None] = 'cf95d0e3a541'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema - create carts and cart_items."""
    op.create_table(
        'carts',
        sa.Column('cart_id', sa.Integer(), nullable=False),
        sa.Column('user_id', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=True),
        sa.Column('updated_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('cart_id'),
        sa.UniqueConstraint('user_id', name='uq_carts_user_id')
    )
    op.create_table(
        'cart_items',
        sa.Column('cart_item_id', sa.Integer(), nullable=False),
        sa.Column('cart_id', sa.Integer(), nullable=False),
        sa.Column('product_id', sa.Integer(), nullable=False),
        sa.Column('quantity', sa.Integer(), nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=True),
        sa.CheckConstraint('quantity > 0', name='chk_cart_item_quantity_positive'),
        sa.ForeignKeyConstraint(['cart_id'], ['carts.cart_id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['product_id'], ['products.product_id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('cart_item_id'),
        sa.UniqueConstraint('cart_id', 'product_id', name='uq_cart_product')
    )


def downgrade() -> None:
    """Downgrade schema - drop cart_items and carts."""
    op.drop_table('cart_items')
    op.drop_table('carts')
    # ### end Alembic commands ###
