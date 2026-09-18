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

    <title>여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<!-- =========================
     상단 헤더
========================= -->

<% String activeNav = "home"; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         메인 이미지
    ========================== -->

    <section class="main-visual">

        <div class="main-overlay"></div>

        <div class="main-content">

            <p class="main-label">
                KOREA · JAPAN · WORLD
            </p>

            <h1>
                여행을 만들면
                <span>새로운 이야기가 시작된다</span>
            </h1>

            <p class="main-description">
                한국과 일본, 우리들의 특별한 여행을<br>
                함께 만들어가는 여행 커뮤니티입니다.
            </p>

            <form class="search-form"
                  id="searchForm"
                  action="#"
                  method="get">

                <label for="searchKeyword"
                       class="blind">
                    여행지 검색
                </label>

                <span class="search-icon">
                    ⌕
                </span>

                <input type="text"
                       id="searchKeyword"
                       name="keyword"
                       placeholder="어디로 떠나고 싶으신가요?">

                <button type="submit">
                    검색
                </button>

            </form>

            <div class="recommend-keywords">

                <button type="button">#서울</button>
                <button type="button">#제주도</button>
                <button type="button">#도쿄</button>
                <button type="button">#오사카</button>
                <button type="button">#후쿠오카</button>
                <button type="button">#바르셀로나</button>

            </div>

        </div>

    </section>

    <!-- =========================
         여행 카테고리
    ========================== -->

    <section class="category-section"
             id="travelCategory">

        <div class="section-heading">

            <h2>여행 카테고리</h2>

            <a href="<%= contextPath %>/posts.jsp">
                전체보기 〉
            </a>

        </div>

        <div class="category-list">

            <!-- 한국 여행지 -->
            <a href="#koreaBoard"
               class="category-card">

                <img src="<%= contextPath %>/images/korea.jpg"
                     alt="한국 여행지">

                <div class="category-content">

                    <h3>한국 여행지</h3>

                    <p>
                        국내의 아름다운 여행지를 만나보세요.
                    </p>

                </div>

            </a>

            <!-- 일본 여행지 -->
            <a href="#japanBoard"
               class="category-card">

                <img src="<%= contextPath %>/images/japan.jpg"
                     alt="일본 여행지">

                <div class="category-content">

                    <h3>일본 여행지</h3>

                    <p>
                        가깝고도 새로운 일본을 여행해 보세요.
                    </p>

                </div>

            </a>

            <!-- 세계 여행지 -->
            <a href="#worldBoard"
               class="category-card">

                <img src="<%= contextPath %>/images/world.jpg"
                     alt="세계 여행지">

                <div class="category-content">

                    <h3>세계 여행지</h3>

                    <p>
                        더 멀리, 더 새로운 세계로 떠나보세요.
                    </p>

                </div>

            </a>

            <!-- 여행지 맛집 -->
            <a href="<%= contextPath %>/posts.jsp?style=food"
               class="category-card">

                <img src="<%= contextPath %>/images/travel_food.jpg"
                     alt="여행지 맛집">

                <div class="category-content">

                    <h3>여행지 맛집</h3>

                    <p>
                        여행에서 놓칠 수 없는 맛집을 소개합니다.
                    </p>

                </div>

            </a>

        </div>

    </section>

    <!-- =========================
         국가별 최신 게시물
    ========================== -->

    <section class="story-section"
             id="travelStory">

        <div class="section-heading">

            <h2>📝 최신 여행 이야기</h2>

            <a href="<%= contextPath %>/posts.jsp">
                전체보기 〉
            </a>

        </div>

        <!-- =====================
             한국 여행지
        ====================== -->

        <section class="country-board"
                 id="koreaBoard">

            <div class="country-heading">

                <h3>🌺 한국 여행지</h3>

                <div class="country-heading-right">

                    <span>최신순</span>

                    <a href="<%= contextPath %>/posts.jsp?country=KR">
                        더보기 〉
                    </a>

                </div>

            </div>

            <div class="country-card-list"
                 id="koreaCardList">

                <!-- Firestore에서 불러온 한국 여행지 최신 게시물이 여기에 채워진다 -->

            </div>

        </section>

        <!-- =====================
             일본 여행지
        ====================== -->

        <section class="country-board"
                 id="japanBoard">

            <div class="country-heading">

                <h3>🍣 일본 여행지</h3>

                <div class="country-heading-right">

                    <span>최신순</span>

                    <a href="<%= contextPath %>/posts.jsp?country=JP">
                        더보기 〉
                    </a>

                </div>

            </div>

            <div class="country-card-list"
                 id="japanCardList">

                <!-- Firestore에서 불러온 일본 여행지 최신 게시물이 여기에 채워진다 -->

            </div>

        </section>

        <!-- =====================
             세계 여행지
        ====================== -->

        <section class="country-board"
                 id="worldBoard">

            <div class="country-heading">

                <h3>🌍 세계 여행지</h3>

                <div class="country-heading-right">

                    <span>최신순</span>

                    <a href="<%= contextPath %>/posts.jsp?country=ETC">
                        더보기 〉
                    </a>

                </div>

            </div>

            <div class="country-card-list"
                 id="worldCardList">

                <!-- Firestore에서 불러온 세계 여행지 최신 게시물이 여기에 채워진다 -->

            </div>

        </section>

    </section>

    <!-- =========================
         하단 전체 사진
    ========================== -->

    <section class="footer-visual">

        <div class="footer-visual-overlay"></div>

        <div class="footer-visual-content">

            <h2>
                좋은 사람들과 함께 만드는 여행
            </h2>

            <p>
                새로운 여행 이야기를 여행만들기에서
                함께 공유해 보세요.
            </p>

            <a href="<%= contextPath %>/posts/write.jsp">
                여행 이야기 작성하기
            </a>

        </div>

    </section>

