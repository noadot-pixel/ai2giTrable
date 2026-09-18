<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();

    String postId = request.getParameter("id");

    if (postId == null) {
        postId = "";
    }
%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>게시글 상세 - 여행만들기</title>

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
         Firestore posts 컬렉션에서 id로 문서를 조회해서 채운다.
         작성자 본인(또는 관리자)일 때만 수정/삭제 버튼을 보여준다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/posts.jsp">게시글 목록</a>
            〉 상세
        </p>

    </section>

    <section class="detail-section"
             id="detailSection"
             hidden>

        <div class="detail-header">

            <div class="detail-tags">
                <span class="story-category" id="detailCountryLabel"></span>
                <span class="detail-style-tag" id="detailStyleLabel"></span>
            </div>

            <h1 id="detailTitle"></h1>

            <div class="story-information">
                <span id="detailAuthor"></span>
                <span id="detailDate"></span>
                <span id="detailViews"></span>
                <span id="detailComments"></span>
            </div>

            <div class="author-info" id="detailAuthorInfo"></div>

        </div>

        <div class="detail-image">
            <img id="detailImage" src="" alt="">
        </div>

        <div class="detail-body" id="detailBody">
        </div>

        <div class="detail-reactions">

            <button type="button"
                    id="likeButton"
                    class="reaction-button">
                <span class="reaction-icon" id="likeIcon">♡</span>
                좋아요 <span id="likeCount">0</span>
            </button>

            <button type="button"
                    id="scrapButton"
                    class="reaction-button">
                <span class="reaction-icon" id="scrapIcon">☆</span>
                <span id="scrapLabel">스크랩</span>
            </button>

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

        <section class="comment-section">

            <h2>댓글 <span id="commentCount">0</span></h2>

            <form id="commentForm"
                  class="comment-form">

                <textarea id="commentInput"
                          rows="3"
                          maxlength="500"
                          placeholder="댓글을 남겨보세요 (최대 500자)"></textarea>

                <button type="submit"
                        class="comment-submit">
                    댓글 등록
                </button>

            </form>

            <ul class="comment-list"
                id="commentList">
            </ul>

            <p class="comment-empty"
               id="commentEmpty"
               hidden>
                아직 댓글이 없습니다. 첫 댓글을 남겨보세요.
            </p>

        </section>

        <div class="detail-back">
            <a href="<%= contextPath %>/posts.jsp">
                〈 목록으로
            </a>
        </div>

    </section>

    <p class="empty-result"
       id="detailNotFound"
       hidden>
        게시글을 찾을 수 없습니다.
    </p>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>
<script src="<%= contextPath %>/js/author-info.js"></script>

