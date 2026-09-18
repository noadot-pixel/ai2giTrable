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

    <title>회원가입 - 여행만들기</title>

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
         회원가입 (목업)
         실제 계정 생성/DB 저장은 하지 않고, 입력 검사 후 "가입 완료" alert만 띄운 뒤
         로그인 화면으로 이동한다. 추후 Oracle JDBC 기반 회원 테이블로 교체될 예정.
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
                        여행만들기와 함께<br>
                        첫 이야기를 시작해요
                    </h1>

                    <p>
                        가입하면 여행 이야기를 작성하고<br>
                        나만의 기록을 남길 수 있어요.
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

                        <h2>회원가입</h2>

                        <p class="auth-description">
                            기본 정보를 입력하고 여행만들기를 시작하세요.
                        </p>
                    </div>

                    <form id="signupForm">

                        <div class="auth-field">
                            <label for="signupNickname">
                                닉네임
                            </label>

                            <input type="text"
                                   id="signupNickname"
                                   name="signupNickname"
                                   placeholder="사용할 닉네임을 입력해 주세요"
                                   autocomplete="nickname">
                        </div>

                        <div class="auth-field">
                            <label for="signupEmail">
                                이메일
                            </label>

                            <input type="email"
                                   id="signupEmail"
                                   name="signupEmail"
                                   placeholder="이메일을 입력해 주세요"
                                   autocomplete="username">
                        </div>

                        <div class="auth-field">
                            <label for="signupPassword">
                                비밀번호
                            </label>

                            <input type="password"
                                   id="signupPassword"
                                   name="signupPassword"
                                   placeholder="6자 이상 입력해 주세요"
                                   autocomplete="new-password">
                        </div>

                        <div class="auth-field">
                            <label for="signupPasswordConfirm">
                                비밀번호 확인
                            </label>

                            <input type="password"
                                   id="signupPasswordConfirm"
                                   name="signupPasswordConfirm"
                                   placeholder="비밀번호를 다시 입력해 주세요"
                                   autocomplete="new-password">
                        </div>

                        <button type="submit"
                                class="auth-submit">
                            회원가입
                        </button>

                    </form>

                    <div class="auth-divider">
                        <span>TRAVEL COMMUNITY</span>
                    </div>

                    <div class="auth-links">
                        <a href="<%= contextPath %>/auth/login.jsp">로그인</a>
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
     */

    if (mockAuth.isLoggedIn()) {
        location.href = "<%= contextPath %>/index.jsp";
    }
</script>

<script>
    /*
     * 회원가입 목업: 입력값만 검사하고, 가입이 완료된 것처럼 alert를 띄운 뒤
     * 로그인 화면으로 이동한다. (Firebase 계정 생성, DB 기록은 하지 않는다.)
     */

    const signupForm =
        document.getElementById("signupForm");

    const nicknameInput =
        document.getElementById("signupNickname");

    const emailInput =
        document.getElementById("signupEmail");

    const passwordInput =
        document.getElementById("signupPassword");

    const passwordConfirmInput =
        document.getElementById("signupPasswordConfirm");

    signupForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const nickname =
            nicknameInput.value.trim();

        const email =
            emailInput.value.trim();

        const password =
            passwordInput.value;

        const passwordConfirm =
            passwordConfirmInput.value;

        if (nickname === "" || email === "" || password === "" || passwordConfirm === "") {

            alert("모든 항목을 입력해 주세요.");

            return;
        }

        if (password !== passwordConfirm) {

            alert("비밀번호가 서로 일치하지 않습니다.");

            return;
        }

        if (password.length < 6) {

            alert("비밀번호는 6자 이상이어야 합니다.");

            return;
        }

        alert("회원가입이 완료되었습니다. 로그인해 주세요.");

        location.href = "<%= contextPath %>/auth/login.jsp";

    });
</script>

</body>
</html>
