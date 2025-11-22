import { useState, useEffect } from 'react'
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom'
import { apiClient } from './services/api'
import Home from './pages/Home'
import Health from './pages/Health'

function App() {
  const [backendStatus, setBackendStatus] = useState<string>('checking...')

  useEffect(() => {
    // Test backend connection
    apiClient.get('/health')
      .then(() => setBackendStatus('connected'))
      .catch(() => setBackendStatus('disconnected'))
  }, [])

  return (
    <Router>
      <div className="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900">
        <nav className="bg-gray-800/50 backdrop-blur-sm border-b border-gray-700">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between h-16">
              <div className="flex items-center space-x-8">
                <Link to="/" className="text-xl font-bold text-white hover:text-blue-400 transition">
                  Hawkiz Web
                </Link>
                <div className="flex space-x-4">
                  <Link 
                    to="/" 
                    className="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium transition"
                  >
                    Home
                  </Link>
                  <Link 
                    to="/health" 
                    className="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium transition"
                  >
                    Health
                  </Link>
                </div>
              </div>
              <div className="flex items-center space-x-2">
                <div className={`w-2 h-2 rounded-full ${backendStatus === 'connected' ? 'bg-green-500' : 'bg-red-500'}`}></div>
                <span className="text-sm text-gray-400">
                  Backend: {backendStatus}
                </span>
              </div>
            </div>
          </div>
        </nav>

        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/health" element={<Health />} />
          </Routes>
        </main>
      </div>
    </Router>
  )
}

export default App

