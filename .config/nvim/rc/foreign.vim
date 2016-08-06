" fixes on foreign files

if exists("g:loaded_foreign")
    finish
endif
let g:loaded_foreign = 1

func s:save_view()
    let s:cursor = getcurpos()
    let s:view = winsaveview()
endf

func s:restore_view()
    call setpos('.', s:cursor)
    call winrestview(s:view)
endf

func s:fix_spaces()
    if !&modifiable || exists('g:no_foreign_fix')
        return
    end

    call s:save_view()

    " newline format fix
    set ff=unix
    " remove eol spaces
    silent! %s/\s\+$//g

    " keep only one single empty line at the end of buffer
    let last_blank_num = line('$') - prevnonblank(line('$'))
    if last_blank_num == 0
        call append(line('$'), '')
    elseif last_blank_num > 1
        exe '$-' . (last_blank_num-2) . ',$ d _'
    endif

    call s:restore_view()
endf

au bufwritepre * call <SID>fix_spaces()

