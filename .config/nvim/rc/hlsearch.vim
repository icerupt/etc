
if exists("g:loaded_hlsearch")
    finish
endif
let g:loaded_hlsearch = 1

func s:disable()
    let s:old = &hlsearch
    let &hlsearch = 0
endf

func s:resume()
    let &hlsearch = s:old
endf


" clear hlsearch and redraw screen
nnoremap <silent><C-l> :nohls<CR><C-l>
au insertenter * call <SID>disable()
au insertleave * call <SID>resume()

