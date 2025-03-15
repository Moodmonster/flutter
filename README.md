# 프로젝트 설명

이 프로젝트는 **클린 아키텍처** 패턴을 따르고 있으며, 데이터, 도메인, 프레젠테이션 레이어를 분리하여 관리합니다.</br>
이는 유지보수성, 테스트 가능성, 확장성을 높여주며, 비즈니스 로직을 UI나 외부 의존성에서 독립적으로 유지하게 합니다.

## Getting Started

1. Flutter SDK 버전: 3.29.2
2. Dart SDK qㅓ전: 3.7.2
3. 빌드 OS: Android, iOS, Web
4. IDE: Android Studio, VS Code, Xcode
5. 패키지 관리: Flutter pub

## 파일 네이밍 규칙

파일은 크게 3가지 파트로 나누어져 있습니다: **파일 이름**, **파일 역할**, **파일 확장자**. 이는 다음과 같이 구성됩니다:

```
{파일 이름}.{파일 역할}.{파일 확장자}
```

## 아키텍처 설명

### 도메인 레이어

도메인 레이어는 비즈니스 로직 엔티티, 유스케이스, 리포지토리 인터페이스를 포함합니다. 앱의 핵심 기능을 정의하며, 외부 라이브러리나 프레임워크에 의존하지 않지 않는 것이
정석입니다.</br>
하지만, 현재 Exception 처리를 위해 `fpdart` 라이브러리에 의존성을 가지고 있습니다.

- **Entities**: `oauth_request.entity.dart`, `user.entity.dart`와 같은 도메인 엔티티가 있습니다. 이는 비즈니스 객체를
  나타냅니다.
- **Repositories**: 데이터 접근 계약을 정의한 파일들로, `auth.i_repository.dart`, `user.i_repository.dart` 등이 있습니다.
  해당 값은 data layer 에서의 의존성을 역전시키기 위해 사용되는 인터페이스 입니다.
- **Usecases**: 앱의 비즈니스 로직이 구현된 곳으로, `sign_in.usecase.dart`, `sign_out.usecase.dart` 등이 있습니다.
- **Voes**: 값 객체로, `user_profile.vo.dart`, `oauth_provider.vo.dart`와 같이 식별이 불가능한 객체들을 나타냅니다. *
  *Entities**에 포함될 수 있습니다.

### 데이터 레이어 (Persistence)

데이터 레이어는 도메인 레이어에서 정의된 계약을 구현하며, 외부 데이터 소스(API, 로컬 스토리지 등)와 상호작용합니다.

- **Data Sources**: `auth.data_source.dart`, `user.data_source.dart`와 같이, 외부 데이터 소스와의 인터페이스를 정의하는
  클래스와 구현체가 있습니다. 구현체 파일의 경우 어느 데이터 소스를 사용할지가 파일 이름에 명시되어 있습니다.
- **DTOs**: 데이터 전송 객체(DTO)로, 레이어 간 데이터 전송 시 사용됩니다. 예: `oauth.request_dto.dart`,
  `user.response_dto.dart`.
- **Repositories**: `auth.repository.dart`, `user.repository.dart`와 같이, 데이터 소스와 상호작용하는 메서드를 정의합니다.
  이는 도메인 레이어의 리포지토리 인터페이스를 구현합니다.

### 프레젠테이션 레이어

프레젠테이션 레이어는 UI 관련 컴포넌트와 뷰 모델을 포함합니다. 사용자와 상호작용하는 앱의 부분입니다.

- **Pages**: 사용자가 상호작용하는 UI 뷰가 정의된 곳으로, `sign_in.page_view.dart`, `profile.page_view.dart` 같은 파일들이
  있습니다.
- **View Models**: UI가 동작하기 위한 상태와 로직이 포함되어 있으며, 예를 들어 `sign_in.view_model.dart`는 로그인 프로세스와 관련된 로직을
  처리합니다.
- **UI Models**: UI 내에서 데이터를 구조화하는 모델로, `request_oauth.ui_model.dart`가 있습니다.
- **State Views**: `signin_btn.state_view.dart`, `gender_selector.state_view.dart`와 같이, 상태에 따라 UI를
  변경하는 위젯들이 있습니다. 해당 위젯과 view model 은 1대1 관계를 가지고 있습니다.
- **Widgets**: 해당 feature 와 연관이 있지만, page 와 state view 에 종속되지 않는 위젯들이 있습니다.

### 공통 유틸리티

`common` 디렉터리는 재사용 가능한 액션, 로컬 스토리지 관리, 위젯들을 포함합니다. 예를 들어 `progress_dialog.widget.dart`는 여러 기능에서 재사용될
수 있는 공통 위젯입니다.

