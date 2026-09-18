<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>로그인 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<% String activeNav = ""; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         로그인
         Firebase Authentication(이메일/비밀번호)으로 실제 계정을
         검증하고, 로그인 상태 표시는 그대로 localStorage(mockAuth)를 사용한다.
         추후 Oracle JDBC + 세션 기반 로그인으로 교체될 예정.
    ========================== -->

    <section class="auth-section">

        <div class="auth-layout">

            <div class="auth-visual">
                <div class="auth-visual-overlay"></div>

                <div class="auth-visual-content">
                    <p class="auth-kicker">
                        TRAVEL MAKER
                    </p>

                    <h1>
                        다시 여행을<br>
                        이어가 볼까요?
                    </h1>

                    <p>
                        여행 기록을 남기고,<br>
                        새로운 여행 이야기를 만나보세요.
                    </p>

                    <div class="auth-visual-tags" aria-hidden="true">
                        <span>#서울</span>
                        <span>#도쿄</span>
                        <span>#제주</span>
                    </div>
                </div>
            </div>

            <div class="auth-panel">

                <div class="auth-box">

                    <div class="auth-title-area">
                        <span class="auth-title-mark">✈</span>

                        <h2>로그인</h2>

                        <p class="auth-description">
                            여행만들기 계정으로 로그인하세요.
                        </p>
                    </div>

                    <form id="loginForm">

                        <div class="auth-field">
                            <label for="loginEmail">
                                이메일
                            </label>

                            <input type="email"
                                   id="loginEmail"
                                   name="loginEmail"
                                   placeholder="이메일을 입력해 주세요"
                                   autocomplete="username">
                        </div>

                        <div class="auth-field">
                            <label for="loginPassword">
                                비밀번호
                            </label>

                            <input type="password"
                                   id="loginPassword"
                                   name="loginPassword"
                                   placeholder="비밀번호를 입력해 주세요"
                                   autocomplete="current-password">
                        </div>

                        <button type="submit"
                                class="auth-submit">
                            로그인
                        </button>

                    </form>

                    <div class="auth-divider">
                        <span>TRAVEL COMMUNITY</span>
                    </div>

                    <div class="auth-links">
                        <a href="<%= contextPath %>/auth/signup.jsp">회원가입</a>
                        <span aria-hidden="true"></span>
                        <a href="<%= contextPath %>/index.jsp">메인으로 돌아가기</a>
                    </div>

                </div>

            </div>

        </div>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script>
    /*
     * 이미 로그인되어 있으면 메인으로 바로 이동
     * (mockAuth는 화면 표시용 로그인 상태만 관리한다)
     */

    if (mockAuth.isLoggedIn()) {
        location.href = "<%= contextPath %>/index.jsp";
    }
</script>

<script>
    /*
     * Firebase Authentication(이메일/비밀번호)으로 실제 계정을 검증한다.
     * Firebase 콘솔의 Authentication > Users에 미리 등록된 계정만 로그인 가능.
     * 로그인에 성공하면 화면 표시용 mockAuth(localStorage)에도 반영한다.
     */

    const loginForm =
        document.getElementById("loginForm");

    const loginEmailInput =
        document.getElementById("loginEmail");

    const loginPasswordInput =
        document.getElementById("loginPassword");

    const LOGIN_ERROR_MESSAGES = {
        "auth/invalid-email": "이메일 형식이 올바르지 않습니다.",
        "auth/user-not-found": "등록되지 않은 계정입니다.",
        "auth/wrong-password": "비밀번호가 올바르지 않습니다.",
        "auth/invalid-credential": "이메일 또는 비밀번호가 올바르지 않습니다.",
        "auth/too-many-requests": "로그인 시도가 너무 많습니다. 잠시 후 다시 시도해 주세요."
    };

    console.log("[DEBUG] firebase.apps.length =", firebase.apps.length);
    console.log("[DEBUG] firebase.apps =", firebase.apps.map(function (a) { return a.options.apiKey; }));
    console.log("[DEBUG] before login, firebase.auth().currentUser =", firebase.auth().currentUser);

    firebase.auth().onAuthStateChanged(function (user) {
        console.log("[DEBUG] onAuthStateChanged fired, user =", user);
    });

    loginForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const loginEmail =
            loginEmailInput.value.trim();

        const loginPassword =
            loginPasswordInput.value.trim();

        if (loginEmail === "" || loginPassword === "") {

            alert("이메일과 비밀번호를 입력해 주세요.");

            return;
        }

        console.log("[DEBUG] calling signInWithEmailAndPassword...");

        firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL)
            .then(function () {

                console.log("[DEBUG] persistence set to LOCAL, signing in...");

                return firebase.auth().signInWithEmailAndPassword(loginEmail, loginPassword);

            })
            .then(function (userCredential) {

                const firebaseUser = userCredential.user;

                console.log("[DEBUG] sign-in resolved, userCredential.user =", firebaseUser);
                console.log("[DEBUG] immediately after, firebase.auth().currentUser =", firebase.auth().currentUser);

                mockAuth.login({
                    id: firebaseUser.uid,
                    email: firebaseUser.email,
                    nickname: firebaseUser.displayName || firebaseUser.email.split("@")[0]
                });

                /*
                 * Firebase Auth가 로그인 세션을 브라우저에 완전히 기록하기 전에
                 * 바로 다른 페이지로 넘어가면 세션 복원이 안 되는 경우가 있어
                 * 아주 짧게 기다렸다가 이동한다.
                 */

                setTimeout(function () {
                    console.log("[DEBUG] right before redirect, firebase.auth().currentUser =", firebase.auth().currentUser);
                    location.href = "<%= contextPath %>/index.jsp";
                }, 500);

            })
            .catch(function (error) {

                console.log("[DEBUG] sign-in rejected:", error);

                const message =
                    LOGIN_ERROR_MESSAGES[error.code]
                    || "로그인에 실패했습니다. 잠시 후 다시 시도해 주세요.";

                alert(message);

            });

    });
</script>

</body>
</html>
