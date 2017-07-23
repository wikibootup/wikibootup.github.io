+++
date = "2017-07-16T23:20:42+09:00"
title = "UI 컴포넌트와 테마"
draft = false
categories = []
tags = ['ui', 'css', 'html', 'ui-component']

+++

# 개요

테마란 일상적인 의미에서는 대화(또는 작품의)의 주제나 화제를 뜻하고, 주식에서는 주가의 등락을 결정하는 요인이라고 부른다고 한다. 그렇지만 여기서는 이것을 **'브랜드를 표현하는 일관된 UI 스타일'**로 정의한다. 그리고 여기서의 '컴포넌트'는 **'웹페이지를 구성하는 기능적으로 구분된 시각적 사물'**로 그 의미로 한정하기로 한다. 정리하면 '테마화가 가능한 UI 컴포넌트화'란 '웹페이지를 구성하는 기능적으로 구분된 시각적 사물들의 스킨(skin)을 브랜드에 따라 다르게 표현할 수 있도록 만드는 작업'이다.

상상해보자, 누군가 맥주회사를 위한 UI 테마화를 원하고 있다. 이 경우 각 UI 요소는 M사이건 H사이건 상관없이 독립적으로 존재해야 하며, 오직 UI 스킨만이 테마에 따라 달라져야 한다. 그리고 각 UI 요소는 특정 뷰(웹페이지)에 독립적인 컴포넌트의 형태로 만들어야 한다. 만약 이를 무시하고 뷰(또는 웹페이지)에 UI 요소를 종속시킨 채로 테마화 작업을 진행한다면 뷰의 개수와 브랜드(M사, H사, 등등)의 개수가 늘어날 수록 추가작업량은 곱절로 늘어나게 될 것이다.

UI 요소가 컴포넌트가 되는 것과 더불어 그것이 테마에 따라 스킨을 달리할 수 있으려면 생각해야 할 것들이 많다. 웹사이트의 각 페이지마다 쓰이는 UI 요소가 특정 페이지에 의존적이지 않아 서로 다른 페이지에 공통적으로 쓰일 수 있도록 설계해야 함과 더불어 각  UI 컴포넌트 간에 가능한 조합은 어떤 것들이 있을지를 생각해야 하기 때문이다. 그리고 UI를 구성하는 기존의 방식이 전혀 컴포넌트를 고려하지 않았다면, 변화에는 적지 않은 고통이 따를 것이다.

내가 하고자 했던 것은 바로 위처럼 꼬일만큼 꼬여서 어쩔 수 없이 잘라내야 하는 실뭉치처럼 남겨진 기존의 구현물을 개선하여 UI를 만드는데 필요한 최소한의 것들만을 남기는 것이었다. 그렇게 되면 이해하기 쉽고, 사용하기 쉽고, 수정하기 쉬운, 뛰어나면서도 이타적인 구현물을 만들 수 있을 것이라고 판단했다.

이 글에서는 이러한 고통스러운 작업을 맛보는(~~맛만 보는~~) 실습을 기술적인 측면에서 진행해보려고 한다.

***

Contents
===

