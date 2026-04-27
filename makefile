setup: ## シンボリックリンクを作成する (macOS)
	@bash scripts/setup.sh

setup-win: ## シンボリックリンクを作成する (Windows/WSL)
	@bash scripts/setup_win.sh

help: ## ヘルプを表示する
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'
