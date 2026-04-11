# dotfiles

## 構成

```
dotfiles/
├── shell/
│   ├── .zshrc
│   ├── .bashrc
│   └── starship.toml
├── git/
│   └── .gitconfig
├── gh/
│   └── config.yml
├── vim/
│   └── .vimrc
├── ssh/
│   └── config
├── claude/
│   ├── CLAUDE.md
│   └── settings.json
├── editor/
│   ├── vscode/
│   │   └── setting.json
│   └── zed/
│       ├── settings.json
│       ├── keymap.json
│       └── tasks.json
├── scripts/
│   └── setup.sh
└── makefile
```

## セットアップ

```zsh
make setup
```

各ファイルを適切な場所へシンボリックリンクで配置します。
既存のファイルは `.bak` にリネームされてバックアップされます。

## シンボリックリンク一覧

| リポジトリ内のファイル | リンク先 |
|---|---|
| `shell/.zshrc` | `~/.zshrc` |
| `shell/.bashrc` | `~/.bashrc` |
| `shell/starship.toml` | `~/.config/starship.toml` |
| `git/.gitconfig` | `~/.gitconfig` |
| `gh/config.yml` | `~/.config/gh/config.yml` |
| `vim/.vimrc` | `~/.vimrc` |
| `ssh/config` | `~/.ssh/config` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `editor/vscode/setting.json` | `~/Library/Application Support/Code/User/settings.json` |
| `editor/zed/settings.json` | `~/.config/zed/settings.json` |
| `editor/zed/keymap.json` | `~/.config/zed/keymap.json` |
| `editor/zed/tasks.json` | `~/.config/zed/tasks.json` |
