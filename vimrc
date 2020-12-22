" This is just the loader. Main configuration is in vimrc.vim

"-------------------------------------------------------------------------------
" Globals
"-------------------------------------------------------------------------------

" dirname of script like node.js
let s:__dirname=expand("<sfile>:p:h")

" Absolute path from script
function! Vim0AbsPath(path)
    return s:__dirname . '/' . a:path
endfunction

" Dynamically sources a path relative to project
function! Vim0Source(path)
    exec 'source ' . Vim0AbsPath(a:path)
endfunction

let s:pluginsDir = '_plugins'
let vim0BackupDir=Vim0AbsPath('_backups')
let vim0PluginsDir=Vim0AbsPath(s:pluginsDir)

"-------------------------------------------------------------------------------
" Initialize
"-------------------------------------------------------------------------------

" vim-plug manager
call Vim0Source(s:pluginsDir . '/plug.vim')

" all plugins
call Vim0Source('Plugfile')

" customize plugins and vim
call Vim0Source('vimrc.vim')
