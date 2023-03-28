# Dotfiles

These are the files required to get my system up and running quickly.<br>
I've tuned them for my specific needs, and change them as I change my workflow.<br>
When building my dotfiles, I stick to the following philosophies and requirements:<br>

- Support a proper environment on macOS and Ubuntu 22
- Minimal shell, compromising on heavy features in favor of speed
- Uncluttered home (~) directory and proper utilization of ~/.config

## Configurations

- **General**:
  - A [`launchd`](https://www.launchd.info) task to run a daily maintenance script on macOS
  - A [Homebrew](https://brew.sh) installation and bundle to install all the tools I use on macOS
  - Automated installation of all the dotfiles through a bootstrap script

- **ZSH**:
  - No plugin manager to keep things fast
  - Cached `compinit` using a stored `zcompdump` file
  - Conditional loading of configurations based on OS
  - [Typewritten](https://typewritten.dev/#/): an asynchronous, minimal prompt
  - [ZSH Completions](https://github.com/zsh-users/zsh-completions) and [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

- **Tmux**:
  - Custom keybinds to emulate vim-like commands
  - Fancy tab-bar style to better readability
  - Floating windows for [btop](https://github.com/aristocratos/btop) and [lazygit](https://github.com/jesseduffield/lazygit)
  - [Alacritty](https://alacritty.org) terminal configuration on macOS

- **Neovim**:
  - Plugin management via [Lazy.nvim](https://github.com/folke/lazy.nvim)
  - Beautiful [ayu mirage](https://github.com/Shatur/neovim-ayu) color scheme
  - Terminal friendly keybindings and user interface
  - LSP configuration and automated [completions](https://github.com/hrsh7th/nvim-cmp))
  - Searching and navigation through [Telescope](https://github.com/nvim-telescope/telescope.nvim)
  - Very responsive [File-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) and [status-line](https://github.com/nvim-lualine/lualine.nvim) with batteries
  - Virtual git-blame and status indicators in the gutter ([gitsigns](https://github.com/lewis6991/gitsigns.nvim))
  - Wakatime integration with the official Vim wakatime plugin

- **Git Configuration**:
  - Global [`gitignore`](./config/git/.gitignore) for macOS and Linux
  - Git hook to ensure GPG email and committer email match
  - Git commit hook to validate conventional commit format
  - Hook for [Husky](https://github.com/typicode/husky) to ensure that global git hooks are run

- **Development Environment**:
  - [Node.js](https://nodejs.org) and [PNPM](https://pnpm.io) for JavaScript development
  - [Theos](https://github.com/theos/theos) installation on macOS for iOS development
  - [Rust](https://www.rust-lang.org) installation on macOS and Linux
  - [Golang](https://golang.org) installation on macOS

## Installation

Please ensure that you have `bash`, `curl`, `git`, and `coreutils` installed before running the bootstrap script.<br>
These all come preinstalled on macOS, but on Linux you may need to install them manually.

```sh
curl -fsSL https://raw.githubusercontent.com/tale/dotfiles/main/bootstrap.sh | bash -
```

## Updating

There's an inbuilt utility function meant for managing the dotfiles installation.<br>
Simply run `dotfiles update` in your terminal to update the dotfiles.<br>
As for submodules and dependencies, I update them occasionally.

> **Note:** The updater will not update the dotfiles if there are any uncommitted changes.

On a final note, because these are mostly meant for me, I don't really offer support for these dotfiles.<br>
If you have any questions, feel free to contact me on [Twitter](https://twitter.com/aarnavtale).
> Copyright (c) 2023 Aarnav Tale
