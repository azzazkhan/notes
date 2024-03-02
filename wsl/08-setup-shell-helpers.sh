#!/bin/bash

echo "\n\n"  >> ~/.zshrc \
    && echo "export PATH=\"\$PATH:\$(yarn global bin):\$(composer global config bin-dir --absolute --quiet)\"\n" >> ~/.zshrc \
    && echo "alias artisan=\"php artisan\"\n" \
    && echo "alias mfs=\"php artisan migrate:fresh --seed\"\n" \
    && echo "alias artc=\"php artisan optimize:clear && php artisan clear-compiled\""
