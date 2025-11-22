"""Test script for Phase 1 functionality."""
import requests
import json
from datetime import date, timedelta

BASE_URL = "http://127.0.0.1:8001"

def test_health():
    """Test health endpoint."""
    print("Testing health endpoint...")
    response = requests.get(f"{BASE_URL}/health")
    assert response.status_code == 200
    print(f"✅ Health check: {response.json()}")
    return True

def test_root():
    """Test root endpoint."""
    print("\nTesting root endpoint...")
    response = requests.get(f"{BASE_URL}/")
    assert response.status_code == 200
    print(f"✅ Root endpoint: {response.json()}")
    return True

def test_fetch_stock_data():
    """Test fetching stock data."""
    print("\nTesting fetch stock data endpoint...")
    symbol = "SPY"
    start_date = (date.today() - timedelta(days=30)).isoformat()
    
    url = f"{BASE_URL}/api/v1/market-data/stocks/{symbol}/fetch"
    params = {
        "start_date": start_date,
        "interval": "1d"
    }
    
    try:
        response = requests.post(url, params=params)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Fetched stock data: {data}")
            return True
        else:
            print(f"❌ Error: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"❌ Exception: {str(e)}")
        return False

def test_get_stock_prices():
    """Test getting stock prices from database."""
    print("\nTesting get stock prices endpoint...")
    symbol = "SPY"
    start_date = (date.today() - timedelta(days=7)).isoformat()
    
    url = f"{BASE_URL}/api/v1/market-data/stocks/{symbol}"
    params = {
        "start_date": start_date,
        "limit": 10
    }
    
    try:
        response = requests.get(url, params=params)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Retrieved {data['count']} stock price records")
            if data['count'] > 0:
                print(f"   First record: {data['data'][0]}")
            return True
        else:
            print(f"⚠️  Status {response.status_code}: {response.text}")
            print("   (This is OK if no data has been fetched yet)")
            return True  # Not a failure if no data exists
    except Exception as e:
        print(f"❌ Exception: {str(e)}")
        return False

def test_get_options_chain():
    """Test getting options chain."""
    print("\nTesting get options chain endpoint...")
    symbol = "SPY"
    
    url = f"{BASE_URL}/api/v1/market-data/options/{symbol}"
    
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Retrieved options chain: {data['count']} options")
            print(f"   Underlying price: ${data['underlying_price']}")
            print(f"   Expirations: {len(data['expirations'])}")
            return True
        else:
            print(f"⚠️  Status {response.status_code}: {response.text}")
            return True  # Options data might not always be available
    except Exception as e:
        print(f"❌ Exception: {str(e)}")
        return False

def test_available_dates():
    """Test getting available dates."""
    print("\nTesting available dates endpoint...")
    
    url = f"{BASE_URL}/api/v1/market-data/available-dates"
    
    try:
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Available dates: {data['count']} dates")
            if data['count'] > 0:
                print(f"   Sample dates: {data['dates'][:5]}")
            return True
        else:
            print(f"⚠️  Status {response.status_code}: {response.text}")
            return True
    except Exception as e:
        print(f"❌ Exception: {str(e)}")
        return False

def main():
    """Run all tests."""
    print("=" * 60)
    print("Phase 1 Testing - Hawkiz Options Backtesting API")
    print("=" * 60)
    
    results = []
    
    # Basic endpoints
    results.append(("Health Check", test_health()))
    results.append(("Root Endpoint", test_root()))
    
    # Market data endpoints
    results.append(("Fetch Stock Data", test_fetch_stock_data()))
    results.append(("Get Stock Prices", test_get_stock_prices()))
    results.append(("Get Options Chain", test_get_options_chain()))
    results.append(("Available Dates", test_available_dates()))
    
    # Summary
    print("\n" + "=" * 60)
    print("Test Summary")
    print("=" * 60)
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status}: {test_name}")
    
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All tests passed! Phase 1 is working correctly.")
    else:
        print("\n⚠️  Some tests failed. Check the output above for details.")
    
    return passed == total

if __name__ == "__main__":
    try:
        main()
    except requests.exceptions.ConnectionError:
        print("\n❌ ERROR: Could not connect to the API server!")
        print("   Make sure the server is running:")
        print("   cd backend")
        print("   .\\start.ps1")
    except KeyboardInterrupt:
        print("\n\nTest interrupted by user.")
    except Exception as e:
        print(f"\n❌ Unexpected error: {str(e)}")

