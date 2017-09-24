"#"

         "#::[[-----  Custom VimRC -----]]::#

"####################################################"
                    "# Defaults #
"####################################################"
"----------------------------------------------------"

    "# I use amix's Awesome .vimrc configuration
    
      "# See: https://github.com/amix/vimrc "

        "# To update:"
          "" cd ~/.vim_runtime & git pull --rebase

"----------------------------------------------------'
"####################################################"
              "# amix's VimRC Options #
"####################################################"

  "# If utilizing amix's VimRC, uncomment the below


    "# Runtime path #
"#--------------------------------------------------'
  "set runtimepath+=~/.vim_runtime


    "# Source configs #
"#--------------------------------------------------"
  "source ~/.vim_runtime/vimrcs/basic.vim
  "source ~/.vim_runtime/vimrcs/filetypes.vim
  "source ~/.vim_runtime/vimrcs/plugins_config.vim
  "source ~/.vim_runtime/vimrcs/extended.vim


    "# My configs #
"#--------------------------------------------------"
  "try
  "source ~/.vim_runtime/my_configs.vim
  "catch
  "endtry



"####################################################"
              "#  VimRC Custom Options #
"####################################################"

set nocompatible



    "# Bindings #
"# --------------------------------------------------"

"# BackSpace:"
set backspace=indent,eol,start


"# KeyPad:"
inoremap <Esc>Oq 1
inoremap <Esc>Or 2
inoremap <Esc>Os 3
inoremap <Esc>Ot 4
inoremap <Esc>Ou 5
inoremap <Esc>Ov 6
inoremap <Esc>Ow 7
inoremap <Esc>Ox 8
inoremap <Esc>Oy 9
inoremap <Esc>Op 0
inoremap <Esc>On .
inoremap <Esc>OQ /
inoremap <Esc>OR *
inoremap <Esc>Ol +
inoremap <Esc>OS -
inoremap <Esc>OM <Enter>


"# Space open/closes folds:"
nnoremap <space> za

if filereadable(expand("$VIMRUNTIME/syntax/synload.vim"))
  syntax on
endif


"# Xterm:"
if has("syntax") && &term =~ "xterm"
  set t_Co=8

  if has("terminfo")
      set t_Sf=<Esc>[3%p1%dm
      set t_Sb=<Esc>[4%p1%dm

  else
      set t_Sf=<Esc>[3%dm
      set t_Sb=<Esc>[4%dm
  endif
endif



    "# Formatting #
"#--------------------------------------------------"

"# Folding:"
set foldenable

set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent


"# Tabs:"
set tabstop=2
set softtabstop=2

set expandtab
set softtabstop=2

set shiftwidth=2

    "set list"
"# Wrapping:"
set textwidth=0
set wrapmargin=0


"# Pasting:"
set paste



    "# GUI #
"#--------------------------------------------------"

"# GUI File Menu:"
set wildmenu


"# Match Highlighting:"
set showmatch


"# Search:"
set incsearch
set hlsearch

set smartcase


"# Colors:"
set  t_Co=256


    "# Syntax #
"#--------------------------------------------------"

"# File Recognition:"
filetype indent on


"# No Auto-Indent:"
set noai
set showmode


"# Show partial command:"
set showcmd



    "# Backups #
"#--------------------------------------------------"

"# Backups:"
set backup

set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set backupskip=/tmp/*,/private/tmp/*
set backupskip+=/etc/crontabs.*

set writebackup


  "# Auto backup:"
    "set autowrite"



"# Disabled Options #
"# --------------------------------------------------"

  "# Line Numbers:"
    "set number"
    "set cursorline"


  "# Space & Tab Symbols:"
    "set list"
