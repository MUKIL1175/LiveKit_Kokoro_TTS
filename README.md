# Joey - Voice AI Assistant (LiveKit Cloud + Local TTS)

Joey is a high-performance voice AI assistant built on **LiveKit Agents**, utilizing online intelligence (via LiveKit Cloud Inference for AssemblyAI STT and OpenAI LLM) paired with a local **Kokoro-FastAPI** server for low-latency, high-quality local Text-to-Speech (TTS).

---

## Architecture Overview

- **Agent Logic (`agent.py`)**: Runs the LiveKit voice agent session. It routes STT (`assemblyai/universal-streaming:en`) and LLM (`openai/gpt-4.1-mini`) online via LiveKit Cloud Inference, and sends speech synthesis requests to the local TTS server.
- **Local TTS Engine (`Kokoro-FastAPI`)**: A local, OpenAI-compatible web server running Kokoro models to produce premium speech audio offline.
- **Custom Adapter (`kokoro.py`)**: Extends LiveKit's TTS core to handle local streaming of audio chunks.

---

## 🛠️ Getting Started

### 1. Prerequisites

Ensure dependencies are installed using `uv` or `pip`:
```bash
uv pip install -e .
```

### 2. Configure Your LiveKit Cloud Credentials

Ensure your active LiveKit Cloud URL, API Key, and Secret are saved in the `.env` file at the root of the project:
```env
LIVEKIT_URL=wss://your-project.livekit.cloud
LIVEKIT_API_KEY=your_api_key
LIVEKIT_API_SECRET=your_api_secret
```

### 3. Start the Local Kokoro TTS Server

Start the FastAPI server inside the `Kokoro-FastAPI` folder. It runs on port `8880` by default:
```bash
cd Kokoro-FastAPI
uv run uvicorn api.src.main:app --port 8880
```
*(Verify by visiting `http://localhost:8880/health` or `http://localhost:8880/web/` in your browser)*

---

## 🚀 Running the Assistant

You can run the entire system (FastAPI server + Agent) together using the startup script:

### Option A: Local Console Mode (Microphone/Speaker in Terminal)
To converse with the agent directly in your terminal:
```bash
./start.sh
```

### Option B: Local LiveKit Server Mode
To register the agent worker with your LiveKit Cloud project:
```bash
./start.sh dev
```

---

## ⚙️ Configuration Details
- **Voice / Speed**: Instantiated in `agent.py` using `voice="af_bella"` and `speed=0.87`.
