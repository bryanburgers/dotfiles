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
  Plug 'airblade/vim-gitgutter'
  Plug 'fatih/vim-go'
  Plug 'stephpy/vim-php-cs-fixer'
  Plug 'lumiliet/vim-twig'
  Plug 'hashivim/vim-terraform'
call plug#end()

map <C-t> :NERDTreeToggle<CR>
map <C-n> :Files<CR>
map <C-p> :Buffers<CR>

" Syntastic settings. These are recommended by Syntastic until you've read the
" manual. Which I haven't. So, OK. 
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:go_def_mapping_enabled = 0
let g:php_cs_fixer_level = 'symfony'
let g:php_cs_fixer_verbose = 1

let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

" ESLint
let g:syntastic_javascript_checkers = ['eslint']

" My own settings
set tabstop=4 shiftwidth=4 expandtab
set showcmd

" Always highlight all Dockerfiles
autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile

" Open up the "alternate file" for the current file. For a X.js file, this will
" try to open up the X.test.js file in the same folder. Taken from
" https://github.com/uptech/alt#use-with-vim (but with a hand-rolled `alt`
" bash script)
function! AltCommand(path, vim_command)
    let l:alternate = system("alt " . a:path)
    if empty(l:alternate)
        echo "No alternate file for " . a:path . " exists!"
    else
        exec a:vim_command . " " . l:alternate
    endif
endfunction

nnoremap <leader>t :w<cr>:call AltCommand(expand('%'), ':e')<cr>
