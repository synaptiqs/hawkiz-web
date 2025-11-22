"""Options chain model."""
from sqlalchemy import Column, BigInteger, String, Numeric, Date, DateTime, CheckConstraint, UniqueConstraint, Index
from sqlalchemy.sql import func
from app.database import Base


class OptionsChain(Base):
    """Historical options chain snapshots."""
    
    __tablename__ = "options_chains"
    
    id = Column(BigInteger, primary_key=True, index=True)
    underlying_symbol = Column(String(10), nullable=False, index=True)
    timestamp = Column(DateTime(timezone=True), nullable=False, index=True)
    expiration_date = Column(Date, nullable=False, index=True)
    strike = Column(Numeric(10, 2), nullable=False)
    option_type = Column(String(1), nullable=False)  # 'C' for Call, 'P' for Put
    bid = Column(Numeric(10, 2), nullable=True)
    ask = Column(Numeric(10, 2), nullable=True)
    last = Column(Numeric(10, 2), nullable=True)
    volume = Column(BigInteger, nullable=True)
    open_interest = Column(BigInteger, nullable=True)
    implied_volatility = Column(Numeric(6, 4), nullable=True)
    delta = Column(Numeric(8, 6), nullable=True)
    gamma = Column(Numeric(10, 8), nullable=True)
    theta = Column(Numeric(10, 6), nullable=True)
    vega = Column(Numeric(10, 6), nullable=True)
    underlying_price = Column(Numeric(10, 2), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    
    __table_args__ = (
        CheckConstraint("option_type IN ('C', 'P')", name='chk_option_type'),
        UniqueConstraint('underlying_symbol', 'timestamp', 'expiration_date', 'strike', 'option_type', 
                        name='uq_options_chains_unique'),
        Index('idx_options_chains_underlying_timestamp', 'underlying_symbol', 'timestamp'),
        Index('idx_options_chains_expiration_strike', 'expiration_date', 'strike'),
    )
    
    def __repr__(self):
        return f"<OptionsChain(underlying={self.underlying_symbol}, strike={self.strike}, type={self.option_type})>"

