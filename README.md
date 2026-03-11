# Dotfiles
My personal dotfiles configuration! If you're wondering why it's all configured
in Lua, it's because I use my own self-built system configuration management
tool called [rootbeer](https://rootbeer.tale.me). It's pretty cool and is a
deterministic configuration alternative to tools like Nix's home-manager or
Chezmoi. Check it out if you're interested!

```sh
sh -c "$(curl -fsSL rootbeer.tale.me/rb.sh)" -- init --apply tale/dotfiles
```

### Whats Inside?
- Support for macOS
- Easy installation using [rootbeer](https://rootbeer.tale.me)
- Separated configs based on an device type (work, personal, etc.)
- Load secrets from [1Password](https://1password.com) using the CLI.
- Git, Zsh, SSH configs, all the goodies
- [Ghostty](https://ghostty.org): a new terminal emulator with good performance
- [Mise](https://mise.jdx.dev): per-directory and global devtools (like `asdf`)
- [AeroSpace](https://github.com/nikitabobko/AeroSpace): Tiling WM for macOS
- A minimal Neovim configuration using the new nightly `vim.pack` API.
