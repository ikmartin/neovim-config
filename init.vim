" ###########################################################
" ## SETTINGS FOR NEOVIM
" ## SEE https://dev.to/elvessousa/my-basic-neovim-setup-253l
" ###########################################################

" Options
set background=dark " apply color set for dark screens
set clipboard=unnamedplus " enable clipboard between vim/neovim and other applications
set completeopt=noinsert,menuone,noselect " autocomplete menu behaves like ide
set cursorline
set hidden " hide unused buffers
set inccommand=split " show replacements in a split screen
set mouse=a " allows use of mouse in editor
set number " display line numbers
"set relativenumber " show line numbers starting from the current one
set splitbelow splitright
set title " shows file title
set ttimeoutlen=0 " time in milliseconds to run commands
set wildmenu " show more advanced menu for auto-completion

" Tabs size
set expandtab
set shiftwidth=4
set tabstop=4

" enable 256 colors on the terminal
set t_Co=256

" True color if available
let term_program=$TERM_PROGRAM

" Check for conflicts with Apple Terminal app
if term_program !=? 'Apple_Terminal'
    set termguicolors
else
    if $TERM !=? 'xterm-256color'
        set termguicolors
    endif
endif

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" continue indent on wrapped lines
set breakindent

" File browser
let g:netrw_banner=0
let g:netrw_liststyle=2
let g:netrw_browse_split=4 " open file in previous window, do not create more divisions
let g:netrw_altv=1 
let g:netrw_winsize=25
let g:netrw_keepdir=0
let g:netrw_localcopydircmd='cp -r'

" Create file without opening buffer
function! CreateInPreview()
  let l:filename = input('please enter filename: ')
  execute 'silent !touch ' . b:netrw_curdir.'/'.l:filename
  redraw!
endfunction

" Netrw: create file using touch instead of opening a buffer
function! Netrw_mappings()
  noremap <buffer>% :call CreateInPreview()<cr>
endfunction

augroup auto_commands
    autocmd filetype netrw call Netrw_mappings()
augroup END

" indent by an additional 2 characters on wrapped lines, when line >= 40 characters, put 'showbreak' at start of line
set breakindentopt=shift:0,min:40,sbr
set showbreak=>>  " append '>>' to indent

" spell check settings
setlocal spell
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=red

" plug-ins
call plug#begin()
	" Appearance
    Plug 'sonph/onehalf', { 'rtp': 'vim' } " color scheme choice 1
    Plug 'arcticicestudio/nord-vim' " color scheme choice 2
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-airline/vim-airline'
        " airline settings
        let g:airline_theme='onehalfdark'
        let g:airline_powerline_fonts = 1
        "let g:airline#extensions#tabline#enabled = 1
	Plug 'keitanakamura/tex-conceal.vim'
		set conceallevel=1
		let g:tex_conceal='abdmg'
		hi conceal ctermbg=none

    " Utilities
    Plug 'sheerun/vim-polyglot'
    Plug 'ap/vim-css-color'
    Plug 'preservim/nerdtree'	
    Plug 'jiangmiao/auto-pairs'
    	let g:AutoPairs={'(':')', '[':']', '{':'}','"':'"', '`':'`'}
	Plug 'SirVer/ultisnips'   
		let g:UltiSnipsExpandTrigger = '<tab>'
		let g:UltiSnipsJumpForwardTrigger = '<tab>'
		let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
		let g:UltiSnipsSnippetDirectories=["UltiSnips","my-snippets"]
	Plug 'lervag/vimtex'
		filetype plugin indent on
		syntax enable
		let g:tex_flavor='latex'
		let g:vimtex_view_method='zathura'
		let g:vimtex_quickfix_mode=0
		let g:latex_view_general_viewer = 'zathura'
		let g:vimtex_view_forward_search_on_start=1
		let g:vimtex_complete_enabled=1

    " Completion / linters / formatters
    Plug 'neoclide/coc.nvim',  {'branch': 'release'}
    Plug 'plasticboy/vim-markdown'

    " Git
    Plug 'airblade/vim-gitgutter'

    " solely used for syntax highlighting in sxhkd configuration files
    Plug 'kovetskiy/sxhkd-vim'

call plug#end()

" allow for file type specific configuration
filetype plugin indent on

" File browser settings, show things like .config and .bash 
let NERDTreeShowHidden=1

" enable file search in your project's folder
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" colorscheme settings
syntax on
colorscheme onehalfdark
" colorscheme nord

" Language server stuff
" run Prettier and format file on save
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" Normal mode remappings
nnoremap <C-q> :q!<CR>
nnoremap <F4> :bd<CR>
nnoremap <F5> :NERDTreeToggle<CR>
nnoremap <F6> :sp<CR>:terminal<CR>

" Tabs
nnoremap <S-Tab> gT
nnoremap <Tab> gt
nnoremap <silent> <S-t> :tabnew<CR>

" #### COC CONFIG #####
"
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Coc autocomplete using Ctrl-Space
inoremap <silent><expr> <c-space> coc#refresh()

" ##########################################################################

" Markdown configuration
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['tsx=typescriptreact']


" keep cushion of lines above and below cursor
set scrolloff=7

" ###### AIRLINE CONFIG #############
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
