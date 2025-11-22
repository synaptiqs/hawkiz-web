# Database Schema Design

## Overview

The database will use PostgreSQL with TimescaleDB extension for efficient time-series data storage. This hybrid approach allows for both relational data (orders, positions, strategies) and time-series data (market prices, options chains).

---

## Core Tables

### Market Data Tables

#### `stock_prices`
Stores historical stock price data.

```sql
CREATE TABLE stock_prices (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL,
    open DECIMAL(10, 2) NOT NULL,
    high DECIMAL(10, 2) NOT NULL,
    low DECIMAL(10, 2) NOT NULL,
    close DECIMAL(10, 2) NOT NULL,
    volume BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(symbol, timestamp)
);

-- Convert to hypertable for time-series optimization
SELECT create_hypertable('stock_prices', 'timestamp');

-- Indexes
CREATE INDEX idx_stock_prices_symbol_timestamp ON stock_prices(symbol, timestamp DESC);
```

#### `options_chains`
Stores options chain snapshots at regular intervals.

```sql
CREATE TABLE options_chains (
    id BIGSERIAL PRIMARY KEY,
    underlying_symbol VARCHAR(10) NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL,
    expiration_date DATE NOT NULL,
    strike DECIMAL(10, 2) NOT NULL,
    option_type CHAR(1) NOT NULL CHECK (option_type IN ('C', 'P')),
    bid DECIMAL(10, 2),
    ask DECIMAL(10, 2),
    last DECIMAL(10, 2),
    volume INT,
    open_interest INT,
    implied_volatility DECIMAL(6, 4),
    delta DECIMAL(8, 6),
    gamma DECIMAL(10, 8),
    theta DECIMAL(10, 6),
    vega DECIMAL(10, 6),
    underlying_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(underlying_symbol, timestamp, expiration_date, strike, option_type)
);

SELECT create_hypertable('options_chains', 'timestamp');

CREATE INDEX idx_options_chains_underlying_timestamp ON options_chains(underlying_symbol, timestamp DESC);
CREATE INDEX idx_options_chains_expiration_strike ON options_chains(expiration_date, strike);
```

#### `market_events`
Stores market events that may affect trading.

```sql
CREATE TABLE market_events (
    id BIGSERIAL PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    event_date DATE NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- 'EARNINGS', 'DIVIDEND', 'SPLIT', etc.
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_market_events_symbol_date ON market_events(symbol, event_date);
```

---

### Trading Simulation Tables

#### `users`
User accounts (if implementing authentication).

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login TIMESTAMPTZ
);
```

#### `replay_sessions`
Tracks each replay session.

```sql
CREATE TABLE replay_sessions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    session_name VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE,
    start_time TIME,
    end_time TIME,
    playback_speed DECIMAL(5, 2) DEFAULT 1.0,
    current_timestamp TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'paused', -- 'paused', 'playing', 'completed'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_replay_sessions_user ON replay_sessions(user_id);
