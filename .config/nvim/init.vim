
runtime! plugins.vim
runtime! rc/*.vim

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"set clipboard+=unnamedplus

colorscheme molokai
set background=dark

" completion also scan include files, but no tags
set path+=/usr/include/c++/*/
set complete+=i
set complete-=t

" better vertical split style
set fillchars+=vert:│
hi clear VertSplit
hi VertSplit ctermfg=238 guifg=#455354

set number
set relativenumber
set ruler

set foldtext=G_fold_text()
hi clear Folded
hi Folded ctermfg=59 guifg=#7E8E91
" should be hi link Folded Comment

set smartcase
set ignorecase
set shell=sh
set completeopt+=longest
set undofile
set autoindent
set smartindent
au filetype c set cindent
au filetype cpp set cindent

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround
filetype indent off
" never ever change indentation settings based on file type

set nowrap
set textwidth=0
set colorcolumn=76
set sidescrolloff=8
set sidescroll=1
set scrolloff=4

"set nofoldenable
set foldlevel=999
set foldmethod=indent
set foldminlines=0

" tabline colors
hi clear TabLine
hi clear TabLineFill
hi clear TabLineSel
hi TabLine     cterm=bold ctermfg=232 ctermbg=238 guifg=#080808 guibg=#455354
hi TabLineFill cterm=bold ctermfg=232 ctermbg=238 guifg=#080808 guibg=#455354
hi TabLineSel  cterm=bold ctermfg=81  ctermbg=236 guifg=#66D9EF guibg=#232526

" statusline colors
hi clear StatusLine
hi clear StatusLineNC
hi StatusLine   cterm=reverse ctermfg=244 ctermbg=232 gui=reverse guifg=#808080 guibg=#080808
hi StatusLineNC cterm=bold,reverse ctermfg=238 ctermbg=253 gui=bold,reverse guifg=#455354 guibg=fg

" some highlights modification
hi Special ctermfg=12
hi MatchParen cterm=bold ctermfg=208 ctermbg=0 guifg=#FD971F guibg=#000000
hi Conceal ctermbg=232 ctermfg=69


" terminal emulator
tnoremap <Esc> <C-\><C-n>
tnoremap <Esc><Esc> <Esc>
tnoremap <Esc>w <C-\><C-n><C-w><C-w>
"tnoremap <C-c> <C-\><C-n>
"tnoremap <C-c><C-c> <C-c>

