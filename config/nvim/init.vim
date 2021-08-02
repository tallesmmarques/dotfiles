" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin(expand('~/.config/nvim/plugged'))

Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'alvan/vim-closetag'
Plug 'preservim/nerdtree' |
            \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
Plug 'lifepillar/vim-solarized8'

call plug#end()

" Map the leader key to ,
let mapleader="\<SPACE>"


" General
  set smarttab
  set noautoindent
  set nocindent
  set encoding=utf-8


" Formatting
  set showcmd 
  set showmatch
  set showmode
  set ruler
  set number
  set textwidth=0
  set expandtab
  set tabstop=2
  set shiftwidth=2

  set noerrorbells
  set modeline
  set linespace=0
  set nojoinspaces

  set splitbelow
  set splitright

  if !&scrolloff
    set scrolloff=3       " Show next 3 lines while scrolling.
  endif
  if !&sidescrolloff
    set sidescrolloff=5   " Show next 5 columns while side-scrolling.
  endif
  set display+=lastline
  set nostartofline       " Do not jump to first character with page commands.


" Configuration 
  if has('path_extra')
    setglobal tags-=./tags tags^=./tags;
  endif

  set autochdir           " Switch to current file's parent directory.

  " Remove special characters for filename
  set isfname-=:
  set isfname-==
  set isfname-=+

  " Map ; to :
  nnoremap ; :

  if &history < 1000
    set history=1000      " Number of lines in command history.
  endif
  if &tabpagemax < 50
    set tabpagemax=50     " Maximum tab pages.
  endif

  if &undolevels < 200
    set undolevels=200    " Number of undo levels.
  endif

  " Allow color schemes to do bright colors without forcing bold.
  if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
  endif

  " Enable mouse support 
  set mouse=a

" UI options
  colorscheme gruvbox
  let g:gruvbox_contrast_dark='medium'
  let g:gruvbox_contrast_light='medium'
  set bg=dark

  let g:gruvbox_invert_signs=0

  " Contrast
  function! GruvboxContrastToggle()
    colorscheme gruvbox
    if(g:gruvbox_contrast_dark == "soft" && g:gruvbox_contrast_light == "soft")
      let g:gruvbox_contrast_dark="medium"
      let g:gruvbox_contrast_light="medium"
      call gruvbox#invert_signs_toggle()
    elseif(g:gruvbox_contrast_dark == "medium" && g:gruvbox_contrast_light == "medium")
      let g:gruvbox_contrast_dark="hard"
      let g:gruvbox_contrast_light="hard"
      call gruvbox#invert_signs_toggle()
    else
      let g:gruvbox_contrast_dark="soft"
      let g:gruvbox_contrast_light="soft"
      call gruvbox#invert_signs_toggle()
    endif
  endfunc

  " Contrast Solarized
  function! SolarizedContrastToggle()
    if(g:colors_name == "solarized8")
        colorscheme solarized8_flat
      elseif(g:colors_name == "solarized8_flat")
        colorscheme solarized8_high
      elseif(g:colors_name == "solarized8_high")
        colorscheme solarized8_low
      else
        colorscheme solarized8
    endif
  endfunc

  " Toggle between soft and hard mode
  nnoremap <leader>tg :call GruvboxContrastToggle()<cr>
  nnoremap <leader>ts :call SolarizedContrastToggle()<cr>
  
  " Background color
  function! ThemeToggle()
    if(&background == "dark")
      set background=light
    else
      set background=dark
    endif
  endfunc

  " Toggle between light and dark background
  nnoremap <leader>tb :call ThemeToggle()<cr>

  " Relative numbering
  function! NumberToggle()
    if(&relativenumber == 1)
      set nornu
      set number
    else
      set rnu
    endif
  endfunc

  " Toggle between normal and relative numbering.
  nnoremap <leader>tn :call NumberToggle()<cr>


" Keybindings
  " Save file
  nnoremap <Leader>w :w<CR>
  "Copy and paste from system clipboard
  vmap <Leader>y "+y
  vmap <Leader>d "+d
  nmap <Leader>p "+p
  nmap <Leader>P "+P
  vmap <Leader>p "+p
  vmap <Leader>P "+P

  " Move between buffers
  nmap <Leader>l :bnext<CR>
  nmap <Leader>h :bprevious<CR>

  nnoremap <leader>fo :NERDTreeFocus<CR>
  nnoremap <leader>ft :NERDTree<CR>
  nnoremap <leader>fT :NERDTreeToggle<CR>
  nnoremap <F3>       :NERDTreeToggle<CR>
  nnoremap <leader>f/ :NERDTreeFind<CR>


" Experimental 
  " Search and Replace
  nmap <Leader>s :%s//g<Left><Left>


" Coc.nvim
if filereadable(expand("~/.config/nvim/coc.vim"))
    source ~/.config/nvim/coc.vim
endif


" Plugin Settings {
  " NERDTree
    " Start NERDTree when Vim starts with a directory argument.
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
        \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

    " Start NERDTree when Vim is started without file arguments.
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

    " Exit Vim if NERDTree is the only window left.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
        \ quit | endif

    " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
    autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * silent NERDTreeMirror

    " Git NERDTree
    let g:NERDTreeGitStatusConcealBrackets = 1
    let g:NERDTreeGitStatusUseNerdFonts = 1
    let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

  " Airline {
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif

    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline_powerline_fonts = 1

    if !exists('g:airline_powerline_fonts')
      let g:airline#extensions#tabline#left_sep = ' '
      let g:airline#extensions#tabline#left_alt_sep = '|'
      let g:airline_left_sep          = '▶'
      let g:airline_left_alt_sep      = '»'
      let g:airline_right_sep         = '◀'
      let g:airline_right_alt_sep     = '«'
      let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
      let g:airline#extensions#readonly#symbol   = '⊘'
      let g:airline#extensions#linecolumn#prefix = '¶'
      let g:airline#extensions#paste#symbol      = 'ρ'
      let g:airline_symbols.linenr    = '␊'
      let g:airline_symbols.branch    = '⎇'
      let g:airline_symbols.paste     = 'ρ'
      let g:airline_symbols.paste     = 'Þ'
      let g:airline_symbols.paste     = '∥'
      let g:airline_symbols.whitespace = 'Ξ'
    else
      let g:airline#extensions#tabline#left_sep = ''
      let g:airline#extensions#tabline#left_alt_sep = ''

      " powerline symbols
      let g:airline_left_sep = ''
      let g:airline_left_alt_sep = ''
      let g:airline_right_sep = ''
      let g:airline_right_alt_sep = ''
      let g:airline_symbols.branch = ''
      let g:airline_symbols.readonly = ''
      let g:airline_symbols.linenr = ''
    endif

    set termguicolors     " enable true colors support

    " Theme ( github.com/vim-airline/vim-airline-themes
      let g:airline_theme= 'gruvbox'

  " AutoPairs
    let g:tagalong_additional_filetypes = ['javascript', 'js', 'typescript', 'ts']
    let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.js,*.tsx,*.ts"
