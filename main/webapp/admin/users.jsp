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

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
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

    <!-- =========================
         회원 관리
         실제 회원 DB는 없고, 화면 확인용 하드코딩된 목록이다.
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
    /*
     * 실제로는 DB에서 회원 목록을 조회해야 하지만
     * 지금은 화면 확인용 하드코딩 데이터를 사용한다.
     */

    const MOCK_USERS = [
        { nickname: "바다소년", email: "sea_boy@example.com", joinedDate: "2026-06-02", status: "활성" },
        { nickname: "먹부림", email: "foodlover@example.com", joinedDate: "2026-06-15", status: "활성" },
        { nickname: "주말러", email: "weekender@example.com", joinedDate: "2026-07-01", status: "활성" },
        { nickname: "여행좋아", email: "travelfan@example.com", joinedDate: "2026-07-10", status: "활성" },
        { nickname: "쇼퍼홀릭", email: "shopaholic@example.com", joinedDate: "2026-07-22", status: "정지" },
        { nickname: "디즈니덕후", email: "disneyfan@example.com", joinedDate: "2026-08-01", status: "활성" },
        { nickname: "길위에서", email: "onthe_road@example.com", joinedDate: "2026-08-09", status: "활성" },
        { nickname: "파리지앵", email: "parisian@example.com", joinedDate: "2026-08-30", status: "활성" }
    ];

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

    renderUserTable(MOCK_USERS);


    const userSearchForm =
        document.getElementById("userSearchForm");

    const userSearchKeyword =
        document.getElementById("userSearchKeyword");

    userSearchForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const keyword =
            userSearchKeyword.value.trim().toLowerCase();

        if (keyword === "") {
            renderUserTable(MOCK_USERS);
            return;
        }

        const filtered = MOCK_USERS.filter(function (user) {

            return user.nickname.toLowerCase().indexOf(keyword) !== -1
                || user.email.toLowerCase().indexOf(keyword) !== -1;

        });

        renderUserTable(filtered);

    });
</script>

</body>
</html>
