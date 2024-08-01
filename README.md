# Welcome to my dotfiles!

They're finally organized (for now). I've started using stow to manage my
dotfiles using symlinks. If you're interested in figuring out how that works
for yourself, [here][blog] is a great blog post on it. Note that there are some
initial steps you'll need to clone my entire config.

## GNU Stow

If you already have an existing config you want to back up, create your dotfiles
repository, then run `stow .zshrc --adopt` to set the contents of your dotfiles'
`.zshrc` for example, to what you have configured at `~/.zshrc`. You can also
map packages like `nvim`, `doom`, etc. you just need to follow the right
directory hierarchy as shown in the blog linked above.

### Installing on a fresh machine

Typically if I'm installing on a machine that has an existing configuration for a package, I'll use the `--adopt` directive for GNU stow, then do a `git restore`. Here's what that looks like:
1. Clone the repo and `cd` in there.
2. For each package in the repo that you want symlinked, run `stow <package>`. You will need to use `--adopt` if the package already exists on the machine. This creates a symlink for the package to your dotfiles repo.
3. If you want to use the config you had previously stored in your dotfiles repo, then run `git restore <dir>` or `git restore .` if you're feeling wild. If you want to **overwrite** the neovim config you had in your dotfiles repo with the one you have currently at `~/.config/nvim`, then don't do the restore.

> [!WARNING] 
> The `--adopt` flag *will* overwrite the contents of your current
> directory with the contents from your target directory. Please be careful.

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
