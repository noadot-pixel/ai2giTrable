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

            <a href="#">
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
            <a href="#"
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

            <a href="#">
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

                    <a href="#">
                        더보기 〉
                    </a>

                </div>

            </div>

            <div class="country-card-list">

                <!-- 실제 게시물에는 data-date를 입력 -->
                <article class="story-card"
                         data-date="2026-09-10">

                    <a href="#"
                       class="story-image">

                        <img src="<%= contextPath %>/images/jeju.jpg"
                             alt="제주도 2박 3일 여행">
                    </a>

                    <div class="story-content">

                        <span class="story-category">
                            한국 여행지
                        </span>

                        <h3>
                            <a href="#">
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

                <!-- 빈 카드에는 data-empty를 입력 -->
                <article class="empty-story-card"
                         data-empty="true">

                    <div class="empty-folder">
                        📁
                    </div>

                    <p>
                        새로운 한국 여행 이야기가<br>
                        등록될 공간입니다.
                    </p>

                </article>

                <article class="empty-story-card"
                         data-empty="true">

                    <div class="empty-folder">
                        📁
                    </div>

                    <p>
                        새로운 한국 여행 이야기가<br>
                        등록될 공간입니다.
                    </p>

                </article>

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

                    <a href="#">
                        더보기 〉
                    </a>

                </div>

            </div>

            <div class="country-card-list">

                <article class="story-card"
                         data-date="2026-09-12">

                    <a href="#"
                       class="story-image">

                        <img src="<%= contextPath %>/images/fukuoka.jpg"
                             alt="후쿠오카 3박 4일 여행">
                    </a>

                    <div class="story-content">

                        <span class="story-category">
                            일본 여행지
                        </span>

                        <h3>
                            <a href="#">
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

                <article class="empty-story-card"
                         data-empty="true">

                    <div class="empty-folder">
                        📁
                    </div>

                    <p>
                        새로운 일본 여행 이야기가<br>
                        등록될 공간입니다.
                    </p>

                </article>

                <article class="empty-story-card"
                         data-empty="true">

                    <div class="empty-folder">
                        📁
                    </div>

                    <p>
                        새로운 일본 여행 이야기가<br>
                        등록될 공간입니다.
                    </p>

                </article>

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

                    <a href="#">
                        더보기 〉
                    </a>

                </div>

            </div>

            <div class="country-card-list">

                <article class="story-card"
                         data-date="2026-09-08">

                    <a href="#"
                       class="story-image">

                        <img src="<%= contextPath %>/images/barcelona.jpg"
                             alt="스페인 바르셀로나 여행">
                    </a>

                    <div class="story-content">

                        <span class="story-category">
                            세계 여행지
                        </span>

                        <h3>
                            <a href="#">
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

                <article class="empty-story-card"
                         data-empty="true">

                    <div class="empty-folder">
                        📁
                    </div>

                    <p>
                        새로운 세계 여행 이야기가<br>
                        등록될 공간입니다.
                    </p>

                </article>

                <article class="empty-story-card"
                         data-empty="true">

                    <div class="empty-folder">
                        📁
                    </div>

                    <p>
                        새로운 세계 여행 이야기가<br>
                        등록될 공간입니다.
                    </p>

                </article>

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

            <a href="#">
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
     * 각 국가 게시판 게시물을 최신순으로 정렬
     *
     * 실제 게시물:
     * data-date="2026-09-12"
     *
     * 빈 카드:
     * data-empty="true"
     */

    function sortBoardsByLatestDate() {

        const boardLists =
            document.querySelectorAll(
                ".country-card-list"
            );

        boardLists.forEach(function (boardList) {

            const cards =
                Array.from(boardList.children);

            cards.sort(function (firstCard, secondCard) {

                const firstIsEmpty =
                    firstCard.dataset.empty === "true";

                const secondIsEmpty =
                    secondCard.dataset.empty === "true";

                /*
                 * 빈 카드는 무조건 뒤로 이동
                 */

                if (firstIsEmpty && !secondIsEmpty) {
                    return 1;
                }

                if (!firstIsEmpty && secondIsEmpty) {
                    return -1;
                }

                if (firstIsEmpty && secondIsEmpty) {
                    return 0;
                }

                /*
                 * 최신 날짜가 앞으로 오도록 정렬
                 */

                const firstDate =
                    new Date(firstCard.dataset.date);

                const secondDate =
                    new Date(secondCard.dataset.date);

                return secondDate - firstDate;

            });

            cards.forEach(function (card) {
                boardList.appendChild(card);
            });

        });

    }

    sortBoardsByLatestDate();
</script>

</body>
</html>