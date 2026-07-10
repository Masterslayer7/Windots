#!/bin/bash
set -e

echo "============================================="
echo "   Windots WSL Portable Setup Script v2.0    "
echo "============================================="

# ------------------------------------------------------------
# 1. Dynamic Windows Username Detection
# ------------------------------------------------------------
echo "Detecting Windows username..."
WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Fallback if cmd.exe is not accessible
if [ -z "$WIN_USER" ]; then
    for u in /mnt/c/Users/*; do
        if [ -d "$u/.config" ]; then
            WIN_USER=$(basename "$u")
            break
        fi
    done
fi

if [ -z "$WIN_USER" ]; then
    echo "[ERROR] Could not detect your Windows user directory under /mnt/c/Users/"
    exit 1
fi

WIN_CONFIG_DIR="/mnt/c/Users/$WIN_USER/.config"
echo "Found Windows Config Directory: $WIN_CONFIG_DIR"

# ------------------------------------------------------------
# 2. Package Installation Helpers
# ------------------------------------------------------------
update_apt() {
    if [ -z "$APT_UPDATED" ]; then
        echo "Updating apt repositories..."
        sudo apt update
        APT_UPDATED=1
    fi
}

check_and_install() {
    local cmd="$1"
    local pkg="$2"
    if ! command -v "$cmd" &>/dev/null; then
        update_apt
        echo "Installing $pkg..."
        sudo apt install -y "$pkg"
    else
        echo "✓ $cmd is already installed ($pkg)."
    fi
}

# ------------------------------------------------------------
# 3. Install Packages & Shell Tools
# ------------------------------------------------------------
echo "Checking and installing dependencies..."
check_and_install curl curl
check_and_install git git
check_and_install zsh zsh
check_and_install fzf fzf
check_and_install rg ripgrep
check_and_install fdfind fd-find
check_and_install batcat bat
check_and_install eza eza
check_and_install gh gh
check_and_install make make
check_and_install cmake cmake
check_and_install gcc build-essential
check_and_install node "nodejs npm"
check_and_install sqlite3 "sqlite3 libsqlite3-dev"

# Install Fastfetch
if ! command -v fastfetch &>/dev/null; then
    echo "Installing fastfetch..."
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo apt install -y fastfetch
else
    echo "✓ fastfetch is already installed."
fi

# Install Neovim
if ! command -v nvim &>/dev/null; then
    echo "Installing Neovim..."
    sudo snap install nvim --classic || sudo apt install -y neovim
else
    echo "✓ Neovim is already installed."
fi

# Install Starship
if ! command -v starship &>/dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "✓ Starship is already installed."
fi

# Install Zoxide
if ! command -v zoxide &>/dev/null; then
    echo "Installing Zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "✓ Zoxide is already installed."
fi

# Install Zig
if ! command -v zig &>/dev/null; then
    echo "Installing Zig..."
    sudo snap install zig --classic || sudo apt install -y zig
else
    echo "✓ zig is already installed."
fi

# Install Task
if ! command -v task &>/dev/null; then
    echo "Installing task..."
    sudo snap install task --classic || sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
else
    echo "✓ task is already installed."
fi

# Install Lazygit
if ! command -v lazygit &>/dev/null; then
    echo "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm -f lazygit lazygit.tar.gz
else
    echo "✓ lazygit is already installed."
fi

# Clone Zsh plugins (Syntax Highlighting & Autosuggestions)
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    echo "Cloning zsh-syntax-highlighting..."
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
else
    echo "✓ Zsh syntax highlighting is already installed."
fi

if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "Cloning zsh-autosuggestions..."
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.zsh/zsh-autosuggestions"
else
    echo "✓ Zsh autosuggestions is already installed."
fi

# ------------------------------------------------------------
# 4. Symbolic Links setup for config folders
# ------------------------------------------------------------
echo "Setting up configuration symlinks..."
mkdir -p "$HOME/.config"

create_symlink() {
    local src="$1"
    local dest="$2"
    if [ ! -d "$src" ] && [ ! -f "$src" ]; then
        echo "Warning: Source $src does not exist, skipping."
        return
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        rm -rf "$dest"
    fi
    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
}

create_symlink "$WIN_CONFIG_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$WIN_CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch"
create_symlink "$WIN_CONFIG_DIR/lazygit" "$HOME/.config/lazygit"
create_symlink "$WIN_CONFIG_DIR/starship" "$HOME/.config/starship"
create_symlink "$WIN_CONFIG_DIR/bat" "$HOME/.config/bat"
create_symlink "$WIN_CONFIG_DIR/tmux" "$HOME/.config/tmux"
create_symlink "$WIN_CONFIG_DIR/wezterm" "$HOME/.config/wezterm"

# ------------------------------------------------------------
# 5. Shell Configuration
# ------------------------------------------------------------
# 5a. Configure .zshrc
echo "Generating ~/.zshrc..."
cat << EOF > "$HOME/.zshrc"
# ~/.zshrc - ZSH Configuration

# PATH must be set before sourcing addon (zoxide, starship live in ~/.local/bin)
export PATH="\$HOME/.local/bin:\$PATH"

# Load Windots WSL addon if it exists
if [ -f "$WIN_CONFIG_DIR/wsl/.zshrc_addon" ]; then
    source "$WIN_CONFIG_DIR/wsl/.zshrc_addon"
fi
EOF

# 5b. Configure .bashrc
BASHRC_HOOK=$(cat << EOF

# --- WINDOTS WSL INTEGRATION ---
if [ -f "$WIN_CONFIG_DIR/wsl/.bashrc_addon" ]; then
    source "$WIN_CONFIG_DIR/wsl/.bashrc_addon"
fi
# -------------------------------
EOF
)

if ! grep -q "WINDOTS WSL INTEGRATION" "$HOME/.bashrc"; then
    echo "Adding Windots integration hook to ~/.bashrc..."
    echo "$BASHRC_HOOK" >> "$HOME/.bashrc"
fi

# ------------------------------------------------------------
# 6. Change Default Shell to Zsh
# ------------------------------------------------------------
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$CURRENT_SHELL" != *"zsh" ]]; then
    echo "Setting default shell to Zsh..."
    chsh -s "$(which zsh)"
fi

echo "============================================="
echo " Setup complete! Reopen WezTerm to load Zsh! "
echo "============================================="
