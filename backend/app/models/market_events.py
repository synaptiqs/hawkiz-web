"""Market events model."""
from sqlalchemy import Column, BigInteger, String, Date, Text, DateTime, Index
from sqlalchemy.sql import func
from app.database import Base


class MarketEvent(Base):
    """Market events (earnings, dividends, splits, etc.)."""
    
    __tablename__ = "market_events"
    
    id = Column(BigInteger, primary_key=True, index=True)
    symbol = Column(String(10), nullable=False, index=True)
    event_date = Column(Date, nullable=False, index=True)
    event_type = Column(String(50), nullable=False)  # 'EARNINGS', 'DIVIDEND', 'SPLIT', etc.
    description = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    __table_args__ = (
        Index('idx_market_events_symbol_date', 'symbol', 'event_date'),
    )
    
    def __repr__(self):
        return f"<MarketEvent(symbol={self.symbol}, type={self.event_type}, date={self.event_date})>"

