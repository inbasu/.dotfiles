#!/usr/bin/env bash
# install.sh — установка дотфайлов из ~/.dotfiles:
#   0) pacman: базовые пакеты (--needed — уже установленные пропустит)
#   1) stow: ~/.config → ~/.dotfiles/.config (если ещё не связано)
#   2) system-часть (нужен sudo, ложится ВНЕ ~/.config):
#        - /usr/local/bin/sshctl          ← .config/hypr/scripts/sshctl
#        - /usr/local/bin/battery-refresh ← .config/hypr/scripts/battery-refresh
#        - /etc/udev/rules.d/99-battery-refresh.rules
#        - /etc/systemd/system/sshctl-cleanup.service (+ enable)
#   3) user-часть:
#        - systemd --user daemon-reload
#        - enable --now net-refresh.service (мониторинг сети для waybar)
#
# Идемпотентен: повторный запуск ничего не ломает.
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "репо:     $DOT"

# --- 0) пакеты ----------------------------------------------------------------
if command -v pacman >/dev/null; then
    #Extracted from the old install.sh; + stow/jq/ufw/iwd — needed for scripts
    packages=(
        hyprland hyprpaper mako waybar
        ghostty kitty neovim
        stow jq ufw iwd
    )
    echo ">> pacman: недостающие из: ${packages[*]}"
    sudo pacman -S --needed "${packages[@]}"
fi

# --- 1) stow -----------------------------------------------------------------
if [[ -e $HOME/.config && ! -L $HOME/.config ]]; then
    echo "ОШИБКА: $HOME/.config — реальный каталог." >&2
    echo "Не хочу складывать поверх; перенеси содержимое в $DOT/.config сам." >&2
    exit 1
fi
if ! stow -d "$DOT" -t "$HOME" .config; then
    echo "ОШИБКА: stow не смог связать .config" >&2
    exit 1
fi
echo "stow:     ok ($HOME/.config → $DOT/.config)"

sudo() {
    echo ">> sudo $*"
    command sudo "$@"
}

# --- 2) system-часть ---------------------------------------------------------
sudo install -Dm755 "$DOT/.config/hypr/scripts/sshctl"          /usr/local/bin/sshctl
sudo install -Dm755 "$DOT/.config/hypr/scripts/battery-refresh" /usr/local/bin/battery-refresh
sudo install -Dm644 "$DOT/.config/hypr/udev/99-battery-refresh.rules" \
    /etc/udev/rules.d/99-battery-refresh.rules
sudo install -Dm644 "$DOT/.config/systemd/system/sshctl-cleanup.service" \
    /etc/systemd/system/sshctl-cleanup.service

sudo udevadm control --reload
sudo systemctl daemon-reload
sudo systemctl enable --now sshctl-cleanup.service

# --- 3) user-часть -----------------------------------------------------------
systemctl --user daemon-reload
systemctl --user enable --now net-refresh.service

echo
echo "Готово. Проверки:"
echo "  systemctl --user status net-refresh.service"
echo "  systemctl status sshctl-cleanup.service"
echo "  udevadm control --reload  # правило батареи перечитано"
echo "  /usr/bin/sudo -n /usr/local/bin/sshctl status && echo OK"
