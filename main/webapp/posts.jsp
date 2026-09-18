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

    <title>게시글 목록 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<!-- =========================
     상단 헤더
========================= -->

<% String activeNav = "posts"; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         페이지 타이틀
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 게시글 목록
        </p>

        <h1>게시글 목록</h1>

        <p class="page-description">
            국가와 여행 성향으로 원하는 여행 이야기를 찾아보세요.
        </p>

    </section>

    <!-- =========================
         검색 및 필터
    ========================== -->

    <section class="filter-section">

        <form class="search-form"
              id="searchForm"
              action="#"
              method="get">

            <label for="searchKeyword"
                   class="blind">
                게시글 검색
            </label>

            <span class="search-icon">
                ⌕
            </span>

            <input type="text"
                   id="searchKeyword"
                   name="keyword"
                   placeholder="제목으로 검색해 보세요">

            <button type="submit">
                검색
            </button>

        </form>

        <!-- 국가 코드는 확정 전이라 KR/JP/ETC를 임시로 사용합니다 -->
        <div class="filter-group"
             id="countryFilter">

            <p class="filter-label">국가</p>

            <button type="button"
                    class="filter-button active"
                    data-country="ALL">
                전체
            </button>

            <button type="button"
                    class="filter-button"
                    data-country="KR">
                한국
            </button>

            <button type="button"
                    class="filter-button"
                    data-country="JP">
                일본
            </button>

            <button type="button"
                    class="filter-button"
                    data-country="ETC">
                세계
            </button>

        </div>

        <!-- 여행 성향 목록은 미확정이라 예시 항목만 넣었습니다 -->
        <div class="filter-group"
             id="styleFilter">

            <p class="filter-label">여행 성향</p>

            <button type="button"
                    class="filter-button active"
                    data-style="ALL">
                전체
            </button>

            <button type="button"
                    class="filter-button"
                    data-style="healing">
                힐링
            </button>

            <button type="button"
                    class="filter-button"
                    data-style="food">
                맛집
            </button>

            <button type="button"
                    class="filter-button"
                    data-style="activity">
                액티비티
            </button>

            <button type="button"
                    class="filter-button"
                    data-style="shopping">
                쇼핑
            </button>

        </div>

    </section>

    <!-- =========================
         목록 헤더 (결과 수 / 정렬)
    ========================== -->

    <section class="list-heading">

        <p id="resultCount">
            전체 게시글 <strong>9</strong>개
        </p>

        <div class="sort-group"
             id="sortGroup">

            <button type="button"
                    class="sort-button active"
                    data-sort="latest">
                최신순
            </button>

            <button type="button"
                    class="sort-button"
                    data-sort="popular">
                인기순
            </button>

        </div>

    </section>

    <!-- =========================
         게시글 목록
    ========================== -->

    <section class="post-list"
             id="postList">

        <!-- 실제 게시물에는 data-country, data-style, data-date, data-views를 입력 -->

        <article class="story-card"
                 data-country="KR"
                 data-style="healing"
                 data-date="2026-09-10"
                 data-views="892">

            <a href="<%= contextPath %>/posts/detail.jsp?id=1"
               class="story-image">

                <img src="<%= contextPath %>/images/jeju.jpg"
                     alt="제주도 2박 3일 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    한국 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=1">
                        제주도 2박 3일 힐링 여행
                    </a>
                </h3>

                <p>
                    아름다운 바다와 카페, 맛집까지
                    알차게 다녀온 제주 여행 기록입니다.
                </p>

                <div class="story-information">
                    <span>바다소년</span>
                    <span>2026.09.10</span>
                    <span>조회 892</span>
                    <span>댓글 18</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="KR"
                 data-style="food"
                 data-date="2026-09-05"
                 data-views="1560">

            <a href="<%= contextPath %>/posts/detail.jsp?id=2"
               class="story-image">

                <img src="<%= contextPath %>/images/korea.jpg"
                     alt="부산 해운대 맛집 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    한국 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=2">
                        부산 해운대 맛집 총정리
                    </a>
                </h3>

                <p>
                    해운대 근처에서 직접 먹어보고 고른
                    진짜 맛집만 모았습니다.
                </p>

                <div class="story-information">
                    <span>먹부림</span>
                    <span>2026.09.05</span>
                    <span>조회 1,560</span>
                    <span>댓글 27</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="KR"
                 data-style="activity"
                 data-date="2026-09-14"
                 data-views="430">

            <a href="<%= contextPath %>/posts/detail.jsp?id=3"
               class="story-image">

                <img src="<%= contextPath %>/images/korea.jpg"
                     alt="서울 근교 액티비티 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    한국 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=3">
                        서울 근교 당일치기 액티비티 코스
                    </a>
                </h3>

                <p>
                    짧은 시간에도 알차게 즐길 수 있는
                    액티비티 코스를 소개합니다.
                </p>

                <div class="story-information">
                    <span>주말러</span>
                    <span>2026.09.14</span>
                    <span>조회 430</span>
                    <span>댓글 5</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="JP"
                 data-style="food"
                 data-date="2026-09-12"
                 data-views="1245">

            <a href="<%= contextPath %>/posts/detail.jsp?id=4"
               class="story-image">

                <img src="<%= contextPath %>/images/fukuoka.jpg"
                     alt="후쿠오카 3박 4일 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    일본 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=4">
                        후쿠오카 3박 4일, 먹고 걷고 또 먹은 여행
                    </a>
                </h3>

                <p>
                    첫 일본 자유여행에서 만족했던 맛집과
                    숙소, 교통 정보를 정리했습니다.
                </p>

                <div class="story-information">
                    <span>여행좋아</span>
                    <span>2026.09.12</span>
                    <span>조회 1,245</span>
                    <span>댓글 32</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="JP"
                 data-style="shopping"
                 data-date="2026-09-01"
                 data-views="980">

            <a href="<%= contextPath %>/posts/detail.jsp?id=5"
               class="story-image">

                <img src="<%= contextPath %>/images/japan.jpg"
                     alt="오사카 쇼핑 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    일본 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=5">
                        오사카 쇼핑 스팟 완전 정리
                    </a>
                </h3>

                <p>
                    도톤보리부터 신사이바시까지 쇼핑
                    동선을 그대로 공유합니다.
                </p>

                <div class="story-information">
                    <span>쇼퍼홀릭</span>
                    <span>2026.09.01</span>
                    <span>조회 980</span>
                    <span>댓글 14</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="JP"
                 data-style="activity"
                 data-date="2026-09-13"
                 data-views="2210">

            <a href="<%= contextPath %>/posts/detail.jsp?id=6"
               class="story-image">

                <img src="<%= contextPath %>/images/japan.jpg"
                     alt="도쿄 디즈니랜드 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    일본 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=6">
                        도쿄 디즈니랜드 완전 정복기
                    </a>
                </h3>

                <p>
                    대기 시간을 줄이는 동선과 꿀팁까지
                    한 번에 정리했습니다.
                </p>

                <div class="story-information">
                    <span>디즈니덕후</span>
                    <span>2026.09.13</span>
                    <span>조회 2,210</span>
                    <span>댓글 45</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="ETC"
                 data-style="healing"
                 data-date="2026-09-08"
                 data-views="2103">

            <a href="<%= contextPath %>/posts/detail.jsp?id=7"
               class="story-image">

                <img src="<%= contextPath %>/images/barcelona.jpg"
                     alt="스페인 바르셀로나 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    세계 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=7">
                        처음 떠나는 유럽, 스페인 바르셀로나
                    </a>
                </h3>

                <p>
                    캄프 누에서의 열정을 느낄 수 있는
                    바르셀로나 여행을 준비합니다.
                </p>

                <div class="story-information">
                    <span>길위에서</span>
                    <span>2026.09.08</span>
                    <span>조회 2,103</span>
                    <span>댓글 41</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="ETC"
                 data-style="food"
                 data-date="2026-08-30"
                 data-views="1670">

            <a href="<%= contextPath %>/posts/detail.jsp?id=8"
               class="story-image">

                <img src="<%= contextPath %>/images/world.jpg"
                     alt="방콕 맛집 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    세계 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=8">
                        방콕 길거리 맛집 탐방기
                    </a>
                </h3>

                <p>
                    현지인 추천 노점부터 유명 맛집까지
                    직접 다녀온 후기입니다.
                </p>

                <div class="story-information">
                    <span>street food</span>
                    <span>2026.08.30</span>
                    <span>조회 1,670</span>
                    <span>댓글 23</span>
                </div>

            </div>

        </article>

        <article class="story-card"
                 data-country="ETC"
                 data-style="shopping"
                 data-date="2026-09-03"
                 data-views="760">

            <a href="<%= contextPath %>/posts/detail.jsp?id=9"
               class="story-image">

                <img src="<%= contextPath %>/images/world.jpg"
                     alt="파리 쇼핑 여행">
            </a>

            <div class="story-content">

                <span class="story-category">
                    세계 여행지
                </span>

                <h3>
                    <a href="<%= contextPath %>/posts/detail.jsp?id=9">
                        파리에서 놓치면 안 되는 쇼핑 리스트
                    </a>
                </h3>

                <p>
                    면세 쇼핑부터 로컬 편집숍까지
                    동선대로 정리했습니다.
                </p>

                <div class="story-information">
                    <span>파리지앵</span>
                    <span>2026.09.03</span>
                    <span>조회 760</span>
                    <span>댓글 9</span>
                </div>

            </div>

        </article>

    </section>

    <!-- 필터 결과가 없을 때만 표시 -->
    <p class="empty-result"
       id="emptyResult"
       hidden>
        조건에 맞는 게시글이 없습니다.
    </p>

    <!-- =========================
         페이지네이션
    ========================== -->

    <nav class="pagination"
         id="pagination">

        <button type="button"
                class="page-button active"
                data-page="1">
            1
        </button>

        <button type="button"
                class="page-button"
                data-page="2">
            2
        </button>

        <button type="button"
                class="page-button"
                data-page="3">
            3
        </button>

    </nav>

</main>

<!-- =========================
     하단 푸터
========================= -->

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script>
    const postList =
        document.getElementById("postList");


    /*
     * 글쓰기 화면에서 저장한 게시글(localStorage)을 목록 맨 앞에 추가한다.
     * 실제 저장소가 아니라 이 브라우저에만 남는 임시 데이터이며,
     * 상세 페이지가 아직 없어 클릭하면 안내만 표시한다.
     */

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    function renderLocalPosts() {

        const savedPosts =
            JSON.parse(localStorage.getItem("trable_mock_posts") || "[]");

        if (savedPosts.length === 0) {
            return;
        }

        const currentUser =
            mockAuth.getCurrentUser();

        savedPosts.forEach(function (post) {

            const isMine =
                currentUser && currentUser.nickname === post.author;

            const article =
                document.createElement("article");

            article.className = "story-card";
            article.dataset.localId = post.id;
            article.dataset.country = post.country;
            article.dataset.style = post.style;
            article.dataset.date = post.dataDate;
            article.dataset.views = "0";

            const actionsHtml = isMine
                ? '<div class="detail-actions local-post-actions">'
                    + '<a href="<%= contextPath %>/posts/edit.jsp?id=' + post.id + '" class="detail-edit-button">수정</a>'
                    + '<button type="button" class="detail-delete-button local-delete-button">삭제</button>'
                    + '</div>'
                : '';

            article.innerHTML =
                '<a href="#" class="story-image local-post-link">'
                + '<img src="<%= contextPath %>/images/' + post.image + '" alt="'
                + escapeHtml(post.title) + '"></a>'
                + '<div class="story-content">'
                + '<span class="story-category">' + escapeHtml(post.countryLabel) + '</span>'
                + '<h3><a href="#" class="local-post-link">' + escapeHtml(post.title) + '</a></h3>'
                + '<p>' + escapeHtml(post.body) + '</p>'
                + '<div class="story-information">'
                + '<span>' + escapeHtml(post.author) + '</span>'
                + (isMine ? '<span class="my-post-badge">내 글</span>' : '')
                + '<span>' + post.displayDate + '</span>'
                + '<span>조회 0</span>'
                + '<span>댓글 0</span>'
                + '</div>'
                + actionsHtml
                + '</div>';

            postList.insertBefore(article, postList.firstChild);

        });

    }

    renderLocalPosts();

    postList.addEventListener("click", function (event) {

        const deleteButton = event.target.closest(".local-delete-button");

        if (deleteButton) {

            const card = deleteButton.closest(".story-card");
            const localId = card.dataset.localId;

            const isConfirmed =
                confirm("이 게시글을 삭제하시겠습니까?");

            if (!isConfirmed) {
                return;
            }

            const savedPosts =
                JSON.parse(localStorage.getItem("trable_mock_posts") || "[]");

            const remainingPosts =
                savedPosts.filter(function (post) {
                    return post.id !== localId;
                });

            localStorage.setItem(
                "trable_mock_posts",
                JSON.stringify(remainingPosts)
            );

            location.reload();

            return;
        }

        if (event.target.closest(".local-post-link")) {

            event.preventDefault();

            alert("직접 작성한 게시글은 데모용이라 상세 페이지가 아직 연결되지 않았어요.");
        }

    });


    const postCards =
        Array.from(postList.querySelectorAll(".story-card"));

    const resultCount =
        document.getElementById("resultCount");

    const emptyResult =
        document.getElementById("emptyResult");

    const searchInput =
        document.getElementById("searchKeyword");

    let currentCountry = "ALL";
    let currentStyle = "ALL";
    let currentKeyword = "";


    /*
     * 국가 / 여행 성향 필터 버튼 공통 처리
     * 같은 그룹 안에서는 하나만 선택되도록 active를 토글
     */

    function bindFilterGroup(groupId, onSelect) {

        const group =
            document.getElementById(groupId);

        const buttons =
            group.querySelectorAll(".filter-button");

        buttons.forEach(function (button) {

            button.addEventListener("click", function () {

                buttons.forEach(function (other) {
                    other.classList.remove("active");
                });

                button.classList.add("active");

                onSelect(button);

                applyFilters();
            });

        });

    }

    bindFilterGroup("countryFilter", function (button) {
        currentCountry = button.dataset.country;
    });

    bindFilterGroup("styleFilter", function (button) {
        currentStyle = button.dataset.style;
    });


    /*
     * 검색어는 제목 기준으로만 필터링
     * (실제 검색 로직은 게시판 서버 기능 연결 후 교체)
     */

    const searchForm =
        document.getElementById("searchForm");

    searchForm.addEventListener("submit", function (event) {

        event.preventDefault();

        currentKeyword =
            searchInput.value.trim().toLowerCase();

        applyFilters();

    });


    /*
     * 국가 + 여행 성향 + 검색어를 모두 만족하는 카드만 표시
     */

    function applyFilters() {

        let visibleCount = 0;

        postCards.forEach(function (card) {

            const matchesCountry =
                currentCountry === "ALL"
                || card.dataset.country === currentCountry;

            const matchesStyle =
                currentStyle === "ALL"
                || card.dataset.style === currentStyle;

            const title =
                card.querySelector("h3 a").textContent
                    .trim().toLowerCase();

            const matchesKeyword =
                currentKeyword === ""
                || title.indexOf(currentKeyword) !== -1;

            const isVisible =
                matchesCountry && matchesStyle && matchesKeyword;

            card.hidden = !isVisible;

            if (isVisible) {
                visibleCount++;
            }

        });

        resultCount.innerHTML =
            "전체 게시글 <strong>" + visibleCount + "</strong>개";

        emptyResult.hidden = visibleCount !== 0;

    }


    /*
     * 정렬: 최신순 / 인기순
     * (댓글·좋아요 등 인기 기준은 미확정이라 조회수 기준으로 임시 정렬)
     */

    const sortButtons =
        document.querySelectorAll("#sortGroup .sort-button");

    sortButtons.forEach(function (button) {

        button.addEventListener("click", function () {

            sortButtons.forEach(function (other) {
                other.classList.remove("active");
            });

            button.classList.add("active");

            sortPostList(button.dataset.sort);

        });

    });

    function sortPostList(sortType) {

        const sortedCards =
            postCards.slice().sort(function (firstCard, secondCard) {

                if (sortType === "popular") {

                    return Number(secondCard.dataset.views)
                        - Number(firstCard.dataset.views);
                }

                const firstDate =
                    new Date(firstCard.dataset.date);

                const secondDate =
                    new Date(secondCard.dataset.date);

                return secondDate - firstDate;

            });

        sortedCards.forEach(function (card) {
            postList.appendChild(card);
        });

    }


    /*
     * 페이지네이션은 목업 단계라 페이지 이동 없이
     * 선택 상태만 표시합니다.
     */

    const pageButtons =
        document.querySelectorAll("#pagination .page-button");

    pageButtons.forEach(function (button) {

        button.addEventListener("click", function () {

            pageButtons.forEach(function (other) {
                other.classList.remove("active");
            });

            button.classList.add("active");

            alert(
                button.textContent.trim()
                + "페이지 이동 기능은 게시판 제작 후 연결합니다."
            );

        });

    });


    sortPostList("latest");
    applyFilters();
</script>

</body>
</html>
