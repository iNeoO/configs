# Prompt — Arch + sway workstation

> Hand this as-is to an agent (Claude Code, Codex…) running on the new machine,
> from `~/github/ineoo/configs`.

---

You are setting up my workstation on a **fresh Arch Linux install**. The base install is already
done: my user exists with `sudo`, networking works (NetworkManager), and this repo is cloned at
`~/github/ineoo/configs`. Your goal: reproduce exactly the sway environment described by this repo.

The machine is a **Lenovo Yoga laptop** whose exact hardware I don't know: detect it, assume
nothing.

## Rules

1. **Official repositories only.** No AUR, no `yay`/`paru`. If a package is missing from `pacman`,
   stop and ask me.
2. **sudo**: if you cannot type a password, group the root commands and give them to me to run,
   then check the result yourself.
3. **Destroy nothing.** Before overwriting or replacing an existing file, move it to
   `~/.config-backups/<date>/`.
4. **Never run a downloaded script without reading it.** Pin a version (tag), never `curl | sh`
   from a branch.
5. **No secrets in the repo.** Tokens and passwords go in `~/.zshrc.local` (untracked), which I fill
   in myself.
6. **The repo is the source of truth**: configs are installed as **symlinks** into the repo, so a
   local change is directly a change to the repo.
7. Ask the questions marked **[question]** when you reach them, not before.

## Steps

### 1. Inventory
- `lspci -k | grep -EA3 'VGA|3D|Audio'`, `cat /sys/class/dmi/id/product_name`, `localectl`.
- Check the repo contains: `packages.txt`, `sway/`, `waybar/`, `wofi/`, `kitty/`, `fontconfig/`,
  `systemd/user/`, `zsh/`, `wallpapers/`.

### 2. Packages
- `sudo pacman -Syu --needed $(grep -vE '^\s*(#|$)' packages.txt)`
- Video drivers for the detected GPU:
  - Intel: `mesa vulkan-intel intel-media-driver`
  - AMD: `mesa vulkan-radeon libva-mesa-driver`
  - NVIDIA: **[question]** stop and ask me.
- Recent Intel audio (SOF driver in `lspci -k`): `sof-firmware` if not already installed.

### 3. System services
- `sudo systemctl enable --now bluetooth power-profiles-daemon docker`
- **[question]** Add my user to the `docker` group (root-equivalent): yes/no?
- **[question]** Local PostgreSQL, or only through Docker? If local:
  `sudo -iu postgres initdb -D /var/lib/postgres/data` then `sudo systemctl enable --now postgresql`.

### 4. Shell
- `chsh -s /usr/bin/zsh`
- Oh My Zsh without its install script:
  `git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh`
- Create an empty `~/.zshrc.local`, `chmod 600`.

### 5. Configs (symlinks into the repo)

| Repo | Destination |
|---|---|
| `sway/` | `~/.config/sway` |
| `waybar/` | `~/.config/waybar` |
| `wofi/` | `~/.config/wofi` |
| `kitty/` | `~/.config/kitty` |
| `fontconfig/` | `~/.config/fontconfig` |
| `zsh/.zshrc`, `zsh/.zprofile` | `~/` |

Then:
- **Copy** (not symlink) `systemd/user/sway-session.target` into `~/.config/systemd/user/`.
- Copy `wallpapers/gundam.jpg` to `~/images/gundam.jpg`.
- `fc-cache -f`.

### 6. Tools installed outside pacman
These come from their official install scripts. For each one: fetch the script **pinned to a
release tag**, read it, then run it. Install nothing that writes to `~/.zshrc`: the repo's
`.zshrc` already loads what is needed.

- **nvm**: latest release tag of `nvm-sh/nvm` (GitHub API), run `install.sh` with
  `PROFILE=/dev/null`, then `nvm install --lts` and `corepack enable`.

### 7. User services
- `systemctl --user enable ssh-agent.socket waybar.service`
- Check that `pipewire.socket`, `pipewire-pulse.socket` and `wireplumber.service` are enabled.
- `systemctl --user daemon-reload`.

### 8. SSH and git
- Append at the **end** of `~/.ssh/config` (create it with mode `600` if needed):
  ```
  Host *
      AddKeysToAgent yes
  ```
- Do not generate or copy any key: I restore mine by hand.
- **[question]** Name and e-mail for `git config --global user.name / user.email`.

### 9. Hardware adaptation
- **[question]** Physical keyboard: QWERTY (keep `us` / `intl`) or AZERTY (`fr`)? Adjust the
  `input *` block in `sway/config`.
- Output names are only known inside sway. Ask me to log in on tty1 (sway starts automatically from
  `.zprofile`), then run `swaymsg -t get_outputs`:
  - if the internal panel is not named `eDP-1`, fix `sway/config` and
    `waybar/scripts/display-menu.sh`;
  - **[question]** if the panel is wider than 1920 px, suggest a `scale` (1.25 / 1.5 / 2).
- `swaymsg reload` after each change.

### 10. Verification (inside sway)
Check each item and mark it OK/KO:
- waybar at the bottom, icons rendered (no boxes), clickable workspaces
- `Mod+Return`: transparent kitty in JetBrains Mono
- `Mod+d`: wofi
- wallpaper displayed
- network applet in the tray
- volume and brightness keys
- `Mod+Shift+o`: screen locked and blurred
- `notify-send test`: mako notification
- `ssh-add -l` answers (agent reachable)
- `docker run --rm hello-world` (if docker group accepted, after logging in again)
- `node -v`, `code --version`, `vivaldi --version`

### 11. Final report
Give me:
- what was done;
- what failed, with the error output;
- what I must do by hand: SSH keys, `~/.zshrc.local` (tokens), signing in to the browsers and to
  VS Code;
- the repo files you changed for the hardware adaptation. **Do not commit**: I review the diff
  first.
