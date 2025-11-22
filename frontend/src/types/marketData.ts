export interface StockPrice {
  timestamp: string
  open: number
  high: number
  low: number
  close: number
  volume: number
}

export interface StockPriceListResponse {
  symbol: string
  data: StockPrice[]
  count: number
}

export interface OptionsChainItem {
  expiration_date: string
  strike: number
  option_type: 'C' | 'P'
  bid?: number
  ask?: number
  last?: number
  volume?: number
  open_interest?: number
  implied_volatility?: number
  delta?: number
  gamma?: number
  theta?: number
  vega?: number
}

export interface OptionsChainResponse {
  underlying_symbol: string
  underlying_price: number
  timestamp: string
  expirations: string[]
  chains: OptionsChainItem[]
  count: number
}

export interface AvailableDatesResponse {
  symbol?: string
  dates: string[]
  count: number
}

