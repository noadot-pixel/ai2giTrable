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

    <title>게시글 수정 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
    /*
     * 게시글 수정은 글쓰기와 거의 같은 화면이지만,
     * (1) 로그인 여부 + (2) 이 게시글의 작성자 본인인지까지 확인한다.
     *
     * 예시로 넣어둔 1~9번 게시글은 실제 계정과 연결된 데이터가 아니라서
     * (localStorage에 없음) 수정 대상이 될 수 없다. 지금 수정이 가능한 건
     * 글쓰기 화면에서 이 브라우저로 직접 작성해 localStorage에 저장된
     * 게시글뿐이다.
     */

    const params = new URLSearchParams(location.search);
    const editId = params.get("id") || "";

    /*
     * 아래 세 변수는 모든 검사를 통과했을 때만 실제 값이 채워진다.
     * guardPassed가 false면 이 페이지의 나머지 스크립트는 아무 것도
     * 하지 않고 리다이렉트가 끝나기를 기다린다.
     */

    let guardPassed = false;
    let savedPosts = [];
    let targetIndex = -1;
    let targetPost = null;

    if (!mockAuth.isLoggedIn()) {

        const shouldGoToLogin = confirm(
            "게시글 수정은 로그인 후 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?"
        );

        location.href = shouldGoToLogin
            ? "<%= contextPath %>/auth/login.jsp"
            : "<%= contextPath %>/posts.jsp";

    } else if (!editId.startsWith("local-")) {

        alert("예시로 제공된 게시글이라 수정할 수 없습니다.");

        location.href = "<%= contextPath %>/posts.jsp";

    } else {

        savedPosts =
            JSON.parse(localStorage.getItem("trable_mock_posts") || "[]");

        targetIndex =
            savedPosts.findIndex(function (post) {
                return post.id === editId;
            });

        if (targetIndex === -1) {

            alert("게시글을 찾을 수 없습니다.");

            location.href = "<%= contextPath %>/posts.jsp";

        } else {

            targetPost = savedPosts[targetIndex];

            const currentUser = mockAuth.getCurrentUser();

            if (!currentUser || currentUser.nickname !== targetPost.author) {

                alert("본인이 작성한 게시글만 수정할 수 있습니다.");

                location.href = "<%= contextPath %>/posts.jsp";

            } else {

                guardPassed = true;
            }

        }

    }
</script>

<% String activeNav = "posts"; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         게시글 수정
         글쓰기 화면과 같은 구조이며, 기존 값을 미리 채운 뒤
         같은 id로 localStorage 항목을 덮어쓰는 방식으로 동작한다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/posts.jsp">게시글 목록</a>
            〉 게시글 수정
        </p>

        <h1>게시글 수정</h1>

        <p class="page-description">
            여행지 구분과 여행 성향을 각각 하나씩 선택하고 내용을 수정하세요.
        </p>

    </section>

    <section class="write-section">

        <form id="editForm">

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
                수정하기
            </button>

        </form>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script>
    /*
     * 위쪽 가드 스크립트에서 guardPassed가 true일 때만
     * targetPost / savedPosts / targetIndex가 유효하다.
     * 리다이렉트가 걸린 경우 여기서 더 진행하지 않는다.
     */

    if (!guardPassed) {
        throw new Error("게시글 수정 접근 조건을 만족하지 않아 중단합니다.");
    }

    document.getElementById("writeTitle").value = targetPost.title;
    document.getElementById("writeBody").value = targetPost.body;

    let selectedCountry = targetPost.country;
    let selectedCountryLabel = targetPost.countryLabel;
    let selectedStyle = targetPost.style;

    function markActiveButton(groupId, datasetKey, value) {

        const buttons =
            document.getElementById(groupId).querySelectorAll(".filter-button");

        buttons.forEach(function (button) {

            if (button.dataset[datasetKey] === value) {
                button.classList.add("active");
            }

        });

    }

    markActiveButton("writeCountryGroup", "country", selectedCountry);
    markActiveButton("writeStyleGroup", "style", selectedStyle);

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


    const editForm =
        document.getElementById("editForm");

    editForm.addEventListener("submit", function (event) {

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

        const DEFAULT_IMAGE_BY_COUNTRY = {
            KR: "korea.jpg",
            JP: "japan.jpg",
            ETC: "world.jpg"
        };

        savedPosts[targetIndex] = Object.assign({}, targetPost, {
            title: title,
            body: body,
            country: selectedCountry,
            countryLabel: selectedCountryLabel,
            style: selectedStyle,
            image: DEFAULT_IMAGE_BY_COUNTRY[selectedCountry]
        });

        localStorage.setItem(
            "trable_mock_posts",
            JSON.stringify(savedPosts)
        );

        alert("게시글이 수정되었습니다.");

        location.href = "<%= contextPath %>/posts.jsp";

    });
</script>

</body>
</html>
