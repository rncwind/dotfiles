" ------------WARNING--------------
" THIS VIMRC IS OUT OF DATE.
" I USE EMACS AS MY DAILY DRIVER
" VIM IS NOW USED FOR QUICK EDITS
" PLEASE BE AWARE OF THIS. I NO
" LONGER WILL KEEP THIS VIMRC
" IN A CONSTANT STATE OF FLUX
" IT WAS SHIT IN THE FIRST PLACE
" ------------WARNING--------------

"" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"vim-colorschemes
Plugin 'flazz/vim-colorschemes'

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
let g:cpp_member_variable_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_class_decl_highlight = 1

"autoclose brackets and braces
Plugin 'Raimondi/delimitMate'
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1


"indent-line
Plugin 'Yggdroot/indentLine'


" All of your Plugins must be added before the following line
call vundle#end()            " required
"-------------------------Vundle Bullshit End-------------------

"-------------------------100 char meme-------------------------
match ErrorMsg '\%>100v.\+'

"set colorscheme
colorscheme monokain

"-------------------------buffer madness-------------------------
"open a new empty buffer
nmap <leader>bn :enew<CR>
"move to next buffer
nmap <leader>ll :bnext<CR>
"move to prev buffer
nmap <leader>hh :bprevious<CR>
"close current buffer and move to prev
nmap <leader>bq :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>bl :ls<CR>
"
"-------------------------General Bullshit-------------------------
"disable vi compat
set nocompatible

"change leader to space
map <SPACE> <leader>

"enable sytax hilights
set t_Co=256
syntax on
filetype plugin indent on    " enable plguns based on fieltype
set ttyfast
set lazyredraw

"enable line nos
set number
set guioptions+=a

"set clipboard to X11 clipboard
set clipboard=unnamedplus

"smart comments
set comments=sl:/*,mb:\ *,elx:\ */

set expandtab                   "spaces == tabs
set tabstop=4                   "4 spaces = tab
set softtabstop=4               "see above
set shiftwidth=4                ">> indents by 4
set smarttab
set autoindent                  "indent based on prev line
set smartindent
set showmatch
set indentexpr=

set backspace=indent,eol,start  "Make backspace work as you would expect.
set hidden                      "Switch between buffers without having to save first.
set laststatus=2                "Always show statusline.
set display=lastline            "Show as much as possible of the last line.

set incsearch                   "incrimental search
set hlsearch                    "keep searches hilighted

set report=0                    "always report changed lines

set showcmd                     "show currently typed command

"Show non-printable characters.
set list                        
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:??? ,extends:???,precedes:???,nbsp:??'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo
