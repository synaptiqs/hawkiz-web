# API Structure & Endpoints

## Base URL
```
http://localhost:8000/api
```

---

## Authentication
All endpoints (except public ones) require authentication via JWT token in the Authorization header:
```
Authorization: Bearer <token>
```

---

## Market Data Endpoints

### Get Stock Prices
```http
GET /api/market-data/stocks/{symbol}
```
**Query Parameters:**
- `start_date` (required): ISO date string
- `end_date` (optional): ISO date string
- `interval` (optional): '1min', '5min', '15min', '1hour', '1day' (default: '1day')
- `limit` (optional): Max records to return

**Response:**
```json
{
  "symbol": "SPY",
  "data": [
    {
      "timestamp": "2024-01-15T09:30:00Z",
      "open": 450.25,
      "high": 452.10,
      "low": 449.80,
      "close": 451.50,
      "volume": 50000000
    }
  ]
}
```

### Get Options Chain
```http
GET /api/market-data/options/{underlying_symbol}
```
**Query Parameters:**
- `timestamp` (required): ISO datetime string
- `expiration_date` (optional): Filter by expiration
- `min_strike` (optional): Minimum strike price
- `max_strike` (optional): Maximum strike price

**Response:**
```json
{
  "underlying_symbol": "SPY",
  "underlying_price": 451.50,
  "timestamp": "2024-01-15T09:30:00Z",
  "expirations": ["2024-01-19", "2024-01-26"],
  "chains": [
    {
      "expiration_date": "2024-01-19",
      "strike": 450.00,
      "option_type": "C",
      "bid": 2.50,
      "ask": 2.55,
      "last": 2.52,
      "volume": 1000,
      "open_interest": 5000,
      "implied_volatility": 0.15,
      "delta": 0.55,
      "gamma": 0.02,
      "theta": -0.05,
      "vega": 0.10
    }
  ]
}
```

### Get Available Dates
```http
GET /api/market-data/available-dates
```
**Query Parameters:**
- `symbol` (optional): Filter by symbol

**Response:**
```json
{
  "dates": [
    "2024-01-15",
    "2024-01-16",
    "2024-01-17"
  ]
}
```

---

## Replay Endpoints

### Create Replay Session
```http
POST /api/replay/sessions
```
**Request Body:**
```json
{
  "session_name": "SPY Jan 15 Replay",
  "symbol": "SPY",
  "start_date": "2024-01-15",
  "start_time": "09:30:00",
  "end_time": "16:00:00",
  "playback_speed": 1.0
}
```

**Response:**
```json
{
  "session_id": "uuid-here",
  "session_name": "SPY Jan 15 Replay",
  "status": "paused",
  "current_timestamp": "2024-01-15T09:30:00Z"
}
```

### Get Replay Session
```http
GET /api/replay/sessions/{session_id}
```

### Control Replay
```http
POST /api/replay/sessions/{session_id}/control
```
**Request Body:**
```json
{
  "action": "play" | "pause" | "stop" | "seek",
  "timestamp": "2024-01-15T10:30:00Z"  // Required for seek
}
```

### Get Replay Status
```http
GET /api/replay/sessions/{session_id}/status
```
**Response:**
```json
{
  "session_id": "uuid-here",
  "status": "playing",
  "current_timestamp": "2024-01-15T10:30:00Z",
  "playback_speed": 2.0,
  "progress_percent": 45.5
}
```

### List Replay Sessions
```http
GET /api/replay/sessions
```
**Query Parameters:**
- `limit` (optional): Default 20
- `offset` (optional): Default 0

---

## Trading Endpoints

### Place Order
```http
POST /api/trading/orders
```
**Request Body:**
```json
{
  "session_id": "uuid-here",
  "symbol": "SPY_20240119_450C",
  "order_type": "LIMIT",
  "side": "BUY",
  "quantity": 10,
  "limit_price": 2.50
}
```

**Response:**
```json
{
  "order_id": "order-uuid",
  "status": "PENDING",
  "placed_at": "2024-01-15T10:30:00Z"
}
```

### Get Order
```http
GET /api/trading/orders/{order_id}
```

### Cancel Order
```http
DELETE /api/trading/orders/{order_id}
```

### List Orders
```http
GET /api/trading/orders
```
**Query Parameters:**
- `session_id` (required)
- `status` (optional): Filter by status

### Get Positions
```http
GET /api/trading/positions
```
**Query Parameters:**
- `session_id` (required)

**Response:**
```json
{
  "positions": [
    {
      "symbol": "SPY_20240119_450C",
      "quantity": 10,
      "avg_entry_price": 2.50,
      "current_price": 2.75,
      "unrealized_pnl": 250.00,
      "delta": 5.5,
      "gamma": 0.2,
      "theta": -0.5,
      "vega": 1.0
    }
  ],
  "portfolio_greeks": {
    "net_delta": 5.5,
    "net_gamma": 0.2,
    "net_theta": -0.5,
    "net_vega": 1.0
  },
  "total_unrealized_pnl": 250.00
}
```

### Get Trade History
```http
GET /api/trading/trades
```
**Query Parameters:**
- `session_id` (required)
- `limit` (optional): Default 50
- `offset` (optional): Default 0

---

## Backtesting Endpoints

### Create Strategy
```http
POST /api/backtest/strategies
```
**Request Body:**
```json
{
  "name": "Simple Call Strategy",
  "description": "Buy calls when RSI < 30",
  "rules": {
    "entry_conditions": {
      "rsi": {"operator": "<", "value": 30}
    },
    "exit_conditions": {
      "profit_target": 0.5,
      "stop_loss": -0.3
    }
  },
  "parameters": {
    "position_size": 1000,
    "max_positions": 5
  }
}
```

### Run Backtest
```http
POST /api/backtest/run
```
**Request Body:**
```json
{
  "strategy_id": "uuid-here",
  "symbol": "SPY",
  "start_date": "2024-01-01",
  "end_date": "2024-01-31",
  "initial_capital": 100000
}
```

**Response:**
```json
{
  "backtest_id": "uuid-here",
  "status": "RUNNING",
  "started_at": "2024-01-15T10:30:00Z"
}
```

### Get Backtest Results
```http
GET /api/backtest/results/{backtest_id}
```

**Response:**
```json
{
  "backtest_id": "uuid-here",
  "strategy_name": "Simple Call Strategy",
  "start_date": "2024-01-01",
  "end_date": "2024-01-31",
  "initial_capital": 100000,
  "final_capital": 105000,
  "total_pnl": 5000,
  "total_trades": 25,
  "winning_trades": 15,
  "losing_trades": 10,
  "win_rate": 60.0,
  "profit_factor": 1.5,
  "sharpe_ratio": 1.2,
  "max_drawdown": -0.08,
  "equity_curve": [
    {"date": "2024-01-01", "value": 100000},
    {"date": "2024-01-02", "value": 100500}
  ],
  "trades": [...]
}
```

### List Strategies
```http
GET /api/backtest/strategies
```

### Delete Strategy
```http
DELETE /api/backtest/strategies/{strategy_id}
```

---

## Analytics Endpoints

### Get Session Performance
```http
GET /api/analytics/session/{session_id}/performance
```

**Response:**
```json
{
  "session_id": "uuid-here",
  "total_trades": 25,
  "winning_trades": 15,
  "losing_trades": 10,
  "win_rate": 60.0,
  "total_pnl": 5000,
  "avg_win": 500,
  "avg_loss": -300,
  "profit_factor": 1.67,
  "max_drawdown": -0.08,
  "sharpe_ratio": 1.2
}
```

### Get Portfolio Analytics
```http
GET /api/analytics/portfolio
```
**Query Parameters:**
- `session_id` (required)

**Response:**
```json
{
  "total_value": 102500,
  "unrealized_pnl": 2500,
  "realized_pnl": 5000,
  "portfolio_greeks": {
    "net_delta": 5.5,
    "net_gamma": 0.2,
    "net_theta": -0.5,
    "net_vega": 1.0
  },
  "risk_metrics": {
    "var_95": -500,
    "max_loss_scenario": -2000
  }
}
```

---

## WebSocket Endpoints

### Replay Data Stream
```http
WS /ws/replay/{session_id}
```

**Messages from Server:**
```json
{
  "type": "market_data",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "symbol": "SPY",
    "price": 451.50,
    "volume": 1000000
  }
}
```

```json
{
  "type": "order_filled",
  "order_id": "order-uuid",
  "filled_price": 2.50,
  "filled_quantity": 10
}
```

```json
{
  "type": "position_update",
  "positions": [...]
}
```

**Messages to Server:**
```json
{
  "type": "subscribe",
  "channels": ["market_data", "orders", "positions"]
}
```

---

## Error Responses

All errors follow this format:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {}
  }
}
```

**Common Error Codes:**
- `VALIDATION_ERROR`: Invalid request data
- `NOT_FOUND`: Resource not found
- `UNAUTHORIZED`: Authentication required
- `FORBIDDEN`: Insufficient permissions
- `INSUFFICIENT_DATA`: Market data not available
- `ORDER_REJECTED`: Order cannot be executed
- `SESSION_NOT_FOUND`: Replay session doesn't exist

---

## Rate Limiting

- Market data endpoints: 100 requests/minute
- Trading endpoints: 50 requests/minute
- Backtest endpoints: 10 requests/minute

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640000000
```

