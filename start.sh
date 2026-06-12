#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=========================================================="
echo "🚀 Starting Local Voice Agent System (Joey & Kokoro TTS) 🚀"
echo "=========================================================="

# Get the script's directory (project root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Define cleanup function to terminate the background server on exit
cleanup() {
    if [ -n "$FASTAPI_PID" ]; then
        echo -e "\n🛑 Stopping Kokoro-FastAPI server (PID: $FASTAPI_PID)..."
        kill "$FASTAPI_PID" 2>/dev/null || true
        wait "$FASTAPI_PID" 2>/dev/null || true
    fi
}
trap cleanup INT TERM EXIT

# Step 1: Start Kokoro-FastAPI in the background
echo "📦 Starting Kokoro-FastAPI server on port 8880..."
cd "$SCRIPT_DIR/Kokoro-FastAPI"
"$SCRIPT_DIR/.venv/bin/uvicorn" api.src.main:app --port 8880 > "$SCRIPT_DIR/kokoro_server.log" 2>&1 &
FASTAPI_PID=$!
cd "$SCRIPT_DIR"

# Step 2: Poll health check until healthy
# Model warmup can take 30-60+ seconds on first run
echo "⏳ Waiting for Kokoro-FastAPI server to become healthy (model warmup may take ~60s)..."
MAX_ATTEMPTS=90
ATTEMPT=1
HEALTHY=0

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    if curl -s http://localhost:8880/health 2>/dev/null | grep -q '"status":"healthy"'; then
        HEALTHY=1
        break
    fi

    # Check if the server process died
    if ! kill -0 "$FASTAPI_PID" 2>/dev/null; then
        echo "❌ Kokoro-FastAPI server crashed during startup."
        echo "   Check logs: $SCRIPT_DIR/kokoro_server.log"
        tail -20 "$SCRIPT_DIR/kokoro_server.log"
        exit 1
    fi

    sleep 1
    ATTEMPT=$((ATTEMPT + 1))
done

if [ $HEALTHY -eq 0 ]; then
    echo "❌ Timeout waiting for Kokoro-FastAPI server."
    echo "   Check logs: $SCRIPT_DIR/kokoro_server.log"
    tail -20 "$SCRIPT_DIR/kokoro_server.log"
    exit 1
fi

echo "✅ Kokoro-FastAPI server is healthy and running!"

# Step 3: Run the Agent
# Default to console mode, but support dev mode if passed as parameter
RUN_MODE="console"
if [ "$1" == "dev" ]; then
    RUN_MODE="dev"
fi

echo "🎙️ Starting Joey voice assistant in '$RUN_MODE' mode..."
echo "----------------------------------------------------------"
uv run python agent.py "$RUN_MODE"
