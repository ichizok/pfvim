"   pfvim
"   
"   This script eases use of vim with pfexec by adding the ability to
"   edit one file with root privleges without running the whole 
"   session that way.
"
"   Usage:  put it in the plugin directory, and
"         (command line) vim pf:/etc/passwd
"           (within vim) :e pf:/etc/passwd
"
"   Requires:
"       RBAC setting (maybe need to edit /etc/user_attr)
"       SunOS distributions (Solaris, OpenIndiana, ...)
"
"   Provides:
"       URL handler, pf: scheme
"       2 autocommands
"       
"   Commands:
"       PfRead <file>
"       PfWrite <file>
"

if exists('g:loaded_pfvim')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 -complete=file PfEdit  call pfvim#edit(<f-args>)
command! -nargs=1 -complete=file PfRead  call pfvim#read(<f-args>)
command! -nargs=1 -complete=file PfWrite call pfvim#write(<f-args>)

call pfvim#autocmd()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_pfvim = 1
