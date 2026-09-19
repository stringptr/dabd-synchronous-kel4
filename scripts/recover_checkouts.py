"""Operational CLI tool for recovering incomplete Stage 2C checkouts."""

import os
import sys
import argparse
import logging
from datetime import datetime, timezone
from decimal import Decimal
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')
logger = logging.getLogger("recover_checkouts")

# Add parent directory to path so order_service can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

# Ensure INTERNAL_API_KEY is present
if not os.getenv("INTERNAL_API_KEY"):
    os.environ["INTERNAL_API_KEY"] = "testinternal"

try:
    from order_service.main import (
        Checkout, Order, OrderItem, Cart, CartItemModel, 
        recover_single_checkout, SessionLocal, engine
    )
except ImportError as e:
    logger.error(f"Failed to import order_service: {e}")
    sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Durable Checkout Recovery Tool")
    parser.add_argument("--checkout-id", type=int, help="Specific checkout ID to recover", default=None)
    parser.add_argument("--db-url", type=str, help="Database connection URL", default=None)
    args = parser.parse_args()

    active_engine = engine
    if args.db_url:
        active_engine = create_engine(args.db_url)
    
    Session = sessionmaker(bind=active_engine)
    db = Session()

    logger.info("Starting Stage 2C Checkout Recovery pass...")

    try:
        if args.checkout_id:
            chk = db.query(Checkout).filter(Checkout.checkout_id == args.checkout_id).first()
            if not chk:
                logger.error(f"Checkout {args.checkout_id} not found.")
                sys.exit(1)
            logger.info(f"Recovering checkout {chk.checkout_id} (current status: {chk.status})...")
            rec = recover_single_checkout(db, chk.checkout_id)
            logger.info(f"Result: checkout {rec.checkout_id} resolved to status '{rec.status}' (order_id={rec.order_id})")
        else:
            pending = db.query(Checkout).filter(
                Checkout.status.in_(["INITIATED", "RESERVING", "UNKNOWN", "COMPENSATION_REQUIRED"])
            ).all()

            if not pending:
                logger.info("No dangling or unresolved checkouts found. System is fully reconciled.")
                return

            logger.info(f"Found {len(pending)} checkout(s) requiring recovery.")
            for chk in pending:
                try:
                    logger.info(f"Processing checkout {chk.checkout_id} (status: {chk.status}, op: {chk.operation_id})...")
                    rec = recover_single_checkout(db, chk.checkout_id)
                    logger.info(f"Checkout {rec.checkout_id} successfully resolved to '{rec.status}' (order_id={rec.order_id})")
                except Exception as e:
                    logger.error(f"Failed to recover checkout {chk.checkout_id}: {e}")

        logger.info("Checkout recovery pass completed.")
    finally:
        db.close()

if __name__ == "__main__":
    main()
