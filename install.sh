#!/usr/bin/env bash
set -Eeuo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
[[ $EUID -ne 0 ]] || { echo 'Run as your normal user, not sudo.' >&2; exit 1; }
sudo apt-get update
sudo apt-get install -y gcc libx11-dev libxrandr-dev
mkdir -p "$HOME/.local/bin" "$HOME/.config/systemd/user" "$HOME/.local/share/icc"
install -m 644 "$ROOT/profiles/ASUS_sRGB.icm" "$HOME/.local/share/icc/ASUS_sRGB.icm"
install -m 644 "$ROOT/profiles/ASUS_DisplayP3.icm" "$HOME/.local/share/icc/ASUS_DisplayP3.icm"
install -m 644 "$ROOT/profiles/ASUS_DCIP3.icm" "$HOME/.local/share/icc/ASUS_DCIP3.icm"
gcc -O2 "$ROOT/config/display-contrast.c" -o "$HOME/.local/bin/display-contrast" -lXrandr -lX11
chmod 755 "$HOME/.local/bin/display-contrast"
cat > "$HOME/.config/systemd/user/display-comfort.service" <<'UNIT'
[Unit]
Description=Neutral ASUS display contrast curve
After=graphical-session.target
[Service]
Type=simple
Environment=DISPLAY=:0
Environment=XAUTHORITY=%h/.Xauthority
ExecStart=%h/.local/bin/display-comfort-guard
Restart=always
RestartSec=2
[Install]
WantedBy=default.target
UNIT
install -m 755 "$ROOT/config/display-comfort-guard" "$HOME/.local/bin/display-comfort-guard"
systemctl --user daemon-reload
systemctl --user enable --now display-comfort.service
echo 'Installed. Brightness is not changed or locked.'
