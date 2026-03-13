" =====================
" BASICO
" =====================

set nocompatible
syntax on
filetype plugin indent on

set number
set cursorline
set cursorlineopt=number
set norelativenumber

highlight LineNr ctermfg=240
highlight CursorLineNr ctermfg=250 cterm=bold
set showmatch
set matchtime=2
highlight MatchParen ctermbg=240

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

set showmatch
set nowrap

set scrolloff=5

" búsqueda
set ignorecase
set smartcase
set incsearch
set hlsearch

" clipboard sistema
set clipboard=unnamedplus

" mouse opcional
set mouse=a


" =====================
" PLUGINS
" =====================

call plug#begin('~/.vim/plugged')

" explorador de archivos
Plug 'preservim/nerdtree'

" buscador rápido
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" git
Plug 'tpope/vim-fugitive'

" auto cerrar paréntesis
Plug 'jiangmiao/auto-pairs'

" comentar líneas
Plug 'tpope/vim-commentary'

" syntax para muchos lenguajes
Plug 'sheerun/vim-polyglot'

" autocompletado
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()


" =====================
" ATAJOS
" =====================

" abrir file tree
nnoremap <C-n> :NERDTreeToggle<CR>

" buscar archivos
nnoremap <C-p> :Files<CR>

" buscar texto
nnoremap <C-f> :Rg<CR>

" limpiar highlights de búsqueda
nnoremap <leader>h :nohlsearch<CR>

" guardar rápido
nnoremap <C-s> :w<CR>


" =====================
" COC AUTOCOMPLETE
" =====================

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ "\<TAB>"

inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ "\<C-h>"

nmap gd <Plug>(coc-definition)
