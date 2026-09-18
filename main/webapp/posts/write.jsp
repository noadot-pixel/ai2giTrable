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

    <title>여행 이야기 작성 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
    /*
     * 글쓰기는 로그인한 계정만 이용할 수 있다.
     * 실제 권한 검사는 서버(로그인/세션)에서도 해야 하지만
     * 지금은 화면 접근을 막는 이벤트만 구현한 목업이다.
     */

    if (!mockAuth.isLoggedIn()) {

        const shouldGoToLogin = confirm(
            "글쓰기는 로그인 후 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?"
        );

        if (shouldGoToLogin) {
            location.href = "<%= contextPath %>/auth/login.jsp";
        } else {
            location.href = "<%= contextPath %>/posts.jsp";
        }

    }
</script>

<% String activeNav = "posts"; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         게시글 작성
         Firestore posts 컬렉션에 문서를 추가한다(모든 방문자에게 공개).
         여행지 구분(국내/일본/해외) + 여행 성향(힐링/맛집/액티비티/쇼핑)을
         각각 하나씩 골라 두 축으로 태그를 붙인다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/posts.jsp">게시글 목록</a>
            〉 글쓰기
        </p>

        <h1>여행 이야기 작성</h1>

        <p class="page-description">
            여행지 구분과 여행 성향을 각각 하나씩 선택하고 이야기를 남겨보세요.
        </p>

    </section>

    <section class="write-section">

        <form id="writeForm">

            <div class="write-field">

                <label for="writeTitle">
                    제목
                </label>

                <input type="text"
                       id="writeTitle"
                       name="writeTitle"
                       placeholder="제목을 입력해 주세요">

            </div>

            <div class="filter-group"
                 id="writeCountryGroup">

                <p class="filter-label">여행지 구분</p>

                <button type="button"
                        class="filter-button"
                        data-country="KR"
                        data-country-label="한국 여행지">
                    국내여행
                </button>

                <button type="button"
                        class="filter-button"
                        data-country="JP"
                        data-country-label="일본 여행지">
                    일본여행
                </button>

                <button type="button"
                        class="filter-button"
                        data-country="ETC"
                        data-country-label="세계 여행지">
                    해외여행
                </button>

            </div>

            <div class="filter-group"
                 id="writeStyleGroup">

                <p class="filter-label">여행 성향</p>

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

            <div class="write-field">

                <label for="writeBody">
                    본문
                </label>

                <textarea id="writeBody"
                          name="writeBody"
                          rows="10"
                          placeholder="여행 이야기를 자유롭게 남겨주세요"></textarea>

            </div>

            <div class="write-field">

                <label for="writePhoto">
                    사진 첨부
                </label>

                <input type="file"
                       id="writePhoto"
                       name="writePhoto"
                       accept="image/*">

            </div>

            <button type="submit"
                    class="auth-submit">
                등록하기
            </button>

        </form>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>

<script>
    /*
     * 여행지 구분 / 여행 성향은 각 그룹에서 하나만 선택되도록 처리
     */

    let selectedCountry = null;
    let selectedCountryLabel = null;
    let selectedStyle = null;

    function bindWriteFilterGroup(groupId, onSelect) {

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

            });

        });

    }

    bindWriteFilterGroup("writeCountryGroup", function (button) {
        selectedCountry = button.dataset.country;
        selectedCountryLabel = button.dataset.countryLabel;
    });

    bindWriteFilterGroup("writeStyleGroup", function (button) {
        selectedStyle = button.dataset.style;
    });


    /*
     * 국가별 기본 이미지 (사진 첨부는 실제로 업로드/저장하지 않는 목업)
     */

    const DEFAULT_IMAGE_BY_COUNTRY = {
        KR: "korea.jpg",
        JP: "japan.jpg",
        ETC: "world.jpg"
    };

    const writeForm =
        document.getElementById("writeForm");

    writeForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const title =
            document.getElementById("writeTitle").value.trim();

        const body =
            document.getElementById("writeBody").value.trim();

        if (title === "") {
            alert("제목을 입력해 주세요.");
            return;
        }

        if (!selectedCountry) {
            alert("여행지 구분을 선택해 주세요.");
            return;
        }

        if (!selectedStyle) {
            alert("여행 성향을 선택해 주세요.");
            return;
        }

        if (body === "") {
            alert("본문을 입력해 주세요.");
            return;
        }

        const currentUser =
            mockAuth.getCurrentUser();

        const newPostId = await postsStore.createPost({
            title: title,
            body: body,
            country: selectedCountry,
            countryLabel: selectedCountryLabel,
            style: selectedStyle,
            authorUid: currentUser.id,
            authorNickname: currentUser.nickname,
            image: DEFAULT_IMAGE_BY_COUNTRY[selectedCountry]
        });

        alert("게시글이 등록되었습니다.");

        location.href = "<%= contextPath %>/posts/detail.jsp?id=" + newPostId;

    });
</script>

</body>
</html>
