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

<%@ include file="/common/firebase-init.jspf" %>

<script src="<%= contextPath %>/js/mock-auth.js"></script>
<script src="<%= contextPath %>/js/posts-store.js"></script>

<script>
    /*
     * 게시글 수정은 글쓰기와 거의 같은 화면이지만,
     * (1) 로그인 여부 + (2) 이 게시글의 작성자 본인(또는 관리자)인지까지 확인한다.
     *
     * 아래 변수는 모든 검사를 통과했을 때만 실제 값이 채워진다.
     * guardPassed가 false면 이 페이지의 나머지 스크립트는 아무 것도
     * 하지 않고 리다이렉트가 끝나기를 기다린다.
     */

    const params = new URLSearchParams(location.search);
    const editId = params.get("id") || "";

    /*
     * 이 Promise가 게시글(권한 통과 시) 또는 null(리다이렉트 중)로
     * 해결된다. HTML 파싱과 동시에 바로 시작해서, 폼 DOM이 준비된 뒤
     * 아래쪽 스크립트에서 await로 이어받아 쓴다.
     */

    const editGuardPromise = (async function guardEditAccess() {

        if (!mockAuth.isLoggedIn()) {

            const shouldGoToLogin = confirm(
                "게시글 수정은 로그인 후 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?"
            );

            location.href = shouldGoToLogin
                ? "<%= contextPath %>/auth/login.jsp"
                : "<%= contextPath %>/posts.jsp";

            return null;
        }

        const post = editId
            ? await postsStore.getPostById(editId)
            : null;

        if (!post) {

            alert("게시글을 찾을 수 없습니다.");

            location.href = "<%= contextPath %>/posts.jsp";

            return null;
        }

        const currentUser = mockAuth.getCurrentUser();
        const isAdmin = await mockAuth.isAdmin();

        if (currentUser.id !== post.authorUid && !isAdmin) {

            alert("본인이 작성한 게시글만 수정할 수 있습니다.");

            location.href = "<%= contextPath %>/posts/detail.jsp?id=" + editId;

            return null;
        }

        return post;

    })();
</script>

<% String activeNav = "posts"; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         게시글 수정
         글쓰기 화면과 같은 구조이며, Firestore에서 기존 값을 불러와
         채운 뒤 같은 문서를 업데이트하는 방식으로 동작한다.
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

                <p class="write-field-note">
                    5MB 미만의 이미지 파일만 올릴 수 있습니다.
                    새 사진을 고르지 않으면 지금 사진이 그대로 유지됩니다.
                </p>

                <img id="writePhotoPreview"
                     class="post-image-preview"
                     alt="게시글 사진 미리보기"
                     hidden>

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
    (async function initEditForm() {

        /*
         * editGuardPromise는 권한 검사를 통과하면 게시글을,
         * 아니면 null을 준다(이 경우 이미 다른 곳으로 리다이렉트 중이므로
         * 여기서는 아무 것도 하지 않는다).
         */

        const targetPost = await editGuardPromise;

        if (!targetPost) {
            return;
        }

        document.getElementById("writeTitle").value = targetPost.title;
        document.getElementById("writeBody").value = targetPost.body;


        /*
         * 현재 사진을 미리보기로 보여주고, 새 사진을 고르면 그 사진으로 바꿔 보여준다.
         * 실제 업로드는 저장할 때 한 번만 일어난다.
         */

        const writePhotoInput =
            document.getElementById("writePhoto");

        const writePhotoPreview =
            document.getElementById("writePhotoPreview");

        writePhotoPreview.src =
            postsStore.imageSrc(targetPost, "<%= contextPath %>/images/");

        writePhotoPreview.hidden = false;

        writePhotoInput.addEventListener("change", function () {

            const file = writePhotoInput.files[0];

            if (!file) {

                writePhotoPreview.src =
                    postsStore.imageSrc(targetPost, "<%= contextPath %>/images/");

                return;
            }

            const message = postsStore.validateImageFile(file);

            if (message) {

                alert(message);

                writePhotoInput.value = "";

                writePhotoPreview.src =
                    postsStore.imageSrc(targetPost, "<%= contextPath %>/images/");

                return;
            }

            writePhotoPreview.src = URL.createObjectURL(file);

        });

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

        editForm.addEventListener("submit", async function (event) {

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

            /*
             * 글의 작성자(authorUid/authorNickname)는 바꾸지 않는다.
             * 로그의 작업자는 실제로 이 수정을 실행한 사람(관리자일 수도 있음)이어야
             * 하므로 targetPost의 작성자가 아니라 현재 로그인한 사용자로 남긴다.
             */

            const actingUser =
                mockAuth.getCurrentUser();

            const submitButton =
                editForm.querySelector('button[type="submit"]');

            submitButton.disabled = true;

            try {

                const changes = {
                    title: title,
                    body: body,
                    country: selectedCountry,
                    countryLabel: selectedCountryLabel,
                    style: selectedStyle,
                    image: DEFAULT_IMAGE_BY_COUNTRY[selectedCountry]
                };

                /*
                 * 새 사진을 골랐을 때만 업로드해서 imageUrl을 바꾼다.
                 * (관리자가 남의 글을 고칠 때도 업로드는 관리자 본인 폴더에 올라간다.)
                 */

                const photoFile = writePhotoInput.files[0];

                if (photoFile) {
                    changes.imageUrl = await postsStore.uploadPostImage(photoFile);
                }

                await postsStore.updatePost(
                    targetPost.id, changes, actingUser.id, actingUser.nickname
                );

                alert("게시글이 수정되었습니다.");

                location.href = "<%= contextPath %>/posts/detail.jsp?id=" + targetPost.id;

            } catch (error) {

                alert("게시글 수정에 실패했습니다: " + error.message);

                submitButton.disabled = false;

            }

        });

    })();
</script>

</body>
</html>
