set number
set splitright
set list
set nowrap

filetype plugin indent on
set matchpairs+=<:>
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
Plug 'benknoble/vim-synstax'
Plug 'brgmnn/vim-opencl'
Plug 'bagrat/vim-buffet'
Plug 'rhysd/vim-llvm'

call plug#end()

let g:fmtv_clang_format_py = '/home/hugh/llvm/clang/tools/clang-format/clang-format.py'
let g:fmtv_no_mappings = 1

nnoremap <leader>kk <Plug>FormativeNor
nnoremap <leader>kk <Plug>FormativeLine
nnoremap <leader>ka <Plug>FormativeFile
vnoremap <leader>k <Plug>FormativeVis

" Custom mappings
let mapleader = " "
vnoremap <silent><leader>vv y/\V<C-R>=escape(@",'/\')<CR><CR>
nnoremap <silent><leader>_ ddkP
nnoremap <silent><leader>- ddp
inoremap <silent><leader><C-u> <esc> bveU <esc> ea
nnoremap <silent><leader><C-u> bveU <esc> e
nnoremap <silent><leader>s :call gitblame#echo()<CR>
inoremap <silent><leader><C-l> <C-g>u<esc>[s1z=`]a<C-g>u
nnoremap <silent><leader>ev :vs $MYVIMRC<CR>
nnoremap <silent><leader>sv :source $MYVIMRC<CR>
nnoremap <silent><leader>cc :call ShowIR("ptx")<CR>
nnoremap <silent><leader>sc :call ShowIR("spir")<CR>
nnoremap <silent><leader>bc :call ShowIR("nvbc")<CR>
nnoremap <Leader>. :echo synstax#UnderCursor()<CR>

nnoremap <silent><leader>gg <Plug>(coc-implementation)
nnoremap <silent><leader>gt <Plug>(coc-type-definition)
nnoremap <silent><leader>gc <Plug>(coc-definition)
nnoremap <silent><leader>gr <Plug>(coc-references)
nnoremap <silent><leader>fi <Plug>(coc-fix-current)
nnoremap <silent><leader>tt :NERDTree<CR>
nnoremap <silent><leader>tr :terminal<CR>
nnoremap <silent><leader>qq :q<CR>
nnoremap <silent><leader>wq :wq<CR>
nnoremap <silent><leader><leader> <C-w>
inoremap <silent><leader>bb <C-K>0M
inoremap <silent><leader>yyy <C-K>OK
inoremap <silent><leader>xxx <C-K>XX
"noremap  <up> <nop> 
"noremap  <down> <nop>
"noremap  <left> <nop>
"noremap  <right> <nop>
nmap <leader>1 <Plug>BuffetSwitch(1)
nmap <leader>2 <Plug>BuffetSwitch(2)
nmap <leader>3 <Plug>BuffetSwitch(3)
nmap <leader>4 <Plug>BuffetSwitch(4)
nmap <leader>5 <Plug>BuffetSwitch(5)
nmap <leader>6 <Plug>BuffetSwitch(6)
nmap <leader>7 <Plug>BuffetSwitch(7)
nmap <leader>8 <Plug>BuffetSwitch(8)
nmap <leader>9 <Plug>BuffetSwitch(9)
nmap <leader>0 <Plug>BuffetSwitch(10)
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
inoremap <C-L> <C-K>
noremap <leader>v :vs<CR>
noremap <leader>dd :bd<CR>
nnoremap <silent><leader>sw :set wrap<CR>
nnoremap <silent><leader>nw :set nowrap<CR>
nnoremap <silent><leader>sp :sp<CR>
tnoremap <silent><esc> <C-\><C-n>

function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction

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

echom "(>^.^<)"

