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

        </div>

        <div class="detail-image">
            <img id="detailImage" src="" alt="">
        </div>

        <div class="detail-body" id="detailBody">
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

    <p class="empty-result"
       id="detailNotFound"
       hidden>
        게시글을 찾을 수 없습니다.
    </p>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>

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

        const displayDate =
            post.createdAt ? post.createdAt.slice(0, 10).replace(/-/g, ".") : "";

        document.getElementById("detailDate").textContent = displayDate;
        document.getElementById("detailViews").textContent = "조회 " + (post.views || 0);
        document.getElementById("detailComments").textContent = "댓글 " + (post.comments || 0);

        const detailImage =
            document.getElementById("detailImage");

        detailImage.src = "<%= contextPath %>/images/" + post.image;
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

    })();
</script>

</body>
</html>
