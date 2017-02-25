@echo off
ssh devbox@127.0.0.1 -p 2022 xpra --xvfb="Xorg -noreset -nolisten tcp +extension GLX -config /etc/xpra/xorg.conf +extension RANDR +extension RENDER -logfile ${HOME}/.xpra/Xorg-10.log" start --no-microphone --no-webcam --no-speaker --pulseaudio=no --start=/opt/phpstorm/bin/phpstorm.sh --printing=no :10

pause >nul