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
         게시글 로그
         실제 이력 저장소는 없고, 화면 확인용 하드코딩된 로그다.
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

<script>
    /*
     * 실제로는 게시글 작성/수정/삭제 시점마다 서버에 기록해야 하지만
     * 지금은 화면 확인용 하드코딩 데이터를 사용한다.
     */

    const LOG_TYPE_LABEL = {
        CREATE: "작성",
        UPDATE: "수정",
        DELETE: "삭제"
    };

    const MOCK_LOGS = [
        { type: "CREATE", time: "2026-09-10 09:12", postTitle: "제주도 2박 3일 힐링 여행", actor: "바다소년" },
        { type: "CREATE", time: "2026-09-05 14:03", postTitle: "부산 해운대 맛집 총정리", actor: "먹부림" },
        { type: "UPDATE", time: "2026-09-06 08:41", postTitle: "부산 해운대 맛집 총정리", actor: "먹부림" },
        { type: "CREATE", time: "2026-09-12 11:27", postTitle: "후쿠오카 3박 4일, 먹고 걷고 또 먹은 여행", actor: "여행좋아" },
        { type: "CREATE", time: "2026-09-01 19:55", postTitle: "오사카 쇼핑 스팟 완전 정리", actor: "쇼퍼홀릭" },
        { type: "UPDATE", time: "2026-09-02 10:02", postTitle: "오사카 쇼핑 스팟 완전 정리", actor: "쇼퍼홀릭" },
        { type: "CREATE", time: "2026-09-13 20:14", postTitle: "도쿄 디즈니랜드 완전 정복기", actor: "디즈니덕후" },
        { type: "CREATE", time: "2026-09-08 13:36", postTitle: "처음 떠나는 유럽, 스페인 바르셀로나", actor: "길위에서" },
        { type: "DELETE", time: "2026-09-09 21:47", postTitle: "(삭제됨) 바르셀로나 야경 스팟", actor: "길위에서" },
        { type: "CREATE", time: "2026-09-03 16:20", postTitle: "파리에서 놓치면 안 되는 쇼핑 리스트", actor: "파리지앵" }
    ];

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

        const filtered = MOCK_LOGS.filter(function (log) {

            const matchesType =
                currentLogType === "ALL" || log.type === currentLogType;

            const matchesKeyword =
                currentLogKeyword === ""
                || log.postTitle.toLowerCase().indexOf(currentLogKeyword) !== -1
                || log.actor.toLowerCase().indexOf(currentLogKeyword) !== -1;

            return matchesType && matchesKeyword;

        });

        logTableBody.innerHTML = filtered.map(function (log) {

            return "<tr>"
                + "<td><span class=\"admin-log-type admin-log-" + log.type.toLowerCase() + "\">"
                + LOG_TYPE_LABEL[log.type] + "</span></td>"
                + "<td>" + log.time + "</td>"
                + "<td>" + escapeHtml(log.postTitle) + "</td>"
                + "<td>" + escapeHtml(log.actor) + "</td>"
                + "</tr>";

        }).join("");

        logResultCount.innerHTML =
            "전체 로그 <strong>" + filtered.length + "</strong>건";

        logEmptyResult.hidden = filtered.length !== 0;

    }

    renderLogTable();


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
