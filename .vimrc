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
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
call plug#end()

map <C-t> :NERDTreeToggle<CR>

" Syntastic settings. These are recommended by Syntastic until you've read the
" manual. Which I haven't. So, OK. 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let NERDTreeQuitOnOpen=1

" ESLint
let g:syntastic_javascript_checkers = ['eslint']

" My own settings
set tabstop=4 shiftwidth=4 expandtab
