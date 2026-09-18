# 인계 메모 (본체 PC로 작업 환경 이전용)

작성일: 2026-09-19
목적: 노트북(안랩 등 보안 소프트웨어로 Firebase 세션 버그 의심)에서 본체 PC로 작업 환경을 옮기기 위한 전체 상황 정리. 새 Claude 세션에 이 파일 내용을 붙여넣으면 바로 이어서 작업 가능하도록 작성함.

---

## 1. 프로젝트 개요

- NCS 시험용 "여행 커뮤니티" 웹사이트. 최종 목표는 Java + Oracle + JSP.
- 지금 단계는 **이벤트 위주의 목업**을 먼저 완성하는 중이며, 실제 DB(Oracle) 대신 **Firebase(Authentication + Firestore + Storage)**를 임시 백엔드로 써서 "진짜처럼 동작하는" 화면을 만들고 있음.
- 나중에 Oracle/JDBC로 옮길 때는 `posts-store.js` 같은 데이터 접근 계층만 서버 API 호출로 바꾸면 되도록 함수 시그니처를 단순하게 유지해둠.
- 역할 분담(기획서 기준): 유우카 = 화면/디자인, 노아(사용자) = 로그인·권한·데이터·검색·로그 등 로직/백엔드.

## 2. 저장소

- GitHub: `https://github.com/noadot-pixel/ai2giTrable.git`
- 계정: `noadot-pixel` (커밋 author), 이메일 `yihionho@gmail.com`
- 브랜치: `main` 하나만 사용 중 (혼자 작업)
- 로컬 원본 경로(노트북): `C:\Users\yihen\OneDrive\바탕 화면\trable_project`

## 3. 로컬 개발 환경 (노트북 기준 — 본체 PC에도 동일하게 구성 필요)

- JDK 17 (`C:\Program Files\Java\jdk-17`)
- Tomcat 10.1.59 (`C:\apache-tomcat-10.1.59`) — **Tomcat 10 = Jakarta EE 6.0 (jakarta.servlet, javax 아님)**. `main/webapp/WEB-INF/web.xml`도 `web-app_6_0.xsd` 기준으로 작성돼 있음. 본체에도 반드시 **Tomcat 10.x** 계열로 설치할 것 (Tomcat 9는 javax라서 호환 안 됨).
- 포트: HTTP **8081** (8080은 Oracle DB 리스너가 이미 점유), 종료포트 **8006** (8005는 Eclipse가 점유). 본체 PC는 뭐가 점유 중인지 다시 확인 필요.
- 웹앱 루트는 `main/webapp` (Eclipse Dynamic Web Project 구조: `WEB-INF/web.xml`, `META-INF/MANIFEST.MF` 포함). 저장소 루트가 아니라 **`main/webapp`이 실제 배포 대상**.
- Tomcat의 `webapps\trable` 폴더는 `main/webapp`을 가리키는 **정션(junction)**으로 연결돼 있음 → 파일 수정 시 재배포 없이 바로 반영됨. 단, **`web.xml` 수정은 Tomcat 재시작이 필요함** (JSP는 자동 반영, web.xml은 컨텍스트 로드 시점에만 읽음).
- 접속 주소: `http://localhost:8081/trable/index.jsp`

### 본체 PC 현재 상태 (2026-09-19 구성 완료)
- 프로젝트 경로: `C:\AI2GI\ai2giTrable` (노트북 경로와 다름)
- Tomcat 10.1.59: `C:\apache-tomcat-10.1.59`, HTTP 8081 / 종료 8006, `webapps\trable` → `C:\AI2GI\ai2giTrable\main\webapp` 정션 연결됨
- JDK 17(`C:\Program Files\Java\jdk-17`)과 JDK 25가 함께 설치돼 있고 기본 `java`는 25 → Tomcat 실행 시 `JAVA_HOME`을 JDK 17로 지정해서 띄울 것
- VS Code Java 확장 팩(`vscjava.vscode-java-pack` 등)은 설치돼 있음
- **노트북은 더 이상 작업에 쓰지 않음.** 본체에서만 작업.

