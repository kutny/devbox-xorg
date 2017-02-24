@echo off
ssh devbox@127.0.0.1 -p 2022 xpra start --no-microphone --no-webcam --no-speaker --pulseaudio=no --start=firefox --printing=no :10

pause >nul