<script>
    const postId = "<%= postId %>";

    const detailSection =
        document.getElementById("detailSection");

    const detailNotFound =
        document.getElementById("detailNotFound");

    const STYLE_LABELS = {
        healing: "힐링",
        food: "맛집",
        activity: "액티비티",
        shopping: "쇼핑"
    };

    (async function loadPostDetail() {

        const post = postId
            ? await postsStore.getPostById(postId)
            : null;

        if (!post) {

            detailNotFound.hidden = false;

            return;
        }

        detailSection.hidden = false;

        document.title = post.title + " - 여행만들기";

        document.getElementById("detailCountryLabel").textContent = post.countryLabel;
        document.getElementById("detailStyleLabel").textContent =
            STYLE_LABELS[post.style] || post.style;
        document.getElementById("detailTitle").textContent = post.title;
        document.getElementById("detailAuthor").textContent = post.authorNickname;

        const detailAuthorInfo =
            document.getElementById("detailAuthorInfo");

        detailAuthorInfo.dataset.authorUid = post.authorUid;
        detailAuthorInfo.dataset.authorNickname = post.authorNickname;

        initAuthorInfo(detailSection);

        const displayDate =
            post.createdAt ? post.createdAt.slice(0, 10).replace(/-/g, ".") : "";

        document.getElementById("detailDate").textContent = displayDate;
        document.getElementById("detailViews").textContent = "조회 " + (post.views || 0);
        document.getElementById("detailComments").textContent = "댓글 " + (post.comments || 0);

        const detailImage =
            document.getElementById("detailImage");

        detailImage.src =
            postsStore.imageSrc(post, "<%= contextPath %>/images/");
        detailImage.alt = post.title;

        document.getElementById("detailBody").textContent = post.body;

        const detailActions =
            document.getElementById("detailActions");

        const currentUser =
            mockAuth.getCurrentUser();

        const isAdmin =
            await mockAuth.isAdmin();

        const canManage =
            currentUser
            && (currentUser.id === post.authorUid || isAdmin);

        if (canManage) {
            detailActions.hidden = false;
        }

        document.getElementById("editButton").href =
            "<%= contextPath %>/posts/edit.jsp?id=" + post.id;

        document.getElementById("deleteButton")
            .addEventListener("click", async function () {

                const isConfirmed =
                    confirm("이 게시글을 삭제하시겠습니까?");

                if (!isConfirmed) {
                    return;
                }

                await postsStore.deletePost(
                    post.id,
                    post.title,
                    currentUser.id,
                    currentUser.nickname
                );

                alert("삭제되었습니다.");

                location.href = "<%= contextPath %>/posts.jsp";

            });

        initReactions(post);

        initComments(post, isAdmin);

    })();


    /*
     * 좋아요 / 스크랩 / 댓글은 로그인한 사용자만 쓸 수 있다.
     * 비로그인 상태에서 누르면 로그인 페이지로 안내한다.
     */

    function requireLogin() {

        if (mockAuth.isLoggedIn()) {
            return true;
        }

        const shouldGoToLogin = confirm(
            "로그인 후 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?"
        );

        if (shouldGoToLogin) {
            location.href = "<%= contextPath %>/auth/login.jsp";
        }

        return false;
    }

    async function initReactions(post) {

        const likeButton = document.getElementById("likeButton");
        const scrapButton = document.getElementById("scrapButton");

        let likeCount = post.likes || 0;
        let liked = false;
        let scrapped = false;

        function renderReactions() {

            likeButton.classList.toggle("active", liked);
            document.getElementById("likeIcon").textContent = liked ? "♥" : "♡";
            document.getElementById("likeCount").textContent = likeCount;

            scrapButton.classList.toggle("active", scrapped);
            document.getElementById("scrapIcon").textContent = scrapped ? "★" : "☆";
            document.getElementById("scrapLabel").textContent = scrapped ? "스크랩됨" : "스크랩";
        }

        renderReactions();

        if (mockAuth.isLoggedIn()) {

            try {

                liked = await postsStore.isLiked(post.id);
                scrapped = await postsStore.isScrapped(post.id);

                renderReactions();

            } catch (error) {
                console.error("좋아요/스크랩 상태를 불러오지 못했습니다:", error);
            }

        }

        likeButton.addEventListener("click", async function () {

            if (!requireLogin()) {
                return;
            }

            likeButton.disabled = true;

            try {

                liked = await postsStore.toggleLike(post.id);
                likeCount += liked ? 1 : -1;

                renderReactions();

            } catch (error) {
                alert("좋아요 처리에 실패했습니다: " + error.message);
            }

            likeButton.disabled = false;

        });

        scrapButton.addEventListener("click", async function () {

            if (!requireLogin()) {
                return;
            }

            scrapButton.disabled = true;

            try {

                scrapped = await postsStore.toggleScrap(post.id);

                renderReactions();

            } catch (error) {
                alert("스크랩 처리에 실패했습니다: " + error.message);
            }

            scrapButton.disabled = false;

        });

    }

    async function initComments(post, isAdmin) {

        const commentList = document.getElementById("commentList");
        const commentEmpty = document.getElementById("commentEmpty");
        const commentForm = document.getElementById("commentForm");
        const commentInput = document.getElementById("commentInput");

        const me = mockAuth.getCurrentUser();

        let comments = [];

        function formatDateTime(iso) {

            const date = new Date(iso);

            if (isNaN(date)) {
                return "";
            }

            function pad(n) {
                return String(n).padStart(2, "0");
            }

            return date.getFullYear() + "." + pad(date.getMonth() + 1) + "." + pad(date.getDate())
                + " " + pad(date.getHours()) + ":" + pad(date.getMinutes());
        }

        function renderComments() {

            commentList.innerHTML = "";

            commentEmpty.hidden = comments.length !== 0;

            document.getElementById("commentCount").textContent = comments.length;
            document.getElementById("detailComments").textContent = "댓글 " + comments.length;

            comments.forEach(function (comment) {

                const item = document.createElement("li");
                item.className = "comment-item";

                const head = document.createElement("div");
                head.className = "comment-head";

                const nickname = document.createElement("strong");
                nickname.textContent = comment.authorNickname;
                head.appendChild(nickname);

                if (comment.authorUid === post.authorUid) {

                    const badge = document.createElement("span");
                    badge.className = "my-post-badge";
                    badge.textContent = "작성자";
                    head.appendChild(badge);

                }

                const time = document.createElement("span");
                time.className = "comment-time";
                time.textContent = formatDateTime(comment.createdAt);
                head.appendChild(time);

                /*
                 * 댓글 삭제는 댓글 작성자 본인, 게시글 작성자, 관리자만 할 수 있다.
                 */

                const canDelete =
                    me && (me.id === comment.authorUid || me.id === post.authorUid || isAdmin);

                if (canDelete) {

                    const deleteButton = document.createElement("button");
                    deleteButton.type = "button";
                    deleteButton.className = "comment-delete";
                    deleteButton.textContent = "삭제";
                    deleteButton.dataset.commentId = comment.id;
                    head.appendChild(deleteButton);

                }

                const body = document.createElement("p");
                body.className = "comment-body";
                body.textContent = comment.body;

                item.appendChild(head);
                item.appendChild(body);

                commentList.appendChild(item);

            });

        }

        try {

            comments = await postsStore.getComments(post.id);

        } catch (error) {
            console.error("댓글을 불러오지 못했습니다:", error);
        }

        renderComments();

        commentForm.addEventListener("submit", async function (event) {

            event.preventDefault();

            if (!requireLogin()) {
                return;
            }

            const body = commentInput.value.trim();

            if (body === "") {
                alert("댓글 내용을 입력해 주세요.");
                return;
            }

            const submitButton = commentForm.querySelector("button[type='submit']");

            submitButton.disabled = true;

            try {

                const added = await postsStore.addComment(post.id, body, me.nickname);

                comments.push(added);

                commentInput.value = "";

                renderComments();

            } catch (error) {
                alert("댓글 등록에 실패했습니다: " + error.message);
            }

            submitButton.disabled = false;

        });

        commentList.addEventListener("click", async function (event) {

            const deleteButton = event.target.closest(".comment-delete");

            if (!deleteButton) {
                return;
            }

            if (!confirm("이 댓글을 삭제하시겠습니까?")) {
                return;
            }

            deleteButton.disabled = true;

            try {

                await postsStore.deleteComment(post.id, deleteButton.dataset.commentId);

                comments = comments.filter(function (comment) {
                    return comment.id !== deleteButton.dataset.commentId;
                });

                renderComments();

            } catch (error) {

                alert("댓글 삭제에 실패했습니다: " + error.message);

                deleteButton.disabled = false;

            }

        });

    }
</script>

</body>
</html>
