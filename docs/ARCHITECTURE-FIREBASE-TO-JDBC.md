# 구조 비교: 지금(Firebase) → 나중(Oracle JDBC, DTO/DAO/DBM/Main)

작성일: 2026-09-21

이 문서는 "지금 Firebase로 만든 화면"과 "DTO, DAO, DBM(DB 연결 관리), Main(실행용 JSP)으로 만드는 Oracle JDBC 프로젝트"가 **같은 기능을 어떻게 다른 방식으로 만드는지** 비교한다.
테이블/컬럼 설계 자체는 [DB-SCHEMA.md](DB-SCHEMA.md)에 있으니, 이 문서는 **"코드가 어디에 있고, 누가 DB를 지키는가"**에 집중한다.

---

## 1. 한 줄 요약

| | 지금 (Firebase) | 나중 (Oracle JDBC) |
|---|---|---|
| DB에 누가 접속하는가 | **브라우저**가 Firestore에 직접 접속 | **Java 서버**만 Oracle에 접속. 브라우저는 서버 근처도 못 감 |
| DB를 지키는 것 | Firebase **보안 규칙**(`firestore.rules`) | **Java 코드**(DAO, 서블릿의 `if`문) |
| 로그인 상태를 기억하는 곳 | 브라우저(Firebase Auth 세션) | 서버(`HttpSession`) |
| "게시글 쓰기" 버튼을 누르면 | 브라우저 JS → Firestore로 바로 저장 | 브라우저 → 서버(JSP/Servlet) → DAO → Oracle |

가장 큰 차이는 이것이다. **지금은 브라우저가 DB와 직접 대화하고, 그 대화 내용이 옳은지를 "규칙"이 검사한다.** 나중에는 **브라우저는 서버하고만 대화하고, DB와의 대화는 전부 서버(Java) 안에서 끝난다.** 그래서 "규칙"이라는 별도의 개념이 아예 없어지고, 그 자리를 **평범한 Java `if`문**이 대신한다.

---

## 2. 계층 대응표

지금 쓰는 JS 파일들과, 앞으로 만들 Java 계층이 하는 일은 같다. 이름과 언어만 다르다.

| 하는 일 | 지금 (JS) | 나중 (Java) |
|---|---|---|
| 화면 1개 = 페이지 1개 | `posts/write.jsp` (화면 + 버튼 이벤트) | `posts/write.jsp` (화면만) + `WriteServlet` 또는 `<jsp:useBean>` (실행 로직) — 문제에서 말한 **Main** |
| "게시글 1건"을 표현하는 자료 모양 | JS 객체 `{title, body, authorUid, ...}` | **DTO**: `PostDTO` 클래스 (`getTitle()`, `setTitle()` …) |
| DB에 SQL을 실제로 날리는 곳 | `posts-store.js`의 `createPost()`, `getAllPosts()` 등 | **DAO**: `PostDAO` 클래스의 `insertPost()`, `selectAll()` 등 |
| DB 연결을 맺고 끊는 곳 | Firebase SDK가 알아서 처리 (`firebase.firestore()`) | **DBM**(DB Manager): `Connection`을 얻고 반납하는 공통 클래스 |
| 로그인 여부 확인 | `firebase.auth().currentUser` | `HttpSession`의 `session.getAttribute("loginUser")` |
| 권한 검사("내 글만 지울 수 있다") | Firestore **보안 규칙** | `PostDAO.deletePost()` 안의 SQL `WHERE` 조건, 또는 서블릿의 `if` |

이 프로젝트 안에서 실제로 대응되는 파일을 짝지으면 이렇다.

| 지금 | 나중 |
|---|---|
| `js/posts-store.js` | `PostDAO.java`, `CommentDAO.java`, `LikeDAO.java`, `ScrapDAO.java` |
| `js/mock-auth.js`의 로그인 상태 부분 | `HttpSession` (로그인 서블릿이 만들고, 이후 모든 서블릿이 읽음) |
| `js/mock-auth.js`의 `isAdmin()` | `MemberDTO.getIsAdmin()` (세션에 들어있는 로그인 회원 정보의 필드 하나) |
| `common/firebase-init.jspf` | `DBConnectionManager.java` (DBM) — Oracle 접속 정보와 `Connection` 생성 |
| Firestore 문서 하나 (`posts/{id}`) | `PostDTO` 객체 하나 (Java 인스턴스) |
| `firebase/firestore.rules` | 없음(파일이 아니라 **여러 Java 파일에 나눠 들어감**) — 아래 4번에서 자세히 설명 |