### (참고) 본체 PC에서 처음 할 일 (환경 구성) — 위 항목은 이미 완료됨
```powershell
# 1) JDK 확인/설치 (없으면)
winget install --id Git.Git -e --source winget   # git은 이미 있다고 하셨으니 생략 가능
java -version   # 없으면 JDK 17 설치 필요

# 2) Tomcat 10.1.x 압축 풀어서 C:\apache-tomcat-10.1.x 같은 곳에 배치

# 3) 포트 충돌 확인 후 필요하면 conf/server.xml에서 Connector port, Server port(종료포트) 수정
Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
Get-NetTCPConnection -LocalPort 8005 -ErrorAction SilentlyContinue

# 4) git clone
git clone https://github.com/noadot-pixel/ai2giTrable.git "C:\원하는 경로\trable_project"

# 5) webapps에 정션 생성 (Tomcat 경로/버전은 실제 설치 경로로 교체)
New-Item -ItemType Junction -Path "C:\apache-tomcat-10.1.x\webapps\trable" -Target "C:\원하는 경로\trable_project\main\webapp"

# 6) Tomcat 기동
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
$env:CATALINA_HOME = "C:\apache-tomcat-10.1.x"
Start-Process -FilePath "C:\apache-tomcat-10.1.x\bin\startup.bat" -WindowStyle Hidden

# 종료할 때
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
$env:CATALINA_HOME = "C:\apache-tomcat-10.1.x"
& "C:\apache-tomcat-10.1.x\bin\shutdown.bat"
```

## 4. Git 사용법 (자세히)

### 기본 개념
- **pull** = GitHub(원격 저장소)의 최신 내용을 내 컴퓨터로 받아오기
- **push** = 내 컴퓨터에서 커밋한 내용을 GitHub로 올리기
- 지금은 노트북/본체 두 곳에서 오갈 수 있으니, **작업 시작 전엔 항상 pull, 작업 끝나면 항상 push**가 원칙.

### 처음 한 번만 (본체 PC, clone 직후)
```powershell
cd "C:\원하는 경로\trable_project"
git config user.name "noadot-pixel"
git config user.email "yihionho@gmail.com"
```
첫 `git push`나 `git pull` 시 GitHub 로그인 창(브라우저)이 뜰 수 있음 — `noadot-pixel` 계정으로 로그인하면 자격 증명이 Windows에 저장되어 이후엔 다시 로그인 안 해도 됨 (노트북에서도 이 방식으로 했었음).

### 작업 시작할 때마다 (pull)
```powershell
git status            # 혹시 내 컴퓨터에 커밋 안 한 변경사항이 있는지 먼저 확인
git pull origin main  # 최신 내용 받아오기
```
- `git status`에서 "Changes not staged" 같은 게 있는데 pull부터 하면 충돌날 수 있음 → 그 전에 커밋하거나 `git stash`로 잠깐 치워두기.

### 작업 끝났을 때마다 (push)
```powershell
git status                     # 뭐가 바뀌었는지 확인 (의도한 파일만 바뀌었는지 체크)
git add -A                     # 전체 변경사항 스테이징
git commit -m "무엇을 했는지 한 줄 요약"
git push origin main
```

### 충돌(conflict)이 나면
- 원인: 노트북/본체 양쪽에서 pull 안 하고 같은 파일을 각자 고친 뒤 push한 경우.
- 지금처럼 한 사람이 한 번에 한 곳에서만 작업하면 거의 안 생김. **본체로 넘어간 이후엔 노트북에서는 작업하지 말 것.**
- 혹시 나면: `git status`로 충돌 파일 확인 → 파일 열어서 `<<<<<<< HEAD`, `=======`, `>>>>>>>` 구분선 사이 내용을 직접 정리 → `git add <파일>` → `git commit`.

