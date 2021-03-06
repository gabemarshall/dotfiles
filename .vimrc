set nocompatible
filetype off
syntax on
filetype plugin indent on

autocmd FileType go compiler go

set backspace=2  "Allow backspacing over everything in insert mode"

set autoindent   "Always set auto-indenting on"
set expandtab    "Insert spaces instead of tabs in insert mode. Use spaces for indents"
set tabstop=2    "Number of spaces that a <Tab> in the file counts for"
set shiftwidth=2 "Number of spaces to use for each step of (auto)indent"
set sts=2

set showmatch    "When a bracket is inserted, briefly jump to the matching one"

set nowrap
let mapleader=","
map <C-t><right> :tabn<cr>
map <C-t><left> :tabp<cr>
set ruler
set foldmethod=marker
set foldmarker={{,}}
set rtp+=/usr/local/opt/fzf

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown'] }
Plug 'https://github.com/easymotion/vim-easymotion.git'
Plug 'https://github.com/xolox/vim-misc.git'
Plug 'https://github.com/fidian/hexmode.git'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'francoiscabrol/ranger.vim'
call plug#end()
nmap F <Plug>(easymotion-prefix)s
