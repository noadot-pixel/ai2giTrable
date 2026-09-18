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

    <title>회원 관리 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<%@ include file="/common/firebase-init.jspf" %>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
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

    <!-- =========================
         회원 관리
         Firestore의 users 컬렉션(회원가입 시 기록됨)을 그대로 보여준다.
         검색은 닉네임/이메일 기준 클라이언트 필터링만 동작한다.
         이용 정지·탈퇴 처리 권한은 기획서상 미확정이라 조회만 제공한다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/admin/index.jsp">관리자</a>
            〉 회원 관리
        </p>

        <h1>회원 관리</h1>

        <p class="page-description">
            닉네임 또는 이메일로 회원을 검색할 수 있습니다.
        </p>

    </section>

    <section class="filter-section">

        <form class="search-form"
              id="userSearchForm"
              action="#"
              method="get">

            <label for="userSearchKeyword"
                   class="blind">
                회원 검색
            </label>

            <span class="search-icon">
                ⌕
            </span>

            <input type="text"
                   id="userSearchKeyword"
                   name="keyword"
                   placeholder="닉네임 또는 이메일로 검색">

            <button type="submit">
                검색
            </button>

        </form>

    </section>

    <section class="admin-table-section">

        <p id="userResultCount">
            전체 회원 <strong>0</strong>명
        </p>

        <table class="admin-table">

            <thead>
                <tr>
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>가입일</th>
                    <th>상태</th>
                </tr>
            </thead>

            <tbody id="userTableBody">
            </tbody>

        </table>

        <p class="empty-result"
           id="userEmptyResult"
           hidden>
            검색 결과가 없습니다.
        </p>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script>
    const userTableBody =
        document.getElementById("userTableBody");

    const userResultCount =
        document.getElementById("userResultCount");

    const userEmptyResult =
        document.getElementById("userEmptyResult");

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    function renderUserTable(users) {

        userTableBody.innerHTML = users.map(function (user) {

            const statusClass =
                user.status === "정지" ? "admin-status-suspended" : "admin-status-active";

            return "<tr>"
                + "<td>" + escapeHtml(user.nickname) + "</td>"
                + "<td>" + escapeHtml(user.email) + "</td>"
                + "<td>" + user.joinedDate + "</td>"
                + "<td><span class=\"admin-status " + statusClass + "\">" + user.status + "</span></td>"
                + "</tr>";

        }).join("");

        userResultCount.innerHTML =
            "전체 회원 <strong>" + users.length + "</strong>명";

        userEmptyResult.hidden = users.length !== 0;

    }

    let allUsers = [];

    async function loadUsers() {

        const snapshot = await firebase.firestore().collection("users").get();

        allUsers = snapshot.docs.map(function (doc) {
            return doc.data();
        });

        renderUserTable(allUsers);
    }

    loadUsers();


    const userSearchForm =
        document.getElementById("userSearchForm");

    const userSearchKeyword =
        document.getElementById("userSearchKeyword");

    userSearchForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const keyword =
            userSearchKeyword.value.trim().toLowerCase();

        if (keyword === "") {
            renderUserTable(allUsers);
            return;
        }

        const filtered = allUsers.filter(function (user) {

            return user.nickname.toLowerCase().indexOf(keyword) !== -1
                || user.email.toLowerCase().indexOf(keyword) !== -1;

        });

        renderUserTable(filtered);

    });
</script>

</body>
</html>
