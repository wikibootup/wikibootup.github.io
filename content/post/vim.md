+++
draft = false
categories = []
tags = ["environment"]
date = "2017-04-15T18:41:58+09:00"
title = "Vim과 Vim이 아닌 것"

+++

> "지도는 아무짝에도 소용없는 거야. 허술한 지도는 허술하니까 소용없고 가장 정교한 지도는 가장 정교해지는 순간 도시가 바뀌어버리니까 소용없는 거야. 그래서 나는 지도 따위는 보지 않아. (...)"[^1]

배경
===

좋은 에디터가 많다. 회사 소유의(proprietary) 제품들은 언어별 문법을 자동으로 지원하고[^2], 수많은 기본 기능을 제공한다. 여기에 연동되는 플러그인까지 있어 장점이 많다. 예를 들어 Sublime text, Jetbrains 사의 제품들, Visual studio 등 이미 유명한 제품들이 이러한 기능들을 제공한다. 이러한 에디터들을 체험해보면 혹자들이 Vim이나 Emacs는 CUI 환경의 유물(?) 정도로 여기는 이유를 짐작해볼 수 있다. 나는 Vim 에디터를 주로 사용하지만 이런 관념을 비판할 생각은 없다. 왜냐하면 이 에디터를 다른 에디터 만큼 유용하게 사용하는 수준이 되기까지 소요되는 시간은 적지 않기 때문이다. 따라서 단지 에디터를 수단으로만 사용하고 있다면, 그 목적(코드 등의 텍스트 편집)에 이것을 사용해야 하는 이유의 타당성을 설득하기 어렵다고 생각한다.

Vim은 다른 에디터라면 기본적으로 되어 있을 설정들을 일일이 알아내서 해야한다. 다른 에디터들처럼 설정창이 있어서 쉽게 토글링할 수 있는 것도 아니라서, 비교적 많은 명령어들과 단축키들을 숙지하고, 필요한 것들은 추가해야 한다. 그래서 Vim을 가끔 사용하는 사람들은 코드의 라인 넘버를 표시하는 `:set nu`와 숨기는 `:set nonu` 마저 긴가민가 하기 때문에 Vim 사용자들을 보면 고개를 절레절레 흔들기도 한다. 한편, Vim은 `Normal, Insert, Visual`이라는 편집 모드를 가지고 있어서 각 경우에 따라 달라지는 설정들을 이해하는 데에 애를 먹기도 한다 (`vmap, imap, nmap`으로 인한 차이). 하지만 이러한 편집 모드가 나에게는 Vim을 사용하는 가장 큰 이유가 되었다[^3].

***

Contents
===