### 자주 쓰는 확인 명령
```powershell
git log --oneline -10   # 최근 커밋 10개 요약 보기
git remote -v           # 원격 저장소 주소 확인
```

## 5. Firebase 프로젝트 설정

- 프로젝트: **ai2gi-project-01** (`https://console.firebase.google.com/project/ai2gi-project-01`)
- 클라이언트 설정값(공개돼도 안전한 값 — `main/webapp/common/firebase-init.jspf`에 하드코딩돼 있음):
  ```js
  {
    apiKey: "AIzaSyAythcpdfR-tuSQEzFkw8EKRwNEfnC7bJE",
    authDomain: "ai2gi-project-01.firebaseapp.com",
    projectId: "ai2gi-project-01",
    storageBucket: "ai2gi-project-01.firebasestorage.app",
    messagingSenderId: "34655357322",
    appId: "1:34655357322:web:d7f146b0ccd5bc15f3a073"
  }
  ```
- SDK는 **compat 빌드**(v8 스타일, `firebase.auth()`, `firebase.firestore()`, `firebase.storage()`) 버전 **11.6.0**을 CDN(`www.gstatic.com/firebasejs/...`)에서 로드. 로그인/회원가입도 원래 모듈 방식이었다가 전부 compat으로 통일함.
- **Authentication**: 이메일/비밀번호 로그인 활성화됨.
- **Firestore**: 프로덕션 모드로 활성화됨. 규칙은 아래 6번.
- **Storage**: 활성화됨 (Blaze 요금제로 업그레이드 필요했음 — 무료 Spark 플랜은 Storage 새로 시작 불가). 규칙은 아래 7번.
- **관리자 계정**: `yihenry@naver.com` / uid `vgtiyBLYmAgZRXmO38z2UkKTnDR2`
  - Firestore `admins` 컬렉션에 이 uid로 문서가 존재함 (필드 없이, 존재 자체가 관리자 표시). **admins 컬렉션 문서는 클라이언트에서 못 쓰게 막아놔서 콘솔에서 직접 추가/삭제해야 함.**
  - 이 계정은 콘솔에서 직접 만든 계정이라 `users` 컬렉션엔 원래 기록이 없었음 (회원가입 화면을 거치지 않았기 때문). 지금은 예시 게시글 9개의 작성자로 재지정해둠.
- **예시 게시글 9개**: `posts` 컬렉션에 시드 데이터로 들어가 있음 (한국/일본/세계 각 3개), 전부 `authorUid`가 위 관리자 계정으로 되어 있어서 그 계정으로 로그인하면 전부 수정/삭제 가능.
  - 관리자 화면(`/admin/index.jsp`)에 "예시 게시글 시드 추가" 버튼이 있음 — `posts` 컬렉션이 비어있을 때만 동작(이미 있으면 무시).
  - **주의**: 시드 데이터를 PowerShell(REST API)로 직접 넣었을 때 한글이 `?`로 깨진 적 있었음 (Windows PowerShell 5.1이 기본적으로 UTF-8이 아닌 인코딩으로 요청 본문을 보내서 생긴 문제). REST API로 뭔가 넣을 일이 있으면 **반드시 `[System.Text.Encoding]::UTF8.GetBytes(...)`로 직접 바이트 변환해서 body로 보낼 것**, 그냥 문자열을 바디로 주면 깨짐.

