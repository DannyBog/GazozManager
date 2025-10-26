# === Stage 1: Build ===
FROM python:3.11-alpine AS builder

# Install build dependencies (for any native packages)
RUN apk add --no-cache build-base

# Set workdir
WORKDIR /app

# Copy and install Python dependencies to isolated path
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# === Stage 2: Runtime ===
FROM python:3.11-alpine

# Install runtime dependencies only
RUN apk add --no-cache libgcc libstdc++

# Set workdir
WORKDIR /app

# Copy app source code
COPY src/ src/

# Copy only necessary Python packages from builder stage
COPY --from=builder /install /usr/local

# Expose Flask port
EXPOSE 5000

# Set entrypoint
ENTRYPOINT ["python", "src/app.py"]
