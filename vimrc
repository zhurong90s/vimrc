""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示
"winpos 5 5          " 设定窗口位置
"set lines=40 columns=155    " 设定窗口大小

"设置主题
colorscheme ron
"set background=dark "背景使用黑色

set guifont=Courier_New:h10:cANSI   " 设置字体
if (has("gui_running"))
   set guifont=Bitstream\ Vera\ Sans\ Mono\ 10 "字体
   set go=             " 不要图形按钮
   set novisualbell    " 不要闪烁
endif
" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
"编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn

set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
set noeb                    " 去掉输入错误的提示声音
set confirm                 " 在处理未保存或只读文件的时候，弹出确认
set nocompatible            "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限

autocmd InsertLeave * se nocul  " 用浅色高亮当前行
autocmd InsertEnter * se cul    " 用浅色高亮当前行
set showcmd         " 输入的命令显示出来，看的清楚些
"set whichwrap+=<,>,h,l   " 允许backspace和光标键跨越行边界(不建议)
"set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%Y\ -\ %l:%M\ %p\")}   "状态行显示的内容
set laststatus=1    " 启动显示状态行(1),总是显示状态行(2)

" 显示行号
set number
" 历史记录数
set history=10000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新文件标题
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()"

"定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: ")
        call append(line(".")+2, "\# Mail: ")
        call append(line(".")+3, "\# Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/bin/bash")
        call append(line(".")+6, "")
        "新建文件后，自动定位到文件末尾
        autocmd BufNewFile * normal G
    else
        call setline(1, "/*************************************************************************")
        call append(line("."), "    > File Name: ".expand("%"))
        call append(line(".")+1, "    > Author: ")
        call append(line(".")+2, "    > Mail: ")
        call append(line(".")+3, "    > Created Time: ".strftime("%c"))
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")

        if &filetype == 'cpp'
            call append(line(".")+6, "#include <iostream>")
            call append(line(".")+7, "using namespace std;")
            call append(line(".")+8, "")
            call append(line(".")+9, "int main(int argc, char *argv[]) {")
            call append(line(".")+10, "")
            call append(line(".")+11, "    cout<< \"HelloWorld\" << endl;")
            call append(line(".")+12, "    return 0;")
            call append(line(".")+13, "}")
            call cursor(12,0)
        endif

        if &filetype == 'c'
            call append(line(".")+6, "#include <stdio.h>")
            call append(line(".")+7, "")
            call append(line(".")+8, "int main(int argc, char *argv[])")
            call append(line(".")+9, "{")
            call append(line(".")+10, "    return 0;")
            call append(line(".")+11, "}")
            call cursor(11,0)
        endif
    endif
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"function! Mydict()
"  let expl=system('sdcv -n ' .
"        \  expand("<cword>"))
"  windo if
"        \ expand("%")=="diCt-tmp" |
"        \ q!|endif
"  25vsp diCt-tmp
"  setlocal buftype=nofile bufhidden=hide noswapfile
"  1s/^/\=expl/
"  1
"endfunction
"nmap F :call Mydict()<CR>

function! LoadHeadPath()
    set path=.,
    let s:lines = system("find `pwd` -type d -name 'include'|sort |uniq|sed 's%include$%include,%'")
    let s:lines = split(s:lines, '\n')
    for s:line in s:lines
      let &path = &path . s:line
      let &path = &path . ','
    endfor
    let s:lines = system("find `pwd` -type f -name '*.h'|sed 's!/[^/]*\.h$!,!'|sort|uniq")
    let s:lines = split(s:lines, '\n')
    for s:line in s:lines
      let &path = &path . s:line
      let &path = &path . ','
    endfor
endfunction
nnoremap L :call LoadHeadPath() <CR>

function! NegateRelativeNumber()
    if &relativenumber < 1
        set relativenumber
    else
        set norelativenumber
    endif
endfunction
nnoremap <C-n> :call NegateRelativeNumber() <CR>

"比较文件
"nnoremap <F2> :vert diffsplit <CR>

"新建标签
"map <F3> :tabnew .<CR>
"切换标签
"map <F4> :tabNext <CR>

func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -g3 -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -g3 -o %<"
        exec "! ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc
"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>

func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc
"C,C++的调试
map <F8> :call Rungdb()<CR>

