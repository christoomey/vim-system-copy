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
  echohl String | echon 'Activated from: ' . mode | echohl None
endfunction

function! s:resolve_mode(type, arg)
  let visual_mode = a:arg != 0
  if visual_mode
    if a:type == ''
      return s:blockwise
    else
      return s:visual
    end
  elseif a:type == 'line'
    return s:linewise
  else
    return s:motion
  endif
endfunction

xnoremap <silent> <Plug>SystemCopy :<C-U>call <SID>system_copy(visualmode(),visualmode() ==# 'V' ? 1 : 0)<CR>
nnoremap <silent> <Plug>SystemCopy :<C-U>set opfunc=<SID>system_copy<CR>g@

if !hasmapto('<Plug>SystemCopy') || maparg('cp','n') ==# ''
  xmap cp <Plug>SystemCopy
  nmap cp <Plug>SystemCopy
  nmap cP <Plug>SystemCopyLine
endif
