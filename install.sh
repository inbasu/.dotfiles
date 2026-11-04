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
        kitty neovim
        stow jq ufw iwd
    )
    echo ">> pacman: недостающие из: ${packages[*]}"
    sudo pacman -S --needed "${packages[@]}"
fi

# --- 1) stow ----------------------------------------------------------------
# Правильная раскладка: ~/.config — реальный каталог, внутри — лин-ки на
# наши дот-файлы из репо; .zshrc/.zlogin — лин-ки на уровень вверх.
if [[ -L $HOME/.config ]]; then
    link=$(readlink "$HOME/.config")
    case "$link" in
        *"$(basename "$DOT")/.config")
            # старая схема («.config целиком линком») — заменяем на реальный каталог
            rm "$HOME/.config"
            mkdir "$HOME/.config"
            echo "stow:     старый линк ~/.config снят, каталог создан"
            ;;
        *)
            echo "ОШИБКА: ~/.config — симлинк в чужое место ($link)." >&2
            echo "Не трогаю: разберись вручную." >&2
            exit 1
            ;;
    esac
elif [[ ! -d $HOME/.config ]]; then
    mkdir "$HOME/.config"
fi

if ! stow -d "$(dirname "$DOT")" -t "$HOME" "$(basename "$DOT")"; then
    echo "ОШИБКА: stow не смог связать дот-файлы" >&2
    exit 1
fi
echo "stow:     ok (~/.config/<app> → $(basename "$DOT")/.config/<app>)"

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
