from fastapi.testclient import TestClient
from app.src.main import app

# TestClient simulates HTTP traffic without needing to spin up a live server
client = TestClient(app)

def test_read_root():
    """Ensure the root endpoint returns HTTP 200 and expected payload."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Cloud GitOps Engine API is running."}

def test_health_check_payload():
    """Ensure health check matches schema and reports 'healthy'."""
    response = client.get("/health")
    assert response.status_code == 200
    
    data = response.json()
    assert data["status"] == "healthy"
    assert "environment" in data
    assert "version" in data