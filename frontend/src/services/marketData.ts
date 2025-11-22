import apiClient from './api'
import { StockPriceListResponse, OptionsChainResponse, AvailableDatesResponse } from '../types/marketData'

const API_BASE = '/api/v1/market-data'

export const marketDataService = {
  /**
   * Get historical stock prices
   */
  getStockPrices: async (
    symbol: string,
    startDate?: string,
    endDate?: string,
    limit?: number
  ): Promise<StockPriceListResponse> => {
    const params = new URLSearchParams()
    if (startDate) params.append('start_date', startDate)
    if (endDate) params.append('end_date', endDate)
    if (limit) params.append('limit', limit.toString())

    const response = await apiClient.get(`${API_BASE}/stocks/${symbol}?${params.toString()}`)
    return response.data
  },

  /**
   * Fetch and store stock data from external provider
   */
  fetchStockData: async (
    symbol: string,
    startDate: string,
    endDate?: string,
    interval: string = '1d'
  ) => {
    const params = new URLSearchParams()
    params.append('start_date', startDate)
    if (endDate) params.append('end_date', endDate)
    params.append('interval', interval)

    const response = await apiClient.post(`${API_BASE}/stocks/${symbol}/fetch?${params.toString()}`)
    return response.data
  },

  /**
   * Get options chain data
   */
  getOptionsChain: async (
    underlyingSymbol: string,
    timestamp?: string,
    expirationDate?: string
  ): Promise<OptionsChainResponse> => {
    const params = new URLSearchParams()
    if (timestamp) params.append('timestamp', timestamp)
    if (expirationDate) params.append('expiration_date', expirationDate)

    const response = await apiClient.get(
      `${API_BASE}/options/${underlyingSymbol}?${params.toString()}`
    )
    return response.data
  },

  /**
   * Get available dates in database
   */
  getAvailableDates: async (symbol?: string): Promise<AvailableDatesResponse> => {
    const params = new URLSearchParams()
    if (symbol) params.append('symbol', symbol)

    const response = await apiClient.get(`${API_BASE}/available-dates?${params.toString()}`)
    return response.data
  },
}

