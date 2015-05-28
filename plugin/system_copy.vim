let s:blockwise = 'blockwise visual'
let s:visual = 'visual'
let s:motion = 'motion'
let s:linewise = 'linewise'

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

function! s:CopyCommandForCurrentOS()
  let os = substitute(system('uname'), '\n', '', '')
  if has("gui_mac") || os == 'Darwin'
    return 'pbcopy'
  elseif has("gui_win32")
    return 'clip'
  else
    return 'xsel --clipboard --input'
  endif
endfunction

xnoremap <silent> <Plug>SystemCopy :<C-U>call <SID>system_copy(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>SystemCopy :<C-U>set opfunc=<SID>system_copy<CR>g@
nnoremap <silent> <Plug>SystemCopyLine :<C-U>set opfunc=<SID>system_copy<Bar>exe 'norm! 'v:count1.'g@_'<CR>

if !hasmapto('<Plug>SystemCopy') || maparg('cp','n') ==# ''
  xmap cp <Plug>SystemCopy
  nmap cp <Plug>SystemCopy
  nmap cP <Plug>SystemCopyLine
endif
