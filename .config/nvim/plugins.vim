let plugin_base = expand('<sfile>:p:h') . "/plugged"

func! P_update(arg)
  UpdateRemotePlugins
endf

call plug#begin(plugin_base)

"---- colorschemes
Plug 'tomasr/molokai'

"---- ide feature
Plug 'Shougo/deoplete.nvim', {'do': function('P_update')}           " async completion
Plug 'Shougo/unite.vim'                 " unite interface to different things
Plug 'neomake/neomake'                  " lint/compile on save, asynchronously
Plug 'tpope/vim-fugitive'               " git support
Plug 'tpope/vim-commentary'             " add/remove comments
Plug 'ctrlpvim/ctrlp.vim'               " fuzzy finder
" Plug 'Shougo/vim-javacomplete2'         " Java complete!!!
Plug 'Shougo/neosnippet'                " Snippet support
Plug 'Shougo/neosnippet-snippets'       " Default snippets
Plug 'blindFS/vim-taskwarrior'          " taskwarrior integration (task management)

"---- enhancement
Plug 'tpope/vim-repeat'                 " allow other plugins to repeat by '.' atomically
Plug 'tpope/vim-surround'               " change/add surround pairs: `cs[{` `ysiW]`
Plug 'tpope/vim-unimpaired'             " paired operation: `]b` to next buffer, `]n` to next git conflict
Plug 'godlygeek/tabular'                " vertical align: :Tab /\s
Plug 'wellle/targets.vim'               " more text objects: inside comma, inside argument
Plug 'tommcdo/vim-exchange'             " exchange two text segments: `cxiw`
Plug 'simnalamburt/vim-mundo'           " visualize undo tree
Plug 'justinmk/vim-sneak'               " quick navigation by 2 characters: `slu`

"---- language support
Plug 'dag/vim-fish'                     " fish shell
Plug 'tpope/vim-afterimage'             " edit image file
Plug 'tikhomirov/vim-glsl'              " glsl
"Plug 'cjxgm/nvim-nim'                   " nim

call plug#end()

" setup unite
nmap <silent> <M-/> :Unite -toggle buffer file_rec/neovim<CR>
nmap <silent> <M-'> :Unite -toggle<CR>

" setup neomake
au bufwritepost * Neomake
let g:neomake_error_sign = { 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'texthl': 'MoreMsg', 'text': '！' }
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_args = ["-std=gnu++14", "-Wextra", "-Wall", "-fsyntax-only"]
let g:neomake_c_enabled_makers = ['gcc']
let g:neomake_c_clang_args = ["-std=gnu11", "-Wextra", "-Wall", "-fsyntax-only"]

" setup commentary
vmap / gcgv
au filetype nim setlocal commentstring=#\ %s

" setup deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 1
imap <silent><expr><C-p> deoplete#manual_complete()
imap <silent><expr><C-n> deoplete#manual_complete()

" setup neosnippet
imap <C-l>     <Plug>(neosnippet_expand_or_jump)
smap <C-l>     <Plug>(neosnippet_expand_or_jump)
xmap <C-l>     <Plug>(neosnippet_expand_target)
set conceallevel=2 concealcursor=niv

