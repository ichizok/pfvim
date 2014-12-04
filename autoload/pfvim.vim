function! s:abs_uri(uri)
  let uri = a:uri == "<afile>" ? expand(a:uri) : a:uri
  return uri[0:2] ==# 'pf:' ? uri : 'pf:' . uri
endfunction

function! pfvim#read(uri)
  let uri = s:abs_uri(a:uri)
  enew
  let ul_save = &l:undolevels
  try
    setl undolevels=-1
    exec '1read !pfexec cat 2>/dev/null "' . uri[3:] . '"'
    exec 'silent' 'file' uri
    1d
  finally
    let &l:undolevels = ul_save
  endtry
  setl nomod
  filetype detect
endfunction

function! pfvim#write(uri) abort
  setl nomod
  exec 'silent' '%write !pfexec tee >/dev/null "' . s:abs_uri(a:uri)[3:] . '"'
endf
