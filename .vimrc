filetype plugin indent on
syntax on
au FileType gitcommit set tw=72

call plug#begin('~/.vim/plugins')
  Plug 'scrooloose/nerdtree'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'vim-syntastic/syntastic'
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
call plug#end()

map <C-n> :NERDTreeToggle<CR>

" Syntastic settings. These are recommended by Syntastic until you've read the
" manual. Which I haven't. So, OK. 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ESLint
let g:syntastic_javascript_checkers = ['eslint']