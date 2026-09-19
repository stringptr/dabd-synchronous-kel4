import os
import sys
from logging.config import fileConfig
from sqlalchemy import engine_from_config
from sqlalchemy import pool
from alembic import context
from dotenv import load_dotenv

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
load_dotenv(os.path.join(os.path.dirname(__file__), '..', '.env'))

from auth_service.main import Base as AuthBase
from product_service.main import Base as ProductBase
from order_service.main import Base as OrderBase

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

from sqlalchemy import MetaData
target_metadata = MetaData()
for m in [AuthBase.metadata, ProductBase.metadata, OrderBase.metadata]:
    for t_name, t in m.tables.items():
        if t_name not in target_metadata.tables:
            t.to_metadata(target_metadata)

def get_url():
    user = os.getenv('POSTGRES_USER', 'postgres')
    password = os.getenv('POSTGRES_PASSWORD', 'postgres')
    host = os.getenv('DB_HOST', '127.0.0.1')
    port = os.getenv('DB_PORT', '5433')
    db = os.getenv('POSTGRES_DB', 'postgres')
    return f'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}'

def include_object(object, name, type_, reflected, compare_to):
    if type_ == "table" and reflected and compare_to is None:
        return False
    return True

def run_migrations_offline() -> None:
    url = get_url()
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        include_object=include_object,
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    configuration = config.get_section(config.config_ini_section)
    configuration['sqlalchemy.url'] = get_url()
    connectable = engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection, 
            target_metadata=target_metadata,
            include_object=include_object
        )
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()