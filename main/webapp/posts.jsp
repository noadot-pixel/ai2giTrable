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
            전체 게시글 <strong>0</strong>개
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

        <!-- Firestore에서 불러온 게시글 카드가 여기에 채워진다 -->

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

<script src="<%= contextPath %>/js/posts-store.js"></script>
<script src="<%= contextPath %>/js/author-info.js"></script>

<script>
    const postList =
        document.getElementById("postList");

    const resultCount =
        document.getElementById("resultCount");

    const emptyResult =
        document.getElementById("emptyResult");

    const searchInput =
        document.getElementById("searchKeyword");

    let currentCountry = "ALL";
    let currentStyle = "ALL";
    let currentKeyword = "";

    let postCards = [];

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    /*
     * Firestore의 posts 컬렉션을 읽어 카드로 렌더링한다.
     * 작성자 본인 글, 또는 관리자 계정이면 수정/삭제 버튼이 붙는다.
     * (기존 목록 화면에 관리자용 기능을 표시하는 방식 - 별도 관리 페이지 없음)
     */

    async function loadPosts() {

        const posts = await postsStore.getAllPosts();

        const currentUser =
            mockAuth.getCurrentUser();

        const isAdminUser =
            await mockAuth.isAdmin();

        postList.innerHTML = "";

        posts.forEach(function (post) {

            const isMine =
                currentUser && currentUser.id === post.authorUid;

            const canManage =
                isMine || isAdminUser;

            const article =
                document.createElement("article");

            article.className = "story-card";
            article.dataset.postId = post.id;
            article.dataset.country = post.country;
            article.dataset.style = post.style;
            article.dataset.date = post.createdAt;
            article.dataset.views = post.views || 0;

            const displayDate =
                post.createdAt ? post.createdAt.slice(0, 10).replace(/-/g, ".") : "";

            const actionsHtml = canManage
                ? '<div class="detail-actions local-post-actions">'
                    + '<a href="<%= contextPath %>/posts/edit.jsp?id=' + post.id + '" class="detail-edit-button">수정</a>'
                    + '<button type="button" class="detail-delete-button" data-post-id="' + post.id + '">삭제</button>'
                    + '</div>'
                : '';

            article.innerHTML =
                '<a href="<%= contextPath %>/posts/detail.jsp?id=' + post.id + '" class="story-image">'
                + '<img src="' + escapeHtml(postsStore.imageSrc(post, "<%= contextPath %>/images/")) + '" alt="'
                + escapeHtml(post.title) + '"></a>'
                + '<div class="story-content">'
                + '<span class="story-category">' + escapeHtml(post.countryLabel) + '</span>'
                + '<h3><a href="<%= contextPath %>/posts/detail.jsp?id=' + post.id + '">'
                + escapeHtml(post.title) + '</a></h3>'
                + '<p>' + escapeHtml(post.body) + '</p>'
                + '<div class="story-information">'
                + '<span>' + escapeHtml(post.authorNickname) + '</span>'
                + (isMine ? '<span class="my-post-badge">내 글</span>' : '')
                + '<span>' + displayDate + '</span>'
                + '<span>조회 ' + (post.views || 0) + '</span>'
                + '<span>좋아요 ' + (post.likes || 0) + '</span>'
                + '<span>댓글 ' + (post.comments || 0) + '</span>'
                + '</div>'
                + '<div class="author-info" data-author-uid="' + post.authorUid
                + '" data-author-nickname="' + escapeHtml(post.authorNickname) + '"></div>'
                + actionsHtml
                + '</div>';

            postList.appendChild(article);

        });

        postCards = Array.from(postList.querySelectorAll(".story-card"));

        sortPostList("latest");
        applyFilters();

        initAuthorInfo(postList);

    }

    postList.addEventListener("click", async function (event) {

        const deleteButton = event.target.closest(".detail-delete-button");

        if (!deleteButton) {
            return;
        }

        const isConfirmed =
            confirm("이 게시글을 삭제하시겠습니까?");

        if (!isConfirmed) {
            return;
        }

        const postId = deleteButton.dataset.postId;
        const card = deleteButton.closest(".story-card");
        const postTitle = card.querySelector("h3 a").textContent.trim();
        const currentUser = mockAuth.getCurrentUser();

        await postsStore.deletePost(
            postId,
            postTitle,
            currentUser.id,
            currentUser.nickname
        );

        loadPosts();

    });


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


    /*
     * index.jsp의 "전체보기"/"더보기" 링크에서 넘어온 country/style
     * 쿼리 파라미터가 있으면 해당 필터를 미리 선택된 상태로 적용한다.
     * 예: posts.jsp?country=KR, posts.jsp?style=food
     */

    function applyInitialFilterFromUrl() {

        const params =
            new URLSearchParams(location.search);

        const initialCountry = params.get("country");
        const initialStyle = params.get("style");

        if (initialCountry) {

            const countryButton =
                document.querySelector(
                    '#countryFilter .filter-button[data-country="' + initialCountry + '"]'
                );

            if (countryButton) {

                document.querySelectorAll("#countryFilter .filter-button")
                    .forEach(function (other) {
                        other.classList.remove("active");
                    });

                countryButton.classList.add("active");

                currentCountry = initialCountry;
            }

        }

        if (initialStyle) {

            const styleButton =
                document.querySelector(
                    '#styleFilter .filter-button[data-style="' + initialStyle + '"]'
                );

            if (styleButton) {

                document.querySelectorAll("#styleFilter .filter-button")
                    .forEach(function (other) {
                        other.classList.remove("active");
                    });

                styleButton.classList.add("active");

                currentStyle = initialStyle;
            }

        }

    }

    applyInitialFilterFromUrl();
    loadPosts();
</script>

</body>
</html>
