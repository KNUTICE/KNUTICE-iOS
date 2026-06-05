![](https://velog.velcdn.com/images/jeunghun2/post/8dfaa8dc-b3d3-4378-a896-71ec8b4ceab4/image.png)


[![Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917](https://github.com/user-attachments/assets/0dd1e613-7ed0-48ce-a875-95124a2aa6a3)](https://apps.apple.com/kr/app/knutice/id6547855991)

<br>

# 💁‍♂️ Service Introduction
- 새로운 공지 사항을 앱 푸시 알림으로 전달하는 공지 사항 알리미와 대학 생활에 필요한 정보를 빠르게 전달하는 캠퍼스 생활 유틸리티

<br>

# 🙋‍♂️ Part
- KNUTICE iOS 어플리케이션 기획, 설계, 개발, 디자인


<br>

# ⚒️ Tech Stack
- `Swift`, `iOS`, `UIKit`, `SwiftUI`, `MVVM`, `Clean Architecture`, `TCA`, `RxSwift`, `Combine`, `Swift Concurrency`, `Tuist`, `Alamofire`, `CoreData`, `Firebase`, `Xcode Cloud`, `XCTest`

<br>

# ⚙️ Architecture
- MVVM + Clean Architecture
![](https://velog.velcdn.com/images/jeunghun2/post/da6a081b-700f-4c35-ba68-68256fdb2edd/image.png)

<br>

# 💡 Trouble Shooting
1. Tuist 도입을 통한 모듈화 및 빌드 성능 개선
- 위젯 익스텐션 등에서 앱 모듈의 공지 조회와 같은 로직을 각각 구현해야 했으며, 기능 변경 시 수정 범위가 여러 타깃으로 확산되는 문제 발생
- Swift 기반 프로젝트 설정으로 반복적인 세팅 값 재사용, 모듈 단위 캐싱을 통해 빌드 시간을 단축, git에 xcodeproj 파일을 포함하지 않아 Git 충돌 이슈를 해소할 수 있는 장점을 활용하기 위해 Tuist를 도입하여 프로젝트를 관심사별로 모듈화하고, Swift를 활용한 프로젝트 세팅으로 반복적인 세팅 값을 재사용 가능한 구조로 개선
- 코드 재사용성을 확보하고, 클린 빌드 시간을 50초에서 15초로 개선할 수 있었음
2. Feature 모듈 간 순환 참조 문제를 인터페이스 기반으로 의존성 분리
- Notice 모듈에서 북마크 저장을 위해 Bookmark 모듈을 참조해야 했고, Bookmark 모듈에서도 공지 조회를 위해 Notice 모듈을 참조하면서 순환 의존성으로 빌드 에러 발생
- Feature 모듈에서 모듈 간 직접적인 의존을 피하기 위해 인터페이스로 추상화하고, 실제 의존성은 App 모듈에서 주입하도록 변경하여 순환 참조 이슈 해결
3. 앱 재방문 빈도와 콘텐츠 접근 비율이 낮은 문제를 UI 재배치를 통한 콘텐츠 소비율 개선
- 사용자가 공지 사항을 확인하는 목적 외에는 재방문 빈도가 낮았고, 앱 진입 후 콘텐츠 조회 비율 또한 약 38%에 머무르는 문제 발생
- 사용자들의 이용 패턴을 분석하고 '학식 메뉴 조회'와 '열람실 좌석 조회’ 기능에 대한 수요가 많다는 근거를 바탕으로 팀에 두 기능을 메인 화면 최상단에 배치 제안
- 앱 재방문 횟수는 약 280% 증가했으며, 진입한 사용자가 자연스럽게 공지까지 확인하는 선순환 구조가 형성되어 콘텐츠 조회 비율이 58%로 증가
4. Clean Architecture 기반 계층 구조 개편
- 비즈니스 로직이 ViewModel에 구현되어 있으면 테스트 시 UI 계층까지 함께 테스트해야 했고, 핵심 비즈니스 로직을 독립적으로 검증하기 어려운 문제 발생
- 기본적인 MVVM + Repository 패턴의 아키텍처 구조에서 Clean Architecture 기반으로 리팩토링하여 계층 간 책임을 명확하게 분리하고 의존성을 도메인으로 향하도록 구조 개선
- 계층별 관심사를 명확하게 분리하여 각 계층을 독립적으로 관리하여 테스트 용이성이 증가하고, UIKit에서 SwiftUI로 변경 혹은 데이터 계층의 코드 수정이 도메인 계층의 수정을
최소화할 수 있었음
5. 단방향 데이터 흐름으로 예측 가능한 구조로 개선
- ViewModel에서 데이터 조회, 로딩 처리, Alert 표시 등 서로 다른 위치에서 상태 값을 직접 수정하는 구조로 구현되어 특정 상태가 어떤 이벤트에 의해 변경되었는지 추적하기 어려운 문
제가 발생하고, 예상치 못한 화면 상태가 발생하는 문제 존재
- 단방향 데이터 흐름, State와 Effect의 독립적인 관리, 테스트에서 액션 -> 상태 변화 흐름을 단계적으로 검증할 수 있는 구조를 도입하기 위해 TCA 선택
- TCA 아키텍처를 도입하여 단방향 데이터 플로우 기반으로 모든 상태 변경은 Reducer 내부에서만 가능하도록 개선하여 상태 추적의 복잡도를 낮추고, 디버깅이 용이해졌으며, 테스트 용이한 구조로 전환되어 안정성 향상

# 🧐 What I learned
프로젝트 기획부터 개발, 실제 앱스토어 배포에 이르기까지 서비스 런칭과 운영 전 과정을 직접 주도적으로 경험할 수 있었음
- UIKit, SwiftUI
  - AutoLayout을 활용하여 다양한 화면 크기와 방향에서 View를 배치하고, 동적으로 변하는 UI 요소에 유연하게 대응하는 방법을 알게 되었음
  - SwiftUI의 데이터 상태에 따른 View 갱신 알고리즘과 데이터 의존성을 분리하여 SwiftUI의 성능을 향상하는 방법을 알게 되었음
- TCA
  - TCA의 단방향 데이터 흐름을 통해 상태 변경을 한 곳에서 관리하고, 예측 가능한 구조를 바탕으로 선언형 UI의 이점을 극대화하는 설계 방식을 알게 되었음
- Tuist
  - Tuist를 활용한 모듈화 구조 설계를 통해 기능 단위로 의존성을 분리하고, 빌드 시간 단축과 코드 재사용성을 높이는 프로젝트 구성 방식을 알게 되었음
- Combine, RxSwift
  - 비동기 네트워크 요청과 응답을 처리하기 위해 Publisher와 Subscriber 기반의 데이터 스트림을 생성하여 반응형 프로그래밍을 구현하는 방법에 대해 알게 되었음
  - Combine에서 제공하는 다양한 연산자(map, flatMap, merge, debounce 등)를 활용하여 데이터를 변환, 통합하는 방법에 대해 알게 되었음
- Swift Concurrency
  - GCD 대비 Swift Concurrency가 가지는 성능적 장점을 이해하고 사용할 수 있음
  - async/await, async-let, Task Tree, Actor 등을 활용하여 비동기 코드에서 구조적 프로그래밍이 가능하도록 코드를 작성하는 방법을 알게 되었음
- Core Data
  - Persistent Storage에 데이터 CRUD(저장, 조회, 갱신, 삭제) 방법에 대해 알게 되었음
- CI/CD
  - Xcode Cloud를 이용한 CI/CD 환경 구축 및 빌드 자동화, 테스트 자동화, 배포 자동화 파이프라인 구축하는 방법에 대해 알게 되었음

<br>

# 📱 Preview
<div style="display: flex; justify-content: center; margin-bottom: 10px;">
    <img src="https://velog.velcdn.com/images/jeunghun2/post/a8346fed-50b5-4308-a699-b276c816d7a0/image.png" style="width: 30%; margin-right: 10px"/>

   <img src="https://velog.velcdn.com/images/jeunghun2/post/582e5ee9-fe72-4543-ab6b-12a78e5f02ba/image.png" style="width: 30%; margin-right: 10px">

   <img src="https://velog.velcdn.com/images/jeunghun2/post/182aa9ff-5ddf-4870-8876-558b1ddc17a4/image.png" style="width: 30%; margin-right: 10px"/>

   <img src="https://velog.velcdn.com/images/jeunghun2/post/13cf7c62-3f9f-4690-9fcc-9f54024479c2/image.png" style="width: 30%; margin-right: 10px"/>

   <img src="https://velog.velcdn.com/images/jeunghun2/post/da50d16d-4fbd-4e72-bf74-b79736e04df4/image.png" style="width: 30%"/>
</div>

<div style="display: flex; justify-content: center; margin-bottom: 10px;">
    <img src="https://velog.velcdn.com/images/jeunghun2/post/c39ef8d1-62f8-4592-a2fb-e00d0c38e146/image.png" style="width: 30%; margin-right: 10px"/>

   <img src="https://velog.velcdn.com/images/jeunghun2/post/c2a2de2a-6069-4ff9-8418-03d80d55bcb6/image.png" style="width: 30%; margin-right: 10px">

   <img src="https://velog.velcdn.com/images/jeunghun2/post/3a557f46-7f7d-4d28-8884-6a86f39f0c93/image.png" style="width: 30%; margin-right: 10px"/>

   <img src="https://velog.velcdn.com/images/jeunghun2/post/f4063192-f227-45ed-a6fc-4be4ae3d31c1/image.png" style="width: 30%; margin-right: 10px"/>

   <img src="https://velog.velcdn.com/images/jeunghun2/post/83f3ce4d-6ceb-4cce-a5e3-391a04fcbf49/image.png" style="width: 30%"/>
</div>
