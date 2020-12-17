.PHONY: all
all: build

.PHONY: build
build:
	swift build -c release
	cp .build/release/advent-of-code /usr/local/bin/advent-of-code

.PHONY: install-completions
install-completions:
	advent-of-code --generate-completion-script zsh > ~/.oh-my-zsh/completions/_advent-of-code
