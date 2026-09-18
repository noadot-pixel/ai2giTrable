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

<%@ include file="/common/firebase-init.jspf" %>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
    /*
     * 관리자 전용 화면. 로그인 여부 + Firestore admins/{uid} 문서 존재 여부를
     * 모두 확인한다. 실제로는 서버에서도 세션의 권한을 검사해야 한다.
     */

    (async function guardAdminAccess() {

        if (!mockAuth.isLoggedIn()) {

            alert("관리자 전용 화면입니다. 로그인 후 이용해 주세요.");

            location.href = "<%= contextPath %>/auth/login.jsp";

            return;
        }

        const isAdmin = await mockAuth.isAdmin();

        if (!isAdmin) {

            alert("관리자 권한이 없습니다.");

            location.href = "<%= contextPath %>/index.jsp";
        }

    })();
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

    <!-- =========================
         예시 게시글 시드
         posts 컬렉션이 비어 있을 때만 9개의 예시 게시글을 채워 넣는다.
         이미 데이터가 있으면 아무 것도 하지 않는다.
    ========================== -->

    <section class="admin-seed-section">

        <p class="admin-seed-description">
            게시판이 비어 있을 때 예시 게시글 9개를 한 번에 채워 넣습니다.
            이미 게시글이 있으면 아무 것도 바뀌지 않습니다.
        </p>

        <button type="button"
                id="seedButton"
                class="auth-submit admin-seed-button">
            예시 게시글 시드 추가
        </button>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>

<script>
    document.getElementById("seedButton")
        .addEventListener("click", async function () {

            const addedCount = await postsStore.seedIfEmpty();

            if (addedCount === 0) {
                alert("이미 게시글이 있어서 시드를 추가하지 않았습니다.");
            } else {
                alert(addedCount + "개의 예시 게시글을 추가했습니다.");
            }

        });
</script>

</body>
</html>
