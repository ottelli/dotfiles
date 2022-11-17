"
" ~/.vimrc
"

" Plugins
call plug#begin()

Plug 'ayu-theme/ayu-vim'

call plug#end()

" Theme, implimented via plugin
set termguicolors " enable true colors support
let ayucolor="dark" " light, mirage, dark
colorscheme ayu  

" Disable compatibility with vi, which can cause problems.
set nocompatible

" Enable type file detection.
filetype on

" Enable plugins, and load plugin for the file type.
filetype plugin on

" Load an indent file for the file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add line number in left margin.
set number

" Highlight row beneath cursor.
set cursorline

" Highlight column beneath cursor.
" set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use spaces instead of tabs.
set expandtab

" Do not save backup files.
" set nobackup

" Maximum scroll margin, in N lines.
set scrolloff=8

" Do not wrap lines.
set nowrap

" Highlight characters while typing a search.
set incsearch

" 1: Ignore capital letters during search, 2: unless explicit in query.
set ignorecase
set smartcase

" Use highlighting when doing a search.
set hlsearch

" Show matching words during a search.
set showmatch

" Show partial command you type in the last line of the screen.
set showcmd

" Show the current mode in the last line.
set showmode

" Number of commands to save in history.
set history=20

" Enable auto completion on TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" Ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