---

## 3. 로그인/세션 비교

### 지금 (Firebase Auth)

1. 로그인하면 Firebase가 브라우저의 IndexedDB에 로그인 토큰을 저장한다.
2. 페이지를 새로 열 때마다 `firebase.auth().onAuthStateChanged()`가 그 토큰을 읽어 **브라우저 안에서** 로그인 상태를 복원한다. (`window.authReady`로 기다리게 만든 그 부분)
3. Firestore에 쓰기를 할 때마다 그 토큰이 자동으로 요청에 실려가고, **Firebase 서버가** 토큰의 uid를 규칙의 `request.auth.uid`로 사용한다.
4. 즉 "내가 로그인했다"는 사실을 **브라우저가 계속 들고 다니고, 매번 Firebase에게 증명**한다.

### 나중 (Java `HttpSession`)

1. 로그인 폼을 제출하면 **서버의 로그인 서블릿**이 `MEMBERS` 테이블에서 이메일/비밀번호를 SQL로 조회한다.
2. 맞으면 `HttpSession session = request.getSession();`으로 세션을 만들고 `session.setAttribute("loginUser", memberDTO);`로 로그인 회원 정보를 **서버 메모리에** 저장한다.
3. 브라우저는 `JSESSIONID`라는 쿠키만 들고 다닌다. 로그인 정보 자체는 브라우저에 없다.
4. 이후 어떤 JSP/서블릿이든 `request.getSession().getAttribute("loginUser")`로 "지금 이 요청을 보낸 사람이 누구인지"를 서버 안에서 바로 알 수 있다.
5. 로그아웃은 `session.invalidate()`.

**비유하면:** 지금은 손님(브라우저)이 신분증(토큰)을 들고 다니면서 상점(Firebase)마다 직접 보여준다. 나중에는 손님이 매표소(서버)에서 표(JSESSIONID)만 받고, 매표소 안쪽 창고(Oracle)는 직원(Java)만 드나든다. 손님은 창고 열쇠를 아예 가진 적이 없다.

---

## 4. "규칙"은 어디로 가는가 — 가장 중요한 부분

지금 `firebase/firestore.rules`에 있는 한 줄 한 줄이, 나중에는 **DAO 메서드 안의 SQL이나 서블릿의 `if`문**으로 흩어져 들어간다. 대응표로 보면 이렇다.

| Firestore 규칙 (지금) | Java로 옮기면 (나중) |
|---|---|
| `match /posts/{postId} { allow read: if true; }` | 그냥 아무 `if`도 없이 `SELECT * FROM POSTS`를 실행하는 서블릿을 만들면 된다. (모두가 볼 수 있음 = 애초에 검사할 게 없음) |
| `allow create: if isSignedIn() && request.resource.data.authorUid == request.auth.uid;` | 글쓰기 서블릿 맨 앞에: <br>`MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");`<br>`if (loginUser == null) { response.sendRedirect("login.jsp"); return; }`<br>그 다음 INSERT할 때 `WRITER_ID` 컬럼에 무조건 `loginUser.getMemberId()`를 넣는다(화면에서 받은 값을 쓰지 않는다). |
| `allow update, delete: if authorUid == request.auth.uid \|\| isAdmin();` | 수정/삭제 서블릿에서: <br>`if (!loginUser.getMemberId().equals(post.getWriterId()) && !loginUser.isAdmin()) { response.sendError(403); return; }`<br>또는 DAO의 SQL 자체에 조건을 건다: <br>`DELETE FROM POSTS WHERE POST_ID=? AND (WRITER_ID=? OR ? = 'Y')` |
| `allow update: if ... \|\| onlyCounterChange();` (좋아요 수만 바꾸는 건 허용) | 애초에 "좋아요 수 바꾸기"와 "글 수정하기"를 **다른 메서드**로 분리한다: `PostDAO.increaseLike(postId)`는 권한 검사 없이 호출 가능, `PostDAO.updatePost(dto)`는 작성자 확인 필요. Firestore처럼 "한 문서의 필드 일부만 허용"할 필요가 없다 — SQL은 컬럼 단위로 UPDATE 문을 따로 쓰면 그만이다. |
| `match /comments/{commentId} { allow delete: if 댓글작성자 \|\| 글작성자 \|\| 관리자; }` | `CommentDAO.deleteComment()` 호출 전에 서블릿에서 세 조건을 `||`로 검사. SQL로 하고 싶으면 `DELETE FROM COMMENTS WHERE COMMENT_ID=? AND (WRITER_ID=? OR ? IN (SELECT WRITER_ID FROM POSTS WHERE POST_ID=?) OR ?='Y')` |
| `match /users/{uid} { allow update: if request.auth.uid == uid; }` | 프로필 수정 서블릿에서: 화면(hidden input 등)에서 회원번호를 받더라도 **믿지 않고**, `UPDATE MEMBERS SET ... WHERE MEMBER_ID = ?`의 `?` 자리에는 **세션에 든 값**(`loginUser.getMemberId()`)만 쓴다. 이게 핵심이다 — 화면이 보낸 id를 그대로 믿으면 남의 정보를 바꿀 수 있게 된다. |
| `admins/{uid}` 컬렉션 존재 여부로 관리자 판별 | `MEMBERS.IS_ADMIN` 컬럼 하나. 로그인할 때 이미 세션에 실려있어서 매번 DB를 다시 볼 필요도 없다. |
| `request.resource.data.body.size() <= 500` (댓글 500자 제한) | Java에서 `if (content.length() > 500) { ...에러... }`. 이것도 이중으로 하면 더 안전: HTML `<textarea maxlength="500">`(사용자 편의) + 서버 Java 검사(진짜 방어선). |
| Storage의 `request.resource.size < 5MB`, `contentType.matches('image/.*')` | 파일 업로드 서블릿(주로 `Apache Commons FileUpload` 라이브러리 사용)에서 `if (file.getSize() > 5*1024*1024) {...}`, 확장자/MIME 타입 검사를 Java로 직접. |