## 6. Firestore 보안 규칙 (현재 적용된 최종본)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isSignedIn() {
      return request.auth != null;
    }

    function isAdmin() {
      return isSignedIn() &&
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }

    match /posts/{postId} {
      allow read: if true;
      allow create: if isSignedIn();
      allow update, delete: if isSignedIn() &&
        (resource.data.authorUid == request.auth.uid || isAdmin());
    }

    match /postLogs/{logId} {
      allow read: if isAdmin();
      allow create: if isSignedIn();
      allow update, delete: if false;
    }

    match /users/{uid} {
      allow read: if true;
      allow create: if isSignedIn() && request.auth.uid == uid;
      allow update: if isSignedIn() && request.auth.uid == uid;
      allow delete: if false;
    }

    match /admins/{uid} {
      allow read: if isSignedIn() && request.auth.uid == uid;
      allow write: if false;
    }
  }
}
```

- `users` 컬렉션을 공개 읽기로 열어둔 이유: 게시글 작성자의 자기소개/국가 등을 **비로그인 방문자도 볼 수 있게** 하기 위함(작성자 정보 카드 기능, 아래 8번 참고). 이메일 등 민감한 필드는 화면에 표시만 안 할 뿐 문서 자체는 공개라는 점 인지하고 있을 것.
- Firestore/Storage 콘솔에서 규칙 텍스트를 붙여넣기만 하고 **"게시" 버튼을 안 누르면 적용 안 됨** — 이 프로젝트 하면서 두 번이나 이걸로 헤맸음. 규칙 수정하면 꼭 게시 버튼 확인.

## 7. Storage 보안 규칙 (현재 적용된 최종본, 동작 확인됨)

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /profile-images/{uid} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == uid
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

- `profile-images/{uid}` 경로만 허용됨. **게시글 사진 첨부는 아직 실제 업로드가 아님** — write.jsp/edit.jsp의 "사진 첨부" 입력은 지금도 장식용이고, 실제로는 국가별 고정 이미지(korea.jpg/japan.jpg/world.jpg)를 그대로 씀. 게시글 이미지도 진짜 업로드하려면 Storage 규칙에 `post-images/...` 같은 경로를 추가하고 write.jsp/edit.jsp에 업로드 로직을 새로 붙여야 함.
- PowerShell REST API로 업로드/다운로드 직접 테스트해서 규칙 자체는 정상 동작 확인함 (삭제만 규칙상 막혀있는데, 앱에서 실제로 삭제 기능을 안 쓰니 문제 없음).

## 8. Firestore 데이터 모델

- **`posts/{postId}`**: `title`, `body`, `country`(`KR`/`JP`/`ETC`), `countryLabel`(예: "한국 여행지"), `style`(`healing`/`food`/`activity`/`shopping`), `image`(파일명), `authorUid`, `authorNickname`, `createdAt`(ISO 문자열), `views`(number), `comments`(number)
- **`postLogs/{logId}`**: `type`(`CREATE`/`UPDATE`/`DELETE`), `postId`, `postTitle`, `actorUid`, `actorNickname`, `time`(ISO 문자열) — 게시글 작성/수정/삭제할 때마다 `js/posts-store.js`가 자동으로 기록함
- **`users/{uid}`**: `nickname`, `email`, `joinedDate`, `status`(현재는 항상 "활성", 정지 기능 없음), `bio`, `country`, `countryOther`, `emailLocal`, `emailDomain`, `emailDomainOther`, `birthday`, `birthdayVisibility`(`public`/`private`), `name`, `nameVisibility`(`public`/`private`), `photoUrl`
  - `signup.jsp`가 가입 시 `nickname`/`email`/`joinedDate`/`status`만 최소로 기록
  - `mypage/edit.jsp`가 나머지 필드까지 채움 (프로필 수정 화면)
- **`admins/{uid}`**: 필드 없이 존재 여부만 확인. 콘솔에서만 추가 가능.

## 9. 페이지/기능 구성

| 경로 | 설명 |
|---|---|
| `index.jsp` | 메인. 국가별 최신 게시물 3개씩(Firestore 실시간 로드), 카테고리 카드, 전체보기/더보기가 `posts.jsp?country=..`/`?style=..`로 필터 지정해서 연결됨 |
| `posts.jsp` | 게시글 목록. 국가/성향 필터, 검색, 정렬(최신/인기), 작성자 정보 카드, 본인 글(또는 관리자)이면 수정/삭제 버튼 |
| `posts/detail.jsp` | 상세. Firestore에서 `id` 파라미터로 문서 조회. 작성자 본인/관리자만 수정·삭제 가능 |
| `posts/write.jsp` | 글쓰기. 비로그인 시 confirm으로 로그인 유도. 여행지 구분(국내/일본/해외) + 여행 성향(힐링/맛집/액티비티/쇼핑) 2중 태그 |
| `posts/edit.jsp` | 수정. 작성자 본인 또는 관리자만 접근 가능(가드 실패 시 상세/목록으로 리다이렉트) |
| `auth/login.jsp` | 로그인. Firebase Authentication 이메일/비밀번호 |
| `auth/signup.jsp` | 회원가입. 계정 생성 + `users` 문서 최소 필드 기록 |
| `mypage.jsp` | **보기 전용** 마이페이지. 프로필 카드 + 내가 쓴 글 목록(수정/삭제 가능) |
| `mypage/edit.jsp` | 프로필 수정 + 프로필 이미지 업로드(Storage) |
| `admin/index.jsp` | 관리자 메인. "예시 게시글 시드 추가" 버튼 |
| `admin/users.jsp` | 회원 관리. `users` 컬렉션 실제 조회, 닉네임/이메일 검색 |
| `admin/post-logs.jsp` | 게시글 로그. `postLogs` 컬렉션 실제 조회, 작업 종류 필터 |
| `error.jsp` | 404/403/500 발생 시 Tomcat이 자동 연결 (`web.xml`의 `<error-page>`) |

### 공통 조각 (`main/webapp/common/`)
- `header.jspf` / `footer.jspf`: 모든 페이지가 include. 헤더 nav는 현재 "홈", "커뮤니티"(→`posts.jsp`) 두 개만 있음(사용자가 직접 정리함). 로그인 시 "글쓰기/마이페이지/닉네임님/로그아웃", 관리자면 "관리자" 링크도 추가됨.
- `firebase-init.jspf`: Firebase compat SDK 스크립트 태그 + `firebase.initializeApp(...)` (중복 include돼도 `if (!firebase.apps.length)`로 안전).
- `auth-scripts.jspf`: `firebase-init.jspf` include + `mock-auth.js` 로드 + 헤더의 로그인/로그아웃 상태 렌더링.

### 공용 JS (`main/webapp/js/`)
- `mock-auth.js`: **실제 Firebase 인증과는 별개로** localStorage에 `{id, email, nickname}`을 저장해서 헤더 표시용으로 쓰는 자체 장치(`mockAuth.login/logout/getCurrentUser/isLoggedIn`). `isAdmin()`은 비동기로 Firestore `admins/{uid}` 문서 존재 여부를 확인함.
- `posts-store.js`: Firestore `posts`/`postLogs` CRUD 공용 함수 (`getAllPosts`, `getPostById`, `createPost`, `updatePost`, `deletePost`, `getAllLogs`, `seedIfEmpty`). 나중에 Oracle로 옮길 때 이 파일만 서버 API 호출로 바꾸면 되도록 설계함.
- `author-info.js`: 게시글 카드/상세에 작성자의 자기소개·국가를 **항상 바로 보이게**(호버 아님) 렌더링. `.author-info` 요소에 `data-author-uid`를 채워두면 알아서 채워짐.

## 10. ✅ 해결됨: "다른 페이지로 이동하면 Firebase 로그인이 풀리는" 문제 (2026-09-19)

**증상**: 로그인은 성공하는데 다른 페이지에서 로그인이 필요한 Firestore/Storage **쓰기**(프로필 저장, 이미지 업로드, 게시글 작성 등)가 "Missing or insufficient permissions"로 실패하고, `firebase.auth().currentUser`가 `null`로 보임. (읽기는 대부분 공개 규칙이라 화면은 멀쩡해 보였음. `mockAuth`(localStorage)가 헤더에 닉네임을 잘 보여줘서 "로그인된 줄" 착각하기 쉬웠음.)

**원인**: 안랩/노트북 환경 문제가 아니라 **타이밍 문제**였음. Firebase Auth는 저장된 세션(IndexedDB)을 **비동기로 복원**하기 때문에, 페이지 로드 직후에는 `currentUser`가 잠깐 `null`임. 코드가 복원이 끝나기 전에 `currentUser`를 동기로 읽거나 쓰기를 시작해서 실패한 것. 본체 PC에서도 똑같이 재현되어 환경 문제가 아님을 확인함. (`mypage.jsp` 콘솔에서 `onAuthStateChanged`로 기다린 뒤에는 Firebase uid와 mockAuth id가 일치했고 쓰기도 성공함.)

**해결 (구현 완료)**:
- `common/firebase-init.jspf`: 전역 `window.authReady`(세션 복원 완료 시 유저 또는 `null`로 resolve되는 Promise)를 추가. 복원에 걸린 시간을 콘솔에 `[authReady] …ms`로 출력. 이 조각이 한 페이지에 여러 번 include돼도 SDK를 한 번만 로드하도록 가드(전에는 `admin/*.jsp`, `posts/edit.jsp`에서 SDK가 중복 로드돼 전역 `firebase` 객체가 덮어써짐).
- `js/posts-store.js`: `createPost/updatePost/deletePost/seedIfEmpty`는 `ensureSignedIn()`(= `await authReady`)을 먼저 수행. `getAllLogs`도 복원 후 조회.
- `js/mock-auth.js`: `isAdmin()`이 `admins/{uid}`(로그인 본인만 읽기 가능)를 읽기 전에 `await authReady`.
- `mypage/edit.jsp`: 저장 시 `firebase.auth().currentUser` 동기 검사를 `await authReady`로 교체. 이미지 없이 저장할 때도 세션을 확인.
- `auth/login.jsp`: 디버그 로그, 효과 없던 500ms 지연, `setPersistence` 호출 제거.

**앞으로의 규칙**: 로그인 상태가 필요한 Firebase 호출(쓰기, `admins`/`postLogs` 읽기, Storage 업로드)은 **반드시 `await window.authReady` 뒤에** 실행할 것. `firebase.auth().currentUser`를 페이지 로드 직후 동기로 읽지 말 것.

**참고**: 콘솔의 "A listener indicated an asynchronous response by returning true, but the message channel closed…"는 브라우저 확장 프로그램이 내는 에러라 Firebase와 무관함(무시).

## 11. 최근에 정리한 것들 (참고)

- 헤더/푸터 등 이벤트 없는 `<a href="#">` 전수 점검 완료 (푸터 6개 링크는 클릭 시 alert만 뜨는 placeholder로 처리)
- 관리자가 게시글 **목록**에서도 남의 글을 관리할 수 있게 수정함 (전에는 상세 화면에서만 가능했음)
- 게시글 수정 로그에 "작업자"가 항상 실제 로그인한 사람(관리자일 수도 있음)으로 남도록 수정함 (전에는 원래 작성자로 잘못 기록되던 버그 있었음)
- GitHub Pages용 정적 사본(`index.html`, `posts.html`, `auth/login.html`, 저장소 루트)은 **Firestore 전환 이후로 갱신 안 함** — 지금 내용이 예전 방식(하드코딩/localStorage) 그대로라 실제 앱과 다름. 공유 링크 필요할 때 다시 찍어주기로 함.

## 12. 아직 안 만든 것 / 기획서상 남은 항목

- `/mypage/edit`은 있지만 회원정보 수정 세부 항목(비밀번호 변경 등)은 기획서 원안과 다르게 단순화됨
- 게시글 사진 첨부 실제 업로드 (현재는 국가별 고정 이미지)
- 댓글/좋아요/스크랩 (기획서상 선택 기능, 미확정)
- 회원 관리에서 이용 정지/탈퇴 처리 (기획서상 미확정, 조회만 가능)
- 모바일 반응형은 로그인/회원가입 화면에만 있고 나머지 화면은 없음
