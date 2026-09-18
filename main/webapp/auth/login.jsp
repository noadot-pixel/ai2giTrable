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
         로그인 폼
         실제 인증은 없고, 입력값을 그대로
         localStorage에 저장하는 목업입니다.
    ========================== -->

    <section class="auth-section">

        <div class="auth-box">

            <h1>로그인</h1>

            <p class="auth-description">
                여행만들기 계정으로 로그인하세요.
            </p>

            <form id="loginForm">

                <label for="loginId"
                       class="blind">
                    아이디
                </label>

                <input type="text"
                       id="loginId"
                       name="loginId"
                       placeholder="아이디"
                       autocomplete="username">

                <label for="loginPassword"
                       class="blind">
                    비밀번호
                </label>

                <input type="password"
                       id="loginPassword"
                       name="loginPassword"
                       placeholder="비밀번호"
                       autocomplete="current-password">

                <button type="submit">
                    로그인
                </button>

            </form>

            <p class="auth-links">
                <a href="#">회원가입</a>
                <a href="<%= contextPath %>/index.jsp">메인으로 돌아가기</a>
            </p>

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


    /*
     * 로그인 처리 목업
     * 아이디/비밀번호를 검증하는 서버가 없으므로
     * 입력값이 비어있지 않으면 로그인된 것으로 간주한다.
     */

    const loginForm =
        document.getElementById("loginForm");

    const loginIdInput =
        document.getElementById("loginId");

    const loginPasswordInput =
        document.getElementById("loginPassword");

    loginForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const loginId =
            loginIdInput.value.trim();

        const loginPassword =
            loginPasswordInput.value.trim();

        if (loginId === "" || loginPassword === "") {

            alert("아이디와 비밀번호를 입력해 주세요.");

            return;
        }

        mockAuth.login({
            id: loginId,
            nickname: loginId
        });

        location.href = "<%= contextPath %>/index.jsp";

    });
</script>

</body>
</html>
