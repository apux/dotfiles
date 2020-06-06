set encoding=utf-8
if &compatible
  set nocompatible
end

" Leader
let mapleader = " "

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set noswapfile      " Don't create swapfiles

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Folowing settings are important but they are already provided by sensible
" plugin

" set autoindent
" set backspace=indent,eol,start " Backspace deletes like most programs in insert mode
" set history=1000               " increase the number of lines supported in the history
" set ruler                      " show the cursor position all the time
" set incsearch                  " do incremental searching
" set laststatus=2               " Always display the status line


" VimPlug installation

if has('nvim')
  let vimplugfile='~/.local/share/nvim/site/autoload/plug.vim'
  let plugginsdir='~/.config/nvim/plugged'
else
  let vimplugfile='~/.vim/autoload/plug.vim'
  let plugginsdir='~/.vim/plugged'
endif

let vimplug_exists=expand(vimplugfile)

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo ". vimplugfile. " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall --sync
endif

call plug#begin(plugginsdir)

if !has('nvim')
  Plug 'tpope/vim-sensible'           " A universal set of defaults that (hopefully) everyone can agree on
endif

" Files & buffers
Plug 'tpope/vim-unimpaired'           " Extends pairs of mappings as ]q [q ]t [b [e
Plug 'tpope/vim-vinegar'              " Enhances netrw with -, I, ., ~, etc
Plug 'tpope/vim-eunuch'               " Vim sugar for the UNIX shell commands that need it the most
Plug 'ctrlpvim/ctrlp.vim'             " Full path fuzzy file, buffer, mru, tag, ... finder
Plug 'bogado/file-line'               " Open a file and go to a line, example vim index.html:20

" Edit
Plug 'tpope/vim-commentary'           " Comment out the target of a motion
Plug 'tpope/vim-repeat'               " Extends the dot '.' command to other plugings
Plug 'tpope/vim-endwise'              " Add end after if, do, def and other keywords
Plug 'tpope/vim-surround'             " Add/change parentheses, brackets, quotes, XML tags and more
Plug 'Raimondi/delimitMate'           " Provides automatic closing of '', (), {}, etc
Plug 'AndrewRadev/splitjoin.vim'      " Switches between single-line and multi-line statements
Plug 'machakann/vim-highlightedyank'  " Make the yanked region apparent
Plug 'tommcdo/vim-exchange'           " Exchange operator (cx{motion})

" Ruby & RoR
Plug 'vim-ruby/vim-ruby'              " Vim configuration files for editing and compiling Ruby
Plug 'tpope/vim-rails'                " Useful things for rails projects (gf, :A, :R, :Econtroller, :Emodel, etc)
Plug 'tpope/vim-bundler'              " Goodies for Bundler (includes tags generated with with gem-ctags!)
Plug 'tpope/vim-projectionist'        " Dependency for vim-rake
Plug 'tpope/vim-rake'                 " Add vim-rails like behaviour to any ruby project
Plug 'ecomba/vim-ruby-refactoring'    " Add refactoring configuration for ruby
Plug 'kana/vim-textobj-user'          " dependency for vim-textobj-rubyblock
Plug 'nelstrom/vim-textobj-rubyblock' " A custom text object for selecting ruby blocks
Plug 'janko-m/vim-test'               " Wrapper for running tests on different granularities

" Other languages
Plug 'pangloss/vim-javascript'        " Syntax highlighting and improved indentation
Plug 'kchmck/vim-coffee-script'       " CoffeeScript support (syntax, indenting, compiling, etc.)
Plug 'leafgarland/typescript-vim'     " Syntax file and other settings for TypeScript
Plug 'ekalinin/Dockerfile.vim'        " Syntax file for Dockerfile and snippets for snipMate

" Syntax
Plug 'w0rp/ale'                       " Syntax checking and semantic errors

" Snippets
Plug 'SirVer/ultisnips'               " An engine for snippets
Plug 'LogicalBricks/vim-snippets'     " The actual snippets

" Git & GitHub
Plug 'tpope/vim-fugitive'             " Git for vim :Gedit (and :Gsplit, :Gvsplit, :Gtabedit, ...)
Plug 'tpope/vim-rhubarb'              " Enables :Gbrowse to open GitHub URLs. (Depends on fugitive.vim)
Plug 'airblade/vim-gitgutter'         " Shows a git diff in the 'gutter' (sign column)

if filereadable(expand("~/.vimrc.bundles.local"))
  source ~/.vimrc.bundles.local
endif

call plug#end()

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown " by default md is for modula2
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  " set grepprg=grep\ -rn\ $*\ /dev/null

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Always use vertical diffs
set diffopt+=vertical

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

let g:rails_ctags_arguments = ['--languages=ruby', '-f .git/tags', '--tag-relative=yes']
let g:fugitive_git_executable = 'LANG=en_US.UTF8 git'

if v:version >= 800 || has('nvim')
  set updatetime=100
endif

if executable('ripper-tags')
  let g:tagbar_type_ruby = {
      \ 'kinds' : [
                      \ 'm:modules',
                      \ 'c:classes',
                      \ 'C:constants',
                      \ 'F:singleton methods',
                      \ 'f:methods',
                      \ 'a:aliases'
      \ ],
      \ 'kind2scope' : { 'c' : 'class',
                       \ 'm' : 'class' },
      \ 'scope2kind' : { 'class' : 'c' },
      \ 'ctagsbin'   : 'ripper-tags',
      \ 'ctagsargs'  : ['-f', '-']
  \ }
else
  let g:tagbar_type_ruby = {
      \ 'kinds' : [
          \ 'm:modules',
          \ 'c:classes',
          \ 'd:describes',
          \ 'C:contexts',
          \ 'f:methods',
          \ 'F:singleton methods'
      \ ]
  \ }
endif

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
nnoremap <PageUp> :echoe "Use \<C-u\> or \<C-b\>"<CR>
nnoremap <PageDown> :echoe "Use \<C-d\> or \<C-f\>"<CR>

" Misc
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
noremap YY "+y<CR>
nnoremap gr :grep <cword><CR>
let g:UltiSnipsListSnippets="<c-l>"
set tags^=./.git/tags;