## 의존성 주입

이 프로젝트는 **의존성 주입**을 사용하여 레이어 간 상호작용을 관리합니다. 의존성 주입은 앱의 확장성과 테스트 용이성을 보장합니다. `riverpod` 패키지를 사용하여
의존성을 관리합니다:

- **Data Sources**: 앱 전반에서 사용할 데이터 소스를 주입합니다 (`data_source_provider.dart`).
- **Repositories**: `auth.repository.dart` 같은 리포지토리를 주입합니다 (`repository_provider.dart`).
- **Usecases**: `sign_in.usecase.dart`와 같은 유스케이스를 주입합니다 (`usecase_provider.dart`).
- **View Models**: `sign_in.view_model.dart`와 같은 뷰 모델을 주입합니다 (`view_model_provider.dart`).

## Git 커밋 메시지 규칙

- **Tag Name**: 커밋의 목적을 나타내는 태그입니다.
- **Scope**: 선택 사항이며, 작업 범위를 지정할 수 있습니다. (예: `feat(users)`, `fix(auth)`)
- **Subject**: 태그 뒤에 간결한 설명을 작성합니다. (50자 내외)

### Tag 설명

| Tag Name             | Description                            |
|----------------------|----------------------------------------|
| **feat**             | 새로운 기능을 추가                             |
| **fix**              | 버그 수정                                  |
| **design**           | CSS 등 사용자 UI 디자인 변경                    |
| **!BREAKING CHANGE** | 커다란 API 변경 또는 호환성에 큰 영향이 있는 경우         |
| **!HOTFIX**          | 급하게 치명적인 버그를 수정해야 할 때                  |
| **style**            | 코드 포맷 변경, 세미콜론 누락 등, 코드의 동작에 영향이 없는 경우 |
| **refactor**         | 프로덕션 코드 리팩토링 (기능 변경 없이 구조 개선)          |
| **comment**          | 주석 추가 및 변경                             |
| **docs**             | 문서 수정 (README.md 등의 문서 수정)             |
| **test**             | 테스트 코드 추가 또는 리팩토링                      |
| **chore**            | 빌드 작업 업데이트, 패키지 관리자 설정 변경 등            |
| **rename**           | 파일이나 폴더명 수정 및 이동                       |
| **remove**           | 파일 삭제 작업                               |
| **merge**            | 브랜치 병합 커밋                              |
| **revert**           | 이전 커밋을 취소할 때 사용                        |

### 커밋 메시지 작성 규칙

1. **Tag와 Scope**는 콜론(`:`)으로 구분하며, 태그는 소문자로 작성합니다.
    - 예: `feat(users): add user login feature`
2. **Subject**는 50자 이내로 간결하고 명확하게 작성합니다.
3. **Body**는 선택 사항이지만, 필요한 경우 커밋의 상세 내용을 작성할 수 있습니다. 72자 이하로 작성하는 것이 좋습니다.
4. **BREAKING CHANGE**는 커다란 변경 사항이 발생할 때 사용하며, commit body에 해당 변경에 대한 상세 설명을 포함해야 합니다.
5. **HOTFIX**는 급한 수정 사항에만 사용하며, 꼭 필요한 경우에만 사용합니다.

### 예제

```text
feat(auth): OAuth2.0 로그인 기능 추가

- 구글과 페이스북을 통한 OAuth2.0 로그인 기능을 구현했습니다.
- 인증 모듈에 필요한 의존성을 업데이트했습니다.
```

```text
fix(users): 사용자 프로필 사진 업로드 문제 수정

- 큰 이미지 파일이 제대로 업로드되지 않는 문제를 해결했습니다.
- 서버 측에서 이미지 크기 검증을 추가했습니다.
```

```text
!BREAKING CHANGE: 사용자 인증을 위한 API 계약 변경

- `/auth/login` 엔드포인트에 추가 보안 헤더가 필요합니다.
- 이 변경 사항은 이전 클라이언트와의 호환성을 깨뜨립니다. 반드시 업데이트가 필요합니다.
```

```text
!HOTFIX: 결제 처리 중 발생한 치명적인 버그 수정

- 결제 처리 중 트랜잭션이 실패하는 심각한 문제를 수정했습니다.
```

## Firebase 세팅

1. firebase login (쉘에서 bombee 파이어베이스 프로젝트 접근 권한이 있는 계정으로 로그인 필요)
2. flutterfire configure
3. 2번 단계에서, package name은 "com.jeongtongjib.moodmonster" 로 설정
4. 끝