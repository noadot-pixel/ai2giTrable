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

    <title>관리자 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
    /*
     * 관리자 전용 화면. 로그인 여부 + 관리자 계정 여부를 모두 확인한다.
     * 관리자 판별은 mockAuth.isAdmin()의 이메일 목록으로 대신하는 목업이며,
     * 실제로는 서버에서 세션의 권한을 검사해야 한다.
     */

    if (!mockAuth.isLoggedIn()) {

        alert("관리자 전용 화면입니다. 로그인 후 이용해 주세요.");

        location.href = "<%= contextPath %>/auth/login.jsp";

    } else if (!mockAuth.isAdmin()) {

        alert("관리자 권한이 없습니다.");

        location.href = "<%= contextPath %>/index.jsp";
    }
</script>

<% String activeNav = ""; %>
<%@ include file="/common/header.jspf" %>

<main>

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 관리자
        </p>

        <h1>관리자</h1>

        <p class="page-description">
            회원 관리와 게시글 로그를 확인할 수 있습니다.
        </p>

    </section>

    <section class="admin-menu-section">

        <a href="<%= contextPath %>/admin/users.jsp"
           class="admin-menu-card">

            <h2>회원 관리</h2>

            <p>
                회원을 검색하고 회원정보·상태를 확인합니다.
            </p>

        </a>

        <a href="<%= contextPath %>/admin/post-logs.jsp"
           class="admin-menu-card">

            <h2>게시글 로그</h2>

            <p>
                게시글 작성·수정·삭제 이력을 조회합니다.
            </p>

        </a>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

</body>
</html>