- [개요](#개요)
- [CSS](#css)
- [HTML](#html)
- [컴포넌트화](#컴포넌트화)
- [ETC](#etc)
- [디자이너와 개발자의 소소한 협업](#디자이너와-개발자의-소소한-협업)
- [Epilogue](#epilogue)

***

# CSS

css는 트릭이다. 명확한 인과관계가 있지만 모르는 사람이 보면 이해할 수 없다. 그래서 그러한 인과관계를 이해하지 못한 누군가가 작성한 구현물은 놀라울 정도로 지저분하다. 그러니 본내용을 설명하기에 앞서 먼저 css의 기초적인 부분을 이해하기 위해 몇가지 간단한 실습을 진행하고 넘어가려고 간다.

## 정렬
먼저 수평방향부터 생각해보자. 엘리먼트를 수평으로 정렬하는 방법은 여러가지가 있다.

- 만약 width가 지정되어 있는(명시적이든, 암시적이든) 엘리먼트를 정렬하려면 `margin`을 `auto`으로 주어서 해결할 수 있다.
- 또는 엘리먼트(width가 지정되어 있는)의 내용물 및 하위 엘리먼트들을 정렬하고 싶다면 `text-align`을 사용할 수 있다. 이 때 하위 엘리먼트들은 인라인(인라인 블록도 포함)의 속성을 가지는 엘리먼트여야 한다.
- 위 경우로 해결되지 않는 경우(보통 인라인 엘리먼트) `float`를 사용할 수 있다. float를 사용하면 외부 블록의 영역을 무시하고 침범하므로 float를 사용한 엘리먼트 바로 다음에 `clear: both`를 적용한 엘리먼트를 첨가하거나, float를 사용한 엘리먼트를 감싸는 바깥 엘리먼트에 `overflow: auto`를 시도해볼 수 있다.

<p data-height="265" data-theme-id="0" data-slug-hash="zdOXEY" data-default-tab="html,result" data-user="wikibootup" data-embed-version="2" data-pen-title="zdOXEY" class="codepen">See the Pen <a href="https://codepen.io/wikibootup/pen/zdOXEY/">zdOXEY</a> by wikibootup (<a href="https://codepen.io/wikibootup">@wikibootup</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

수직방향은 조금 더 트릭이다. 나는 오랫동안 `vertical-align`이 수직정렬이라고 생각했지만 내가 생각했던 수직정렬은 아니었다. 물론 table 디스플레이를 사용하면 그게 맞지만 그게 아니라면 `vertical-align`은 인라인 엘리먼트의 내부 컨텐츠(텍스트)의 정렬을 의미하는 것이었다. 하지만 많은 경우 블록 엘리먼트(height를 가지는)를 수직으로 정리할 일이 더 많기 때문에 난감했다. 이럴 때는 중앙정렬을 해야하는 엘리먼트의 상위 엘리먼트에다가 `line-height`를 자식 엘리먼트의 `height`보다 높게 주는 방법, 또는 `position: absolute`를 이용할 수도 있을 것이다. 하지만 그보다는 `flex`나 `table-cell`의 두가지 display 속성을 이용하는 것이 더 쉽고 부작용을 줄이는 방법이다.


```html
<div style="display: table;">
  <div style="display: table-cell; vertical-align: middle;">
    content here
  </div>
  ...
</div>
```

하지만 위의 솔루션으로 해결되지 않는 UI가 종종 있는데, 예를 들면 엘리먼트가 동적으로 생기거나 사라지는 경우 또는 정렬해야 하는 엘리먼트들이 많아서 통제하기가 어려운 경우가 있을 것이다. 이 경우에는 `flex`를 사용하면 간편하다.

처음 flex를 사용했을 때에는 `display: table`과 비슷하다는 생각을 했었지만 table이 단순히 셀마다 비율을 지정해 정렬을 하는게 기본값이지만 flex는 엘리먼트들을 비율로 지정할 수도 있고, 그렇지 않아도 되어서 좋다.

flex를 사용했을 때 몇 안되는 단점은

- IE 브라우저가 이것을 불완전하게 지원하고(autoprefixer로 벤더접두어를 주어서 렌더링한다고 해도)
- 다른 속성들을 무시해버리거나 충돌이 나는 경우가 있다는 점이다.

실례로 나는 최근 float-clearfix 조합으로 정렬을 하던 방식을 flex-justify-content 조합으로 수정한 적이 있는데, clearfix(clear 속성)가 flex와 충돌을 일으킬 거라고는 생각을 안해서 디버깅하는 과정에서 애를 먹은 적이 있다.

```html
<div style="display: flex; justify-content: space-between">
  <div></div>
</div>
```

그래서 만드려는 UI가 유연하지 않아도 되거나 `inline-block` 정도로 쉽게 해결되는 경우 flex를 사용하지 않는게 더 나은 것 같다. 정리하면 나는 정렬을 할 때 부작용 및 구현 난이도를 고려해서 다음의 순서대로(왼쪽 우선) 사용하는 편이다. `text-align -> margin -> flex -> float -> line-height`

## relative, absolute, z-index
relative 속성이 지정된 엘리먼트와 아닌 것의 차이가 뭘까? 겉보기에는 다를 것이 없어보여서 absolute를 지정하기 위한 용도 외에는 없는 것으로 보이기도 한다. 무슨 말이냐면 relative 속성을 적용한 엘리먼트 내부에 absolute 엘리먼트를 사용하면, absolute 엘리먼트의 위치는 relative 엘리먼트의 좌측 상단 (0, 0)에 위치한다는 것이다. 그렇지만 그 외에 다른 이유가 있다. relative 속성을 이용하면 `top, left, right, bottom` 등의 절대 위치를 이동하는 속성을 적용할 수 있고, `z-index` 역시 relative, absolute가 지정되어 있지 않으면 해당 속성이 무시된다.

- z-index는 높을 수록 UI 우선순위가 높다. 영역이 겹칠 경우 z-index 값이 높은 것을 표현한다.
- relative 속성은 내부 엘리먼트로 absolute를 쓰거나, 절대위치 이동(top, left 등)을 하거나, z-index를 사용해야 의미가 있다.
- relative 속성은 절대 위치 이동을 하지 않은 경우 텍스트 상으로 먼저 렌더링 된 엘리먼트 다음에 만들어지는 반면, absolute는 (0, 0)에 표현된다.

<p data-height="265" data-theme-id="0" data-slug-hash="JyPVxb" data-default-tab="html,result" data-user="wikibootup" data-embed-version="2" data-pen-title="JyPVxb" class="codepen">See the Pen <a href="https://codepen.io/wikibootup/pen/JyPVxb/">JyPVxb</a> by wikibootup (<a href="https://codepen.io/wikibootup">@wikibootup</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

## flex
flex는 간결하고 유연한 UI를 만드는데 좋은 도구이다. 이걸 사용하면 수직-수평 정렬이 매우 쉽고, 좌우끝 정렬이나 아이템을 쌓는 방향(row, column)도 가능하고, 아이템의 기본넓이를 지정하되 영역이 충돌하면 비율을 지정할 수도 있다. 아래 예시는 flex로 가능한 것들 중 일부일 뿐이다.

<p data-height="265" data-theme-id="0" data-slug-hash="gxYJYj" data-default-tab="html,result" data-user="wikibootup" data-embed-version="2" data-pen-title="gxYJYj" class="codepen">See the Pen <a href="https://codepen.io/wikibootup/pen/gxYJYj/">gxYJYj</a> by wikibootup (<a href="https://codepen.io/wikibootup">@wikibootup</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>


## overflow
UI 작업을 하다보면 엘리먼트가 지정한 넓이와 높이를 넘어서는 경우가 종종 있다. 텍스트가 길거나, 이미지가 크거나, 엘리먼트가 가변적으로 늘어나거나, float를 사용했거나 하는 등등의 이유로 말이다. `overflow: scroll`을 적용하여 스크롤을 만들 수도 있겠지만 더 나은 UI를 위해서는 조금 더 고민해보아야 한다. 텍스트가 길어지면 `word-wrap: break-word`를 주어 다음줄로 넘어가게 할 것인가? 아니면 텍스트 엘리먼트 바깥 엘리먼트에 `overflow: hidden; text-overflow: ellipsis;`를 주어서 초과하는 부분에 대하여 `...`으로 그것을 대신할 것인가?

## hover, focus, active, disabled
Pseudo class라고 알려진 것들 중 위의 4가지만 살펴보자.

- hover : 해당 UI 영역이 어디까지인지 표현. UI 버튼 같은 경우 마우스를 해당 영역에 가져다 두기만 해도 발생
- focus : 해당 UI 영역이 선택되었음(활성화나 동작과 무관하게)을 표현. input 필드 같은 경우 해당 필드가 선택되었고 텍스트 입력이 가능하다는 것을 나타낼 수 있다. focus는 해당 UI를 tab 키로 이동하거나, 마우스를 누른 경우(떼지 않아도 상관없다, 그리고 드래그해서 해당영역 밖에서 떼도 포커스 상태 유지) 발생
- active : 해당 UI 영역이 활성화되었음을 표현. 내비게이션 바에서 어떤 페이지가 활성화되었는지 표현할 수 있을 것이다. pseudo class 방식 외에도 명시적으로 `active` 클래스 등을 사용하기도 한다.
- disabled : 해당 UI 영역에 기능이 비활성화되었음을 표현. active와 마찬가지로 명시적으로 `disabled` 클래스를 적용하기도 한다.

## media query
웹서비스들의 내비게이션 바를 보면 태블릿 사이즈(768px) 이상에서는 메뉴들이 나오지만 모바일(767px 이하)에서는 메뉴(≡) 아이콘 하나로 표현되는 경우를 본 적이 있을 것이다. 이런 것들은 css의 미디어 쿼리와 `display: hidden`의 조합으로 만들 수 있다. 이처럼 렌더링은 되었지만 숨겨놓다가 보여주기도 하고, 아니면 디스플레이 사이즈에 따라 `flex` 엘리먼트가 `inline-block` 엘리먼트로 바뀔 수도 있다. 더 자세한 정보는 다른 사이트에서 쉽게 찾아볼 수 있으니 생략하겠다.

## px, rem
rem을 쓰면 최상단 엘리먼트에서 설정한 폰트 크기를 기준으로 폰트 사이즈를 일괄적으로 바꿀 수 있으므로 유용하다. 절대적인 크기를 원하면 px로 주면 되고, 최상단 태그(html 태그)에서 지정한 폰트를 1rem으로 판단하고 하위 요소에 rem을 적용할 수도 있다.

<p data-height="265" data-theme-id="0" data-slug-hash="xLKoGJ" data-default-tab="html,result" data-user="wikibootup" data-embed-version="2" data-pen-title="xLKoGJ" class="codepen">See the Pen <a href="https://codepen.io/wikibootup/pen/xLKoGJ/">xLKoGJ</a> by wikibootup (<a href="https://codepen.io/wikibootup">@wikibootup</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>

# HTML
html은 짧게만 언급하려고 한다. div 태그 외에 보다 semantic한 이름을 사용할 수 있다는 것을 알 것이다. `header, nav, section, article, main, table, ul, li, hr` 등등 말이다. 이것들을 사용하는 것은 좋으나 해당 태그의 브라우저 지원여부를 알아본 뒤, 용도와 제약사항을 준수하여 사용해야 한다. 예를 들어, `nav` 태그는 내비게이션 스타일이면 전부 사용하는 것이 아니라 매인 내비게이션 바(주로 상단에 위치할 것이다)에 사용해야 한다. 그리고 `table`은 레이아웃을 잡는 용도가 아니라 명확히 테이블 형태의 데이터 표현을 하는 경우에 사용해야 한다. 또한 `ul`은 하위 태그로 `li` 만을(그것도 리스트로 표현해야 하는 내용물이 안에 들어가야 한다) 사용해야한다.

# 컴포넌트화
위에서 든 예시에는 의도적으로 class를 거의 사용하지 않고 inline style로 UI를 만들었다. 보다시피 굉장히 보기 어렵다는 것을 알 수 있다. 보기도 어렵지만 저렇게 하면 UI 요소를 컴포넌트로 만들 수가 없다. 따라서 이제부터는 컴포넌트화를 진행하여 간결하게 UI를 표현할 수 있도록 수정하려고 한다.

## 파일구조
모든 클래스들이 파일 하나에 들어있으면 파일 안에 뭐가 있는지 그리고 그 안으로 가도 뭐가 뭔지 파악을 하기가 어렵다. 따라서 온톨로지 개념을 적용한다는 취지로 각 컴포넌트를 하나의 파일로 분리하고, 내부적으로는 주석으로 세부영역을 나누려고 한다. 여기서는 부트스트랩 등의 외부 라이브러리를 기반으로 만든다는 가정을 하므로, 구조와 내용물이 그것들과 비슷한 부분이 많을 것이다. 나의 경우에는 이러한 호환에 있어서 엄격한 BEM보다 가이드의 성격을 띄는 SMACSS적인 방법론을 따르는 것이 적절하다고 판단했다.

```sh
ui-component
├── partials
│   ├── _base.scss
│   ├── _misc.scss
│   ├── _layout.scss
│   ├── _utils.scss
│   ├── modules
│   │   ├── _button-groups.scss
│   │   ├── _buttons.scss
│   │   ├── _chips.scss
│   │   ├── _dropdowns.scss
│   │   ├── _forms.scss
│   │   ├── _glyphicons.scss
│   │   ├── _lists.scss
│   │   ├── _navbar.scss
│   │   ├── _page-header.scss
│   │   └── _tables.scss
│   ├── themes
│   │   ├── _my-theme.scss
│   │   └── _utils.scss
│   └── utils
│       ├── _extends.scss
│       ├── _functions.scss
│       └── _mixins.scss
└── ui-component.scss
```

위의 파일구조는 컴포넌트 작업의 일부분을 가정하여 만든 예시이다. 파일 내부 내용물은 생략하고 각 디렉토리만 설명하겠다.


### partials
`partials`라는 네이밍은 흔한 방식인데, 그 기원은 `scss`가 Ruby 언어로 만들어진게 영향을 주었을 것이다. 루비에서 저렇게 많이 쓴다고 하니까. 다른 곳으로 로딩되어지는 파일은 `_` 접두어가 붙어있음을 알 수 있다.

### modules
부트스트랩의 구조와 흡사하게 각 UI 요소를 파일로 분리하였다. 이 디렉토리 안에 있는 파일 하나하나가 곧 하나의 UI 컴포넌트라고 생각할 수 있다. Google material design에서 나온 list나 chip같은 컴포넌트도 여기에 포함하였음을 알 수 있다.

### utils
scss를 사용하면 mixin 뿐만 아니라 extend, function을 사용할 수 있다. 요 3가지 개념을 다른 개발자들이 유틸이라고 명명한 것을 보고 괜찮다고 생각해서 차용했다. 믹스인은 가장 범용적으로 사용할 수 있는 기능인데, 속성이 가변적으로 변해야 하는 경우에 사용하면 적합하다. extend는 이와는 다르게 공통적으로 사용되는 고정된 속성들을 지정할 때 사용한다. 하지만 extend가 미디어쿼리(반응형이나 어댑티브)에서 적용이 안되므로 믹스인으로 대체해도 무방하다. function은 아직 내가 활용범위를 파악하지 못했지만, 입력받은 값을 특정 계산을 하여 원하는 값으로 바꾸어 출력(반환)하는 경우에 사용하고 있다. 예를 들어, px을 rem으로 바꾸는데 함수를 사용하면 적절할 것이다.

### themes
테마의 정의는 **개요**에서 설명했다. 사실 이 정의는 부트스트랩이 제공하는 테마기능과 유사하다. 즉, 여기서 테마란 사실 기술적으로는 가변적인 변수와 믹스인의 모음에 지나지 않는다. 배경색을 바꾸고, 폰트크기를 바꾸고, 엘리먼트의 사이즈를 바꾸는 것은 사실 scss의 변수값을 바꾸는 것이기 때문이다.

## 로딩구조
위의 파일구조에서 각 파일들은 개념에 따라 묶어서 로딩이 되고, 그걸 더 큰 개념의 일부로 판단하여 로딩이 되는 구조이다. 예를 들어, `utils`라는 디렉토리에 있는 파일들은 그 디렉토리 바깥에 있는 `_utils.scss`에서 로딩하고, 이것은 `partials` 바깥에 있는 `ui-component.scss`에서 로딩할 수 있다.

```css
// Utils for Theme
@import './partials/themes/_utils';
// Theme
@import './partials/themes/_my-theme';
// Utils
@import './partials/_utils';
// Base
@import './partials/_base';
// Misc
@import './partials/_misc';
// Layout
@import  './partials/_layout';
// Modules
@import './partials/modules/_navbar';
@import './partials/modules/_icons';
...
```

이 때 로딩순서를 주의하자. 예를 들어, 여기서 테마 로딩은 유틸보다 앞서지만, 테마를 위한 유틸은 따로 있는 것이다. 이것이 의미하는 것은 유틸은 테마에서 지정된 값을 사용할 수 있다는 것이다 (종속성이 있을 수 있다는 의미).

## 구조와 표면
OOCSS에서 나오는 말이 있다. '구조structure와 표면skin을 분리하자'. 비슷한 개념으로 나는 UI 요소를 크게 item과 item-box의 2가지로 나타낸다. 예를 들어, text이면 text, text-box로 두고, 아래처럼 사용할 수 있을 것이다.


```css
.text {
  font-size: $text-size;
  color: $btn-color;
}

.text-box {
  padding: 10px;
  word-wrap: break-word;
}
```

```html
<div class="text-box">
  <div class="text">
    Some text here.
  </div>
</div>
```

## 네이밍
선택자 이름은 명확하고 중복되지 않아야 한다.

- 예를 들어, 여러 라이브러리들을 사용하고 있다면 어떤 라이브러리에서 정의된 선택자인지, 또 같은 이름을 쓰는 선택자들이 없도록 해야하므로, 특정 이름을 접두어로 강제할 수도 있다.
  - font-awesome같은 라이브러리는 그런 이유로 `fa-`라는 접두어를 기본으로 두는 것 같다.
- 라이브러리 간 구분을 할 수 있다고 하면, 그 다음은 모듈(컴포넌트) 별로 선택자들을 구분할 수 있어야 한다. 이 때에는 간단히 모듈명을 추가하면 된다.
  - `chip-text-box`, `card-text-box` 이런 식으로.
- 모듈 간 구분이 가능하면 그 다음은 모듈 내부에서 UI 성격에 따라 구분할 수 있어야 한다.
  - Theme
      - 같은 기종의 스마트폰이라도 색상은 서로 다를 수 있듯이 같은 컴포넌트라도 서로 다른 구조와 표면을 가질 수 있다(다른 의미지만 일종의 테마).
          - `card-heading-salt`, `card-content-salt`
          - `card-heading-pepper`, `card-content-pepper`
  - Sizing
      - 사이즈 별로 구분도 해야겠지만 그 방식도 고정(width, height)이냐, 가변이냐(padding, margin)에 따라 다르다.
          - `card-md`, `card-md-fixed`

이상을 적용하면 요런 식으로 만들 수 있을 것이다.

```html
<div class="card">
  <div class="card-heading card-heading-salt">
   <div class="card-text-box">
     <div class="card-text card-text-md">
     </div>
   </div>
  </div>
  <div class="card-body card-body-salt">
    ...
  </div>
</div>
<div class="card">
  <div class="card-heading card-heading-pepper">
   <div class="card-text-box">
     <div class="card-text card-text-md">
     </div>
   </div>
  </div>
  <div class="card-body card-body-pepper">
    ...
  </div>
</div>
```

이렇게 하면 만사형통일 것 같지만 사실 여기서부터가 시작이다. `card-text`는 `card-heading`에만 쓰이는 특수한 것인가? 아니면 `card` 모듈 내부라면 어디서나 쓰일 수 있는 것일까? 컴포넌트 테마에 따라서 이 텍스트 스타일을 따로 정의해야 할까, 아니면 자식 선택자`>`를 이용하여 각 컴포넌트 테마에 맞게 수정해야 하는 것일까? 각 컴포넌트 테마에 하위 요소를 종속시켜 버리면, 코드 양이 줄지만 선택자 간에 종속성이 생기므로 좋지 않고, 반대로 각 컴포넌트 테마에 따라 모든 하위 UI 요소를 위한 선택자를 따로 정의하면 오해의 소지가 없고 선택자 간에 의존성 구조를 없앨 수는 있지만 코드 양이 늘고, 선택자 이름도 너무 길어지는 것이 아닌가, 하는 생각도 든다.

```css
.card-heading-pepper {
  ...
  > .card-text {
    font-size: 20px;
  }
}
```

위는 종속, 아래는 독립 형태이다.

```css
.card-heading-pepper {
...
}

.card-heading-text-pepper {
  font-size: 20px;
}
```

네이밍이 명확한 것은 물론 좋지만 생략해도 의미가 손실되지 않는다면 하는게 좋은 것 같다. 예를 들어, `card-body-item-text-box`라고 하자. 만약, `card-body-text-box`라고 하더라도 그것이 item이라는 개념을 지칭하는 것이 분명하다면 그렇게 하는 것이다.

네이밍에 답은 없으므로 협업하는 다수의 동료가 납득 가능하게 만들어야 겠지만, 그러면서도 가급적 유니버설하게 만들어야 작업물의 쓰임새와 수명을 늘릴 수 있을 것 같다.

## 공간 주기
방금 전 `item-box`로 사이징을 한다고 했다. 하지만 UI 레이아웃을 구성할 때, 딱히 어떤 모듈의 box에 속한다고 보기 어려운 여백이 필요할 때가 참 많다. 그럴 때에는 오로지 공간을 주기위한 선택자를 만들어 집어넣는 것도 방법인 것 같다. 이렇게 하면 `item-box`의 의미를 지킬 수 있으면서도 UI 레이아웃을 유연하게 바꿀 수 있다.

```css
@for $i from 1 through 10 {
  .margin-v-#{$i} {
    display: inline-block;
    margin-top: $index + px;
  }
}
```

```html
<div class="item-a"></div>
<div class="margin-v-5"></div>
<div class="item-b"></div>
```

## 인라인 스타일
인라인 스타일만 필요할 때도 있다. 선택자 네이밍이 아직 정해지지 않았거나, 특정 페이지에서만 다르게 적용해야 하는 컴포넌트 UI가 있을 때 등등 말이다. 그럴 때에는 인라인스타일 대신 인라인 스타일 클래스를 만들어서 사용하는 것도 방법이다.

```css

.text-align-right {
  text-align: right;
}

.item-something-box {
  ...
}
```

```html
<div class="item-something-box text-align-right">
  ...
</div>
```

## Built-in function

`darken`, `lighten`과 같은 내장된 함수를 사용하면 쉽게 UI 요소의 느낌을 바꿀 수 있다. 부트스트랩이 버튼 UI에 대해 이미 사용하고 있는 방식인데, 예를 들면 `btn:hover`일 때에는 `darken`을 10%정도 줘서 그만큼 더 어둡게 만드는 식이다. 이게 번거로운 반복 작업을 일괄적으로 하게 만드는 장점이 있는데, 이게 곧 테마에 따라 UI의 느낌을 다르게 줄 때에도 시간을 많이 아껴줄 것 같다.

# ETC

## 작업 방법
UI는 언제든 바뀔 수 있는 부분이다. 따라서 어떻게 바꿀지 가늠을 해봐야 하는데 나의 경우에는 그 프로세스를 대략 아래 순서로 진행하는 것 같다.

1. 빠르게 전체를 훑어본다
2. 기존 구조를 유지한 채 개선하는게 좋다면 그렇게 한다
3. 새 구조를 만드는게 나을 것이라고 판단하면, 내용물(텍스트, 이미지)만 남긴채 모든 구조(`box`, inline style)를 해체한다.
  - div가 4중 5중으로 중첩되어 있고, 각각이 어떻게 영향을 주는지 파악이 어려운 경우 등
4. 내용물로부터 새 구조를 설계한다.


## 언어학
나는 뜻밖에도 html, css에서 언어학적인 구조를 느낄 수 있었다. 그 중에서도 흔히 기호학(semiotics)이라고 일컬어지는 '의미론 - 통사론 - 화용론'의 세가지 요소 말이다.

- 의미론 : CSS의 각 선택자가 지칭하는 각각의 사물(UI 요소)들이 지칭하는 대상을 설계
- 통사론 : CSS의 각 성분(스타일)을 HTML의 구조에 적용하고 의미를 해석
- 화용론 : 설계한 UI를 '사람 - 컴퓨터 - 사람' 사이에서 상호작용하는 것

또한 사람과 컴퓨터의 관계적인 측면도 생각해볼 수 있었다.

1. 사람 - 컴퓨터 - 사람
2. 컴퓨터 - 컴퓨터

# 디자이너와 개발자의 소소한 협업
실제 웹서비스는 html, css로만 동작하지는 않는다. 자바스크립트 언어가 html, css와 뒤죽박죽 얽혀서 움직이기 때문에 디자이너가 실제 웹서비스에 변화를 주면서 작업을 하기는 쉽지가 않다. 이 경우, 비대한 웹서비스에서 디자인적 요소만 따로 떼어내어 디자인 작업 전용 레포지토리를 따로 만드는 방법을 시도해볼 수 있다. 작게는 정적파일(css, image, font)만 복사해올 수도 있고, 조금 더 나아가서 여러 scss 파일로 분리된 스타일을 자동 컴파일하게 만들어주고 가볍게 서버를 동작할 수 있도록 만들 수도 있을 것이다. 동적인 작업까지는 어려워도 정적인 뷰를 만들어볼 수는 있으니 조금만 시간을 들여 이런 작업을 같이 진행하면 개발자와 디자이너 간 협업에 있어서 어느 한쪽이 끝나야만 진행이 되는 상황을 벗어나서 각자가 역할을 분담할 수가 있다. 또한 작성한 작업물(css)을 어떻게 사용해야 하는지 UI 스타일 가이드를 제작하는 것도 디자인 전용의 별도의 레포지토리를 만들어두면 작업하기 수월하다.


# Epilogue
내가 작업하는 내용을 세세하게 기록할 수는 없어서 아쉽지만 그래도 이정도를 기록해둘 수 있어서 다행이다. 처음 css를 실습해볼 때에는 아주 지저분하고 논리적으로 해석이 불가능한 것처럼 느껴졌지만 나중에서야 css의 트릭만 익히면 그 안에 나름의 논리가 있음을 알게되었다. 그 다음부터는 점점 더 높은 퀄리티의 결과물이 나왔고 디자이너와 개발자 모두 보람을 느끼게 되었던 것 같다. 나는 많은 경우 **UX, UI, Tech**의 우선순위대로 제품이 제작되었으면 좋겠다고 생각해왔다. 기술에 맞춰서 UX와 UI를 만들면 성능은 좋을지 몰라도 정작 사용자가 쓰기에는 불편한 무엇이 나오지만, UX와 UI에 맞춰서 기술을 최적화하면 사용자를 위한 제품이 나온다고 생각을 하기 때문이다. 그러던 내가 최근 우연한 계기로 UI와 직접적으로 연관된 일을 하게되었다. 아쉽게도 한 번에 모든게 달라질 수는 없었지만, 내가 제품을 위하여 필요하다고 생각하는 변화를 실제로 만들어가는 것은 뜻깊은 경험이었다.
