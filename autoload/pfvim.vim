function! s:abs_uri(uri)
  let uri = a:uri == "<afile>" ? expand(a:uri) : a:uri
  return uri[0:2] ==# 'pf:' ? uri : 'pf:' . uri
endfunction

function! s:read(uri)
  exec 'silent' '1read !pfexec cat 2>/dev/null' a:uri[3:]
endfunction

function! s:write(uri)
  let temp = tempname()
  let uri = a:uri[3:]
  try
    call writefile([], temp)
    exec 'silent' '!pfexec chmod --reference=' . uri temp
    exec 'silent' '!pfexec chown --reference=' . uri temp
    exec 'silent' '%write !pfexec tee >/dev/null' temp
    exec 'silent' '!pfexec mv' temp uri
  finally
    exec 'silent' '!pfexec rm -f' temp
  endtry
endfunction

function! pfvim#edit(uri)
  let uri = s:abs_uri(a:uri)
  let ul_save = &undolevels
  try
    setl undolevels=-1
    call s:autocmd(0)
    exec 'silent' 'edit' uri
    call s:read(uri)
    1d
  finally
    let &l:undolevels = ul_save
    call s:autocmd(1)
  endtry
  setl nomod
  filetype detect
endfunction

function! pfvim#read(uri)
  call s:read(s:abs_uri(a:uri))
endfunction

function! pfvim#write(uri) abort
  setl nomod
  call s:write(s:abs_uri(a:uri))
endf

function! s:autocmd(x)
  augroup pfvim
    autocmd!
    if a:x
      au BufReadCmd               pf:*,pf:*/* PfEdit <afile>
      au FileReadCmd              pf:*,pf:*/* PfRead <afile>
      au BufWriteCmd,FileWriteCmd pf:*,pf:*/* PfWrite <afile>
    endif
  augroup END
endfunction

function! pfvim#autocmd()
  call s:autocmd(1)
endfunction
