Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

This repo contains my shell + Wayland desktop + terminal + editor configuration, including (at least):

- `zsh` (`.zshrc`)
- Hyprland (`~/.config/hypr`)
- Waybar (`~/.config/waybar`)
- Kitty (`~/.config/kitty`)
- Neovim (`~/.config/nvim`)
- nnn (`~/.config/nnn`)
- fuzzel (`~/.config/fuzzel`)
- (optional) Oh My Zsh bits (`~/.oh-my-zsh` or custom pieces)

> ⚠️ These are my personal configs. Expect assumptions about packages, fonts, and hardware.

---

## Screenshots

Add screenshots here if you want:
- `./screenshots/...`

---

## Prerequisites

You’ll need:

- `git`
- `chezmoi`
- `zsh`
- Wayland + Hyprland stack (Hyprland, Waybar, fuzzel, kitty, etc.)
- Neovim
- (optional) `nnn`

### Fedora Workstation (dnf)

```sh
sudo dnf install -y \
  git chezmoi zsh \
  hyprland waybar kitty fuzzel neovim nnn