- [배경](#배경)
- [속도](#속도)
- [Colorscheme](#colorscheme)
- [File Navigator](#file-navigator)
- [Search](search)
- [Edit Helpers](#edit-helpers)
- [의존성을 가진 플러그인](#의존성을-가진-플러그인)
- [단축키 설정](#단축키-설정)
- [Neovim](#neovim)
- [첫화면](#첫화면)
- [기타](#기타)
  - [기타 설정](#기타-설정)
  - [필요에 의한 플러그인](#필요에-의한-플러그인)
- [Epilogue](#epilogue)

***

속도
===
내가 Vim을 사용하면서 가장 우선순위로 지키려고 하는 것은 기능이 아니라 속도이다. 아무리 많은 기능이 있어도 속도가 느리면 굳이 Vim을 사용할 필요가 없다고 생각하고 있다. 대체로 Vim의 속도를 느리게 만들었던 것이 크게 2가지였는데, 첫 째가 플러그인이었고 둘 째가 I/O 이벤트 자동 명령어(autocmd)였다.

'플러그인'부터 말하자면, 아무리 유용한 플러그인이라도 작업을 느리게 만드는 기능은 추가하지 않았다. 그래서 [YouCompleteMe](https://valloric.github.io/YouCompleteMe/)와 같은 자동완성도구와 문법을 검사하는 [Syntastic](https://github.com/vim-syntastic/syntastic)은 그 유용한 기능에도 불구하고 사용할 수가 없었다. 뿐만 아니라 있으면 좋지만 없어도 괜찮은 플러그인들은 '속도 우선'과 가급적 단순하게 사용하겠다는 목적을 지키기 위해서 과감히 사용하지 않기로 했다. [Wakatime](https://wakatime.com)이나 [vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides) 등 수많은 플러그인들은 그런 이유로 제외하였다. 뒤에서 이야기하겠지만 자동완성과 문법 검사는 해결하였다.

다음으로 I/O 이벤트 자동 명령어(autocmd)를 말하자면, `autocmd` 자체가 특정 I/O 이벤트 시에 수행하는 명령어를 말하므로 부하를 준다는 것을 알 수 있다. 따라서 굳이 없어도 되는 자동 명령어(autocmd)들은 모두 제거하였다. 또한 `autocmd`는 반드시 `Augroup`으로 감싼 뒤 `au!(=autocmd!)`를 설정하여 초기화하였다. 그 이유는 `autocmd`가 한 번 설정되면 알아서 스마트하게 중복설정을 방지하지는 않아서, 그 명령어가 저장된 파일을 읽어올 때마다 중복으로 설정이 되어 프로세스를 느리게 만들기 때문이다. 그래서 자동 명령어 패턴은 아래와 같이 구현하였다.

```vim
augroup AuGroupName
  au!
  autocmd ...
augroup END
```

이 두가지 외에도 사소한 이슈들이 있었다. 예를 들면, 속도 우선을 위하여 모듈화를 위한 파일 격리도 포기하였다. 기존에는 모듈화를 유지하겠다는 이유로 설정의 성격(플러그인 설정, 단축키 설정 등)에 따라 여러 파일로 분리한 뒤 `runtime!`을 이용하여 파일을 로드하는 방식이었다. 하지만 이것이 약간의 시간 지연을 일으킨다는 것을 알게 되었고, 고민 끝에 파일 한 개에 모든 설정을 넣기로 결정하였다.

또한 Fold 방식 역시 수정해야 했다. 기존에는 Syntax 방식으로 작업을 하고 있었는데, 이것이 프로세스를 느리게 만든다는 것을 알게되어 현재는 Indent 방식으로 바꾸어 사용중이다. Fold의 시간 소모에 관해서는 [FastFold](https://github.com/Konfekt/FastFold)라는 플러그인이 있어서 몇 번 사용해봤지만 아직 유용하게 사용하고 있지는 않다.

Syntax highlighting은 프로세스에 부하를 주는 동작이지만 반드시 필요하므로 적절한 추가 설정이 필요하다. 이에 대해서는 오해의 소지가 있을 수 있는 설명을 하는 대신 아래의 코드를 첨부할테니 `:help`을 통하여 직접 공식문서를 확인해보기 권한다.

```vim
"Speed up Syntax Highlighting
set nocursorcolumn
set nocursorline
"set lazyredraw "It makes no effect(or more slow?!) from personal experience
set ttyfast
set norelativenumber
set synmaxcol=400 "set enough(but not too long) column length.
syn sync minlines=50 maxlines=50
```

마지막으로 Vim의 속도 벤치마킹에 관심이 있다면 [간단한 테스트]("http://stackoverflow.com/a/12216578)를 해보거나 [벤치마크 플러그인](https://github.com/junegunn/vim-startuptime-benchmark)을 시도해보자.

Colorscheme
===
배경화면(Colorscheme)은 매우 중요하다. 배경화면이 단순히 보이는 모습이 아니라 Syntax highlighting도 결정해서 각 언어(c,js,py,go,html,css,...)들과 수많은 플러그인들의 효과와 어울려야 하기 때문이다. 단순히 어울리는 것 이상의 문제가 발생할 수 있는데, 예를 들면 텍스트가 너무 밝거나 어두워서 안보이는 경우이다. 배경화면과 관련해서는 [Dracula](https://draculatheme.com/vim/), [Molokai](https://github.com/tomasr/molokai), [Seoul256](https://github.com/junegunn/seoul256.vim) 등 수많은 테마가 있다. 위에 제시한 테마들은 개인적으로 다 좋았지만 사람들(특히 Vim에 익숙치 않은)과의 협업 중에 그들이 [Solarized](https://github.com/altercation/vim-colors-solarized) 테마일 때 가장 편하게 보는 것을 많이 경험한 뒤로는 계속 Solarized 테마를 유지하고 있다. Iterm과의 호환을 언급하면, Iterm에서 배경화면을 설정했어도 Vim에서는 따로 배경화면을 명시적으로 지정하는게 좋다. 왜냐하면 위에서 말한 Syntax highlighting의 문제 때문이다.

만약, 사용하는 테마가 16 color 이상을 지원한다면 그것을 선택하자. 더 효과적인 시각 효과(특히 Syntax highlighting)를 경험할 수 있다. 예를 들어, Solarized를 사용한다면 256 color를 설정해보자.

```vim
set background=dark
colorscheme solarized
"Set term color palette to 256, and auto
let g:solarized_termcolors = 256
"Set the default color with the best option for ITERM2 expliciltly.
let g:solarized_termtrans = 1
```

File Navigator
===
너무나도 유명한 [Nerdtree](https://github.com/scrooloose/nerdtree) 외에도 [FZF](https://github.com/junegunn/fzf) 등의 증분검색(Incremental Search) 도구를 활용하면 현재 디렉토리 위치라는 한계를 넘어 단숨에 원하는 파일을 찾아 열 수가 있다. 둘 다 매우 유용하므로 `:help` 명령어를 통해 관련 문서를 읽어보는게 좋다. 그 외에 유용하게 사용하는 것은 [MRU](https://github.com/vim-scripts/mru.vim)이다. 이것은 파일 검색 도구라고 하기는 그렇지만 이 목적으로 사용하기에 매우 유용하다. 이것은 최근 열어본 파일들을 저장하여 그 목록을 보여주는 플러그인이다. 별 것 아닌듯 보이지만 짝코딩처럼 빠른 코드리딩과 디버깅이 필요한 시점에 진가를 발휘한다. 여기까지만 해도 Vim을 IDE의 파일 뷰처럼(또는 그 이상) 되도록 구축할 수가 있다. 이상의 플러그인들을 이용하여 파일들을 여러 탭에 열어두거나 최근 사용한 파일들에 손쉽게 접근할 수가 있다.

Search
===
C 언어 개발자라면 Ctags에 익숙할 것이다. 나는 ctags를 알게되자 마자 대단하다고 생각했는데, 그래픽 하나 없는 CUI 환경에서 단어 검색 및 내비게이션이 가능하였기 때문이다. 하지만 놀라움도 얼마 가지는 못했는데, 코드에 변화가 있을 때 마다 매번 최소 10초 이상의 시간이 걸리는 태그 파일을 생성해주어야 했기 때문이다. 후에 [Atags](https://github.com/fntlnz/atags.vim) 등을 도입하여 자동으로 태그 파일을 생성하는 작업도 시도해보았지만 태그를 생성하기 위해 과도하게 돌아가는 프로세스 때문에 사용을 중단한 상태이다. 그럼에도 태그 기능은 코드의 수정이 적거나 제한된 환경에서는 유용한 도구임에 틀림 없다고 생각하고 있다. 대신 이쪽 방면의 유명한 라이브러리인 [Silver searcher](https://github.com/ggreer/the_silver_searcher)처럼 검색으로 방향을 선회하였다. 나는 비슷한 도구인 [Ack](https://github.com/mileszs/ack.vim)를 기반으로 하되, Ack의 속도를 훨씬 뛰어넘은 [rg](https://github.com/jremmen/vim-ripgrep)를 통합[^4]하여 사용하고 있다 (방법은 아래 코드 참조). 아직 다른 유명한 IDE처럼 여러 파일에서 필요한 단어를 찾아 이동까지 해주는 쿨한 방법은 도입하지 못했다.

```vim
"RipGrep integration
"http://www.wezm.net/technical/2016/09/ripgrep-with-vim/
if executable("rg")
  let g:ackprg = 'rg --vimgrep --no-heading -i'
endif
```

Edit Helpers
===
코드 편집 시에 진정으로 유용한 기능들은 바로 편집도우미(Edit Helper)들일 것이다. 예를 들면 아래와 같은 경우,

```json
{
  "apple": "1",
  "pineApple": "20",
  "banana": "4"
}
```
위의 코드에서 ':'에 맞추어 열을 정리하고 싶으면 [Tabular](https://github.com/godlygeek/tabular)를 사용할 수 있다. 적용하고 싶은 부분을 Visual mode로 블록한 뒤에 `:'<,'>Tabularize/:`를 입력해주기만 하면 아래처럼 된다[^5].

```json
{
  "apple"     : "1",
  "pineApple" : "20",
  "banana"    : "4"
}
```

아니면 이런 것도 있다.

```html
html:5 > div.col-xs-12*5 > div.something
```

이게 뭔가 싶다면 [Emmet-vim](https://github.com/mattn/emmet-vim) 플러그인을 설치한 뒤, `<C-y>,`을 입력해보자 (Insert 모드에서도 기본 적용되는 단축키이다).

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
  <div class="col-xs-12">
    <div class="something"></div>
  </div>
  <div class="col-xs-12">
    <div class="something"></div>
  </div>
  <div class="col-xs-12">
    <div class="something"></div>
  </div>
  <div class="col-xs-12">
    <div class="something"></div>
  </div>
  <div class="col-xs-12">
    <div class="something"></div>
  </div>
</body>
</html>
```

보다시피 가벼운 테스트나 반복적인 블록 사용 시에 특히 유용한 도구이다.

이런 자동 수정 외에 커서를 여러 라인에 만들 수 있게 하는 [Vim multiple cursor](https://github.com/terryma/vim-multiple-cursors)와 같은 플러그인을 이용하면 Sublime text의 전유물인 줄로만 알았던 기능도 구사할 수 있다. 특히 Multiple cursor 모드에서 Visual block이나 `<S-#>`[^6] 등의 Vim 고유 기능을 접목하면 매우 유용한 도구가 된다.

이처럼 유용한 기능을 쉽게 사용 가능한 플러그인들도 있지만, 비교적 설정이 어려운 것들도 있다. 위에서 언급했던 자동완성(Auto Completion)과 문법 검사(Linting) 기능이다. 현재 자동완성은 [Deoplete](https://github.com/Shougo/deoplete.nvim)을 이용하고 있다. 처음 환경설정을 하는 과정에서 이것이 자동완성을 위해 사용해야 하는 기본 Python 설정 경로가 제대로 적용이 안되었던 지라 계속 애를 먹었다. 빠른 작업을 위해서 반드시 이 기능이 필요했기 때문에 삽질을 한 끝에 시스템 파이썬 경로를 지정한 뒤에야 문제가 해결되었다. 아래처럼 길고 하드코딩된 경로가 나라고 좋을리 없겠지만 가능한 시간 범위에서 해결 방법을 찾기 어렵다고 판단하여 보류중이다.

```vim
let g:python_host_prog = '/Library/Frameworks/Python.framework/Versions/2.7/bin/python'
let g:python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.5/bin/python3'
```

일단 기능이 동작한다면 이후로는 어렵지 않다. 약간의 설정만 더해주면 각 언어별 자동완성을 유용하게 사용할 수 있다. 예를 들면 Javscript를 연동하기 위해서 Tern을 사용할 수 있다.

```vim
"JAVASCRIPT
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
```

* 위의 코드는 플러그인 매니저 가운데 [Vim-plug](https://github.com/junegunn/vim-plug)를 이용한 형태이다. 이것은 비동기적 플러그 작업(설치, 수정, 삭제 등) 뿐 아니라 위처럼 `npm install`과 같은 후처리 작업을 하는 데에 있어서도 좋다.


사소한 버그들은 임시방편으로 대체한 상태이다. 예를 들면, html 자동 완성은 [html5.vim](https://github.com/othree/html5.vim)과 충돌을 일으키기도 하고, 자동완성 개수 제한 등의 제약을 무시해 버려서 명시적으로 해제한 상태이다. 그럼에도 자동완성은 잘 된다. 아마 `omnicomplete`이 어딘가에 적용되어 있는게 아닐까 싶다. 모든 것을 이해하기에는 아직 턱없이 부족하다.

문법 검사 도구로는 [Neomake](https://github.com/neomake/neomake)를 이용하고 있다. 파일을 열 때마다 문법 검사를 진행하면 열 때마다 불쾌한 지연이 발생하여 파일 저장 시에만 기능(문법 검사)이 작동하도록 수정하였다. 대신 필요할 때에는 명시적으로 창을 열어서 문법 경고/오류 항목들을 확인해보고 있다. 만약, 자바스크립트 작업을 위하여 `jshint`를 사용하도록 설정하고 싶다면 아래와 같은 코드로 설정할 수 있다.

```vim
let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }
let g:neomake_javascript_enabled_makers = ['jshint']
```

의존성을 가진 플러그인
===
위의 소단락에서 Deoplete과 Tern처럼 플러그인 간에 의존성을 가진 경우가 종종 있다. 예를 하나 더 들어보면, [Lightline](https://github.com/itchyny/lightline.vim)과 [Vim-fugitive](https://github.com/tpope/vim-fugitive)가 있다. 나는 [Powerline](https://github.com/powerline/powerline)의 인기에도 불구하고 Lightline을 사용하는데, 그 이유는 역시 속도 때문이다. Lightline은 가볍고 빠른 대신 무언가를 더 설정을 해주어야 유용해진다. 나의 경우에는 Vim-fugitive를 이용하여 Git 레포지토리 하의 브랜치(master, develop)나 작업하는 파일들의 상태(untraced, modified, staged) 등을 표시하는 기능을 통합하였다. 구현 모습은 아래 소단락 [첫화면](#첫화면)에서 확인할 수 있다.

단축키 설정
===
- 사용하는 기능들에 단축키를 설정하면 당연히 편리하다. 예를 들면, Vim 내부에서 창(pane)을 이동할 때 `<C-ww>`를 매번 입력하는게 은근 고역이었던 지라 `<S-방향키>`로 매핑(nmap)시켰다.

```vim
"http://vim.wikia.com/wiki/Switch_between_Vim_window_splits_easily
nmap <S-Up> :wincmd k<CR>
nmap <S-Down> :wincmd j<CR>
nmap <S-Left> :wincmd h<CR>
nmap <S-Right> :wincmd l<CR>
```

- Ack를 이용하여 검색시에는 현재 버퍼 내에 검색이냐, 아니면 경로내의 모든 파일들에 대한 검색이냐에 따라서 단축키를 분리하였다. 현재 열려있는 버퍼(파일)에서 특정 텍스트를 포함하는 파일을 찾기 위해서는 `<C-f>`, 아니면 현재 디렉토리로부터 모든 파일들에 대해서 검색을 하기 위해서는 `<S-f>`에 매핑하였다.

```vim
"Ack.vim
"type Ack, then it makes Ack!, because [I don't want to jump to the first result automatically.]
"https://github.com/mileszs/ack.vim#i-dont-want-to-jump-to-the-first-result-automatically
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
map <S-f> :Ack \
map <C-f> :LAckWindow! -H \
```

- 텍스트의 잘라내기(Cut) 기능을 추가하기 위하여 일반적인 단축키인 `<C-x>`를 매핑하였다. 단순히 잘라내기 목적으로 추가한 것은 아니고, 협업 시에 `Yank` 방식에 익숙치 않은 경우 이로인해 사소한 지연이 발생하는 것을 해소하고자 했다. 따라서 흔히 쓰는 단축키인 복사 `<C-c>`, 붙여넣기 `<C-v>` 역시 그에 맞게 지정하였다.

```vim
"http://vim.wikia.com/wiki/Quick_yank_and_paste
"Ctrl + (c,x,v) as copy(yank)
vmap <C-c> y<Esc>i
vmap <C-x> d<Esc>i
imap <C-v> <Esc>pi
```

- 창분할을 쉽게 하기 위하여 `-`, `\`를 각각 수평 수직 분할로 지정하였다.

```vim
"split pane
nmap \ :vsp<CR>
nmap - :sp<CR>
```

- 빈 공백(trailing)을 제거하기 위하여 CTRAIL, 탭 공간을 공백 문자(space)로 바꾸기 위하여 CTAB을 해당 기능과 매핑(nmap)하였다.

```vim
"Remove all trailing whitespace
nmap CTRAIL :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
"Remove all tab space
nmap CTAB :%s/\t/  /g<CR>
```

- 폴딩을 쉽게 하기 위하여 펴기는 `<Tab>`으로, 접기는 `<S-Tab>`으로 지정하였다.

```vim
"Folding
"fold (ex: level=<input><CR>)
nmap fd :setlocal foldlevel=
"Toggle
nmap <Tab> zO
nmap <s-Tab> zc
```

- 협업 및 작업의 용이함을 위해서 파일을 켜고 끄는 데에 일반적으로 쓰이는 단축키를 매핑하였다. 예를 들면, `<C-q>`를 창 끄기(`:q`), `<C-s>`를 저장(`:w`)에 매핑하였다. `qa`는 `:qa`를 자주 써서 Normal mode에서 쉽게 창들을 닫을 수 있도록 매핑하였다.

```vim
"Quit file
nmap <C-q> :q<CR>
"Quit all file
nmap qa :qa<CR>
"Save file like GUI editor
nmap <C-s> :w<CR>
```

- 터미널 프롬프트에서 사용하는 커서 이동 단축키를 Vim에도 매핑하였다.

```vim
"Move to beginning of the current line
map <C-a> 0
"Move to end of line
map <C-e> $
```

위처럼 자주 쓰는 것들에 대하여 키보드 매핑을 하여 편리하게 사용중이다. 하지만 안쓰는 자동 명령어(autocmd)를 굳이 남기지 않듯이, 안쓰는 단축키 역시 굳이 남기지 않고 지우고 있다.

NeoVim
===
다른 에디터들이 1년 단위로 버전이 바뀌듯 Vim 역시 그를 둘러싼 수많은 플러그인들이 개선되거나 대세가 바뀐다. 심지어 Vim 조차 다른 유사 Vim(?)으로 대체하여 사용하기도 한다. 여러가지가 있는데, 나의 경우에는 아직 터미널에서 분리되어 실행되는 타입인 Macvim이나 [Nyaovim](https://github.com/rhysd/NyaoVim)은 고려하지 않고 있다[^7]. 대신 나는 [Neovim](https://neovim.io/)을 이용하고 있다. Neovim 측에서는 자신들의 에디터로 갈아타야 하는 이유를 몇가지 제시하는데, 나에게 피부로 와닿았던 부분은 Neovim 환경을 전제로 만들어진 유용한 플러그인들이었다. Neovim의 비동기 프로세스 기능을 잘 활용한 플러그인들은 기존의 유용하나 느렸던 플러그인들을 대체하는 것들이 많다. 에디터 사용자 입장에서는 Vim과의 인터페이스 차이가 없어서 그런지 사용하는 데에 이질감은 전혀 느껴지지 않았다. 단지 이것을 맨 처음 설치했을 때가 약간 당황스러웠는데, 그 이유는 기존 Vim처럼 `~/.nvimrc`와 같은 환경설정 파일을 기본으로 사용하지 않았기 때문이다. 대신 `~/.config/nvim/init.vim`이 있어서 `~/.vimrc`처럼 생각하고 작업을 하면 된다는 것을 알게 되었다.

Neovim 환경에서는 비동기 방식의 프로세스를 이용한 플러그인들을 통하여 기존의 Vim 환경에서 보다 더 효과적인 작업을 할 수가 있다. 이것을 사용하면서 내가 얻은 가장 큰 효과도 여기에 있다. 각 기능들이 적용되는 `대기 시간이 감소`했다.

그리고 사소하지만 Neovim에서는 굳이 에디터의 모든 창을 닫고 터미널로 빠져나가지 않아도 Vim 내부에서 터미널을 열어 작업을 할 수가 있다. 덕분에 편집 과정에서 작업 흐름을 유지할 수 있게 되었다. 아직 사용해 본 적이 없다면 `:terminal`을 입력해보자.

만약 자주 사용한다면 아래처럼 창 상단의 일부를 분할하여 터미널로 만들어 쓸 수도 있다.

```vim
"New terminal in the top of the active pane
nmap term :new<CR>:wincmd k<CR>:resize 5<CR>:terminal<CR>
```

첫화면
===
나는 Vim 에디터를 켰을 때 첫화면에 대해서 다음과 같은 기능을 자동으로 실행하도록 구현하였다.

1. Nerdtree 좌측
2. MRU 하단
3. Side Pane 우측
4. 커서는 중앙(편집할 파일이 불려올 창)

창이 분할되는 특성상 키를 입력하는 순서가 중요하다.

```vim
"VimEnter configurations ------------------------------------------------------
"NOTE: Order is important in this block.

augroup MRUOpen
  autocmd!
  autocmd VimEnter * MRU
augroup END

augroup NERDTreeOpen
  autocmd!
  "NERDTree
  autocmd VimEnter * NERDTree
  "To focus edit pane after NERDTree open
  autocmd VimEnter * wincmd l
augroup END

"Make a new 'Vertical New Pane Side' & back to the main pane
augroup SideRightOpen
  au!
  autocmd VimEnter * :vnew
  autocmd VimEnter * :vertical resize 40
  autocmd VimEnter * :wincmd h
augroup END

"END VimEnter configuration ---------------------------------------------------
```

이 소단락을 포함하여 위에서 설명한 설정들을 마치면 아래와 같은 모습이 된다[^8].

![](/img/vim-edit-screen.png)

기타
===

기타 설정
---
- Visual mode에서 Yank한 텍스트를 클립보드에도 포함하고 싶다면 `set clipboard=unnamedplus`을 해주자[^9]. 이러면 클립보드의 버퍼 레지스터가 Yank 쪽으로 붙는다. 아니면 `옵션키Option key`를 누른 상태에서 복사를 하여 클립보드로 옮기는 방법도 있다.
- `vit`를 이용하면 html 태그 내부의 내용을 Visual blocking 한다. 예를 들면 `<div>`**이 부분에 해당하는 내용**`</div>`이 블록된다.
- 빈 공백문자(trailing character)와 탭 문자를 표시하려면 아래와 같이 `set list`를 활용하자.

```vim
"To show space(trail) as ~
set listchars=trail:~,tab:↹\
set list
```

필요에 의한 플러그인
---
위의 소단락 [NeoVim](#neovim)에서 언급했듯이 Vim을 둘러싼 플러그인들은 1년만 지나도 다른 것들로 대체되는 것들이 많다. 그런 이유로 현재 사용하는 플러그인들에 대해서 자세하게 기록하는 것은 그다지 유용한 생각이 아닌 것 같다. 따라서 시간이 흐른 뒤 남는 것은 '어떤 플러그인을 사용했는지'가 아니라 '어떤 기능이 필요했는지'가 되는 것 같다.

Epilogue
===
지금까지 만났던 Vim에 애정을 갖고 있는 사람들은 모두 기본적으로 개발을 즐기는 사람들이었다. 그들이 어떤 이유로 Vim을 주 에디터로 사용하게 되었는지는 모른다. 단지 그들은 모두 Vim을 진정으로 유용하게 사용하고 있었다. 표본은 적지만 지금까지 경험한 바로 그들은 한 번도 개발이 싫다거나 재미가 없다는 얘기를 하는 경우가 없었다. 정확한 이유는 모르겠다. 하지만 짐작은 가능한데, 바로 Vim을 유용하게 사용하려면 대단한 자발성이 필요하다는 점이다. 현명한 사람들이라면 진작에 이것 말고 더 쿨한 에디터를 사용하지 않겠는가?

하지만 `하나의 에디터를 잘 사용하라`던 실용주의 프로그래머의 조언은 여기서도 유용하다. 아무리 좋은 도구가 있어도 익숙하지 않으면 제대로 쓰지 못하기 때문이다. Vim은 단순하지만 익숙해질 수록 큰 힘을 발휘하는 에디터이다. 처음에는 단순 암기같은 명령어들이 익숙해지면 머리속에서 하나의 흐름이 되어 유연하게 흘러가게 된다.

결국 코드(텍스트) 에디터를 사용하는 목적은 생각하는 대로 작성하는 것과 미처 생각하지 못했던 것을 발견해주는 데에 있을 것이다. 이것을 미래형으로 생각해보자. 가까운 미래에는 에디터가 사람이 생각하는 대로 컴퓨터가 작성해주는 단계로 발전한다면, 그것보다도 더 미래에는 아예 생각하지 않아도 의도하게 될 것을 알아서 작성해주는 수준으로 발전하지 않을까? 그 때가 되면 어떨지 모르겠지만, 오픈소스의 힘을 입어 Vim이 시대에 적응하면서 계속 발전했으면 좋겠다. 하지만 만일, 그 경쟁에서 도태된다고 해도 Vim을 사용할 때에 필요한 편집모드와 명령어를 활용하는 사고방식은 어딘가에 녹아들어 함께 갔으면 좋겠다.

- 지금까지 설명한 내용은 개인 레포지토리인 [nvimrc](https://github.com/wikibootup/nvimrc)에 있다. 그외 유명한 vimrc 레포지토리들이 많으니 검색해보고 참조해보자.

[^1]: 김연수, "세계의 끝 여자친구" 가운데 단편 "웃는 듯 우는 듯, 알렉스, 알렉스" 중 p226, 문학동네, 2009.09

[^2]: Syntax highlighting 및 Linting, Autocompletion을 포함하여 자동으로 지원한다. 이렇게 의식적으로 세가지를 구분하지 않아도 될만큼 잘 되어있다.

[^3]: 이 중에서도 노멀 모드에서는 콜론(:)으로 주는 옵션들을 결합하여 수많은 기능들을 제공한다. 다른 에디터들이 '굳이' Vim 모드를 지원하려는 이유가 여기에 있지 않을까, 추측해본다.

[^4]: FZF 또한 rg와 통합해서 사용하고 있다.

[^5]: Zsh을 이용한 자동완성 기능을 이용한다고 가정할 때 매우 편리하다.

[^6]: Word(at cursor) search & highlight

[^7]: Nyaovim은 NeoVim을 기본 전제로 구현되어 있다.

[^8]: 이전에는 텍스트에 집중하던 시선이 화면 중앙을 벗어나 개방된 오른쪽으로 빠져 나가는 경험을 종종 했다. 그래서 이것은 가독성이 떨어지는 경험을 개선하고자 취한 조치였다. 물론 여분의 창을 미리 열어두어 나중에 다른 파일을 열기위한 목적도 있기는 하였다. 하지만 그래도 본 목적은 가독성에 있었다. 또한 이전에는 우측창 대신 [Tagbar](https://github.com/majutsushi/tagbar)가 그 자리에 위치하여 있었다. 이것은 ctags를 기반으로 하여 코드로부터 클래스, 함수, 변수를 항목(categories)으로 만들어 창에 표시하는 플러그인인데, 추가적인 파일 생성 없이 태그를 동적으로 만드므로 깔끔하고 볼만했다. 다만 아쉽게도 텍스트의 양이 많은 파일을 분석하는 경우 속도 이슈가 발생하여, Vim을 켤 때 자동으로 실행하는 대신 수동으로 실행하도록 변경하였다.

[^9]: 이 기능을 포함하여 다른 좋은 기능들을 위해서는 Vim의 버전이 충분히 높아야 한다.
