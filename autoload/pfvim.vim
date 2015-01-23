if !exists('s:write_script')
  let s:write_script = fnamemodify(expand('<sfile>'), ':p:r') . '.sh'
endif

function! s:abs_uri(uri)
  let uri = a:uri ==# '<afile>' ? expand(a:uri) : a:uri
  return fnamemodify(uri[0:2] ==# 'pf:' ? uri[3:] : uri, ':p')
endfunction

function! s:read(uri)
  let uri = s:abs_uri(a:uri)
  silent execute printf('read !pfexec cat 2>/dev/null ''%s''', uri)
endfunction

function! s:write(uri) abort
  let uri = s:abs_uri(a:uri)
  silent execute printf('%write !pfexec >/dev/null ''%s'' ''%s''', s:write_script, uri)
  setl nomod
endfunction

function! pfvim#edit(uri)
  let save_ul = &l:undolevels
  try
    setl undolevels=-1
    call s:read(a:uri)
    1d
  finally
    let &l:undolevels = save_ul
  endtry
  setl nomod
  filetype detect
endfunction

function! pfvim#read(uri)
  call s:read(a:uri)
endfunction

function! pfvim#write(uri)
  call s:write(a:uri)
endf
