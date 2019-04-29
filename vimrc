"-------------------------------------------------------------------------------
" Globals
"-------------------------------------------------------------------------------
let s:__dirname=expand("<sfile>:p:h")

function! Vim0AbsPath(path)
    return s:__dirname . '/' . a:path
endfunction

" Dynamically sources a path relative to project
function! Vim0Source(path)
    exec 'source ' . Vim0AbsPath(a:path)
endfunction

let vim0BackupDir=Vim0AbsPath('_backups')
let vim0PluginsDir=Vim0AbsPath('_plugins')

"-------------------------------------------------------------------------------
" Load everything
"-------------------------------------------------------------------------------

" vim-plug manager
call Vim0Source('_plugins/plug.vim')

" all plugins
call Vim0Source('Plugfile')

" customize plugins and vim
call Vim0Source('init.vim')

