# Hawkiz Web

A modern full-stack web application with FastAPI backend and React frontend.

## Project Structure

```
hawkiz-web/
├── backend/          # FastAPI backend
│   ├── main.py       # FastAPI application
│   ├── requirements.txt
│   └── venv/         # Python virtual environment
└── frontend/         # React + TypeScript frontend
    ├── src/          # Source files
    └── package.json  # Node dependencies
```

## Quick Start

### Backend Setup

1. Navigate to backend directory:
```powershell
cd backend
```

2. Create and activate virtual environment:
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

3. Install dependencies:
```powershell
pip install -r requirements.txt
```

4. Run the server:
```powershell
uvicorn main:app --reload
```

The backend will be available at `http://127.0.0.1:8001`

### Frontend Setup

1. Navigate to frontend directory:
```powershell
cd frontend
```

2. Install dependencies:
```powershell
npm install
```

3. Start the development server:
```powershell
npm run dev
```

The frontend will be available at `http://localhost:5173`

## Running Both Services

Open two terminal windows:

**Terminal 1 (Backend):**
```powershell
cd backend
.\venv\Scripts\Activate.ps1
uvicorn main:app --reload
```

**Terminal 2 (Frontend):**
```powershell
cd frontend
npm run dev
```

## API Endpoints

- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /api/test` - Test endpoint

**Note:** Backend runs on port 8001 (port 8000 may be in use by other services)

## Tech Stack

### Backend
- FastAPI 0.115.0
- Uvicorn 0.30.0
- Python 3.11+

### Frontend
- React 18
- TypeScript
- Vite
- Tailwind CSS
- React Router
- Axios

## Development

### Backend
- API documentation: `http://127.0.0.1:8001/docs` (Swagger UI)
- Alternative docs: `http://127.0.0.1:8001/redoc`

### Frontend
- Development server with hot reload
- TypeScript for type safety
- Tailwind CSS for styling

## License

MIT

