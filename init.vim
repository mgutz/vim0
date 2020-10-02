" init.vim - vim initialization script

" set leader
"let mapleader=" "

" start guard {{
if exists("g:vim_mgutz_loaded")
    finish
endif

let g:vim_mgutz_loaded = 1

if has('nvim')
    runtime! plugin/python_setup.vim
endif
" }}


" General Settings {{
set nocompatible
syntax on
syntax sync minlines=256

set regexpengine=1
set lazyredraw
set ttyfast
set foldmethod=manual
set updatetime=300
set relativenumber

" Automatically re-read file if a change was detected outside of vim
set autoread

" Backups
let &backupdir=g:vim0BackupDir
set backup
set noswapfile
set modelines=3
set encoding=utf8
set termencoding=utf-8
set fileencodings=          " Don't do any encoding conversion"

set history=100
set number ruler
set linebreak nowrap
set laststatus=2
set autoindent backspace=indent,eol,start
"set hlsearch ignorecase incsearch
set hlsearch incsearch

if (executable('pbcopy') || executable('xclip') || executable('xsel')) && has('clipboard')
    set clipboard=unnamed
endif

set history=2048   " Number of things to remember in history.
set autowrite      " Writes on make/shell commands
set timeoutlen=250 " Time to wait after ESC (default causes an annoying delay)
set ttimeoutlen=0  " Time to wait after ESC (default causes an annoying delay)
set tags=./tags;
"set cinoptions=:0,p0,t0
"set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr

set showmatch               " Show matching brackets.
"set list listchars=tab:??,trail:?
set list listchars=tab:»·,trail:·

set mouse-=a                " Disable visual mouse
set hidden                  " allow buffer changes without being written

set fo-=r                   " do not insert a comment leader after an enter, (no work, fix!!)
"set textwidth=78
set textwidth=0

" seems to help performance by not using cursorline
set nocursorcolumn
set nocursorline
"set synmaxcol=192
set synmaxcol=300

" No annoying audible or visible bell in terminal or GUI
set noeb vb t_vb=
if has('autocmd')
    autocmd GUIEnter * set vb t_vb=
endif

if executable("rg")
    set grepprg=rg\ --vimgrep
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
endif

" no right margin line
set colorcolumn=

" if has('win32') || has ('win64')
"   exec "source ".scriptRoot.'/windows.vim'
" endif

" }} General Settings


" Autocmd {{

