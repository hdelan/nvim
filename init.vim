set number
set mouse=a

filetype plugin indent on

set ts=2 sts=2 sw=2 et ai si

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

if has('python')
     map <C-I> :pyf /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
     imap <C-I> <c-o>:pyf /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
   elseif has('python3')
     map <C-I> :py3f /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
     imap <C-I> <c-o>:py3f /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
   endif


call plug#begin()

Plug 'preservim/nerdtree'
Plug 'tmux-plugins/vim-tmux'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'frasercrmck/formative.vim'
Plug 'zivyangll/git-blame.vim'


call plug#end()

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/mysnips']

let g:fmtv_clang_format_py = '/home/hugh/llvm/clang/tools/clang-format/clang-format.py'

set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

