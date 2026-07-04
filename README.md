Here’s your **clean, complete, GitHub-ready README.md** with the missing Kokoro-FastAPI clone step added and everything organized properly.

---

#  Joey – Voice AI Assistant (LiveKit Cloud + Local TTS)

Joey is a high-performance voice AI assistant built on **LiveKit Agents**, combining:

*  LiveKit Cloud AI (STT + LLM)
*  OpenAI GPT-4.1-mini for reasoning
*  Local Kokoro TTS (FastAPI server) for high-quality low-latency speech

It is designed for real-time conversational voice AI with modular architecture.

---

#  Architecture Overview

* **`agent.py`**

  * Main LiveKit Agent runtime
  * Handles voice pipeline orchestration
  * Uses:

    * STT → AssemblyAI (`assemblyai/universal-streaming:en`)
    * LLM → OpenAI (`gpt-4.1-mini` via LiveKit Cloud)

* **`Kokoro-FastAPI/`**

  * Local FastAPI-based TTS server
  * Runs Kokoro models offline
  * Provides OpenAI-compatible speech synthesis API

* **`kokoro.py`**

  * Custom LiveKit TTS adapter
  * Streams audio chunks from local server into LiveKit pipeline

---

#  Getting Started

## 1. Prerequisites

Install dependencies:

```bash
uv pip install -e .
```

or:

```bash
pip install -r requirements.txt
```

---

## 2. Configure Environment Variables

Create a `.env` file in the root directory:

```env
LIVEKIT_URL=wss://your-project.livekit.cloud
LIVEKIT_API_KEY=your_api_key
LIVEKIT_API_SECRET=your_api_secret
```

---

#  3. Clone Required Repositories

This project depends on a local TTS service.

## Clone Main Project

```bash
git clone https://github.com/MUKIL1175/LiveKit_Kokoro_TTS.git
cd LiveKit_Kokoro_TTS
```

## Clone Kokoro-FastAPI (TTS Server)

```bash
git clone https://github.com/remsky/Kokoro-FastAPI.git
```

---

#  4. Start Kokoro TTS Server

Go into the TTS directory:

```bash
cd Kokoro-FastAPI
```

Install dependencies:

```bash
uv pip install -e .
```

Start the server:

```bash
uv run uvicorn api.src.main:app --port 8880
```

---

##  Verify TTS Server

Open in browser:

* [http://localhost:8880/health](http://localhost:8880/health)
* [http://localhost:8880/web/](http://localhost:8880/web/)

If it responds, your TTS engine is ready.

---

#  Running the Voice Assistant

Go back to project root:

```bash
cd ../LiveKit_Kokoro_TTS
```

---

## ▶ Option A: Local Interactive Mode

Run voice assistant in terminal:

```bash
./start.sh
```

---

## ▶ Option B: LiveKit Cloud Mode (Agent Worker)

Register the agent with LiveKit Cloud:

```bash
./start.sh dev
```

---

#  Configuration Notes

* Default TTS voice: `af_bella`
* Default speed: `0.87`
* TTS server runs on: `http://localhost:8880`
* Ensure Kokoro-FastAPI is running BEFORE starting agent

---

#  Project Structure

```bash
LiveKit_Kokoro_TTS/
│
├── agent.py              # Main LiveKit voice agent
├── kokoro.py             # TTS adapter (LiveKit integration)
├── start.sh              # Startup script
├── pyproject.toml
├── uv.lock
│
├── Kokoro-FastAPI/      # Local TTS server (separate repo)
│
├── learn.txt
└── README.md
```

---

# mportant Notes

* Do NOT commit `.env` files
* Do NOT push model weights or large binaries
* Ensure port `8880` is free before starting TTS server
* Keep both services running for full functionality

---

#  One-Line Setup (Recommended)

```bash
git clone https://github.com/MUKIL1175/LiveKit_Kokoro_TTS.git
git clone https://github.com/<YOUR_ORG>/Kokoro-FastAPI.git

cd LiveKit_Kokoro_TTS
./start.sh
```

---

#  Future Improvements

* Docker support for full stack
* Streaming TTS optimization
* Web UI for voice chat
* Multi-voice support in Kokoro
* Production deployment (AWS / Render / VPS)

---
