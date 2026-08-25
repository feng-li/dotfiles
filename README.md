# Dotfiles

Personal Linux configuration for a terminal-first development environment built
around Zsh, tmux, Emacs, Git, R, Python, and LaTeX. The repository keeps the
configuration in one place and uses [`setup.sh`](setup.sh) to link the actively
managed files into the home directory.

This is an opinionated, machine-specific setup rather than a portable package.
Several files contain personal paths, host names, service definitions, and Git
identity settings. Read the configuration and adapt it before using it on a new
account.

## Highlights

| Area | Configuration |
| --- | --- |
| Shell | Zsh, Oh My Zsh, autosuggestions, syntax highlighting, `direnv`, custom prompt, and automatic tmux attachment |
| Terminal | Alacritty with the Dracula theme, tmux, custom terminfo, fontconfig, and Readline |
| Editor | Emacs configuration as a submodule, `emacsclient` defaults, and a user systemd service |
| Git | Global defaults, `diff-so-fancy`, LaTeX diffs, rebased pulls, and a global ignore file |
| Languages | R startup/build settings, Conda and pip mirrors, virtualenv defaults, Julia settings, and JabRef preferences |
| LaTeX | XeLaTeX defaults, bibliography and figure caching in `/dev/shm`, and helper scripts for diffs and conversion |

## Requirements

The installer and primary configuration target GNU/Linux. At minimum, expect:

- Bash, Zsh, Git, `curl`, and GNU coreutils;
- tmux for the automatic workspace started by `.zshrc`;
- a working `en_US.UTF-8` locale; and
- GitHub SSH access for the `.emacs.d` submodule.

The configuration is most useful with Emacs, `direnv`, `fzf`, ripgrep, fd,
Miniforge, R, a TeX distribution, Alacritty, and an Iosevka Term Nerd Font.
Most of these are optional and are not installed by `setup.sh`.

## Installation

The expected checkout location is `~/.dotfiles`. Some settings, including the
Git pager and Alacritty theme import, refer to that path directly.

```sh
git clone --recurse-submodules git@github.com:feng-li/dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
less setup.sh
./setup.sh
exec zsh
```

If the repository has already been cloned, initialize its submodules first:

```sh
git submodule update --init --recursive
```

> [!WARNING]
> `setup.sh` has no backup or rollback step. It force-replaces several files and
> symlinks in the home directory. Back up any existing configuration before
> running it. Existing real directories such as `~/.config/git` cannot be
> replaced by the script; `ln` will report the conflict and the script will
> continue.

The installer also executes the installer downloaded from
`https://direnv.net/install.sh`. Review `setup.sh` and install `direnv` separately
if piping a remote script to Bash is not appropriate for your environment.

### What `setup.sh` manages

The script creates `~/.config`, `~/.local/bin`, `~/.config/enchant`, and `~/.R`
when needed, then creates the following links:

- every immediate child of `.config/` into `~/.config/` (Alacritty, Git,
  latexmk, tmux, systemd user units, and related tool settings);
- `.terminfo`, `.emacs.d`, and `.java` into the home directory;
- `.inputrc`, `.zshrc`, `.condarc`, `.Renviron`, `.Rprofile`, `.lintr`, and the
  Hunspell dictionary into their expected locations;
- `Makevars.local` as `~/.R/Makevars`; and
- `diff-so-fancy` as `~/.local/bin/diff-so-fancy`.

When Miniforge exists at `~/.local/miniforge3`, the script also exposes its Zsh,
tmux, Emacs, and `emacsclient` binaries through `~/.local/bin`.

The repository also tracks `.bash_profile`, `.bashrc`, `.zshenv`, `.chktexrc`,
`.npmrc`, `.screenrc`, `.julia`, `.podget`, a Jupyter kernel, and the scripts in
`bin/`, `ebook-convert/`, and `setvars/`. These are opt-in files: `setup.sh` does
not link them automatically.

## Customize before use

At a minimum, review these settings:

- `.config/git/config` contains a personal name and email, enables the plaintext
  Git credential store, and assumes the checkout is at `~/.dotfiles`.
- `.zshrc` expects tmux, uses `~/.local/miniforge3`, starts tmux automatically,
  and looks for the SSH key `~/.ssh/fli_rsa` on remote sessions.
- `.config/alacritty/alacritty.toml` expects an Iosevka Term Nerd Font and imports
  a theme from `~/.dotfiles`.
- `.condarc`, `.config/pip/pip.conf`, `.Rprofile`, and the Julia configuration
  select particular package mirrors and local paths.
- `.config/systemd/user/` includes host-specific SSH tunnels and an absolute
  LanguageTool path. Units are linked but are not enabled by the installer.
- `.config/latexmk/latexmkrc` uses XeLaTeX and `/dev/shm`, and reads bibliography
  files from `~/texmf/bibtex/bib`.
- the Ray, ebook, Jupyter, JabRef, and TeX-to-DOCX helpers contain host names,
  cluster addresses, or absolute paths specific to the original environment.

## Helper scripts

The scripts are intended to be run from the checkout unless you choose to link
them into a directory on `PATH`.

- `bin/setup_devtools.sh` installs Miniforge, Rust, and `direnv` in the user
  account.
- `bin/setup_python.sh VERSION [update]` builds a versioned Conda Python and a
  matching virtual environment and Jupyter kernel.
- `bin/biblatex2bibtex.sh FILE.bib` converts common BibLaTeX fields to BibTeX.
- `bin/git-latexdiff-with-additiononly.sh` builds an additions-only PDF diff for
  a Git-controlled LaTeX document.
- `bin/tex2docx.sh FILE.tex` converts LaTeX to DOCX with Pandoc using a configured
  personal bibliography.
- `bin/setup_ray.sh start|stop` controls the hard-coded Ray cluster over SSH.

Review each script before running it: the development setup scripts download
and install software, while the Ray and ebook tools operate on remote or
machine-specific resources.

## Updating

Pull the main repository, synchronize the submodules, and rerun the installer to
refresh links or add newly managed paths:

```sh
cd "$HOME/.dotfiles"
git pull --rebase
git submodule update --init --recursive
./setup.sh
```

Changes made through a symlink are changes to this checkout and will appear in
`git status`. Local state that should not be shared—credentials, shell history,
tokens, and machine-specific secrets—should remain outside the repository.

## Removing the links

There is no automated uninstall command. Remove only the symlinks that point
into `~/.dotfiles`, then restore the files from the backup made before
installation. Removing the repository first leaves broken links behind.
