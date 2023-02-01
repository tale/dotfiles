# Dotfiles

These are my dotfiles, that I've specifically tuned for my needs.<br>
If you're interested in using them, I've tried to make them as easy to use as possible.<br>
When creating these dotfiles, I had a few requirements:

- Be able to use the same dotfiles on macOS and Linux
- Minimal shell environment to keep things fast
- Declutter the home (~) directory

## Features

- ZSH (no plugin manager)
  - Using the [Pure](https://github.com/sindresorhus/pure) prompt by [Sindre Sorhus](https://sindresorhus.com)
  - [ZSH Completions](https://github.com/zsh-users/zsh-completions) and [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - Custom [LS colors](https://github.com/trapd00r/LS_COLORS) for terminals
  - Faster `compinit` by only using `zcompdump` in login shells
  - Different ZSH configuration directory in `~/.config/zsh`
  - Conditional loading of configs based on the OS
- Git Configuration
  - Global [`gitignore`](./config/git/.gitignore) for macOS and Linux
  - Git hooks that ensure GPG and committer email match and that commits are conventional
  - Hook for [Husky](https://github.com/typicode/husky) to ensure that global git hooks are run
- Development Environments
  - [Node.js](https://nodejs.org) and [PNPM](https://pnpm.io) for JavaScript development
  - [Theos](https://github.com/theos/theos) installation on macOS for iOS development
  - [Golang](https://golang.org) installation on macOS and Linux
  - [Rust](https://www.rust-lang.org) installation on macOS and Linux
- A [`launchd`](https://www.launchd.info) to automatically run a daily maintenance script on macOS
- A [Homebrew](https://brew.sh) installation and bundle to install all the tools I use on macOS
- Automated installation of all the dotfiles through a bootstrap script

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
