function! s:get_fpath(url)
  let path = (a:url == "<afile>") ? expand(a:url) : a:url
  if matchstr(path, '^pf\ze:') == 'pf'
    let path = strpart(path, 3)
  endif
  return path
endfunction

function! pfvim#read(url)
  :0,$d
  call setline(1, '...')		
  exec '1read !pfexec cat 2>/dev/null "' . s:get_fpath(a:url) . '"'
  let ul_save = &undolevels
  try
    setl undolevels=-1
    :1d
  finally
    let &l:undolevels = ul_save
  endtry
  setl nomod
  :filetype detect
endfunction

function! pfvim#write(url) abort
  setl nomod
  exec '%write !pfexec tee >/dev/null "' . s:get_fpath(a:url) . '"'
endf
