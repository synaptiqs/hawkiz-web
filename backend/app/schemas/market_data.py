"""Pydantic schemas for market data."""
from pydantic import BaseModel, Field
from datetime import datetime, date
from typing import Optional, List
from decimal import Decimal


class StockPriceResponse(BaseModel):
    """Stock price data response."""
    timestamp: datetime
    open: Decimal
    high: Decimal
    low: Decimal
    close: Decimal
    volume: int
    
    class Config:
        from_attributes = True


class StockPriceListResponse(BaseModel):
    """List of stock prices response."""
    symbol: str
    data: List[StockPriceResponse]
    count: int


class OptionsChainItem(BaseModel):
    """Single options chain item."""
    expiration_date: date
    strike: Decimal
    option_type: str  # 'C' or 'P'
    bid: Optional[Decimal] = None
    ask: Optional[Decimal] = None
    last: Optional[Decimal] = None
    volume: Optional[int] = None
    open_interest: Optional[int] = None
    implied_volatility: Optional[Decimal] = None
    delta: Optional[Decimal] = None
    gamma: Optional[Decimal] = None
    theta: Optional[Decimal] = None
    vega: Optional[Decimal] = None
    
    class Config:
        from_attributes = True


class OptionsChainResponse(BaseModel):
    """Options chain response."""
    underlying_symbol: str
    underlying_price: Decimal
    timestamp: datetime
    expirations: List[date]
    chains: List[OptionsChainItem]
    count: int


class AvailableDatesResponse(BaseModel):
    """Available dates for market data."""
    symbol: Optional[str] = None
    dates: List[date]
    count: int