### 왜 파일 하나가 아니라 여러 곳에 흩어지는가

Firestore 규칙은 "DB 앞을 지키는 문지기 하나"였다. **모든** 접근이 반드시 그 문을 통과해야 했다 — 브라우저가 Firestore에 직접 붙기 때문이다.

Oracle은 애초에 브라우저가 직접 접속할 수 없고 **Java 코드를 거쳐야만** 접속된다. 그래서 "문지기 하나"가 필요 없고, **접속 통로(서블릿/DAO) 하나하나에 검사 코드를 심는** 방식이 된다. 검사가 사라지는 게 아니라, **위치가 "DB 서버 앞"에서 "Java 코드 안"으로 옮겨갈 뿐**이다. 오히려 실수로 검사를 빠뜨린 통로가 생기지 않도록, 다음처럼 **공통화**해서 관리하는 게 일반적이다.

- **로그인 여부 검사**: 모든 서블릿 맨 앞에서 반복하지 않고, `LoginFilter`(서블릿 필터) 하나가 `/mypage/*`, `/posts/write` 같은 주소들을 가로채서 미로그인이면 로그인 페이지로 보낸다. (Firestore의 `isSignedIn()` 함수 하나를 여러 규칙이 재사용하던 것과 같은 발상)
- **본인/관리자 확인**: 공통 메서드 `AuthUtil.checkOwnerOrAdmin(loginUser, post)`를 만들어 여러 서블릿에서 재사용한다.

---

## 5. 요청 하나의 흐름 비교 (댓글 삭제를 예로)

### 지금 (Firebase)

```
[브라우저]
  댓글 삭제 버튼 클릭
    → JS: postsStore.deleteComment(postId, commentId)
      → Firestore SDK가 delete 요청을 Firebase 서버로 전송
        (요청에 로그인 토큰이 자동으로 실림)

[Firebase 서버]
  보안 규칙 검사
    → request.auth.uid가 댓글 작성자/글 작성자/관리자 중 하나인가?
    → 통과 → 문서 삭제, 실패 → "Missing or insufficient permissions" 에러 반환

[브라우저]
  성공/실패 결과를 받아 화면 갱신
```

### 나중 (Oracle JDBC)

