"""Market data API endpoints."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from datetime import date, datetime
from typing import Optional, List
from app.database import get_db
from app.services.market_data_service import MarketDataService
from app.schemas.market_data import (
    StockPriceListResponse,
    StockPriceResponse,
    OptionsChainResponse,
    OptionsChainItem,
    AvailableDatesResponse,
)
import yfinance as yf
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get("/stocks/{symbol}", response_model=StockPriceListResponse)
async def get_stock_prices(
    symbol: str,
    start_date: Optional[date] = Query(None, description="Start date (YYYY-MM-DD)"),
    end_date: Optional[date] = Query(None, description="End date (YYYY-MM-DD)"),
    limit: Optional[int] = Query(None, ge=1, le=10000, description="Maximum number of records"),
    db: Session = Depends(get_db),
):
    """
    Get historical stock price data.
    
    - **symbol**: Stock symbol (e.g., SPY, AAPL)
    - **start_date**: Start date for data retrieval
    - **end_date**: End date for data retrieval
    - **limit**: Maximum number of records to return
    """
    try:
        prices = MarketDataService.get_stock_prices(
            db=db,
            symbol=symbol.upper(),
            start_date=start_date,
            end_date=end_date,
            limit=limit,
        )
        
        price_responses = [
            StockPriceResponse(
                timestamp=price.timestamp,
                open=price.open,
                high=price.high,
                low=price.low,
                close=price.close,
                volume=int(price.volume),
            )
            for price in prices
        ]
        
        return StockPriceListResponse(
            symbol=symbol.upper(),
            data=price_responses,
            count=len(price_responses),
        )
    except Exception as e:
        logger.error(f"Error retrieving stock prices: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error retrieving stock prices: {str(e)}")


@router.post("/stocks/{symbol}/fetch")
async def fetch_and_store_stock_data(
    symbol: str,
    start_date: date = Query(..., description="Start date (YYYY-MM-DD)"),
    end_date: Optional[date] = Query(None, description="End date (YYYY-MM-DD)"),
    interval: str = Query("1d", description="Data interval (1d, 1h, etc.)"),
    db: Session = Depends(get_db),
):
    """
    Fetch stock data from external provider and store in database.
    
    - **symbol**: Stock symbol
    - **start_date**: Start date for data fetch
    - **end_date**: End date for data fetch (defaults to today)
    - **interval**: Data interval
    """
    try:
        prices = MarketDataService.fetch_stock_data(
            symbol=symbol.upper(),
            start_date=start_date,
            end_date=end_date,
            interval=interval,
        )
        
        stored_count = MarketDataService.store_stock_prices(
            db=db,
            symbol=symbol.upper(),
            prices=prices,
        )
        
        return {
            "message": f"Fetched and stored {stored_count} records for {symbol.upper()}",
            "symbol": symbol.upper(),
            "records_stored": stored_count,
            "total_fetched": len(prices),
        }
    except Exception as e:
        logger.error(f"Error fetching stock data: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error fetching stock data: {str(e)}")


@router.get("/options/{underlying_symbol}", response_model=OptionsChainResponse)
async def get_options_chain(
    underlying_symbol: str,
    timestamp: Optional[datetime] = Query(None, description="Specific timestamp for options chain"),
    expiration_date: Optional[date] = Query(None, description="Filter by expiration date"),
    db: Session = Depends(get_db),
):
    """
    Get options chain data.
    
    Note: For MVP, this fetches live data from yfinance. Historical options data
    requires a paid provider like Polygon.io.
    
    - **underlying_symbol**: Underlying stock symbol
    - **timestamp**: Specific timestamp (for historical data, if available)
    - **expiration_date**: Filter by expiration date
    """
    try:
        # For MVP, fetch live options data
        # TODO: Add database lookup for historical options data
        chains = MarketDataService.fetch_options_chain(
            symbol=underlying_symbol.upper(),
            expiration_date=expiration_date,
        )
        
        # Get current underlying price
        ticker = yf.Ticker(underlying_symbol.upper())
        info = ticker.info
        underlying_price = info.get('regularMarketPrice') or info.get('currentPrice', 0)
        
        # Extract unique expiration dates
        expirations = sorted(list(set(chain.expiration_date for chain in chains)))
        
        return OptionsChainResponse(
            underlying_symbol=underlying_symbol.upper(),
            underlying_price=underlying_price,
            timestamp=datetime.now(),
            expirations=expirations,
            chains=chains,
            count=len(chains),
        )
    except Exception as e:
        logger.error(f"Error retrieving options chain: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error retrieving options chain: {str(e)}")


@router.get("/available-dates", response_model=AvailableDatesResponse)
async def get_available_dates(
    symbol: Optional[str] = Query(None, description="Filter by symbol"),
    db: Session = Depends(get_db),
):
    """
    Get list of available dates in the database.
    
    - **symbol**: Optional symbol filter
    """
    try:
        dates = MarketDataService.get_available_dates(db=db, symbol=symbol.upper() if symbol else None)
        
        return AvailableDatesResponse(
            symbol=symbol.upper() if symbol else None,
            dates=dates,
            count=len(dates),
        )
    except Exception as e:
        logger.error(f"Error retrieving available dates: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error retrieving available dates: {str(e)}")

