# Welcome to my dotfiles!

They're finally organized (for now). I've started using stow to manage my
dotfiles using symlinks. If you're interested in figuring out how that works
for yourself, [here][blog] is a great blog post on it. Note that there are some
initial steps you'll need to clone my entire config.

## Neovim

1. If you have an existing neovim installation, delete any existing runtime dir
   you have for neovim to prevent errors in your new version.
   `usr/local/nvim/runtime`. See :checkhealth of your current neovim install to
   confirm what the path is on your machine.
2. [Install the nightly version of neovim][nightly] - I have some plugins, I
   can't remember which ones (treesitter maybe?) that require the nightly
   version of neovim as they use the latest features. I just install from
   source.
3. [Install Packer][packer] - this is the package manager I use for lua
   dotfiles.
4. Run `nvim`
5. Type `:PackerSync` or `:PackerInstall` (need to double check this on a
   *fresh* install) - This will install all of your nvim plugins.
6. You may have to run `:TSUpdate` 'cause treesitter is fussy,

[blog]: https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
[packer]: https://github.com/wbthomason/packer.nvim?tab=readme-ov-file#quickstart
[nightly]: https://github.com/neovim/neovim/releases/nightly

## Tmux

1. [Install tpm][tpm]
2. Add plugins to `~/.tmux.conf`
3. Run tmux (or reload tmux env `tmux source ~/.tmux.conf`)
4. Install plugins with `prefix + I` (capital i)

[tpm]: https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation
