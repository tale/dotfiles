let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set updatetime=100 clipboard=unnamedplus scrolloff=99999
set termguicolors autoread undofile noswapfile nobackup colorcolumn=80
set relativenumber cursorline signcolumn=yes noshowmode noshowcmd noruler
set tabstop=4 softtabstop=4 shiftwidth=4 shiftround noexpandtab
set incsearch nohlsearch ignorecase smartcase splitbelow splitright

let g:zig_fmt_autosave = 0
let g:copilot_no_tab_map = v:true

nnoremap <Tab> >>
nnoremap <S-Tab> <<
inoremap <Tab> <C-t>
inoremap <S-Tab> <C-d>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <C-[> :RG<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-e> :lua OilToggle()<CR>
inoremap <C-e> <Esc>:lua OilToggle()<CR>
vnoremap <C-e> <Esc>:lua OilToggle()<CR>
imap <silent><script><expr> <M-CR> copilot#Accept("\<CR>")
 
call plug#begin()
	Plug 'bluz71/vim-moonfly-colors', { 'as': 'moonfly' }
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'wakatime/vim-wakatime'
	Plug 'airblade/vim-gitgutter'
	Plug 'mg979/vim-visual-multi'
	Plug 'github/copilot.vim'
	Plug 'stevearc/oil.nvim'
call plug#end()

let g:fzf_vim = {}
let g:fzf_vim.buffers_jump = 1
let g:fzf_vim.preview_window = ['right:40%', 'ctrl-/']
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:moonflyTransparent = v:true
silent! colorscheme moonfly

command! -bang -nargs=* RG call fzf#vim#grep(
\   "rg --column --line-number --no-heading --color=always
\   --smart-case --with-filename --hidden --glob !.git/
\   ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0
\ )

lua << EOF
require("oil").setup({
	view_options = { show_hidden = true },
	keymaps = {
		["<C-x>"] = "actions.select_split",
		["<C-v>"] = "actions.select_vsplit",
	},
})

OilToggle = function()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end
EOF
