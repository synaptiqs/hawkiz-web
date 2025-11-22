#!/usr/bin/env python3
"""
Test script to verify backend setup
"""
import sys
import subprocess

def test_imports():
    """Test if all required packages are installed"""
    print("Testing imports...")
    try:
        import fastapi
        import uvicorn
        print("[OK] FastAPI and Uvicorn imported successfully")
        return True
    except ImportError as e:
        print(f"[ERROR] Import error: {e}")
        print("  Run: pip install -r requirements.txt")
        return False

def test_main_module():
    """Test if main.py can be imported"""
    print("\nTesting main.py...")
    try:
        import main
        print("[OK] main.py imported successfully")
        print(f"  FastAPI app: {main.app}")
        return True
    except Exception as e:
        print(f"[ERROR] Error importing main.py: {e}")
        return False

def test_uvicorn():
    """Test if uvicorn can be run"""
    print("\nTesting uvicorn...")
    try:
        result = subprocess.run(
            [sys.executable, "-m", "uvicorn", "--version"],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            print(f"[OK] Uvicorn version: {result.stdout.strip()}")
            return True
        else:
            print(f"[ERROR] Uvicorn test failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"[ERROR] Error testing uvicorn: {e}")
        return False

if __name__ == "__main__":
    print("=" * 50)
    print("Backend Setup Test")
    print("=" * 50)
    
    all_passed = True
    all_passed &= test_imports()
    all_passed &= test_main_module()
    all_passed &= test_uvicorn()
    
    print("\n" + "=" * 50)
    if all_passed:
        print("[OK] All tests passed! Backend is ready to run.")
        print("\nTo start the server, run:")
        print("  uvicorn main:app --reload")
    else:
        print("[ERROR] Some tests failed. Please fix the issues above.")
    print("=" * 50)

