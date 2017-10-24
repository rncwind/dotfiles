:inoremap <C-j> <Esc>/[)}"'\]>]<CR>:nohl<CR>a
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub

"YCM
Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_server_python_interpreter = '/usr/bin/python2'
let g:ycm_max_num_identifier_candidates = 8
let g:ycm_always_populate_location_list = 1
map <leader>fi :YcmCompleter FixIt<CR>

"ListToggle
Plugin 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>yc'
let g:lt_quickfix_list_toggle_map = '<leader>qf'
let g:lt_height = 7
"vim-colorschemes
Plugin 'flazz/vim-colorschemes'
"colorscheme monokain

"airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme='hybridline'
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1

"NERDTree
Plugin 'scrooloose/nerdtree'
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
nmap <leader>nt :NERDTree<CR>

"vim-cpp-enhanced-hilight
Plugin 'octol/vim-cpp-enhanced-highlight'

"chromatica
"Plugin 'arakashic/chromatica.nvim'
"let g:chromatica#enable_at_startup=1
"let g:chromatica#responsive_mode=1

"autoclose
Plugin 'Raimondi/delimitMate'
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

"tagbar
Plugin 'majutsushi/tagbar'
nmap<leader>tb :TagbarToggle<CR>

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"------------------------------------------------------------------"
"disable vi compat
set nocompatible

"enable sytax hilights
set t_Co=256
syntax on

"set lazyredraw

"enable line nos
set number
set guioptions+=a

"set clipboard to X11 clipboard
set clipboard=unnamedplus

"auto {}
"inoremap { {<CR><BS>}<Esc>ko

"smart comments
set comments=sl:/*,mb:\ *,elx:\ */

"tab and indent shit
set expandtab
set tabstop=4 "4 spaces = tab
set softtabstop=4 "see above
set shiftwidth=4
set smarttab
set autoindent
set smartindent
set showmatch
set indentexpr=


"set colorscheme
colorscheme monokain
"autocmd vimenter * NERDTree

"nerdtree bullshit
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
set showcmd

"buffer madness
"open a new empty buffer
nmap <leader>bn :enew<CR>

"move to next buffer
nmap <F8> :bnext<CR>

"move to prev buffer
nmap <F7> :bprevious<CR>

"close current buffer and move to prev
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

set timeoutlen=5000
