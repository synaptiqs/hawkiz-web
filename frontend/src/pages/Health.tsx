import { useState, useEffect } from 'react'
import { apiClient } from '../services/api'

interface HealthResponse {
  status: string
}

function Health() {
  const [health, setHealth] = useState<HealthResponse | null>(null)
  const [loading, setLoading] = useState<boolean>(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    checkHealth()
  }, [])

  const checkHealth = async () => {
    setLoading(true)
    setError(null)
    try {
      const response = await apiClient.get<HealthResponse>('/health')
      setHealth(response.data)
    } catch (err) {
      setError('Failed to connect to backend')
      console.error('Health check error:', err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold text-white mb-6">Health Check</h1>
      
      <div className="bg-gray-800/50 backdrop-blur-sm rounded-lg p-6 border border-gray-700">
        {loading ? (
          <div className="text-gray-400">Checking health...</div>
        ) : error ? (
          <div className="text-red-400">
            <p className="font-semibold mb-2">Error:</p>
            <p>{error}</p>
          </div>
        ) : health ? (
          <div>
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
              <span className="text-green-400 font-semibold text-lg">
                Backend is {health.status}
              </span>
            </div>
            <pre className="bg-gray-900/50 p-4 rounded text-left text-sm text-gray-300 overflow-auto">
              {JSON.stringify(health, null, 2)}
            </pre>
          </div>
        ) : null}
        
        <button
          onClick={checkHealth}
          className="mt-4 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md transition"
        >
          Check Again
        </button>
      </div>
    </div>
  )
}

export default Health

