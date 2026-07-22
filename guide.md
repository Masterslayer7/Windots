# Windots Configuration & Setup Guide

This guide outlines how to restore your terminal and shell configuration on a fresh Windows PC and serves as a cheatsheet for all custom keybindings and aliases.

---

## 🚀 Part 1: Setup on a New PC

Follow these steps in order to fully replicate your environment:

### Step 1: Clone Your Repository & Setup Windows
1. Copy or clone this `.config` repository to `C:\Users\<YourUsername>\.config`.
2. Open **Windows PowerShell** as Administrator and run the Windows setup script:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   & "$env:USERPROFILE\.config\Setup.ps1"
   ```
   *This installs WezTerm, fonts, and sets up PowerShell symlinks.*

### Step 2: Install WSL (Ubuntu)
1. Open PowerShell and run:
   ```powershell
   wsl --install -d Ubuntu
   ```
2. Restart your computer if prompted. Set up your Ubuntu username and password.

### Step 3: Run the WSL Setup Script
1. Open **WezTerm** (which will launch straight into WSL).
2. Run this single command to dynamically locate your Windows config and install everything:
   ```bash
   bash /mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')/.config/wsl/wsl-setup.sh
   ```
3. Enter your Linux `sudo` password when prompted.
4. **Close WezTerm and reopen it.** Your Zsh shell, Starship prompt, and Neovim integrations are now fully active!

---

## ⌨️ Part 2: WezTerm Keyboard Shortcuts

Your WezTerm leader key is configured to **`Ctrl + Space`**.

### 1. Splitting & Pane Layouts
* **Vertical Split (Side-by-Side):** `Ctrl + Space` then `\` (or `|`)
* **Horizontal Split (Top-to-Bottom):** `Ctrl + Space` then `-` (or `"`)
* **Toggle Zoom (Maximize active pane):** `Ctrl + Space` then `z`
* **Close Active Pane:** `Ctrl + Space` then `x` (type `y` to confirm)
* **Select Pane by Screen Overlay:** `Ctrl + Space` then `q`

### 2. Tab Management
* **Create New Tab:** `Ctrl + Space` then `c`
* **Next Tab:** `Ctrl + Space` then `n`
* **Previous Tab:** `Ctrl + Space` then `p`
* **Close Tab:** `Ctrl + Shift + x`
* **Go to Specific Tab:** `Ctrl + Space` then `1` through `9`

### 3. Seamless Neovim Navigation
You can traverse both terminal panes and Neovim split windows seamlessly without using leader keys:
* **Move Focus:** `Ctrl + h` (Left) | `Ctrl + j` (Down) | `Ctrl + k` (Up) | `Ctrl + l` (Right)
* **Resize Active Pane:** `Alt + h` (Left) | `Alt + j` (Down) | `Alt + k` (Up) | `Alt + l` (Right)

### 4. Scrollback Copy Mode
* **Enter Copy Mode:** `Ctrl + Space` then `[`
* **Navigation:** Use standard Vim keys (`h`, `j`, `k`, `l`, `w`, `b`, `0`, `$`, `g`, `G`) to navigate history.
* **Select Text:** Press `v` (visual character), `Shift + v` (visual line), or `Ctrl + v` (visual block).
* **Copy & Close:** Press `y` to yank/copy the selected text to your Windows clipboard.
* **Exit Copy Mode:** Press `Escape` or `q`.

---

## 🐚 Part 3: Shell Aliases & Utilities

These aliases are active in both WSL (Zsh) and Windows (PowerShell):

### 1. Modern Commands
* `ls` / `ll` / `l` -> `eza` (Modern, colorized directory list with icons)
* `cat` -> `bat` (Syntax-highlighted file viewer)
* `vi` / `vim` -> `nvim` (Neovim editor)

### 2. Fuzzy Finder (FZF) Helpers
* **Fuzzy open file:** Type `fo` to search and open files in Neovim.
* **Fuzzy checkout Git branch:** Type `gco` to search and switch local or remote branches.
* **Fuzzy Git commit preview:** Type `gshow` to search commits and preview changes side-by-side.
* **Fuzzy SSH search:** Type `fssh` to search and connect to hosts in your SSH config.
* **Fuzzy process killer:** Type `fkill` to choose and terminate a running process.
