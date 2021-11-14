filetype plugin indent on
" show existing tab with 4 spaces width
"set tabstop=2
"set shiftwidth=2
set mouse=a
colorscheme desert

set spellfile=~/.config/nvim/spell/en.utf-8.add

" On pressing tab, insert 4 spaces
set expandtab

call plug#begin()

" Vimtex
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'zathura'

" set conceallevel=1
" let g:tex_conceal='abdmg'

Plug 'tomlion/vim-solidity'

" Ultisnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/mysnips']

" Nerdtree
Plug 'preservim/nerdtree'

" Matlab
Plug 'MortenStabenau/matlab-vim'
let g:matlab_executable = '/home/hugh/MATLAB/R2020b/bin/matlab'
let g:matlab_panel_size = 50

Plug 'tmux-plugins/vim-tmux'

"Doxygen
Plug 'vim-scripts/DoxygenToolkit.vim'
let g:DoxygenToolkit_briefTag_pre="\\brief:       "
let g:DoxygenToolkit_paramTag_pre="\\param:       "
let g:DoxygenToolkit_returnTag="\\returns      "
let g:DoxygenToolkit_fileTag="\\file:        "
let g:DoxygenToolkit_authorTag="\\author:      "
let g:DoxygenToolkit_versionTag="\\version:     "
let g:DoxygenToolkit_dateTag="\\date:        "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="Hugh Delaney"

Plug 'frasercrmck/formative.vim'
let g:fmtv_clang_format_py = '~/llvm/clang/tools/clang-format/clang-format.py'

set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

call plug#end()
