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
  Plug 'rust-lang/rust.vim'
  " Plug 'prabirshrestha/async.vim'
  " Plug 'prabirshrestha/vim-lsp'
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }
  Plug 'dense-analysis/ale'
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

let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

" ESLint
let g:syntastic_javascript_checkers = ['eslint']

" My own settings
set tabstop=4 shiftwidth=4 expandtab
set showcmd

" Always highlight all Dockerfiles
autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile

" Show tabs and trailing spaces
hi SpecialKey ctermfg=DarkGray
set listchars=tab:→\ ,trail:·,precedes:«,extends:»
set list

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

" if executable('rls')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'rls',
"         \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
"         \ 'whitelist': ['rust'],
"         \ })
" endif

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }

let g:syntastic_rust_checkers = []
" Auto format Rust
let g:rustfmt_command = "rustup run nightly rustfmt"
let g:rustfmt_autosave = 1

nnoremap <leader>t :call AltCommand(expand('%'), ':e')<cr>
