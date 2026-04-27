# dotfiles (WSL)

Windows / WSL2 (Ubuntu) 用 dotfiles ブランチ。

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
│   ├── settings.json
│   └── skills/
├── editor/
│   ├── vscode/
│   │   └── settings.json
│   └── zed/
│       ├── settings.json
│       ├── keymap.json
│       ├── tasks.json
│       └── themes/
│           └── nagi-dark.json
├── ghostty/
│   └── config
├── scripts/
│   └── setup_win.sh
└── makefile
```

## セットアップ

```zsh
make setup-win
```

WSL 側 (`$HOME`) にはシンボリックリンク、Windows 側 (`/mnt/c/...`) には実ファイルをコピー配置します。
既存ファイルは `.bak` にリネームしてバックアップします。

## apt パッケージ

- unzip
- curl
- build-essential
- procps
- file
- git
- zsh

## homebrew パッケージ

- gh
- lazygit
- starship
- zsh-autosuggestions
- zsh-syntax-highlighting

## フォント

JetBrains Mono Nerd Font を Windows のフォントフォルダ (`%LOCALAPPDATA%\Microsoft\Windows\Fonts`) に配置します。
配置だけでは Windows に登録されないため、以下の手順で登録してください。

### 1. Windows にフォントを登録

エクスプローラーで `C:\Users\<USER>\AppData\Local\Microsoft\Windows\Fonts` を開き、
すべての `.ttf` を選択 → 右クリック → **「インストール」** （または **「すべてのユーザーに対してインストール」**）。

PowerShell で一括登録する場合：

```powershell
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.ttf" | ForEach-Object {
    $fonts.CopyHere($_.FullName, 0x10)
}
```

### 2. 各アプリでフォントを指定

| アプリ | 設定状況 |
|---|---|
| Zed | `editor/zed/settings.json` に設定済み (`JetBrainsMono Nerd Font`) |
| VSCode | `editor/vscode/settings.json` に設定済み |
| Ghostty | `ghostty/config` に `font-family = JetBrainsMono Nerd Font` を追記 |

## 配置一覧

### WSL 側 (シンボリックリンク)

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
| `claude/skills/` | `~/.claude/skills` |
| `claude/CLAUDE.md` | `~/.codex/AGENTS.md` |

### Windows 側 (コピー配置)

| リポジトリ内のファイル | コピー先 |
|---|---|
| `editor/vscode/settings.json` | `%APPDATA%\Code\User\settings.json` |
| `editor/zed/settings.json` | `%APPDATA%\Zed\settings.json` |
| `editor/zed/keymap.json` | `%APPDATA%\Zed\keymap.json` |
| `editor/zed/tasks.json` | `%APPDATA%\Zed\tasks.json` |
| `editor/zed/themes/nagi-dark.json` | `%APPDATA%\Zed\themes\nagi-dark.json` |
| `ghostty/config` | `%APPDATA%\com.mitchellh.ghostty\config` |
