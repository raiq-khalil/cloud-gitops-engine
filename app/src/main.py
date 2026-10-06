import os
from fastapi import FastAPI, status
from pydantic import BaseModel

app = FastAPI(
    title="Cloud GitOps Microservice",
    version="1.0.0",
    description="Production-grade API designed for containerized cloud deployment."
)

class HealthResponse(BaseModel):
    status: str
    environment: str
    version: str

@app.get("/", tags=["General"])
def root():
    """Root welcome endpoint."""
    return {"message": "Cloud GitOps Engine API is running."}

@app.get(
    "/health",
    response_model=HealthResponse,
    status_code=status.HTTP_200_OK,
    tags=["Diagnostics"]
)
def health_check():
    """
    Standard cloud health check endpoint.
    Load balancers and container orchestrators probe this to verify availability.
    """
    env = os.getenv("APP_ENV", "development")
    return HealthResponse(
        status="healthy",
        environment=env,
        version="1.0.0"
    )