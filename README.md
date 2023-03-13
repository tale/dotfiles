# Dotfiles

These are my dotfiles, that I've specifically tuned for my needs.<br>
If you're interested in using them, I've tried to make them as easy to use as possible.<br>
When creating these dotfiles, I had a few requirements:

- Be able to use the same dotfiles on macOS and Linux
- Minimal shell environment to keep things fast
- Declutter the home (~) directory

## Features

- ZSH (no plugin manager)
  - Using an asynchronous minimal prompt called [Typewritten](https://typewritten.dev/#/)
  - [ZSH Completions](https://github.com/zsh-users/zsh-completions) and [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - Faster `compinit` by only using `zcompdump` in login shells
  - Different ZSH configuration directory in `~/.config/zsh`
  - Conditional loading of configs based on the OS
- Neovim
  - [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management and fast startup
  - Sensible keybindings using the Command key on macOS with usage via a GUI like Neovide
  - Automated LSP installation and configuration with [Mason](https://github.com/williamboman/mason.nvim)
  - Tab-based completions via LSP using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
  - File and fuzzy searching using [Telescope](https://github.com/nvim-telescope/telescope.nvim) and the native `fzf` integration
  - File explorer through [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) and status-line via [lualine](https://github.com/nvim-lualine/lualine.nvim)
  - Multi-cursor support similar to Visual Studio Code using [vim-visual-multi](https://github.com/mg979/vim-visual-multi)
  - Better syntax highlighting using [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - Darker color scheme using [Rose Pine](https://github.com/rose-pine/neovim)
  - [Comment.nvim](https://github.com/numToStr/Comment.nvim) to simplify commenting blocks of code
  - [Copilot.lua](https://github.com/zbirenbaum/copilot.lua) a faster version of GitHub Copilot for Neovim
  - [Devcontainer support](https://codeberg.org/esensar/nvim-dev-container) through remote attaching
  - [Diffview.nvim](https://github.com/sindrets/diffview.nvim) for git diffs
  - Integrated terminal and floating git management TUI using [lazygit](https://github.com/jesseduffield/lazygit) and [FTerm](https://github.com/numToStr/FTerm.nvim)
  - Git status markers on the left via [gitsigns](https://github.com/lewis6991/gitsigns.nvim) and virtual blame via [gitblame.nvim](https://github.com/f-person/git-blame.nvim)
  - Indent guides and ruler through [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)
  - Wakatime integration with the official Vim wakatime plugin
- Git Configuration
  - Global [`gitignore`](./config/git/.gitignore) for macOS and Linux
  - Git hooks that ensure GPG and committer email match and that commits are conventional
  - Hook for [Husky](https://github.com/typicode/husky) to ensure that global git hooks are run
- Development Environments
  - [Node.js](https://nodejs.org) and [PNPM](https://pnpm.io) for JavaScript development
  - [Theos](https://github.com/theos/theos) installation on macOS for iOS development
  - [Rust](https://www.rust-lang.org) installation on macOS and Linux
  - [Golang](https://golang.org) installation on macOS
- A [`launchd`](https://www.launchd.info) to automatically run a daily maintenance script on macOS
- A [Homebrew](https://brew.sh) installation and bundle to install all the tools I use on macOS
- Automated installation of all the dotfiles through a bootstrap script
- Ligature SF Mono Nerd Font for editors and terminals
- A custom configuration for [Alacritty](https://alacritty.org)

## Installation

There are various ways to install these dotfiles, but the easiest way is to use the bootstrap script.<br>
The bootstrap script will install all the dependencies and then install the dotfiles.

### Standalone URL

Please ensure that you have `bash`, `curl`, `git`, and `coreutils` installed before running the bootstrap script.<br>
These all come preinstalled on macOS, but on Linux you may need to install them manually.

```sh
curl -fsSL https://raw.githubusercontent.com/tale/dotfiles/main/bootstrap.sh | bash -
```

### Visual Studio Code (via Git)

I specifically use this method for the [VSCode's Devcontainer Automation feature](https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories).<br>
This method automatically sets up the dotfiles within the container.<br>
Instead of cloning, I set the following options in my VSCode settings:

```json
{
    "dotfiles.repository": "https://github.com/tale/dotfiles.git",
    "dotfiles.targetPath": "~/.config/dotfiles",
}
```

## Updating

There's an inbuilt updater function that will update the dotfiles and all the dependencies.<br>
Simply run `dotdate` in your terminal to update the dotfiles.<br>
As for submodules and dependencies, I update them occasionally.

> **Note:** The updater will not update the dotfiles if there are any uncommitted changes.

On a final note, because these are mostly meant for me, I don't really offer support for these dotfiles.<br>
If you have any questions, feel free to open an issue or contact me on [Twitter](https://twitter.com/aarnavtale).
> Copyright (c) 2023 Aarnav Tale
