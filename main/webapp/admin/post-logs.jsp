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

    <title>게시글 로그 - 여행만들기</title>

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
         게시글 로그
         Firestore의 postLogs 컬렉션(작성/수정/삭제 시 자동 기록됨)을 조회한다.
         작업 종류·검색어로 클라이언트 필터링만 동작한다.
         저장 항목/보관 기간은 기획서상 미확정이라 예시 항목만 사용한다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/admin/index.jsp">관리자</a>
            〉 게시글 로그
        </p>

        <h1>게시글 로그</h1>

        <p class="page-description">
            게시글 작성·수정·삭제 이력을 조회합니다.
        </p>

    </section>

    <section class="filter-section">

        <form class="search-form"
              id="logSearchForm"
              action="#"
              method="get">

            <label for="logSearchKeyword"
                   class="blind">
                로그 검색
            </label>

            <span class="search-icon">
                ⌕
            </span>

            <input type="text"
                   id="logSearchKeyword"
                   name="keyword"
                   placeholder="게시글 제목 또는 작업자로 검색">

            <button type="submit">
                검색
            </button>

        </form>

        <div class="filter-group"
             id="logTypeFilter">

            <p class="filter-label">작업 종류</p>

            <button type="button"
                    class="filter-button active"
                    data-type="ALL">
                전체
            </button>

            <button type="button"
                    class="filter-button"
                    data-type="CREATE">
                작성
            </button>

            <button type="button"
                    class="filter-button"
                    data-type="UPDATE">
                수정
            </button>

            <button type="button"
                    class="filter-button"
                    data-type="DELETE">
                삭제
            </button>

        </div>

    </section>

    <section class="admin-table-section">

        <p id="logResultCount">
            전체 로그 <strong>0</strong>건
        </p>

        <table class="admin-table">

            <thead>
                <tr>
                    <th>작업 종류</th>
                    <th>작업 시각</th>
                    <th>대상 게시글</th>
                    <th>작업자</th>
                </tr>
            </thead>

            <tbody id="logTableBody">
            </tbody>

        </table>

        <p class="empty-result"
           id="logEmptyResult"
           hidden>
            조건에 맞는 로그가 없습니다.
        </p>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>

<script>
    const LOG_TYPE_LABEL = {
        CREATE: "작성",
        UPDATE: "수정",
        DELETE: "삭제"
    };

    let allLogs = [];

    const logTableBody =
        document.getElementById("logTableBody");

    const logResultCount =
        document.getElementById("logResultCount");

    const logEmptyResult =
        document.getElementById("logEmptyResult");

    let currentLogType = "ALL";
    let currentLogKeyword = "";

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    function renderLogTable() {

        const filtered = allLogs.filter(function (log) {

            const matchesType =
                currentLogType === "ALL" || log.type === currentLogType;

            const actorNickname = log.actorNickname || "";
            const postTitle = log.postTitle || "";

            const matchesKeyword =
                currentLogKeyword === ""
                || postTitle.toLowerCase().indexOf(currentLogKeyword) !== -1
                || actorNickname.toLowerCase().indexOf(currentLogKeyword) !== -1;

            return matchesType && matchesKeyword;

        });

        logTableBody.innerHTML = filtered.map(function (log) {

            const displayTime =
                log.time ? log.time.slice(0, 16).replace("T", " ") : "";

            return "<tr>"
                + "<td><span class=\"admin-log-type admin-log-" + escapeHtml(String(log.type).toLowerCase()) + "\">"
                + escapeHtml(LOG_TYPE_LABEL[log.type] || String(log.type)) + "</span></td>"
                + "<td>" + escapeHtml(displayTime) + "</td>"
                + "<td>" + escapeHtml(log.postTitle || "") + "</td>"
                + "<td>" + escapeHtml(log.actorNickname || "") + "</td>"
                + "</tr>";

        }).join("");

        logResultCount.innerHTML =
            "전체 로그 <strong>" + filtered.length + "</strong>건";

        logEmptyResult.hidden = filtered.length !== 0;

    }

    async function loadLogs() {

        allLogs = await postsStore.getAllLogs();

        renderLogTable();
    }

    loadLogs();


    const logTypeButtons =
        document.querySelectorAll("#logTypeFilter .filter-button");

    logTypeButtons.forEach(function (button) {

        button.addEventListener("click", function () {

            logTypeButtons.forEach(function (other) {
                other.classList.remove("active");
            });

            button.classList.add("active");

            currentLogType = button.dataset.type;

            renderLogTable();

        });

    });


    const logSearchForm =
        document.getElementById("logSearchForm");

    const logSearchKeyword =
        document.getElementById("logSearchKeyword");

    logSearchForm.addEventListener("submit", function (event) {

        event.preventDefault();

        currentLogKeyword =
            logSearchKeyword.value.trim().toLowerCase();

        renderLogTable();

    });
</script>

</body>
</html>
