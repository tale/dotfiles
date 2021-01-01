call plug#begin('~/.vim/plugged')
	Plug 'preservim/nerdtree'
	Plug 'ryanoasis/vim-devicons'
	Plug 'vim-airline/vim-airline'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()

set hidden
set number
set encoding=UTF-8

let g:airline_theme='dark_minimal'
let g:airline#extensions#tabline#enabled = 1

autocmd VimEnter * NERDTree | wincmd p
autocmd WinEnter * if exists('b:NERDTree') | execute 'normal R' | endif

nmap <C-P> :FZF<CR>
nmap <C-N> :enew<CR>
nmap <C-tab> :bnext<CR>
nmap <C-S-tab> :bprev<CR>
nmap <C-W> :bdelete<CR>

inoremap <C-h> <C-w>h
inoremap <C-j> <C-w>j
inoremap <C-k> <C-w>k
inoremap <C-l> <C-w>l
