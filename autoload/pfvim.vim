if !exists('s:write_script')
  let s:write_script = fnamemodify(expand('<sfile>'), ':p:r') . '.sh'
endif

function! s:abs_uri(uri)
  let uri = a:uri ==# '<afile>' ? expand(a:uri) : a:uri
  return escape(uri[0:2] ==# 'pf:' ? uri : 'pf:' . uri, ' ')
endfunction

function! s:read(uri)
  let uri = s:abs_uri(a:uri)
  silent execute 'read !pfexec cat 2>/dev/null' uri[3:]
endfunction

function! s:write(uri)
  let uri = s:abs_uri(a:uri)
  silent execute '%write !pfexec >/dev/null' s:write_script uri[3:]
  setl nomod
endfunction

function! pfvim#edit(uri)
  let ul_save = &l:undolevels
  try
    setl undolevels=-1
    call s:read(a:uri)
    1d
  finally
    let &l:undolevels = ul_save
  endtry
  setl nomod
  filetype detect
endfunction

function! pfvim#read(uri)
  call s:read(a:uri)
endfunction

function! pfvim#write(uri) abort
  call s:write(a:uri)
endf