function! NegateExpandtab()
    if &expandtab < 1
        set expandtab
    else
        set noexpandtab
    endif
endfunction
"tab替换空格
map <F12> :call NegateExpandtab() <CR>

"映射全选+复制 ctrl+a
"map <C-A> ggVGY
"map! <C-A> <Esc>ggVGY
"map <F12> gg=G
" 选中状态下 Ctrl+c 复制
"vmap <C-c> y

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置当文件被改动时自动载入
set autoread
"自动保存
set autowrite

" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>

"共享剪贴板
set clipboard+=unnamed

"make 运行
:set makeprg=g++\ -Wall\ \ %
"set ruler                   " 打开状态栏标尺
set cursorline              " 突出显示当前行
"hi CursorLine cterm=NONE ctermbg=darkyellow ctermfg=white
"hi CursorLine term=bold cterm=none ctermbg=none ctermfg=yellow gui=bold
" 语法高亮
set syntax=on

" 设置在状态行显示的信息
set foldcolumn=0
set foldmethod=syntax    " 语法折叠
"set foldmethod=manual   " 手动折叠 zf
set foldlevel=5
set foldenable          " 开始折叠

" 自动缩进
"set autoindent
"set cindent
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
"set noexpandtab
" 用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
"set smarttab

"禁止生成临时文件
set nobackup
set noswapfile

"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch

"行内替换
set gdefault

" 总是显示状态行
set laststatus=2
" 命令行（在状态行下）的高度，默认为1
set cmdheight=1
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
"set mouse=a
"set selection=exclusive
"set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=10
" 为C程序提供自动缩进
"set smartindent
" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile *  setfiletype txt

"自动补全
":inoremap ( ()<ESC>i
":inoremap ) <c-r>=ClosePair(')')<CR>
":inoremap { {<CR>}<ESC>O
":inoremap } <c-r>=ClosePair('}')<CR>
":inoremap [ []<ESC>i
":inoremap ] <c-r>=ClosePair(']')<CR>
":inoremap " ""<ESC>i
":inoremap ' ''<ESC>i
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags的设定  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序  
let Tlist_Use_Right_Window = 0  " 在左侧显示窗口  
let Tlist_Compart_Format = 1    " 压缩方式  
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer  
let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags  
let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树  
"autocmd FileType java set tags+=D:\tools\java\tags  
"autocmd FileType h,cpp,cc,c set tags+=D:\tools\cpp\tags  
let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Ctags_Cmd = '/usr/bin/ctags' 
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim 
"设置tags  
"set tags=tags;
set tags=tags 
"set autochdir 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"其他东东
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"打开Taglist 
"let Tlist_Auto_Open = 1 

" minibufexpl插件的一般设置
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
map <C-t> :bnext<CR>
map <C-p> :bprev<CR>

"显示空格 tab
set list
set listchars=tab:>+,trail:-

"cscope seting
"cs add cscope.out
if has("cscope")
	set csprg=/usr/bin/cscope
"	cscope.out 搜索优先级
	set csto=1
"	ctl ] 快捷键
"	set cst
"	冗余信息
	set csverb
"	目录长度
"	set cspc=3
	nmap css :cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap csg :cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap csc :cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap cst :cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap cse :cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap csf :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap csi :cs find i <C-R>=expand("<cfile>")<CR><CR>
	nmap csd :cs find d <C-R>=expand("<cword>")<CR><CR> 
	hi ModeMsg ctermfg=LightBlue
	"add any database in current dir
	if filereadable("cscope.out")
		silent cs add cscope.out
	"else search cscope.out elsewhere
	else
		let cscope_file=findfile("cscope.out", ".;")
		let cscope_pre=matchstr(cscope_file, ".*/")
		if !empty(cscope_file) && filereadable(cscope_file)
"			silent exe "cs add" cscope_file cscope_pre
		endif
	endif
endif

function! CreateCtagsCscope()
let s:lines = system("/usr/bin/ctags -R")
"let s:lines = system("/usr/bin/ctags -R `pwd`")
let s:lines = system("cscope -Rbq")
cs add cscope.out
endfunction

function! KCreateCtagsCscope()
let s:lines = system("/usr/bin/ctags -R")
let s:lines = system("cscope -Rbqk")
cs add cscope.out
endfunction

set updatetime=600
"set splitbelow
