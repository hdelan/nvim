set number
set splitright

filetype plugin indent on

set ts=2 sts=2 sw=2 et ai si

set colorcolumn=80

if has('python')
  noremap <C-I> :pyf /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
  inoremap <C-I> <c-o>:pyf /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
elseif has('python3')
  noremap <C-I> :py3f /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
  inoremap <C-I> <c-o>:py3f /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
endif

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'frasercrmck/formative.vim'
Plug 'zivyangll/git-blame.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

let g:fmtv_clang_format_py = '/home/hugh/llvm/clang/tools/clang-format/clang-format.py'

" Custom mappings
let mapleader = " "
vnoremap <silent>// y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent><leader>_ ddkP
nnoremap <silent><leader>- ddp
inoremap <silent><leader><C-u> <esc> bveU <esc> ea
nnoremap <silent><leader><C-u> bveU <esc> e
nnoremap <silent><leader>s :call gitblame#echo()<CR>
inoremap <silent><leader><C-l> <C-g>u<esc>[s1z=`]a<C-g>u
nnoremap <silent><leader>ev :vs $MYVIMRC<CR>
nnoremap <silent><leader>sv :source $MYVIMRC<CR>
nnoremap <silent><leader>cc :call ShowIR("ptx")<CR>

nnoremap <silent><leader>gg <Plug>(coc-implementation)
nnoremap <silent><leader>gt <Plug>(coc-type-definition)
nnoremap <silent><leader>gc <Plug>(coc-definition)
nnoremap <silent><leader>gr <Plug>(coc-references)
nnoremap <silent><leader>fi <Plug>(coc-fix-current)

if &diff
  colorscheme murphy
endif


" TODO add support for bc files, spv files
" TODO add variadic args for cuda gpu version
" TODO automatically compile in background on saving?
" TODO get support for -###
" TODO quickfix list
" TODO make this into a vim-plug plugin
function! ShowIR(IRformat)
  let dpcpp_tmp_ir_folder = "/home/hugh/.tmp_ir"
  if !isdirectory(dpcpp_tmp_ir_folder)
    exec join(["!mkdir", dpcpp_tmp_ir_folder])
  else
    exec join(["!rm -fr ", dpcpp_tmp_ir_folder, "/*"], "")
  endif

  if a:IRformat == "ptx" || a:IRformat == "nvbc"
    let targets = "nvptx64-nvidia-cuda"
  elseif a:IRformat == "spir"
    let targets = "spir64-unknown-unknown"
  endif

  let working_dir = system('pwd')
  let working_file = expand('%:p')

  exec join(["!cd ", dpcpp_tmp_ir_folder, " && clang++ -fsycl --save-temps -fsycl-targets=", targets, " ", working_file], "")

  if a:IRformat == "ptx"
    let ptxfile = system(join(["grep PTX -l ", dpcpp_tmp_ir_folder, "/*"], ""))
    exec join(["vsp", ptxfile])
  elseif a:IRformat == "nvbc"
    let bcfile = system(join(["grep clang * ", dpcpp_tmp_ir_folder, "/* | grep "Binary file.*sycl.*bc"], "")[0]
    echom bcfile
  endif
endfunction

echom "(>^.^<)"
