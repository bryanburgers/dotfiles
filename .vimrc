filetype plugin indent on
syntax on
au FileType gitcommit set tw=72

" Runtime
set directory='~/tmp,/var/tmp,/tmp'
set runtimepath^=$DOTDIR/.vim


call plug#begin('$DOTDIR/.vim/plugins')
  Plug 'scrooloose/nerdtree'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'vim-syntastic/syntastic'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
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

" My own settings
set tabstop=4