```
[브라우저]
  댓글 삭제 버튼 클릭
    → <a href="/trable/comment/delete?postId=1&commentId=7"> 또는 fetch/AJAX 요청

[Tomcat: DeleteCommentServlet]
  1) HttpSession에서 loginUser 꺼내기 → 없으면 로그인 페이지로 이동 (권한 검사 1)
  2) CommentDAO.findById(commentId)로 댓글 조회 (DBM이 Connection을 빌려줌)
  3) loginUser와 댓글 작성자/글 작성자/관리자 비교 → 아니면 403 에러 (권한 검사 2)
  4) 통과하면 CommentDAO.delete(commentId) 호출 → 내부에서 DELETE 문 실행
  5) DBM이 Connection을 반납(close)
  6) 처리 결과에 따라 posts/detail.jsp로 다시 이동(redirect) 또는 JSON 응답

[브라우저]
  갱신된 화면을 다시 받는다
```

**차이의 핵심**: Firebase 버전은 "요청 → 규칙 검사 → DB"가 Firebase 서버 안에서 한 번에 일어난다. JDBC 버전은 "요청 → 서블릿(권한 검사) → DAO(SQL 실행) → DBM(연결 관리)"로 **역할이 클래스별로 쪼개져 있다.** 이게 DTO/DAO/DBM/Main 구조를 쓰는 이유이기도 하다 — 한 클래스가 한 가지 일만 하게 나눠서, 나중에 수정하거나 실수를 찾기 쉽게 만드는 것이다.

---

## 6. 최소 코드 골격 (감 잡기용)

실제 코드는 아니고, "이런 모양이 된다"는 걸 보여주는 뼈대다.

```java
// ── DTO: 게시글 한 건을 담는 상자. 필드 이름은 DB 컬럼과 맞춘다.
public class PostDTO {
    private long postId;
    private long writerId;
    private String title;
    private String content;
    private String country;
    private String style;
    private String imagePath;
    private int viewCount;
    private java.sql.Date createdAt;
    // getter / setter 전부
}
```

```java
// ── DBM: Connection을 만들고 돌려주는 곳. 프로젝트 전체가 이거 하나만 씀.
public class DBConnectionManager {
    private static final String URL  = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String USER = "trable";
    private static final String PASSWORD = "****";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

```java
// ── DAO: SQL을 실제로 실행하는 곳. "권한 검사"도 여기(또는 호출하는 서블릿)에서 한다.
public class PostDAO {

    public void insertPost(PostDTO post) throws SQLException {
        String sql = "INSERT INTO POSTS (POST_ID, WRITER_ID, TITLE, CONTENT, COUNTRY, STYLE) "
                   + "VALUES (SEQ_POSTS.NEXTVAL, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnectionManager.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setLong(1, post.getWriterId());   // ← 화면 값이 아니라 세션의 회원 id여야 한다!
            pstmt.setString(2, post.getTitle());
            pstmt.setString(3, post.getContent());
            pstmt.setString(4, post.getCountry());
            pstmt.setString(5, post.getStyle());
            pstmt.executeUpdate();
        }
    }

    // 일반 회원은 본인 글만, 관리자는 전부 지워지도록 SQL 조건으로 권한을 구현한 예
    public int deletePost(long postId, long loginMemberId, boolean isAdmin) throws SQLException {
        String sql = isAdmin
            ? "DELETE FROM POSTS WHERE POST_ID = ?"
            : "DELETE FROM POSTS WHERE POST_ID = ? AND WRITER_ID = ?";

        try (Connection con = DBConnectionManager.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setLong(1, postId);
            if (!isAdmin) {
                pstmt.setLong(2, loginMemberId);
            }
            return pstmt.executeUpdate();  // 0이면 "권한 없음 또는 글 없음"
        }
    }
}
```

```java
// ── Main(서블릿) = 문제에서 말한 "실행 전용 페이지". 실제로는 .jsp가 아니라 Servlet(.java)으로
//    만드는 게 정석이다. JSP는 "화면 출력"에, Servlet은 "처리"에 집중시키는 구조(MVC)다.
@WebServlet("/post/delete")
public class DeletePostServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect("/trable/auth/login.jsp");
            return;
        }

        long postId = Long.parseLong(request.getParameter("postId"));

        try {
            PostDAO dao = new PostDAO();
            int deletedRows = dao.deletePost(postId, loginUser.getMemberId(), loginUser.isAdmin());

            if (deletedRows == 0) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없거나 글이 없습니다.");
                return;
            }

            response.sendRedirect("/trable/posts.jsp");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
