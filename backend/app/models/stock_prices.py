"""Stock prices model."""
from sqlalchemy import Column, BigInteger, String, Numeric, DateTime, UniqueConstraint, Index
from sqlalchemy.sql import func
from app.database import Base


class StockPrice(Base):
    """Historical stock price data."""
    
    __tablename__ = "stock_prices"
    
    id = Column(BigInteger, primary_key=True, index=True)
    symbol = Column(String(10), nullable=False, index=True)
    timestamp = Column(DateTime(timezone=True), nullable=False, index=True)
    open = Column(Numeric(10, 2), nullable=False)
    high = Column(Numeric(10, 2), nullable=False)
    low = Column(Numeric(10, 2), nullable=False)
    close = Column(Numeric(10, 2), nullable=False)
    volume = Column(BigInteger, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    __table_args__ = (
        UniqueConstraint('symbol', 'timestamp', name='uq_stock_prices_symbol_timestamp'),
        Index('idx_stock_prices_symbol_timestamp', 'symbol', 'timestamp'),
    )
    
    def __repr__(self):
        return f"<StockPrice(symbol={self.symbol}, timestamp={self.timestamp}, close={self.close})>"

