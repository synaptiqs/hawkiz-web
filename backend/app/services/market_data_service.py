"""Market data service for fetching and storing market data."""
import yfinance as yf
import pandas as pd
from datetime import datetime, date, timedelta
from typing import List, Optional
from sqlalchemy.orm import Session
from sqlalchemy import and_, func
from app.models.stock_prices import StockPrice
from app.models.options_chains import OptionsChain
from app.schemas.market_data import StockPriceResponse, OptionsChainItem
import logging

logger = logging.getLogger(__name__)


class MarketDataService:
    """Service for fetching and managing market data."""
    
    @staticmethod
    def fetch_stock_data(
        symbol: str,
        start_date: date,
        end_date: Optional[date] = None,
        interval: str = "1d"
    ) -> List[StockPriceResponse]:
        """
        Fetch stock price data from yfinance.
        
        Args:
            symbol: Stock symbol (e.g., 'SPY')
            start_date: Start date for data
            end_date: End date for data (defaults to today)
            interval: Data interval ('1d', '1h', '1m', etc.)
        
        Returns:
            List of StockPriceResponse objects
        """
        try:
            if end_date is None:
                end_date = date.today()
            
            ticker = yf.Ticker(symbol)
            data = ticker.history(start=start_date, end=end_date, interval=interval)
            
            if data.empty:
                logger.warning(f"No data found for {symbol} from {start_date} to {end_date}")
                return []
            
            prices = []
            for timestamp, row in data.iterrows():
                prices.append(StockPriceResponse(
                    timestamp=timestamp.to_pydatetime(),
                    open=row['Open'],
                    high=row['High'],
                    low=row['Low'],
                    close=row['Close'],
                    volume=int(row['Volume']) if not pd.isna(row['Volume']) else 0,
                ))
            
            return prices
            
        except Exception as e:
            logger.error(f"Error fetching stock data for {symbol}: {str(e)}")
            raise
    
    @staticmethod
    def store_stock_prices(db: Session, symbol: str, prices: List[StockPriceResponse]) -> int:
        """
        Store stock prices in database.
        
        Args:
            db: Database session
            symbol: Stock symbol
            prices: List of stock price data
        
        Returns:
            Number of records stored
        """
        stored_count = 0
        for price_data in prices:
            # Check if record already exists
            existing = db.query(StockPrice).filter(
                and_(
                    StockPrice.symbol == symbol,
                    StockPrice.timestamp == price_data.timestamp
                )
            ).first()
            
            if existing:
                # Update existing record
                existing.open = price_data.open
                existing.high = price_data.high
                existing.low = price_data.low
                existing.close = price_data.close
                existing.volume = price_data.volume
            else:
                # Create new record
                stock_price = StockPrice(
                    symbol=symbol,
                    timestamp=price_data.timestamp,
                    open=price_data.open,
                    high=price_data.high,
                    low=price_data.low,
                    close=price_data.close,
                    volume=price_data.volume,
                )
                db.add(stock_price)
                stored_count += 1
        
        try:
            db.commit()
            return stored_count
        except Exception as e:
            db.rollback()
            logger.error(f"Error storing stock prices: {str(e)}")
            raise
    
    @staticmethod
    def get_stock_prices(
        db: Session,
        symbol: str,
        start_date: Optional[date] = None,
        end_date: Optional[date] = None,
        limit: Optional[int] = None
    ) -> List[StockPrice]:
        """
        Retrieve stock prices from database.
        
        Args:
            db: Database session
            symbol: Stock symbol
            start_date: Start date filter
            end_date: End date filter
            limit: Maximum number of records to return
        
        Returns:
            List of StockPrice objects
        """
        query = db.query(StockPrice).filter(StockPrice.symbol == symbol)
        
        if start_date:
            query = query.filter(StockPrice.timestamp >= datetime.combine(start_date, datetime.min.time()))
        
        if end_date:
            query = query.filter(StockPrice.timestamp <= datetime.combine(end_date, datetime.max.time()))
        
        query = query.order_by(StockPrice.timestamp.desc())
        
        if limit:
            query = query.limit(limit)
        
        return query.all()
    
    @staticmethod
    def get_available_dates(db: Session, symbol: Optional[str] = None) -> List[date]:
        """
        Get list of available dates in database.
        
        Args:
            db: Database session
            symbol: Optional symbol filter
        
        Returns:
            List of available dates
        """
        query = db.query(func.date(StockPrice.timestamp).distinct())
        
        if symbol:
            query = query.filter(StockPrice.symbol == symbol)
        
        dates = [row[0] for row in query.order_by(func.date(StockPrice.timestamp).desc()).all()]
        return dates
    
    @staticmethod
    def fetch_options_chain(
        symbol: str,
        expiration_date: Optional[date] = None
    ) -> List[OptionsChainItem]:
        """
        Fetch options chain data from yfinance.
        
        Note: yfinance has limited options data. For production, consider Polygon.io.
        
        Args:
            symbol: Stock symbol
            expiration_date: Specific expiration date (optional)
        
        Returns:
            List of OptionsChainItem objects
        """
        try:
            ticker = yf.Ticker(symbol)
            options_dates = ticker.options
            
            if not options_dates:
                logger.warning(f"No options data available for {symbol}")
                return []
            
            all_chains = []
            
            # If specific expiration requested, only fetch that one
            expirations_to_fetch = [expiration_date] if expiration_date else options_dates[:5]  # Limit to 5 for MVP
            
            for exp_date in expirations_to_fetch:
                try:
                    opt_chain = ticker.option_chain(exp_date)
                    
                    # Process calls
                    for _, row in opt_chain.calls.iterrows():
                        all_chains.append(OptionsChainItem(
                            expiration_date=exp_date,
                            strike=row['strike'],
                            option_type='C',
                            bid=row.get('bid', None),
                            ask=row.get('ask', None),
                            last=row.get('lastPrice', None),
                            volume=row.get('volume', None),
                            open_interest=row.get('openInterest', None),
                            implied_volatility=row.get('impliedVolatility', None),
                        ))
                    
                    # Process puts
                    for _, row in opt_chain.puts.iterrows():
                        all_chains.append(OptionsChainItem(
                            expiration_date=exp_date,
                            strike=row['strike'],
                            option_type='P',
                            bid=row.get('bid', None),
                            ask=row.get('ask', None),
                            last=row.get('lastPrice', None),
                            volume=row.get('volume', None),
                            open_interest=row.get('openInterest', None),
                            implied_volatility=row.get('impliedVolatility', None),
                        ))
                except Exception as e:
                    logger.warning(f"Error fetching options for {symbol} expiration {exp_date}: {str(e)}")
                    continue
            
            return all_chains
            
        except Exception as e:
            logger.error(f"Error fetching options chain for {symbol}: {str(e)}")
            raise

