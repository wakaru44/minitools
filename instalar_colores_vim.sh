#!/bin/bash
# Instala automaticamente pathogen, fugitive  y el esquema de colores solarized

## Instalacion de pathogen (gestor de plugins para vim)
cd .vim
mkdir  autoload
mkdir bundle
cd autoload/
curl -so pathogen.vim  https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

## configuramos el .vimrc
cd
#### vim .vimrc
### Lo sustituimos por un echo




## Instalamos el plugin fugitive para manejar git y los colores solarized
cd .vim/bundle/
git clone git://github.com/tpope/vim-fugitive.git
git clone git://github.com/altercation/vim-colors-solarized.git

