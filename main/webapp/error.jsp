<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isErrorPage="true" %>

<%
    String contextPath = request.getContextPath();

    Integer statusCode =
        (Integer) request.getAttribute("javax.servlet.error.status_code");

    if (statusCode == null) {
        statusCode =
            (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    }

    String reason = request.getParameter("reason");

    String heading;
    String description;

    if ("forbidden".equals(reason) || Integer.valueOf(403).equals(statusCode)) {
        heading = "접근 권한이 없습니다";
        description = "이 페이지를 볼 수 있는 권한이 없습니다. 로그인 상태나 계정 권한을 확인해 주세요.";
    } else if ("notfound".equals(reason) || Integer.valueOf(404).equals(statusCode)) {
        heading = "페이지를 찾을 수 없습니다";
        description = "요청하신 페이지나 게시글이 존재하지 않거나 삭제되었습니다.";
    } else {
        heading = "문제가 발생했습니다";
        description = "요청을 처리하는 중 알 수 없는 문제가 발생했습니다.";
    }
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title><%= heading %> - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<% String activeNav = ""; %>
<%@ include file="/common/header.jspf" %>

<main>

    <section class="error-section">

        <p class="error-code"><%= statusCode != null ? statusCode : "" %></p>

        <h1><%= heading %></h1>

        <p class="error-description"><%= description %></p>

        <div class="error-actions">
            <a href="<%= contextPath %>/index.jsp" class="auth-submit error-home-button">홈으로 가기</a>
            <a href="<%= contextPath %>/posts.jsp">게시글 목록 보기</a>
        </div>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

</body>
</html>
