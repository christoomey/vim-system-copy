let s:blockwise = 'blockwise visual'
let s:visual = 'visual'
let s:motion = 'motion'
let s:linewise = 'linewise'
let s:mac = 'mac'
let s:windows = 'windows'
let s:linux = 'linux'
let s:os = ''

if exists('g:loaded_system_copy') || &cp || v:version < 700
  finish
endif
let g:loaded_system_copy = 1

function! s:system_copy(type, ...) abort
  let mode = <SID>resolve_mode(a:type, a:0)
  if mode == s:linewise
    let lines = { 'start': line("'["), 'end': line("']") }
    silent exe lines.start . "," . lines.end . "y"
  elseif mode == s:visual || mode == s:blockwise
    silent exe "normal! `<" . a:type . "`>y"
  else
    silent exe "normal! `[v`]y"
  endif
  silent call system(s:CopyCommandForCurrentOS(), getreg('@'))
  echohl String | echon 'Copied to system clipboard via: ' . mode | echohl None
endfunction

function! s:system_paste() abort
  let command = <SID>PasteCommandForCurrentOS()
  put =system(command)
  echohl String | echon 'Pasted to vim using: ' . command | echohl None
endfunction

function! s:resolve_mode(type, arg)
  let visual_mode = a:arg != 0
  if visual_mode
    return (a:type == '') ?  s:blockwise : s:visual
  elseif a:type == 'line'
    return s:linewise
  else
    return s:motion
  endif
endfunction

function! s:currentOS()
  if !empty(s:os)
    return s:os
  endif
  let os = substitute(system('uname'), '\n', '', '')
  if has("gui_mac") || os ==? 'Darwin'
    let s:os = s:mac
    return s:mac
  elseif has("gui_win32")
    let s:os = s:windows
    return s:windows
  elseif os ==? 'Linux'
    let s:os = s:linux
    return s:linux
  endif
  exe "normal \<Esc>"
  throw "unknown OS: " . os
endfunction

function! s:CopyCommandForCurrentOS()
  let os = <SID>currentOS()
  if os == s:mac
    return 'pbcopy'
  elseif os == s:windows
    return 'clip'
  elseif os == s:linux
    return 'xsel --clipboard --input'
  endif
endfunction

function! s:PasteCommandForCurrentOS()
  let os = <SID>currentOS()
  if os == s:mac
    return 'pbpaste'
  elseif os == s:windows
    return 'paste'
  elseif os == s:linux
    return 'xsel --clipboard --output'
  endif
endfunction

xnoremap <silent> <Plug>SystemCopy :<C-U>call <SID>system_copy(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>SystemCopy :<C-U>set opfunc=<SID>system_copy<CR>g@
nnoremap <silent> <Plug>SystemCopyLine :<C-U>set opfunc=<SID>system_copy<Bar>exe 'norm! 'v:count1.'g@_'<CR>
nnoremap <silent> <Plug>SystemPaste :<C-U>call <SID>system_paste()<CR>

if !hasmapto('<Plug>SystemCopy') || maparg('cp','n') ==# ''
  xmap cp <Plug>SystemCopy
  nmap cp <Plug>SystemCopy
  nmap cP <Plug>SystemCopyLine
endif

if !hasmapto('<Plug>SystemPaste') || maparg('cv','n') ==# ''
  nmap cv <Plug>SystemPaste
endif