```

#### `simulated_orders`
All orders placed during replay.

```sql
CREATE TABLE simulated_orders (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT REFERENCES replay_sessions(id) ON DELETE CASCADE,
    order_id VARCHAR(50) UNIQUE NOT NULL,
    symbol VARCHAR(50) NOT NULL, -- e.g., 'SPY_20241220_450C'
    order_type VARCHAR(20) NOT NULL, -- 'MARKET', 'LIMIT', 'STOP'
    side VARCHAR(10) NOT NULL CHECK (side IN ('BUY', 'SELL')),
    quantity INT NOT NULL,
    limit_price DECIMAL(10, 2),
    stop_price DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'FILLED', 'CANCELLED', 'REJECTED'
    filled_price DECIMAL(10, 2),
    filled_quantity INT DEFAULT 0,
    placed_at TIMESTAMPTZ NOT NULL,
    filled_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_simulated_orders_session ON simulated_orders(session_id);
CREATE INDEX idx_simulated_orders_status ON simulated_orders(status);
```

#### `simulated_positions`
Current open positions.

```sql
CREATE TABLE simulated_positions (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT REFERENCES replay_sessions(id) ON DELETE CASCADE,
    symbol VARCHAR(50) NOT NULL,
    quantity INT NOT NULL, -- positive for long, negative for short
    avg_entry_price DECIMAL(10, 2) NOT NULL,
    current_price DECIMAL(10, 2),
    unrealized_pnl DECIMAL(12, 2) DEFAULT 0,
    realized_pnl DECIMAL(12, 2) DEFAULT 0,
    total_pnl DECIMAL(12, 2) DEFAULT 0,
    delta_exposure DECIMAL(12, 6) DEFAULT 0,
    gamma_exposure DECIMAL(12, 8) DEFAULT 0,
    theta_exposure DECIMAL(12, 6) DEFAULT 0,
    vega_exposure DECIMAL(12, 6) DEFAULT 0,
    opened_at TIMESTAMPTZ NOT NULL,
    closed_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(session_id, symbol)
);

CREATE INDEX idx_simulated_positions_session ON simulated_positions(session_id);
```

#### `simulated_trades`
Historical completed trades.

```sql
CREATE TABLE simulated_trades (
    id BIGSERIAL PRIMARY KEY,
    session_id BIGINT REFERENCES replay_sessions(id) ON DELETE CASCADE,
    trade_id VARCHAR(50) UNIQUE NOT NULL,
    symbol VARCHAR(50) NOT NULL,
    side VARCHAR(10) NOT NULL CHECK (side IN ('BUY', 'SELL')),
    quantity INT NOT NULL,
    entry_price DECIMAL(10, 2) NOT NULL,
    exit_price DECIMAL(10, 2) NOT NULL,
    entry_timestamp TIMESTAMPTZ NOT NULL,
    exit_timestamp TIMESTAMPTZ NOT NULL,
    pnl DECIMAL(12, 2) NOT NULL,
    commission DECIMAL(10, 2) DEFAULT 0,
    net_pnl DECIMAL(12, 2) NOT NULL,
    duration_minutes INT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_simulated_trades_session ON simulated_trades(session_id);
CREATE INDEX idx_simulated_trades_symbol ON simulated_trades(symbol);
```

---

### Strategy & Backtesting Tables

#### `strategies`
User-defined trading strategies.

```sql
CREATE TABLE strategies (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    rules JSONB NOT NULL, -- Strategy logic in JSON format
    parameters JSONB, -- Strategy parameters
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_strategies_user ON strategies(user_id);
```

#### `backtest_runs`
Backtest execution records.

```sql
CREATE TABLE backtest_runs (
    id BIGSERIAL PRIMARY KEY,
    strategy_id BIGINT REFERENCES strategies(id) ON DELETE CASCADE,
    session_id BIGINT REFERENCES replay_sessions(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    initial_capital DECIMAL(12, 2) NOT NULL,
    final_capital DECIMAL(12, 2),
    total_pnl DECIMAL(12, 2),
    total_trades INT DEFAULT 0,
    winning_trades INT DEFAULT 0,
    losing_trades INT DEFAULT 0,
    win_rate DECIMAL(5, 2),
    profit_factor DECIMAL(8, 4),
    sharpe_ratio DECIMAL(8, 4),
    max_drawdown DECIMAL(8, 4),
    max_drawdown_duration INT, -- in days
    results JSONB, -- Detailed results and metrics
    status VARCHAR(20) DEFAULT 'RUNNING', -- 'RUNNING', 'COMPLETED', 'FAILED'
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_backtest_runs_strategy ON backtest_runs(strategy_id);
CREATE INDEX idx_backtest_runs_status ON backtest_runs(status);
```

---

## Views

### `current_positions_view`
Aggregated view of current positions with latest prices.

```sql
CREATE VIEW current_positions_view AS
SELECT 
    sp.session_id,
    sp.symbol,
    sp.quantity,
    sp.avg_entry_price,
    sp.current_price,
    sp.unrealized_pnl,
    sp.realized_pnl,
    sp.total_pnl,
    sp.delta_exposure,
    sp.gamma_exposure,
    sp.theta_exposure,
    sp.vega_exposure,
    sp.opened_at
FROM simulated_positions sp
WHERE sp.closed_at IS NULL;
```

### `session_performance_view`
Performance summary for each session.

```sql
CREATE VIEW session_performance_view AS
SELECT 
    rs.id as session_id,
    rs.session_name,
    rs.start_date,
    COUNT(DISTINCT st.id) as total_trades,
    SUM(CASE WHEN st.pnl > 0 THEN 1 ELSE 0 END) as winning_trades,
    SUM(CASE WHEN st.pnl < 0 THEN 1 ELSE 0 END) as losing_trades,
    SUM(st.net_pnl) as total_pnl,
    AVG(st.net_pnl) as avg_pnl_per_trade,
    MAX(st.net_pnl) as best_trade,
    MIN(st.net_pnl) as worst_trade
FROM replay_sessions rs
LEFT JOIN simulated_trades st ON st.session_id = rs.id
GROUP BY rs.id, rs.session_name, rs.start_date;
```

---

## Indexes Summary

- Time-series tables use hypertables with automatic indexing on timestamp
- Foreign key indexes on all relationship columns
- Composite indexes for common query patterns (symbol + timestamp)
- Status indexes for filtering active orders/positions

---

## Data Retention

- Market data: Keep indefinitely (compressed archives for old data)
- Replay sessions: Keep for 90 days (configurable)
- Completed trades: Keep for 1 year
- Backtest results: Keep for 1 year

---

## Notes

- Use TimescaleDB compression policies for old market data
- Consider partitioning large tables by date range
- Implement soft deletes for important records (add `deleted_at` column)
- Add database-level constraints for data integrity
- Use transactions for order execution to ensure consistency

