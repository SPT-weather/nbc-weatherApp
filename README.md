# 🐕 산책갈까?
### 귀여운 날씨앱

**산책갈까?** 는 귀여운 반려동물 이미지를 활용해 날씨 정보를 직관적으로 보여주는 iOS 애플리케이션입니다.  
사용자의 현재 위치나 검색한 지역의 날씨, 기온, 미세먼지 정보를 제공하며, 날씨 상태를 반려동물 캐릭터로 표현합니다.  
MVVM 아키텍처와 RxSwift를 기반으로 반응형 UI를 구현했으며, CoreLocation, OpenWeather API, Kakao Local API를 통해 정확한 위치 기반 날씨 데이터를 제공합니다.

-----

**Project Topic**: 날씨 앱

**Project Name**: 산책갈까?

**Project Period**: 2025. 01. 07 - 2025. 01. 15

**Wire Frame**: 🔗[Figma]((https://www.figma.com/design/Nh5GgraJAG7L9YvbMuL25G/WeatherApp?node-id=0-1&p=f&t=3RmERGUyUaPmcqHg-0))

---

## 🔧 요구사항
- Xcode 버전: 16.1 이상
- iOS 지원 버전: iOS 16.0 이상
- Swift 버전: Swift 5 이상
---

## 🛠️ 기술 스택

- **최소 지원 버전**: iOS 16.0
- **아키텍처**: MVVM (Input/Output 패턴)
- **UI 프레임워크**
  -  UIKit : iOS UI 개발의 기본 프레임워크.
  -  CoreLocation : 사용자 위치 감지와 GPS 데이터 활용.
- **사용 라이브러리**
  - SnapKit : 코드 기반 오토레이아웃 설정.
  - RxSwift : 비동기 데이터 스트림 관리.
  - RxCocoa : UI와 데이터 바인딩 지원.
  - Alamofire : 간편한 네트워킹 구현.
  - SwiftLint : 코드 스타일 검사 및 유지.
- **API**
  - OpenWeather API : 실시간 날씨와 예보 제공.
  - Kakao API : 주소 검색 및 위치 서비스.

------

## ✨ 주요기능
1. **날씨 정보 제공**
   - 현재 위치에 맞는 날씨 정보를 제공합니다.
   - 시간별/일별 예보를 하단 버튼으로 확인할 수 있습니다.
   - 날씨 상태에 따라 귀여운 반려동물 이미지로 시각화합니다.

2. **검색 및 즐겨찾기**
   - 사용자가 원하는 지역을 검색하고, 즐겨찾기에 저장할 수 있습니다.
   - 즐겨찾기한 지역의 현재 날씨도 함께 제공합니다.

3. **설정 기능**
   - 섭씨와 화씨 단위를 전환할 수 있습니다.
   - 화면에 표시될 반려동물 캐릭터를 선택할 수 있습니다.
   - 라이트/다크 모드를 지원합니다.
---
## 📱 화면 구성 
![Screenshot 2025-01-15 at 11 58 55 AM](https://github.com/user-attachments/assets/0214efd3-e0f9-4f02-aba6-8b4178dca07e)

---
## 🧑🏻‍💻 역할 분담
| **박진홍** | **박민석** | **백서희** | **이재영** | **이재훈** |  
| :-: | :-: | :-: | :-: | :-: |
| CoreData구현,<br/> API 구조 설계 | 지역 검색화면,<br/> 설정 화면 | 날씨 상세 모달 | 메인 화면 | 위치 서비스,<br/> 주소 검색 | 

---
##  🌴 Branch Rules & Strategies
### # **코딩 컨벤션**
- **SwiftLint 기본 룰**  
  [SwiftLint 공식 문서](https://github.com/realm/SwiftLint/blob/main/README_KR.md)
### # **커밋 컨벤션**
- **태그**
    - ✨ [Feat]: 새로운 기능 추가
    - 🐝 [Fix]: 버그 수정
    - 📝 [Docs]: 문서 수정
    - 💄 [Style]: 코드 포맷팅, 세미콜론 누락
    - ♻️ [Refactor]: 코드 리팩토링
    - ✅ [Test]: 테스트 코드 추가
    - 🎨 [Chore]: 빌드 업무 수정, 패키지 매니저 수정
### # **브랜치 전략**
1. **main 브랜치**: 프로젝트 기본 세팅
2. **dev 브랜치**: main 브랜치를 기준으로 생성
3. **이슈 브랜치**:  
   - 브랜치 이름 형식: `작업번호-작업-제목` (예: `1-feature-location`)
4. **백로그 관리**:
   - 작업을 백로그에 기록 → To Do → In Progress → Done으로 관리
5. **PR 머지**:
   - 팀원의 70%가 Approve 시 머지 가능
   - PR 템플릿 작성 후 머지
---
