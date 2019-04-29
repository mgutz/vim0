"-------------------------------------------------------------------------------
" Globals
"-------------------------------------------------------------------------------
let s:__dirname=expand("<sfile>:p:h")

function! VimOKAbsPath(path)
    return s:__dirname . '/' . a:path
endfunction

" Dynamically sources a path relative to project
function! VimOKSource(path)
    exec 'source ' . VimOKAbsPath(a:path)
endfunction

let vimokPluginsDir=VimOKAbsPath('_bundles')
let vimokBackupDir=VimOKAbsPath('_tmp')

"-------------------------------------------------------------------------------
" Load everything
"-------------------------------------------------------------------------------

" Source vim-plug manager
call VimOKSource('_bundles/plug.vim')

" Source plugins
call VimOKSource('Plugfile')

" Source init script
call VimOKSource('init.vim')

