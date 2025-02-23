"let data_dir = stdpath('data') . '/site'
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set updatetime=100 clipboard=unnamedplus scrolloff=99999
set autoread undofile noswapfile nobackup colorcolumn=80
set cursorline signcolumn=yes noshowmode noshowcmd noruler
set tabstop=4 softtabstop=4 shiftwidth=4 shiftround noexpandtab
set incsearch nohlsearch ignorecase smartcase splitbelow splitright

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <C-[> :RG<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-e> :Yazi<CR>
inoremap <C-e> <Esc>:Yazi<CR>
vnoremap <C-e> <Esc>:Yazi<CR>

imap <silent><script><expr> <M-CR> copilot#Accept("\<CR>")
 
call plug#begin()
	Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
	Plug '/opt/homebrew/opt/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'wakatime/vim-wakatime'
	Plug 'airblade/vim-gitgutter'
	Plug 'mg979/vim-visual-multi'
	Plug 'github/copilot.vim'
	Plug 'chriszarate/yazi.vim'
call plug#end()

let g:fzf_vim = {}
let g:fzf_vim.buffers_jump = 1
let g:fzf_vim.preview_window = ['right:40%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:copilot_no_tab_map = v:true

let g:moonflyTransparent = v:true
silent! colorscheme moonfly
silent! hi clear SignColumn " Transparent gitgutter

command! -bang -nargs=* RG call fzf#vim#grep(
\   "rg --column --line-number --no-heading --color=always
\   --smart-case --with-filename --hidden --glob !.git/
\   ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0
\ )
