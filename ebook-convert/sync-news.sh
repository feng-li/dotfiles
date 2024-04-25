#! /usr/bin/bash

# Run this program with www-data

# podget --dir_config /home/fli/.dotfiles/.podget
bash /home/fli/.dotfiles/ebook-convert/ebook-convert.sh
php /srv/html/cloud/occ files:scan --path="/fli/files/News"
