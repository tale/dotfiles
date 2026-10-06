# Dotfiles
My dotfiles for macOS. It has all the usual configurations like my shell, git,
SSH, and some other tools along with some cool software I use. The repository
is all managed with [rootbeer](https://rbpkg.com), my own take on a fully
deterministic packaging and system configuration tool (think Nix).

All of my packages on my system are distributed through rootbeer, so if you want
to use my dotfiles you'll need to install rootbeer or translate the packages to
`brew` or something similar.

```sh
sh -c "$(curl -fsSL rootbeer.tale.me/rb.sh)" -- init --apply tale/dotfiles
```

### Software
- [bobrwm](https://github.com/bobrwm/bobrwm): A tiling window manager for macOS
- [Neovim](https://neovim.io/): With a minimal configuration and `vim.pack`
- [Rex](https://www.superlogical.com/): A terminal multiplexer built on `libghostty`
- [Rootbeer](https://rbpkg.com): A deterministic package & system configuration manager