" progressive indent
vnoremap > >gv
vnoremap < <gv
" smooth scroll, keeping cursor still (as to the eye)
"nnoremap <C-j> <DOWN><C-e>
"nnoremap <C-k> <UP><C-y>
"nnoremap <PageUp> 4<UP>4<C-y>4<UP>4<C-y>4<UP>4<C-y>4<UP>4<C-y>4<UP>4<C-y>4<UP>4<C-y>
"nnoremap <PageDown> 4<DOWN>4<C-e>4<DOWN>4<C-e>4<DOWN>4<C-e>4<DOWN>4<C-e>4<DOWN>4<C-e>4<DOWN>4<C-e>
" open fold (all)
nmap <TAB> zO
" close fold
nmap <S-TAB> zc
" show only current fold
nmap <bar> zMzv
" unfold/fold all
nmap <F2> zR
nmap <F3> zM
nmap <F4> :call C_compile_and_test()<CR>
nmap <F5> :call C_compile_and_run()<CR>
nmap <F6> :wa<CR>:make! reconf<CR>
" toggle fold
nmap <F7> zi
nmap <F9> :wa<CR>:!./configure<CR>
nmap <F10> <C-w>i
nmap <silent> <F12> mt:exe ":silent! normal :%s/\\s\\+$//g\r"<CR>:nohls<CR>`t
" when cursor in "(some, other)", swap to "(other, some)"
nmap ,(s %l"sdt,dw%%P"sp
imap <C-d> <C-x><C-d>
imap <F4> <ESC><F4>a
imap <F5> <ESC><F5>a
"imap <PageUp> <UP><UP><UP><UP><UP><UP><UP><UP><UP><UP>
"imap <PageDown> <DOWN><DOWN><DOWN><DOWN><DOWN><DOWN><DOWN><DOWN><DOWN><DOWN>
" omni completion
imap <M-space> <C-x><C-o>
" write with sudo
cmap W!! w !sudo tee "%"


" syntastic settings
"let g:syntastic_cpp_compiler = "clang++"
"let g:syntastic_cpp_compiler_options = "-Wall -Wextra -std=gnu++14"

func! C_compile_and_test()
    wa
    if &filetype == "c"
        call Tabterm("term gcc -Wall -pthread -std=gnu11 -Og -ggdb -march=native -lm -o %:r % && gdb ./%:r")
    elseif &filetype == "rust"
        call Tabterm("term cargo test -- --nocapture")
    else
        call Tabterm("echo -e \\\\e[1\\;33munknown filetype for compile-and-test, fallback to makefile\\\\e[0m; make test -j4 -C $(git rev-parse --show-toplevel 2>/dev/null \|\| echo .)")
    endif
endf

func! C_compile_and_run()
    wa

    let fullname = expand("%")
    let rootname = expand("%:r")    | " a.k.a. strips off suffix names

    let xfullname = shellescape(fullname)
    let xrootname = shellescape(rootname)

    if &filetype == "c"
        call Tabterm("gcc -Wall -pthread -std=gnu11 -O3 -march=native -lm -o " . xrootname . " " . xfullname . " && ./" . xrootname)
    elseif &filetype == "cpp"
        call Tabterm("ml -Cn5 " . xfullname)
    elseif &filetype == "java"
        call Tabterm("javac " . xfullname . " && java " . xrootname)
    elseif &filetype == "dot"
        exe "!dot -T png -o %<.png % && feh %<.png"
    elseif &filetype == "lua"
        call Tabterm("lua " . xfullname)
    elseif &filetype == "perl"
        call Tabterm("perl " . xfullname)
    elseif &filetype == "sh"
        call Tabterm("sh " . xfullname)
    elseif &filetype == "javascript"
        call Tabterm("node --es_staging " . xfullname)
    elseif &filetype == "python"
        call Tabterm("python " . xfullname)
    elseif &filetype == "ruby"
        exe "!ruby %"
    elseif &filetype == "asciidoc"
        exe "!asciidoc -b html5 % && xdg-open %<.html"
    elseif &filetype == "scheme"
        exe "!bigloo -o %< % && ./%<"
    elseif &filetype == "rust"
        call Tabterm("term cargo run")
    elseif &filetype == "nim"
        call Tabterm("nim -d:vim -o:/tmp/nim-build -r -d:ssl c " . xfullname)
    else
        echo "unknown filetype for compile-and-run"
        echo "  fallback to makefile"
        make! -C $(git rev-parse --show-toplevel 2>/dev/null \|\| echo .) test -j4
    endif
endf

func! Tabterm(cmd)
    tabe
    call termopen(a:cmd)
    startinsert
endf

nmap XXXX ZQ
nmap <C-f> <C-w>f
nmap <C-d> <C-w>i

nmap gp `[v`]

"imap ,<SPACE> ,<SPACE>
"imap ,<CR> ,<CR>
"imap , ,<SPACE>

func! C_include(file)
    exe "normal o#include \"" . a:file . "\""
    exe "normal ^www"
endf
command -nargs=1 -complete=file I call C_include("<args>")

func! C_include_system(file)
    exe "normal o#include <" . a:file . ">"
    exe "normal ^www"
endf
command -nargs=1 -complete=file_in_path IS call C_include_system("<args>")

func! C_include_io()
    if &ft == "cpp"
        IS iostream
        exe "normal ousing std::cin;"
        exe "normal ousing std::cout;"
        exe "normal ousing std::cerr;"
        exe "normal ousing std::endl;"
    elseif &ft == "c"
        IS stdio.h
    endif
endf
command II call C_include_io()

func! C_namespace(name)
    exe "normal onamespace " . a:name . "\n{\n}"
    exe "normal %"
endf
command -nargs=1 NS call C_namespace("<args>")

func! C_namespace_anonymous()
    exe "normal onamespace\n{\n}"
    exe "normal %"
endf
command NSA call C_namespace_anonymous()

func! C_unused(vars)
    exe "normal o \b#pragma unused (" . a:vars . ")"
endf
command -nargs=1 UU call C_unused("<args>")

func! C_const_ref(name)
    exe "normal ousing " . a:name . "_cref = " . a:name . " const&;"
endf
command -nargs=1 CR call C_const_ref("<args>")

func! C_header_skeleton()
    exe "normal i#pragma once"
    exe "normal o"
    exe "normal o"
    exe "normal k"
endf
au BufNewFile *.h call C_header_skeleton()
au BufNewFile *.hh call C_header_skeleton()

" extra highlighting and keybinding for lua
func! ExtraLua()
    " table access highlighting
    syn match extra_lua_table /\zs\I\i*\(\s*\.\s*\I\i*\)*\s*\ze[.:][^.]/ nextgroup=extra_lua_table_key,extra_lua_table_method skipwhite
    syn match extra_lua_table  /\zs\(\s*\.\s*\I\i*\)*\s*\ze[.:][^.]/ nextgroup=extra_lua_table_key,extra_lua_table_method skipwhite
    hi def link extra_lua_table luaTable

    syn match extra_lua_table_key /\.\s*\I\i*/ contained contains=extra_lua_table_key_dot
    hi def link extra_lua_table_key luaFunc

    syn match extra_lua_table_key_dot /\./ contained
    hi def link extra_lua_table_key_dot extra_lua_table

    syn match extra_lua_table_method /:\s*\I\i*/ contained
    hi def link extra_lua_table_method extra_lua_table_key

    " fix highlighting of ".."
    syn match luaBlock "\.\."
endf
au BufNewFile,BufRead *.lua call ExtraLua()

func! HighlightFuckingSpace()
    syn match fuckExtraBlank "\s\+$"
    syn match fuckExtraBlank "\s\+$" contained
    hi def link fuckExtraBlank Error
   " syn match fuckIndentSpace "^ \+"
   " syn match fuckIndentSpace "^ \+" contained
   " hi def link fuckIndentSpace Error
endfunc
au BufNewFile,BufRead * call HighlightFuckingSpace()

" show closed folds that look like:
"   » original_text();                         --- 1234 ---|
"   » original_text();                         ---- 234 ---|
"   » original_text();                         ----- 34 ---|
"   » original_text();                         ------ 1 ---|
"   » original_text();                         -- 12345 ---|
"   » original_text();                        -- 123456 ---|
"                                                          `- the right edge of the window
func! G_fold_text()
    let line = getline(v:foldstart)
    let num_folded_lines = v:foldend - v:foldstart + 1
    let num_folded_lines_indicator = " ·" . repeat("·", 4-strwidth(num_folded_lines)) . " " . num_folded_lines . " ▾"

    let left_pane_width = &numberwidth*&number + &foldcolumn
    let area_width = winwidth(0) - left_pane_width
    let prefix_width = area_width - strwidth(num_folded_lines_indicator)
    if prefix_width < 1
        return line
    endif

    let prefix = line[0:prefix_width-1]
    let prefix = prefix . repeat(" ", prefix_width - strwidth(prefix))
    let prefix = substitute(prefix, "\\s\\s\\ze\\S", "▸ ", "")
    return prefix . num_folded_lines_indicator
endf

