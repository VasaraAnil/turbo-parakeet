" Ensure that Vim is in improved mode
set nocompatible              " Be iMproved, required
filetype off                  " Required





" Set Python interpreter path
let g:python3_host_prog = 'V:\Python\python.exe'





function! RunPython()
    " Get the current file name
    let l:filename = expand('%:p')

    " Check if the file has a .py extension
    if l:filename !~ '\.py$'
        echohl ErrorMsg
        echom "Not a Python file."
        echohl None
        return
    endif

    " Run the Python script in a new terminal
    let l:terminal_command = 'start cmd /k python ' . l:filename
    silent execute '!'.l:terminal_command

    echo "Output displayed in a new terminal window."
endfunction



" Create a command to compile and run Python code
command! Runpython call RunPython()




" Set the path for MinGW binaries
let $PATH = $PATH . ';V:/Mingw/Bin'












function! CompileAndRun()
    " Get the current file name
    let l:filename = expand('%:p')

    " Compile the file using g++
    let l:compile_result = system('g++ ' . l:filename . ' -o ' . expand('%:r'))

    " Check for compilation errors
    if v:shell_error
        echohl ErrorMsg
        echom "Compilation Error:"
        echom l:compile_result
        echohl None
        return
    endif

    " Run the executable in a new terminal
    " Change 'your_terminal_emulator' to your preferred terminal emulator
    let l:terminal_command = 'start cmd /k ' . expand('%:r')
    silent execute '!'.l:terminal_command

    echo "Output displayed in a new terminal window."
endfunction





" Create a command to compile and run C++ code
command! RunCpp call CompileAndRun()




" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Remap a few keys for Windows behavior
source $VIMRUNTIME/mswin.vim

" Mouse behavior (the Windows way)
behave mswin

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Set tabs to spaces and define tab size
set tabstop=4
set shiftwidth=4
set expandtab

" Show matching parentheses
set showmatch

" Enable mouse support
set mouse=a

" Set search to be case-insensitive unless uppercase is used
set ignorecase
set smartcase

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif

function MyDiff()
  let opt = '-a --binary '
  
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')

  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')

  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')

  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif

  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3

  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

