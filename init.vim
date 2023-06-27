set number
set splitright
set list
set nowrap
filetype plugin indent on
set matchpairs+=<:>
set ts=2 sts=2 sw=2 et ai si
set colorcolumn=80

let mapleader = " "

call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'frasercrmck/formative.vim'
Plug 'zivyangll/git-blame.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'benknoble/vim-synstax'
Plug 'brgmnn/vim-opencl'
Plug 'bagrat/vim-buffet'
Plug 'rhysd/vim-llvm'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Vim Formative
if has('python')
  noremap <C-I> :pyf /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
  inoremap <C-I> <c-o>:pyf /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
elseif has('python3')
  noremap <C-I> :py3f /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
  inoremap <C-I> <c-o>:py3f /home/hugh/llvm/clang/tools/clang-format/clang-format.py<cr>
endif

let g:fmtv_clang_format_py = '/home/hugh/llvm/clang/tools/clang-format/clang-format.py'
let g:fmtv_no_mappings = 1
nnoremap <leader>kk <Plug>FormativeNor
nnoremap <leader>kk <Plug>FormativeLine
nnoremap <leader>ka <Plug>FormativeFile
vnoremap <leader>k <Plug>FormativeVis

" Git blame
nnoremap <silent><leader>s :call gitblame#echo()<CR>
inoremap <silent><leader><C-l> <C-g>u<esc>[s1z=`]a<C-g>u

" Nvim config
nnoremap <silent><leader>ev :vs $MYVIMRC<CR>
nnoremap <silent><leader>sv :source $MYVIMRC<CR>

" My func
nnoremap <silent><leader>cc :call ShowIR("ptx")<CR>
nnoremap <silent><leader>sc :call ShowIR("spir")<CR>
nnoremap <silent><leader>bc :call ShowIR("nvbc")<CR>

" CoC
nnoremap <silent><leader>gg <Plug>(coc-implementation)
nnoremap <silent><leader>gt <Plug>(coc-type-definition)
nnoremap <silent><leader>gc <Plug>(coc-definition)
nnoremap <silent><leader>gr <Plug>(coc-references)
nnoremap <silent><leader>fi <Plug>(coc-fix-current)

" NERDTree
nnoremap <silent><leader>tt :NERDTree<CR>

" Digraphs
inoremap <silent><leader>bb <C-K>0M
inoremap <silent><leader>yyy <C-K>OK
inoremap <silent><leader>xxx <C-K>XX

" Window movements
nnoremap <silent><leader><leader> <C-w>
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
noremap <leader>dd :bd<CR>
nnoremap <silent><leader>sw :set wrap<CR>
nnoremap <silent><leader>nw :set nowrap<CR>
nnoremap <silent><leader>qq :q<CR>
nnoremap <silent><leader>wq :wq<CR>
nnoremap <silent><leader>jj :e ~/.local/journal.md<CR>

" Terminal
nnoremap <silent><leader>tr :terminal<CR>
tnoremap <silent><esc> <C-\><C-n>

" TODO add variadic args for cuda gpu version
" TODO automatically compile in background on saving?
" TODO get support for -###
" TODO quickfix list
" TODO make this into a vim-plug plugin
function! ShowIR(IRformat)
  let dpcpp_tmp_ir_folder = "/home/hugh/.tmp_ir"
  if !isdirectory(dpcpp_tmp_ir_folder)
    exec join(["!mkdir", dpcpp_tmp_ir_folder])
  elseif system(join(["ls ", dpcpp_tmp_ir_folder, " | wc -l"], "")) > 0
    exec join(["!rm -fr ", dpcpp_tmp_ir_folder, "/*"], "")
  endif

  if a:IRformat == "ptx" || a:IRformat == "nvbc"
    let targets = "nvptx64-nvidia-cuda"
  elseif a:IRformat == "spir"
    let targets = "spir64-unknown-unknown"
  endif

  let working_file = expand('%:p')

  exec join(["!cd ", dpcpp_tmp_ir_folder, " && clang++ -fsycl --save-temps -fsycl-targets=", targets, " ", working_file], "")

  if a:IRformat == "ptx"
    let ptxfile = trim(system(join(["grep PTX -l ", dpcpp_tmp_ir_folder, "/*"], "")))
    exec join(["vsp", ptxfile])
  elseif a:IRformat == "nvbc" || a:IRformat == "spirbc"
    let bcfile = split(systemlist(join(["grep \"clang\" ", dpcpp_tmp_ir_folder, "/* | grep \"Binary file.*sycl.*bc\""], ""))[0])[2]
    exec join(["!llvm-dis ", bcfile, " -o ", bcfile, ".ll"], "")
    exec join(["vsp ", bcfile, ".ll"], "")
  elseif a:IRformat == "spir"
    let spirfile = trim(system(join(["head -n 1 ", dpcpp_tmp_ir_folder, "/*sycl-spir64-unknown-unknown-*.txt"], "")))
    echom join(["!spirv-dis ", spirfile, " -o ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
    exec join(["!spirv-dis ", spirfile, " -o ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
    exec join(["vsp ", dpcpp_tmp_ir_folder, "/tmp_spir.spv.ll"], "")
  endif
  if system(join(["ls ", dpcpp_tmp_ir_folder, "/a.out | wc -l"], "")) > 0
    exec join(["!cp ", dpcpp_tmp_ir_folder, "/a.out ."], "")
  endif
endfunction

if 0 == argc()
    autocmd VimEnter * NERDTree
end

echom "(>^.^<)"

