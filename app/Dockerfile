# ==========================================
# Stage 1: Build & Dependency Resolution
# ==========================================
FROM python:3.11-slim AS builder

WORKDIR /build

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install build dependencies and build wheels
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ==========================================
# Stage 2: Hardened Runtime Environment
# ==========================================
FROM python:3.11-slim AS runner

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/home/appuser/.local/bin:$PATH" \
    APP_ENV="production"

# Create a non-root system user for security compliance (Principle of Least Privilege)
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup --home /home/appuser appuser

# Copy installed packages from the builder stage to the non-root user directory
COPY --from=builder /root/.local /home/appuser/.local

# Copy application source code and adjust ownership
COPY ./src ./src
RUN chown -R appuser:appgroup /app /home/appuser

# Switch execution context to the non-root user
USER appuser

# Expose the internal port for the container
EXPOSE 8000

# Healthcheck instruction for Docker engine / orchestration
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Launch the production ASGI web server
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]