</main>

<!-- =========================
     하단 푸터
========================= -->

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>

<script>
    /*
     * 추천 검색어를 클릭하면 검색창에 입력
     */

    const searchInput =
        document.getElementById("searchKeyword");

    const keywordButtons =
        document.querySelectorAll(
            ".recommend-keywords button"
        );

    keywordButtons.forEach(function (button) {

        button.addEventListener("click", function () {

            searchInput.value =
                button.textContent.replace("#", "");

            searchInput.focus();
        });

    });


    /*
     * 검색 버튼 임시 기능
     */

    const searchForm =
        document.getElementById("searchForm");

    searchForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const keyword =
            searchInput.value.trim();

        if (keyword === "") {

            alert("검색할 여행지를 입력해 주세요.");

            searchInput.focus();

            return;
        }

        alert(
            keyword
            + " 검색 기능은 게시판 제작 후 연결합니다."
        );

    });


    /*
     * Firestore posts 컬렉션에서 국가별 최신 게시물을 최대 3개씩 보여준다.
     * 모자란 칸은 빈 카드로 채운다.
     */

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    function renderCountryBoard(containerId, countryCode, posts, emptyText) {

        const container =
            document.getElementById(containerId);

        const countryPosts =
            posts.filter(function (post) {
                return post.country === countryCode;
            }).slice(0, 3);

        container.innerHTML = countryPosts.map(function (post) {

            const detailUrl =
                "<%= contextPath %>/posts/detail.jsp?id=" + post.id;

            return '<article class="story-card">'
                + '<a href="' + detailUrl + '" class="story-image">'
                + '<img src="<%= contextPath %>/images/' + post.image + '" alt="'
                + escapeHtml(post.title) + '"></a>'
                + '<div class="story-content">'
                + '<span class="story-category">' + escapeHtml(post.countryLabel) + '</span>'
                + '<h3><a href="' + detailUrl + '">' + escapeHtml(post.title) + '</a></h3>'
                + '<p>' + escapeHtml(post.body) + '</p>'
                + '<div class="story-information">'
                + '<span>' + escapeHtml(post.authorNickname) + '</span>'
                + '<span>' + (post.createdAt ? post.createdAt.slice(0, 10).replace(/-/g, ".") : "") + '</span>'
                + '<span>조회 ' + (post.views || 0) + '</span>'
                + '<span>댓글 ' + (post.comments || 0) + '</span>'
                + '</div></div></article>';

        }).join("");

        for (let i = countryPosts.length; i < 3; i++) {

            container.innerHTML +=
                '<article class="empty-story-card" data-empty="true">'
                + '<div class="empty-folder">📁</div>'
                + '<p>' + emptyText + '</p>'
                + '</article>';

        }

    }

    (async function loadHomeStories() {

        const posts = await postsStore.getAllPosts();

        renderCountryBoard("koreaCardList", "KR", posts, "새로운 한국 여행 이야기가<br>등록될 공간입니다.");
        renderCountryBoard("japanCardList", "JP", posts, "새로운 일본 여행 이야기가<br>등록될 공간입니다.");
        renderCountryBoard("worldCardList", "ETC", posts, "새로운 세계 여행 이야기가<br>등록될 공간입니다.");

    })();
</script>

</body>
</html>