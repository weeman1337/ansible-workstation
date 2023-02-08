alias ll='ls -alh'
alias llt='ls -alht'

alias gg='cd ~/git/$(fd --base-directory ~/git --type d --max-depth 2 | fzf)'
alias vg='gg && vi'

alias gid='git diff'
alias gip='git pull'
alias gis='git status'
alias gic='git checkout $(git branch | fzf | tr -d "[:space:]")'

alias gdot='cd ~/git/ansible-workstation'
alias vidot='cd ~/git/ansible-workstation && vi'

# npm
alias npr='test -f package.json && cat package.json | jq .scripts | jq -r "keys[]" | fzf | xargs -t -r -n1 npm run'

# Composer
alias cor='test -f composer.json && cat composer.json | jq .scripts | jq -r "keys[]" | fzf | xargs -t -r -n1 composer run'

# Kitty
alias icat="kitty +kitten icat"

alias nvim="vi"
