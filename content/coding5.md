+++
title = "코딩5: 웹 서비스 퍼포먼스 테스트"
date = 2020-05-16T22:15:58+09:00
draft = false
categories = []
tags = []
+++

***

### 배경

웹 서비스의 수행 능력을 파악하기 위한 검증 작업을 ‘웹 서비스 퍼포먼스 테스트(web service performance test)’라고 한다. 퍼포먼스 테스트는 세부 목적에 따라 로드 테스트(load), 스트레스 테스트(stress), 쏘크 테스트(soak), 스파이크 테스트(spike), 설정 테스트(configuration) 등으로 나뉜다. 만약, 웹 서비스의 각 기능들이 종합적으로 정상 동작할 허용 가능한 부하 조건을 파악하는 것이 목적이라면 로드 테스트이고, 특정 부하를 아주 짧은 시간 동안 급증시켜서 서비스를 검증한다면 스파이크 테스트이다. 그리고, 일정한 부하를 계속 유지하며 서비스를 검증한다면 쏘크테스트, 하드웨어 스펙(spec)에 변화를 주며 서비스를 검증한다면 설정 테스트이다.

검증 작업과 분석(test execution and analysis)을 위해서는 검증 수행 동안의 다양한 구성 요소 값의 변화와 원인을 정확히 파악해야 하므로 검증 요소를 제외한 다른 조건들이 통제된 환경을 설계해야 한다. 또한, 환경을 설계하기에 앞서 검증의 목적(objectives)과 검증하려는 범위(scope) 목록을 명확히 해야 한다.

특정 웹 서비스에 대하여 수행한 여러 조건에 대한 각각의 검증 결과들을 종합해보면, 해당 서비스의 허용 조건과 불능 조건을 근사적으로 파악할 수 있을 것이고, 이것은 서비스 엔지니어링 측면의 개선과 내부적인 의사결정에 영향을 주는 요소, 그리고 외부적으로는 고객 성공을 도울 수 있는 참고 지표가 될 수 있을 것이다.

***

### 문서 작성 예시


문서의 흐름은 "1. Objectives → 2. Test Environment → 3. Test design → 4. Test process → 5. Test result → 6. Test analysis" 정도로 구성할 수 있다. 하나씩 살펴보자.

<div style="height: 50px"></div>

#### "1. Objectives"에는 조건을 명확하게 특정한다.

eg.

> 본 테스트의 목적은 A 서비스의 이벤트 B 요청 횟수를 극한 조건 이상으로 늘리는  부하 상황에 대한 스트레스 테스트를 진행하는 것이다.

<div style="height: 50px"></div>

#### "2. Test environment"에는 서비스의 하드웨어 인프라 스펙을 서술한다.


eg. Service Server

- Instance type: AWS EC2
- Instance count: 8 (min:4, max: 8)
- Instance type: c4.8xlarge
- OS version: Ubuntu 19.04 LTS
- Region: ap-southeast-1

<div style="height: 50px"></div>

#### "3. Test design"에는 검증을 위해서 설계해야 하는 부분을 서술한다.

eg. 초기 데이터 조건

- Group
  - Count: 1
  - Name: A
  - Allowable bucket count: 1000
- Member
  - Count: 1,000,000
  - Member’s Group name: A
  - Joined at May 16, 2020 (UTC)

<div style="height: 50px"></div>

#### "4. Test process"에는 검증을 위한 절차를 서술한다.

eg.

1. May 16, 2020 at 10:00 AM (UTC)에 시나리오 1를 동작시킨다.
2. May 16, 2020 at 10:30 AM (UTC)에 시나리오 2를 동작시킨다.
3. May 16, 2020 at 12:30 AM (UTC)에 시나리오 3를 동작시킨다.

- 시나리오 1: 50,000명의 가상 동시 접속자(VU)가 초당 50회로 서비스의 기능 Q, W, E API의 요청을 "ap-southeast-1"로부터 "ap-southeast-1"에 400분 간 요청한다.
  - VU: 50,000
  - Ramp up: 10m
  - Hold for: 400m
