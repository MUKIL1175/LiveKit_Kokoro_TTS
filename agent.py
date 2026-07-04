import logging
from dotenv import load_dotenv

from livekit import agents
from livekit.agents import Agent, AgentServer, AgentSession, JobContext, room_io
from livekit.plugins import noise_cancellation, silero, openai

load_dotenv()

# -------------------------------------------------
# Agent Definition
# -------------------------------------------------
class Assistant(Agent):
    def __init__(self) -> None:
        super().__init__(
            instructions="""
You are Joey, a helpful voice AI assistant created by and working for Blackwins.

Rules:
- Always respond in a natural spoken style
- Keep responses short and clear
- Be conversational and friendly
"""
        )

# -------------------------------------------------
# Server
# -------------------------------------------------
server = AgentServer()

# -------------------------------------------------
# Entry point
# -------------------------------------------------
@server.rtc_session()
async def entrypoint(ctx: JobContext):

    # -------------------------------------------------
    # Kokoro TTS (OpenAI-compatible local server)
    # -------------------------------------------------
    tts = openai.TTS(
        model="tts-1",
        voice="af_bella",
        base_url="http://localhost:8880/v1",
        api_key="not-needed",
        response_format="pcm",
        speed=0.87,
    )

    # -------------------------------------------------
    # Agent Session (full pipeline)
    # -------------------------------------------------
    session = AgentSession(
        stt="assemblyai/universal-streaming:en",
        llm="openai/gpt-4.1-mini",
        tts=tts,
        vad=silero.VAD.load(),
    )

    # -------------------------------------------------
    # Start session
    # -------------------------------------------------
    await session.start(
        agent=Assistant(),
        room=ctx.room,
        room_options=room_io.RoomOptions(
            audio_input=room_io.AudioInputOptions(
                noise_cancellation=noise_cancellation.BVC(),
            ),
        ),
    )

# -------------------------------------------------
# Main
# -------------------------------------------------
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    agents.cli.run_app(server)