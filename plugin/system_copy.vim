if exists('g:loaded_system_copy') || v:version < 700
  finish
endif
let g:loaded_system_copy = 1

if !exists("g:system_copy_silent")
  let g:system_copy_silent = 0
endif

let s:blockwise = 'blockwise visual'
let s:visual = 'visual'
let s:motion = 'motion'
let s:linewise = 'linewise'
let s:mac = 'mac'
let s:windows = 'windows'
let s:linux = 'linux'

function! s:system_copy(type, ...) abort
  let mode = <SID>resolve_mode(a:type, a:0)
  let unnamed = @@
  if mode == s:linewise
    let lines = { 'start': line("'["), 'end': line("']") }
    silent exe lines.start . "," . lines.end . "y"
  elseif mode == s:visual || mode == s:blockwise
    silent exe "normal! `<" . a:type . "`>y"
  else
    silent exe "normal! `[v`]y"
  endif
  let command = s:CopyCommandForCurrentOS()
  silent call system(command, getreg('@'))
  if g:system_copy_silent == 0
    echohl String | echon 'Copied to clipboard using: ' . command | echohl None
  endif
  let @@ = unnamed
endfunction

function! s:system_paste(type, ...) abort
  let mode = <SID>resolve_mode(a:type, a:0)
  let command = <SID>PasteCommandForCurrentOS()
  let unnamed = @@
  silent exe "set paste"
  if mode == s:linewise
    let lines = { 'start': line("'["), 'end': line("']") }
    silent exe lines.start . "," . lines.end . "d"
    silent exe "normal! O" . system(command)
  elseif mode == s:visual || mode == s:blockwise
    silent exe "normal! `<" . a:type . "`>c" . system(command)
  else
    silent exe "normal! `[v`]c" . system(command)
  endif
  silent exe "set nopaste"
  if g:system_copy_silent == 0
    echohl String | echon 'Pasted to clipboard using: ' . command | echohl None
  endif
  let @@ = unnamed
endfunction

function! s:system_paste_line() abort
  let command = <SID>PasteCommandForCurrentOS()
  put =system(command)
  if g:system_copy_silent == 0
    echohl String | echon 'Pasted to vim using: ' . command | echohl None
  endif
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
  let os = substitute(system('uname'), '\n', '', '')
  let known_os = 'unknown'
  if has("gui_mac") || os ==? 'Darwin'
    let known_os = s:mac
  elseif has("gui_win32") || os =~? 'cygwin' || os =~? 'MINGW'
    let known_os = s:windows
  elseif os ==? 'Linux'
    let known_os = s:linux
  else
    exe "normal \<Esc>"
    throw "unknown OS: " . os
  endif
  return known_os
endfunction

function! s:CopyCommandForCurrentOS()
  if exists('g:system_copy#copy_command')
    return g:system_copy#copy_command
  endif
  let os = <SID>currentOS()
  if os == s:mac
    return 'pbcopy'
  elseif os == s:windows
    return 'clip'
  elseif os == s:linux
    if !empty($WAYLAND_DISPLAY)
      return 'wl-copy'
    else
      return 'xsel --clipboard --input'
    endif
  endif
endfunction

function! s:PasteCommandForCurrentOS()
  if exists('g:system_copy#paste_command')
    return g:system_copy#paste_command
  endif
  let os = <SID>currentOS()
  if os == s:mac
    return 'pbpaste'
  elseif os == s:windows
    return 'paste'
  elseif os == s:linux
    if !empty($WAYLAND_DISPLAY)
      return 'wl-paste -n'
    else
      return 'xsel --clipboard --output'
    endif
  endif
endfunction

xnoremap <silent> <Plug>SystemCopy :<C-U>call <SID>system_copy(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>SystemCopy :<C-U>set opfunc=<SID>system_copy<CR>g@
nnoremap <silent> <Plug>SystemCopyLine :<C-U>set opfunc=<SID>system_copy<Bar>exe 'norm! 'v:count1.'g@_'<CR>
xnoremap <silent> <Plug>SystemPaste :<C-U>call <SID>system_paste(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>SystemPaste :<C-U>set opfunc=<SID>system_paste<CR>g@
nnoremap <silent> <Plug>SystemPasteLine :<C-U>call <SID>system_paste_line()<CR>

if !hasmapto('<Plug>SystemCopy', 'n') || maparg('cp', 'n') ==# ''
  nmap cp <Plug>SystemCopy
endif

if !hasmapto('<Plug>SystemCopy', 'v') || maparg('cp', 'v') ==# ''
  xmap cp <Plug>SystemCopy
endif

if !hasmapto('<Plug>SystemCopyLine', 'n') || maparg('cP', 'n') ==# ''
  nmap cP <Plug>SystemCopyLine
endif

if !hasmapto('<Plug>SystemPaste', 'n') || maparg('cv', 'n') ==# ''
  nmap cv <Plug>SystemPaste
endif

if !hasmapto('<Plug>SystemPaste', 'v') || maparg('cv', 'v') ==# ''
  xmap cv <Plug>SystemPaste
endif

if !hasmapto('<Plug>SystemPasteLine', 'n') || maparg('cV', 'n') ==# ''
  nmap cV <Plug>SystemPasteLine
endif
" vim:ts=2:sw=2:sts=2