if has("autocmd")
    augroup elixir
        autocmd!
        autocmd BufNewFile,BufRead *.ex,*.exs set filetype=elixir
        autocmd BufNewFile,BufRead *.eex set filetype=eelixir
    augroup END


    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        autocmd BufNewFile,BufRead *.plist set filetype=xml
        autocmd BufNewFile,BufRead Bakefile,*.zsh-theme set filetype=sh
        autocmd BufNewFile,BufRead *.sql set filetype=pgsql

        hi link NodeReserved Constant
        hi link BrowserReserved Constant

        " autocmd VimEnter waits until all initialization is finished (plugins are
        " loaded)
        autocmd VimEnter * NERDTree
        "autocmd TabEnter * NERDTreeMirrorOpen
        " " wincmd p puts the cursor in the main window (rather than the NERDTree
        " window)
        autocmd VimEnter * wincmd p

        " quit NERDtree if it is the last buffer
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    augroup END
endif
" }}


" Commands{{

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif
" }}


" Key Mappings {{

" Map jk to ESC
inoremap jk <Esc>`^

" save file
map <M-s> :w<kEnter>
imap <M-s> <Esc>:w<kEnter>i


" alt+n or alt+p to navigate between entries in QuickFix
"map <silent> <m-p> :cp <cr>
"map <silent> <m-n> :cn <cr>

" think as cmd+w or ctrl+w
map <silent> <leader>w :Bwipeout <cr>
nmap <silent> <leader>t :TagbarToggle<CR>

" zoom
"map <silent> <leader><leader> :ZoomWin <cr>

" Ctrl+P to search for files
nnoremap <silent> <C-p> :Files <CR>

let g:goyo_width = 100
let g:goyo_margin_top = 1
let g:goyo_margin_bottom = 1
map <silent> <leader><leader> :Goyo<cr>

"buffer fuzzy search
"nmap <silent> <leader>b :FufBuffer<cr>
"nmap <silent> <leader>b :CtrlPBuffer<cr>
"nmap <silent> <leader>d <plug>Kwbd
"nmap <silent> <leader>h :OverCommandLine<cr>

"disable autoindent for current file
nnoremap <f8> :setl noai nocin nosi inde=<cr>

" remove trailing spaces and tabs
" nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

"view the highlight grouping under the cursor
map <leader>c :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" inserts new line above without going into insert mode
"map <S-Enter> O<ESC>
" inserts new line below without going into insert mode
"map <Enter> o<ESC>
" }}


" Platform specific {{
if has("macunix")
    if executable('rg')
        let g:ackprg = 'rg --vimgrep'
    elseif executable('ag')
        let g:ackprg = 'ag --nogroup --nocolor --column --ignore "*--*"'
    endif
elseif has("unix")
    if executable('rg')
        let g:ackprg = 'rg --vimgrep'
    elseif executable('ag')
        let g:ackprg = 'ag --nogroup --nocolor --column --ignore "*--*"'
    endif
    source $VIMRUNTIME/mswin.vim
    behave mswin
elseif has('win32') || has ('win64')
    source $VIMRUNTIME/mswin.vim
    behave mswin
end
" }}


" coc {{

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Complete options (disable preview scratch window, longest removed to aways show menu)
set completeopt=longest,menuone

" Close preview when completion is done
autocmd! InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Make tab used for trigger completion, completion confirm, snippet expand and
" and jump like VSCode
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:coc_snippet_next = '<tab>'

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-d> <Plug>(coc-cursors-word)
xmap <silent> <C-d> <Plug>(coc-cursors-range)
" nmap <silent> <C-d> <Plug>(coc-cursors-word)*
" xmap <silent> <C-d> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)

" }} end coc


" Global variables {{
let g:is_bash = 1

""" html
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head"

""" JSX
let g:jsx_ext_required = 0
" }}


" FZF {{
"nnoremap <c-p> :FZF<cr>
function KillRunningFzf()
    for i in filter(range(1, bufnr('$')), 'bufname(v:val) =~# ";#FZF"')
        " Delete buffer by ID
        execute "bw!" . i
    endfor
endfunction

command! -nargs=* ToggleFiles call KillRunningFzf() | Files
command! -nargs=* ToggleBuffers call KillRunningFzf() | Buffers

" Fuzzy finder using fzf
nnoremap <leader>f :ToggleFiles <cr>

" Buffers using fzf
nnoremap <leader>b :ToggleBuffers <cr>
" }} end FZF


" mgutz/vim-colors {{
let g:mgutz_tabline=1

""" Converts function, null to symbols, ick
let g:javascript_conceal = 0

" }} end mgutz/vim-colors


" easy align {{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" Align GitHub-flavored Markdown tables by selecting then pressing \\
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
" }}


" ale {{
let g:ale_go_langserver_executable = 'gopls'

" ALE's fixer don't provide enough flexibility, use AutoFormat
"
 let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': [],
\   'javascript': [],
\   'javascript_jsx': [],
\   'less': [],
\   'markdown': [],
\   'sh': ['shfmt'],
\   'typescript': [],
\}

let g:ale_linters = {
\   'c': [], 'cpp': [], 'rust': [], 'go': [], 'python': [], 'sh': [],
\   'html': [], 'css': [], 'javascript': [], 'typescript': [], 'reason': [],
\   'json': [], 'vue': [],
\   'tex': [], 'latex': [], 'bib': [], 'bibtex': []
\ }



let g:ale_linters_explicit = 0
let g:ale_fix_on_save = 0
"let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_delay = 250

""let g:ale_javascript_prettier_use_local_config = 1
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'

" specific to t256
highlight link ALEWarningSign Function
highlight link ALEErrorSign Title

" }}


" NERDCommenter {{
let g:NERDAlignCommentToggle=1
let NERDCommentWholeLinesInVMode=1
let NERDRemoveAltComs=0
let NERDSpaceDelims=1
" }}


" NERDTree {{

" Hide NERDTree folder trailing slashes
augroup nerdtreehidetirslashes
    autocmd!
    autocmd FileType nerdtree syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained
augroup end

autocmd FileType nerdtree let t:nerdtree_winnr = bufwinnr('%')
autocmd BufWinEnter * call PreventBuffersInNERDTree()

" Prevents buffers in nerd tree, but has side effect of closing nerdtree if
" the current buffer is nerdtree
function! PreventBuffersInNERDTree()
  if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree'
    \ && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr
    \ && &buftype == ''
    let bufnum = bufnr('%')
    close
    exe 'b ' . bufnum
  endif
endfunction

" augroup nerdtreehidecwd
"   autocmd!
"   autocmd FileType nerdtree setlocal conceallevel=3
"               \ | syntax match NERDTreeHideCWD #^[</].*$# conceal
"               \ | setlocal concealcursor=n
" augroup end

let NERDTreeIgnore=['^NTUSER', '^ntuser', '\~$', 'desktop.ini', '\.lnk$', '\.exe$', '\.search-ms$', '\.dll$', '.DS_Store', '\.pyc$']
let NERDTreeMinimalUI=1
let NERDTreeQuitOnOpen=0
let NERDTreeWinPos='right'       " left | right
let NERDTreeWinSize=32
let NERDTreeAutoDeleteBuffer=1
" let NERDTreeDirArrowExpandable=" "
" let NERDTreeDirArrowCollapsible=" "
" show abbreviated ~/path...
" let NERDTreeStatusline='%{exists("b:NERDTree") ? "⊟ " . fnamemodify(b:NERDTree.root.path.str(), ":~") : ""}'
"let NERDTreeStatusline='⊟'
let NERDTreeStatusline=' '

" Show hidden files/directories
" let g:NERDTreeShowHidden = 1

" quit if NERDTree is last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"open directory view
nmap <silent> <leader>n :NERDTreeToggle <cr>

"like lcd
map <silent> <leader>l :NERDTreeFind<cr>

" }} /NERDTree


" Tagbar {{
let g:tagbar_type_go = {
            \ 'ctagstype': 'go',
            \ 'kinds' : [
            \'p:package',
            \'f:function',
            \'v:variables',
            \'t:type',
            \'c:const'
            \]
            \}

let g:tagbar_type_coffee = {
            \ 'ctagstype' : 'coffee',
            \ 'kinds'     : [
            \ 'c:classes',
            \ 'm:methods',
            \ 'f:functions',
            \ 'v:variables',
            \ 'f:fields',
            \ ]
            \ }

" Posix regular expressions for matching interesting items. Since this will
" be passed as an environment variable, no whitespace can exist in the options
" so [:space:] is used instead of normal whitespaces.
" Adapted from: https://gist.github.com/2901844
let s:ctags_opts = '
            \ --langdef=coffee
            \ --langmap=coffee:.coffee
            \ --regex-coffee=/(^|=[[:space:]])*class[[:space:]]([A-Za-z]+\.)*([A-Za-z]+)([[:space:]]extends[[:space:]][A-Za-z.]+)?$/\3/c,class/
            \ --regex-coffee=/^[[:space:]]*(module\.)?(exports\.)?@?([A-Za-z.]+):.*[-=]>.*$/\3/m,method/
            \ --regex-coffee=/^[[:space:]]*(module\.)?(exports\.)?([A-Za-z.]+)[[:space:]]+=.*[-=]>.*$/\3/f,function/
            \ --regex-coffee=/^[[:space:]]*([A-Za-z.]+)[[:space:]]+=[^->\n]*$/\1/v,variable/
            \ --regex-coffee=/^[[:space:]]*@([A-Za-z.]+)[[:space:]]+=[^->\n]*$/\1/f,field/
            \ --regex-coffee=/^[[:space:]]*@([A-Za-z.]+):[^->\n]*$/\1/f,staticField/
            \ --regex-coffee=/^[[:space:]]*([A-Za-z.]+):[^->\n]*$/\1/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@([A-Za-z.]+)/\2/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){0}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){1}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){2}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){3}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){4}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){5}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){6}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){7}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){8}/\3/f,field/
            \ --regex-coffee=/(constructor:[[:space:]]\()@[A-Za-z.]+(,[[:space:]]@([A-Za-z.]+)){9}/\3/f,field/'

let $CTAGS = substitute(s:ctags_opts, '\v\([nst]\)', '\\', 'g')

let g:tagbar_type_javascript = {
            \ 'ctagsbin' : 'jsctags'
            \ }

" }} /Tagbar


" vim-go {{
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_def_mapping_enabled = 0
let g:gocode_gofmt_tabwidth=""
" }}


" ZenCoding {{
let g:use_zen_expandabbr_key='<c-e>'
let g:use_zen_complete_tag=1
" }}


" Language server support {{

" Signs and highlighting for errors, etc.
" let s:error_sign = '✘'
" let s:error_hl = 'ErrorMsg'
" let s:warning_sign = '♦'
" let s:warning_hl = 'WarningMsg'
" let s:message_sign = '→'
" let s:message_hl = 'Normal'
" let s:info_sign = '…'
" let s:info_hl = 'Normal'

" let g:LanguageClient_autoStart = 1

" let g:LanguageClient_diagnosticsDisplay = {
"           \  1: {
"           \    'name': 'Error',
"           \    'texthl': s:error_hl,
"           \    'signText': s:error_sign,
"           \    'signTexthl': s:error_hl,
"           \  },
"           \  2: {
"           \    'name': 'Warning',
"           \    'texthl': s:warning_hl,
"           \    'signText': s:warning_sign,
"           \    'signTexthl': s:warning_hl,
"           \  },
"           \  3: {
"           \    'name': 'Information',
"           \    'texthl': s:info_hl,
"           \    'signText': s:info_sign,
"           \    'signTexthl': s:info_hl,
"           \  },
"           \  4: {
"           \    'name': 'Hint',
"           \    'texthl': s:message_hl,
"           \    'signText': s:message_sign,
"           \    'signTexthl': s:message_hl,
"           \  },
"           \ }

" let g:LanguageClient_serverCommands = {
"           \ 'go': ['go-langserver', '-gocodecompletion'],
"           \ 'typescript': ['typescript-language-server', '--stdio'],
"           \ 'javascript': ['javascript-typescript-stdio'],
"           \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"           \ }

" function LC_maps()
"   if has_key(g:LanguageClient_serverCommands, &filetype)
"       nnoremap <F5> :call LanguageClient_contextMenu()<CR>
"       nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
"       nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
"       nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
"   endif
" endfunction

" autocmd FileType * call LC_maps()

" }} /LSP


" Colorscheme {{
if &t_Co >= 256
    try
        colorscheme t256
    catch
    endtry
endif

" error color on status line
hi User1 ctermfg=white ctermbg=red

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif


" }}


" end {{
" This should come at the end
filetype plugin indent on
" }}

 " vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker :
