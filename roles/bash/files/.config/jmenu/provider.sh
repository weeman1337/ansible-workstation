#!/usr/bin/env bash

npm_provider() {
    echo "command;npm ci"
    echo "command;npm install"

    local has_scripts=$(cat package.json | jq 'has("scripts")')

    if $has_scripts; then
        local custom_scripts_raw=$(cat package.json | jq -r '.scripts | keys[]')
        local custom_scripts
        readarray -t custom_scripts <<<"$custom_scripts_raw"
        local custom_items=$(printf "command;npm run %s\n" "${custom_scripts[@]}")
        printf "%s\n" "${custom_items[@]}"
    fi
}

yarn_provider() {
    echo "command;yarn outdated"
    echo "command;yarn upgrade"

    local has_scripts=$(cat package.json | jq 'has("scripts")')

    if $has_scripts; then
        local custom_scripts_raw=$(cat package.json | jq -r '.scripts | keys[]')
        local custom_scripts
        readarray -t custom_scripts <<<"$custom_scripts_raw"
        local custom_items=$(printf "command;yarn run %s\n" "${custom_scripts[@]}")
        printf "%s\n" "${custom_items[@]}"
    fi
}

composer_provider() {
    echo "command;composer dump-autoload"
    echo "command;composer install"
    echo "command;composer require"
    echo "command;composer update"
    echo "command;composer validate"

    local has_scripts=$(cat composer.json | jq 'has("scripts")')

    if $has_scripts; then
        local custom_scripts_raw=$(cat composer.json | jq -r '.scripts | keys[]')
        local custom_scripts
        readarray -t custom_scripts <<<"$custom_scripts_raw"
        local custom_items=$(printf "command;composer run %s\n" "${custom_scripts[@]}")
        printf "%s\n" "${custom_items[@]}"
    fi
}

phpunit_provider() {
    if [ ! -f "./vendor/bin/phpunit" ]; then
        return
    fi

    echo "command;./vendor/bin/phpunit "
}

phpcs_provider() {
    if [ ! -f "./vendor/bin/phpcs" ]; then
        return
    fi

    echo "command;./vendor/bin/phpcs "
}

phpstan_provider() {
    if [ ! -f "./vendor/bin/phpstan" ]; then
        return
    fi

    echo "command;./vendor/bin/phpstan "
}

jest_provider() {
    if [ ! -f "./node_modules/.bin/jest" ]; then
        return
    fi

    echo "command;./node_modules/.bin/jest "
}

mussig_provider() {
    cat ~/.config/jmenu/mussig.txt
}

ssh_provider() {
    grep -hiP "^Host ([^*]+)$" $HOME/.ssh/config.d/* | sed 's/Host /command;ssh /i'
    # force password
    echo "command;ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no "
}

git_provider() {
    echo "command;git status"
    echo "command;git commit"
    echo "command;git commit -m \""
    echo "command;git commit --amend"
    echo "command;git commit --amend --no-edit"
    echo "command;git log "
    echo "command;git pull"
    echo "command;git push "
    echo "command;git push --force "
    echo "command;git rebase -i HEAD~"
    echo "command;git restore --staged "
    echo "command;git stash push --include-untracked"
    echo "command;git stash pop"
}

apt_provider() {
    echo "command;sudo apt update"
    echo "command;sudo apt update && sudo apt upgrade"
}

apt_provider
ssh_provider

if git rev-parse --git-dir > /dev/null 2>&1; then
    git_provider
fi

if [ -f "composer.json" ]; then
    composer_provider
    phpcs_provider
    phpstan_provider
    phpunit_provider
fi

if [ -f "package.json" ]; then
    jest_provider
fi

if [ ! -f "yarn.lock" ] && [ -f "package.json" ]; then
    npm_provider
fi

if [ -f "yarn.lock" ]; then
    yarn_provider
fi

mussig_provider
