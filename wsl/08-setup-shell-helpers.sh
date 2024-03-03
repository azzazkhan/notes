#!/bin/bash


echo "\n\n" >> ~/.zshrc
cat << EOF >> ~/.zshrc
export PATH="\$PATH:$(yarn global bin):\$(composer global config bin-dir --absolute --quiet)"

alias artisan="php artisan"
alias mfs="php artisan migrate:fresh --seed"
alias artc="php artisan optimize:clear && php artisan clear-compiled"
alias dc="docker compose"
alias sail="./sail"
alias install-sail="curl -s \"https://raw.githubusercontent.com/azzazkhan/devcontainer-laravel/master/install\" | bash"
EOF