```

이 골격에서 보듯, **지금 `firebase/firestore.rules`의 `allow delete: if authorUid == uid || isAdmin();` 한 줄이, `DeletePostServlet`의 로그인 검사 + `PostDAO.deletePost()`의 SQL 조건 두 군데로 나뉘어 들어갔다.**

---

## 7. 파일 구조 제안 (Eclipse Dynamic Web Project 기준)

```
main/
  webapp/                  ← 지금과 동일 (화면: .jsp, .css, .js, .images)
    index.jsp
    posts/
      write.jsp            ← 화면만 (입력 폼 출력, <form action="/trable/post/create" method="post">)
      detail.jsp
    WEB-INF/
      web.xml
  src/
    main/java/
      dto/
        MemberDTO.java
        PostDTO.java
        CommentDTO.java
        PostLikeDTO.java
        ScrapDTO.java
      dao/
        DBConnectionManager.java   ← DBM
        MemberDAO.java
        PostDAO.java
        CommentDAO.java
        PostLikeDAO.java
        ScrapDAO.java
        PostLogDAO.java
      servlet/                     ← Main(실행 전용) — @WebServlet 어노테이션이 붙은 .java들
        LoginServlet.java
        LogoutServlet.java
        SignupServlet.java
        post/
          CreatePostServlet.java
          UpdatePostServlet.java
          DeletePostServlet.java
        comment/
          CreateCommentServlet.java
          DeleteCommentServlet.java
        like/
          ToggleLikeServlet.java
        scrap/
          ToggleScrapServlet.java
      filter/
        LoginCheckFilter.java      ← 로그인 필요한 주소를 한 곳에서 검사(공통 규칙)
```

지금 구조(`main/webapp` 하나)와 비교하면, **`src/main/java` 아래에 dto/dao/servlet이 새로 생기는 것**이 가장 큰 변화다. `.jsp`는 남지만 하는 일이 줄어든다 — 지금은 `.jsp` 안의 `<script>`가 Firestore를 직접 부르고 화면도 그리지만, 나중에는 `.jsp`가 **서블릿이 이미 처리해서 건네준 결과만 화면에 찍는** 역할로 축소된다.

---

## 8. 정리: 지금 배운 개념이 그대로 쓰인다

Firebase로 이미 만들어본 개념들이 이름만 바뀌어 그대로 재사용된다.

| 지금 이미 한 것 | 나중에 이름 |
|---|---|
| "로그인 안 했으면 로그인 페이지로 보낸다" (`mockAuth.isLoggedIn()` 검사) | `LoginCheckFilter` 또는 각 서블릿 앞의 세션 검사 |
| "내 글이거나 관리자면 수정/삭제 버튼 보여주기" | 화면(JSP)에서는 그대로 유지(사용자 편의), **진짜 방어는** 서블릿/DAO로 이동 |
| "글을 지우면 댓글/좋아요도 같이 지운다" (`deletePostChildren`) | `PostDAO.deletePost()` 안에서 `DELETE FROM COMMENTS WHERE POST_ID=?` 등을 순서대로 실행 (또는 테이블에 `ON DELETE CASCADE`를 걸어 Oracle이 자동으로 처리 — DB-SCHEMA.md의 `COMMENTS`, `POST_LIKES`, `SCRAPS`에 이미 걸어둠) |
| "닉네임을 바꾸면 옛 글에도 바로 반영" (`resolveNicknames`) | SQL의 `JOIN`: `SELECT p.*, m.NICKNAME FROM POSTS p JOIN MEMBERS m ON ...`으로 **항상 최신 닉네임을 그때그때 가져오므로** 이 문제 자체가 원래 안 생긴다 (DB-SCHEMA.md 2번 참고) |
| Firestore 규칙 파일 하나로 몰아서 관리 | 대신 DAO/서블릿 코드 리뷰, 그리고 "화면이 보낸 값을 그대로 믿지 않는다"는 원칙을 팀(본인) 스스로 지키는 것으로 대체 |

가장 명심할 한 가지는: **Firestore 규칙이 없어진다고 검사를 안 해도 되는 게 아니라, 그 검사를 이제 Java 코드가 직접, 매번 손으로 써줘야 한다**는 것이다. 특히 "화면에서 보낸 회원 id·작성자 id를 그대로 믿지 말고, 항상 `session`에 든 로그인 정보를 기준으로 판단한다"는 원칙이 SQL Injection 방지(`PreparedStatement` 사용)와 함께 Oracle 버전에서 가장 중요한 보안 규칙이 된다.
