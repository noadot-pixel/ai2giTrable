<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();

    String postId = request.getParameter("id");

    if (postId == null || postId.trim().isEmpty()) {
        postId = "1";
    }

    /*
     * 실제로는 DB에서 id로 게시글을 조회해야 하지만
     * 지금은 이벤트/화면 확인용 목업이라 하드코딩된 값을 사용한다.
     * posts.jsp의 9개 카드와 같은 순서/내용으로 맞춰뒀다.
     */

    String title;
    String author;
    String countryLabel;
    String styleLabel;
    String date;
    String views;
    String comments;
    String image;
    String imageAlt;
    String body1;
    String body2;

    switch (postId) {

        case "2":
            title = "부산 해운대 맛집 총정리";
            author = "먹부림";
            countryLabel = "한국 여행지";
            styleLabel = "맛집";
            date = "2026.09.05";
            views = "1,560";
            comments = "27";
            image = "korea.jpg";
            imageAlt = "부산 해운대 맛집 여행";
            body1 = "해운대 근처에서 직접 먹어보고 고른 진짜 맛집만 모았습니다.";
            body2 = "다음에 방문할 때도 다시 찾아갈 만한 곳들로만 추렸어요.";
            break;

        case "3":
            title = "서울 근교 당일치기 액티비티 코스";
            author = "주말러";
            countryLabel = "한국 여행지";
            styleLabel = "액티비티";
            date = "2026.09.14";
            views = "430";
            comments = "5";
            image = "korea.jpg";
            imageAlt = "서울 근교 액티비티 여행";
            body1 = "짧은 시간에도 알차게 즐길 수 있는 액티비티 코스를 소개합니다.";
            body2 = "당일치기로도 충분히 다녀올 수 있는 동선으로 짰습니다.";
            break;

        case "4":
            title = "후쿠오카 3박 4일, 먹고 걷고 또 먹은 여행";
            author = "여행좋아";
            countryLabel = "일본 여행지";
            styleLabel = "맛집";
            date = "2026.09.12";
            views = "1,245";
            comments = "32";
            image = "fukuoka.jpg";
            imageAlt = "후쿠오카 3박 4일 여행";
            body1 = "첫 일본 자유여행에서 만족했던 맛집과 숙소, 교통 정보를 정리했습니다.";
            body2 = "다음 여행에서도 참고할 수 있도록 동선 순서대로 남겨둡니다.";
            break;

        case "5":
            title = "오사카 쇼핑 스팟 완전 정리";
            author = "쇼퍼홀릭";
            countryLabel = "일본 여행지";
            styleLabel = "쇼핑";
            date = "2026.09.01";
            views = "980";
            comments = "14";
            image = "japan.jpg";
            imageAlt = "오사카 쇼핑 여행";
            body1 = "도톤보리부터 신사이바시까지 쇼핑 동선을 그대로 공유합니다.";
            body2 = "면세 절차와 환전 팁도 함께 정리했어요.";
            break;

        case "6":
            title = "도쿄 디즈니랜드 완전 정복기";
            author = "디즈니덕후";
            countryLabel = "일본 여행지";
            styleLabel = "액티비티";
            date = "2026.09.13";
            views = "2,210";
            comments = "45";
            image = "japan.jpg";
            imageAlt = "도쿄 디즈니랜드 여행";
            body1 = "대기 시간을 줄이는 동선과 꿀팁까지 한 번에 정리했습니다.";
            body2 = "입장 시간대별 전략도 함께 남겨둡니다.";
            break;

        case "7":
            title = "처음 떠나는 유럽, 스페인 바르셀로나";
            author = "길위에서";
            countryLabel = "세계 여행지";
            styleLabel = "힐링";
            date = "2026.09.08";
            views = "2,103";
            comments = "41";
            image = "barcelona.jpg";
            imageAlt = "스페인 바르셀로나 여행";
            body1 = "캄프 누에서의 열정을 느낄 수 있는 바르셀로나 여행을 준비합니다.";
            body2 = "가우디 건축물 위주로 동선을 짜서 돌아봤습니다.";
            break;

        case "8":
            title = "방콕 길거리 맛집 탐방기";
            author = "street food";
            countryLabel = "세계 여행지";
            styleLabel = "맛집";
            date = "2026.08.30";
            views = "1,670";
            comments = "23";
            image = "world.jpg";
            imageAlt = "방콕 맛집 여행";
            body1 = "현지인 추천 노점부터 유명 맛집까지 직접 다녀온 후기입니다.";
            body2 = "위생과 매운맛 정도도 함께 메모해뒀습니다.";
            break;

        case "9":
            title = "파리에서 놓치면 안 되는 쇼핑 리스트";
            author = "파리지앵";
            countryLabel = "세계 여행지";
            styleLabel = "쇼핑";
            date = "2026.09.03";
            views = "760";
            comments = "9";
            image = "world.jpg";
            imageAlt = "파리 쇼핑 여행";
            body1 = "면세 쇼핑부터 로컬 편집숍까지 동선대로 정리했습니다.";
            body2 = "환불 절차와 주의할 점도 같이 남겨둡니다.";
            break;

        case "1":
        default:
            postId = "1";
            title = "제주도 2박 3일 힐링 여행";
            author = "바다소년";
            countryLabel = "한국 여행지";
            styleLabel = "힐링";
            date = "2026.09.10";
            views = "892";
            comments = "18";
            image = "jeju.jpg";
            imageAlt = "제주도 2박 3일 여행";
            body1 = "아름다운 바다와 카페, 맛집까지 알차게 다녀온 제주 여행 기록입니다.";
            body2 = "다음에 또 가고 싶을 만큼 만족스러웠던 코스만 남겨둡니다.";
            break;
    }
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title><%= title %> - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<% String activeNav = "posts"; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         게시글 상세
         실제 데이터는 없고 id별로 하드코딩된 값을 보여주는 목업입니다.
         작성자 판별도 실제 세션이 아니라 mockAuth 로그인 여부로만 대체합니다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/posts.jsp">게시글 목록</a>
            〉 상세
        </p>

    </section>

    <section class="detail-section">

        <div class="detail-header">

            <div class="detail-tags">
                <span class="story-category"><%= countryLabel %></span>
                <span class="detail-style-tag"><%= styleLabel %></span>
            </div>

            <h1><%= title %></h1>

            <div class="story-information">
                <span><%= author %></span>
                <span><%= date %></span>
                <span>조회 <%= views %></span>
                <span>댓글 <%= comments %></span>
            </div>

        </div>

        <div class="detail-image">
            <img src="<%= contextPath %>/images/<%= image %>"
                 alt="<%= imageAlt %>">
        </div>

        <div class="detail-body">
            <p><%= body1 %></p>
            <p><%= body2 %></p>
        </div>

        <div class="detail-actions"
             id="detailActions"
             hidden>

            <a href="#"
               id="editButton"
               class="detail-edit-button">
                수정
            </a>

            <button type="button"
                    id="deleteButton"
                    class="detail-delete-button">
                삭제
            </button>

        </div>

        <div class="detail-back">
            <a href="<%= contextPath %>/posts.jsp">
                〈 목록으로
            </a>
        </div>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script>
    /*
     * 로그인한 사용자에게만 수정/삭제 버튼을 보여준다.
     * 실제로는 로그인한 사용자와 작성자가 같은지 서버에서도 확인해야 하며,
     * 지금은 로그인 여부만으로 대체한 목업이다.
     */

    (function toggleDetailActions() {

        const detailActions =
            document.getElementById("detailActions");

        if (mockAuth.isLoggedIn()) {
            detailActions.hidden = false;
        }

    })();

    document.getElementById("editButton")
        .addEventListener("click", function (event) {

            event.preventDefault();

            alert("수정 기능은 게시글 수정 화면 제작 후 연결됩니다.");

        });

    document.getElementById("deleteButton")
        .addEventListener("click", function () {

            const isConfirmed =
                confirm("이 게시글을 삭제하시겠습니까?");

            if (!isConfirmed) {
                return;
            }

            alert("삭제 기능은 게시판 제작 후 연결됩니다.");

        });
</script>

</body>
</html>