- 시나리오 2: 1,000,000명의 가상 동시 접속자가 초당 기능 Z의 API를 "ap-southeast-1"로부터 "ap-southeast-1"에 20분 간 요청한다.
  - VU: 1,000,000
  - Ramp up: 50m
  - Hold for: 100m
- 시나리오 3: 10,000,000명의 가상 동시 접속자가 초당 기능 Z의 API를 "ap-southeast-1"로부터 "ap-southeast-1"에 100분 간 요청한다.
  - VU: 10,000,000
  - Ramp up: 50m
  - Hold for: 100m

<div style="height: 50px"></div>

#### "5. Test result"에는 결과 요약과 타임라인을 서술한다.

eg. Summary

- 기능 Z API는 동시 접속자 수의 증가와 초당 요청 횟수가 x 증가할 때마다 서버 P의 CPU 사용률을 p 증가시켰다.

eg. Timeline

- 10:30 AM (UTC)
  - 시나리오 1의 동작 시작
- 10:30 AM (UTC)
  - 시나리오 2의 동작 시작
- 10:45 AM
  - 기능 W, E의 동작이 acceptance range인 ‘lantency 1s’를 초과

<div style="height: 50px"></div>

#### "6. Test analysis"에는 실행한 검증을 분석한 내용을 서술한다. 시각화 정보가 있다면 함께 첨부한다.

eg. Summary

- 기능 Z API는 동시 접속자 수의 증가와 초당 요청 횟수가 X일 때, 서버 P를 다운시켰다.
- 기능 Z API는 동시 접속자 수의 증가와 초당 요청 횟수가 X일 때, 서버 Q에 유의미한 변화를 주지 않았다.

eg. Infrastructure graph/table

(인프라 컴포넌트의 그래프 및 표 첨부, 시나리오 테스터 서버의 API 요청 횟수, latency 변화 추이 등 첨부)

***
### 구현 방법론 예시

1. 검증이 서비스 데이터와 인프라 환경에 미칠 수 있는 영향을 파악하기 위하여 서비스 내부의 데이터 개체(entity) 간 관계를 기술한다. 필요시 다이어그램의 형태로 작성한다.
2. 초기 데이터를 구축하기 위한 방법을 설정한다. 가급적 실제 서비스 환경에 근접하게 (예를 들면, 실제 사용자가 처음 가입해서 특정 기능들을 사용할 때까지의 과정과 유사하게) 데이터를 재현한다. 이 과정에서 각 개체 간 연관성이 있다면 데이터를 인출하지 않고서도 연결고리를 특정하기 위해서 개체의 property 값에 일정한 규칙을 주는 방법을 시도해볼 수 있다. 데이터 구축은 개체 간 의존성에 따라 단계를 분리하여 순차적으로 진행한다.
3. 시나리오를 설계한다. 발생할 부하가 동시 접속자의 기능 요청으로 인한 것인지, 데이터의 양이나 값의 급격한 변화 때문인지를 분리해서 파악할 수 있도록 시나리오를 설계한다. 로드 테스트를 수행한다면, 헬스체크를 하는 시나리오에 Performance acceptance list를 상세하게 작성해야 검증하려는 요소를 잘 측정할 수 있을 것이다. 시나리오 1개가 다른 시나리오를 포함한다면 수행 시간에 주의하여 작성한다.

***

### etc

- Performance acceptance list를 정의하여 서비스의 동작의 정상 동작 유무를 판단할 기준을 세울 수 있다.
  - 'Acceptable → Questionable → Unacceptable'

***

### References

- https://en.wikipedia.org/wiki/Software_performance_testing
- https://pdfs.semanticscholar.org/a2ff/c8cca5b3aa3302dcb3a05517e8c763314a1f.pdf
- https://www.neotys.com/wp-content/uploads/2018/01/WP__A_Practical_Guide_to_Performance_Testing-EN.pdf
- https://www.stickyminds.com/sites/default/files/article/file/2013/Load-Performance-Test-Plan-Template.pdf
