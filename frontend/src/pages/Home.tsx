import { useState, useEffect } from 'react'
import { apiClient } from '../services/api'

interface ApiResponse {
  message: string
}

function Home() {
  const [message, setMessage] = useState<string>('')
  const [loading, setLoading] = useState<boolean>(false)

  useEffect(() => {
    fetchMessage()
  }, [])

  const fetchMessage = async () => {
    setLoading(true)
    try {
      const response = await apiClient.get<ApiResponse>('/')
      setMessage(response.data.message)
    } catch (error) {
      console.error('Error fetching message:', error)
      setMessage('Failed to connect to backend')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="text-center">
      <h1 className="text-4xl font-bold text-white mb-4">
        Welcome to Hawkiz Web
      </h1>
      <p className="text-xl text-gray-300 mb-8">
        A modern full-stack application
      </p>

      <div className="bg-gray-800/50 backdrop-blur-sm rounded-lg p-6 max-w-md mx-auto border border-gray-700">
        <h2 className="text-2xl font-semibold text-white mb-4">Backend Status</h2>
        {loading ? (
          <div className="text-gray-400">Loading...</div>
        ) : (
          <div className="text-green-400 font-mono">{message || 'No message received'}</div>
        )}
        <button
          onClick={fetchMessage}
          className="mt-4 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md transition"
        >
          Refresh
        </button>
      </div>

      <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4 max-w-4xl mx-auto">
        <div className="bg-gray-800/50 backdrop-blur-sm rounded-lg p-6 border border-gray-700">
          <h3 className="text-lg font-semibold text-white mb-2">FastAPI</h3>
          <p className="text-gray-400 text-sm">Modern Python backend framework</p>
        </div>
        <div className="bg-gray-800/50 backdrop-blur-sm rounded-lg p-6 border border-gray-700">
          <h3 className="text-lg font-semibold text-white mb-2">React + TypeScript</h3>
          <p className="text-gray-400 text-sm">Type-safe frontend with React</p>
        </div>
        <div className="bg-gray-800/50 backdrop-blur-sm rounded-lg p-6 border border-gray-700">
          <h3 className="text-lg font-semibold text-white mb-2">Tailwind CSS</h3>
          <p className="text-gray-400 text-sm">Utility-first CSS framework</p>
        </div>
      </div>
    </div>
  )
}

export default Home

