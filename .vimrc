set nocompatible
filetype off
syntax on
filetype plugin indent on

autocmd FileType go compiler go

set backspace=2  "Allow backspacing over everything in insert mode"

set autoindent   "Always set auto-indenting on"
set expandtab    "Insert spaces instead of tabs in insert mode. Use spaces for indents"
set tabstop=4    "Number of spaces that a <Tab> in the file counts for"
set shiftwidth=4 "Number of spaces to use for each step of (auto)indent"
set sts=4

set showmatch    "When a bracket is inserted, briefly jump to the matching one"

set nowrap
let mapleader=","
map <C-t><right> :tabn<cr>
map <C-t><left> :tabp<cr>
set ruler
set foldmethod=marker
set foldmarker={{,}}
set rtp+=/usr/local/opt/fzf
