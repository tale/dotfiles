# Dotfiles
```sh
curl -fsSL https://raw.githubusercontent.com/tale/dotfiles/main/bootstrap.sh | bash -
```
All of the files with the dots in them, but with a few requirements:
- It has to be easy, because I'm lazy
- Deterministic and easily bootstrapped
- Minimal shell, snappy responsiveness

#### Tmux
- Sessionizer to separate projects and contexts
- Open Neogit (magit clone) from wherever you are
- More sane bindings for pane layout and management

#### Zsh
- Custom prompt and all the compiled `zwc` magic
- Autosuggestions and better history across sessions
- Better looking `LS_COLORS` and shell styling options
- That random `compinit` script we copied from 2016
- A proper harness to always stay within Tmux

#### Neovim
- The insane amount of boilerplate for LSP and completions
- Telescope to search for and within all the files ever
- My dislike for file explorers led me to [oil.nvim](https://github.com/stevearc/oil.nvim)
- Virtual git blames and status indicators in the gutter

#### Nix
- Utilizing `nix-darwin` and `home-manager` for configuration
- Stable `nixpkgs` for all the system packages that I need
- All the boilerplate that comes with Nix (it's a feature)

#### Git
- Hooks for conventional commits and email mismatch checks
- Implemnts a workaround to use global hooks with Husky enabled

#### Toolchain
- A managed installation of `rust` and friends.
- An environment with [`pnpm`](https://pnpm.io) and `node`
- Java (with OpenJDK Temurin) and the Gradle build system
- Configured [`theos`](https://theos.dev) toolchain and iOS build system

> Copyright (c) 2023 Aarnav Tale
