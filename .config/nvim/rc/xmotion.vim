" extended motion keys for bulk motion
"
if exists("g:loaded_xmotion")
    finish
endif
let g:loaded_xmotion = 1

imap <expr> <M-[> repeat("\<left>", &ts)
imap <expr> <M-]> repeat("\<right>", &ts)
nmap <expr> <M-[> repeat("\<left>", &ts)
nmap <expr> <M-]> repeat("\<right>", &ts)
xmap <expr> <M-[> repeat("\<left>", &ts)
xmap <expr> <M-]> repeat("\<right>", &ts)

imap <expr> <M-{> repeat("\<up>", &so)
imap <expr> <M-}> repeat("\<down>", &so)
nmap <expr> <M-{> repeat("\<up>", &so)
nmap <expr> <M-}> repeat("\<down>", &so)
xmap <expr> <M-{> repeat("\<up>", &so)
xmap <expr> <M-}> repeat("\<down>", &so)

