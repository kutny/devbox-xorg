REM "C:\Program Files (x86)\Xpra\Xpra_cmd.exe" attach --ssh="ssh devbox@127.0.0.1 -p 2022" ssh:devbox@127.0.0.1:10
REM you can specify your ssh password in the xpra command line, like so: xpra attach ssh/devbox:asdf@UBUNTUIP:SSHPORT/ (and append DISPLAY to this string only if you run multiple instances)

"C:\Program Files (x86)\Xpra\Xpra_cmd.exe" attach ssh/devbox@127.0.0.1:2022
