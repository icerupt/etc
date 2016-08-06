" preim: PRe-Editing-like IMap
" (imap is the Vim term)

" API:
"   call PREIM_map(rule, result)

if exists("g:loaded_preim")
    finish
endif
let g:loaded_perim = 1

" prefix-string state machine
let s:states = [ { 'nexts': {} } ]
let b:state = 0
let s:keys = "~!@#$%^&*()_+`1234567890-=\bQWERTYUIOP{}|\tqwertyuiop[]\\ASDFGHJKL:\"asdfghjkl;'\nZXCVBNM<>?zxcvbnm,./ "

" assume len(rule) > 0
" assume len(result) > 0
func s:map(rule, result)
    let rule = split(a:rule, '\zs')
    let result = a:result
    let state = 0
    for ch in rule
        if stridx(s:keys, ch) < 0
            echoerr "preim: cannot map key: " . ch
            return
        endif
        let next = s:next_state(state, ch)
        if next == 0
            let next = len(s:states)
            call add(s:states, { 'nexts': {} })
            let s:states[state].nexts[ch] = next
        endif
        let state = next
    endfor
    if has_key(s:states[state], 'result')
        echoerr "preim: cannot redefine rule: " . a:rule
        return
    endif
    let s:states[state].result = result
endf

" assume len(x) == 1
func s:next_state(state, x)
    return get(s:states[a:state].nexts, a:x, 0)
endf

" state transition
func s:feed(input)
    if len(a:input) != 1
        let b:state = 0
        return a:input
    endif
    let b:state = s:next_state(b:state, a:input)
    if b:state == 0
        let b:state = s:next_state(b:state, a:input)
    endif
    return get(s:states[b:state], 'result', a:input)
endf

func s:listen_expr(x,  y)
    exe "inoremap <expr> " . a:x . " <SID>feed(\"" . a:y . "\")"
endf

func s:listen(x)
    let x = a:x
    let ex = x

    if x == '|'
        let x = '<bar>'
    elseif x == "\b"
        let x = '<bs>'
    elseif x == "\t"
        let x = '<tab>'
    elseif x == " "
        let x = '<space>'
    elseif x == "\n"
        let x = '<cr>'
    endif

    call s:listen_expr(x, escape(ex, "\"|\\\n"))
endf

func PREIM_map(rule, result)
    let rule = a:rule
    if empty(rule)
        echoerr "preim: rule cannot be an empty string"
        return
    endif
    let result = rule[len(rule)-1] . a:result
    call s:map(rule, result)
endf

" event listening
for k in split(s:keys, '\zs')
    call s:listen(k)
endfor
call s:listen_expr("<up>", "\<up>")
call s:listen_expr("<down>", "\<down>")
call s:listen_expr("<left>", "\<left>")
call s:listen_expr("<right>", "\<right>")
call s:listen_expr("<esc>", "\<esc>")
call s:listen_expr("<c-c>", "\<c-c>")
au cursorholdi * call <SID>feed('')
au cursormoved * call <SID>feed('')
au insertleave * call <SID>feed('')

" presets
" - singles (and their exceptions)
call PREIM_map(",", " ")
" - pairs
call PREIM_map("<>", "\<left>")
call PREIM_map("()", "\<left>")
call PREIM_map("[]", "\<left>")
call PREIM_map("{}", "\<left>")
call PREIM_map("``", "\<left>")
call PREIM_map("''", "\<left>")
call PREIM_map('""', "\<left>")
call PREIM_map('//', "\<left>")
call PREIM_map('||', "\<left>")
" - follow up: backspace
call PREIM_map(",\b", "\<bs>")
call PREIM_map("<>\b", "\<del>")
call PREIM_map("()\b", "\<del>")
call PREIM_map("[]\b", "\<del>")
call PREIM_map("{}\b", "\<del>")
call PREIM_map("``\b", "\<del>")
call PREIM_map("''\b", "\<del>")
call PREIM_map("\"\"\b", "\<del>")
call PREIM_map("//\b", "\<del>")
call PREIM_map("||\b", "\<del>")
" - follow up: space
call PREIM_map(", ", "\<bs>")
call PREIM_map("<> ", "\<bs>\<right>")
call PREIM_map("() ", "\<bs>\<right>")
call PREIM_map("[] ", "\<bs>\<right>")
call PREIM_map("{} ", " \<left>")
call PREIM_map('// ', "\<bs>\<right> ")
call PREIM_map('|| ', "\<bs>\<right> ")
" - follow up: comma
call PREIM_map(",,", "\<bs>\<bs>")
call PREIM_map("[],", "\<bs>\<right>,")
call PREIM_map("``,", "\<bs>\<right>,")
call PREIM_map("'',", "\<bs>\<right>,")
call PREIM_map('"",', "\<bs>\<right>,")
call PREIM_map("``,,", "\<bs>\<bs>\<left>,")
call PREIM_map("'',,", "\<bs>\<bs>\<left>,\<right>")
call PREIM_map('"",,', "\<bs>\<bs>\<left>,")
" - follow up: dot
call PREIM_map("().", "\<bs>\<right>.")
call PREIM_map("[].", "\<bs>\<right>.")
call PREIM_map("``.", "\<bs>\<right>.")
call PREIM_map("''.", "\<bs>\<right>.")
call PREIM_map('"".', "\<bs>\<right>.")
call PREIM_map("``..", "\<bs>\<bs>\<left>.")
call PREIM_map("''..", "\<bs>\<bs>\<left>.\<right>")
call PREIM_map('""..', "\<bs>\<bs>\<left>.")
" - follow up: semicolon
call PREIM_map("();", "\<bs>\<right>;")
call PREIM_map("[];", "\<bs>\<right>;")
call PREIM_map("{};", "\<bs>\<right>;")
call PREIM_map("``;", "\<bs>\<right>;")
call PREIM_map("'';", "\<bs>\<right>;")
call PREIM_map('"";', "\<bs>\<right>;")
call PREIM_map("();;", "\<bs>\<bs>\<left>;")
call PREIM_map("``;;", "\<bs>\<bs>\<left>;")
call PREIM_map("'';;", "\<bs>\<bs>\<left>;\<right>")
call PREIM_map('"";;', "\<bs>\<bs>\<left>;")

