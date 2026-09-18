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

    <title>마이페이지 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
    /*
     * 마이페이지는 로그인한 계정만 이용할 수 있다.
     */

    if (!mockAuth.isLoggedIn()) {

        const shouldGoToLogin = confirm(
            "마이페이지는 로그인 후 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?"
        );

        location.href = shouldGoToLogin
            ? "<%= contextPath %>/auth/login.jsp"
            : "<%= contextPath %>/index.jsp";
    }
</script>

<% String activeNav = ""; %>
<%@ include file="/common/header.jspf" %>

<main>

    <!-- =========================
         마이페이지 (보기 전용)
         Firestore users/{uid} 문서에서 프로필을 읽어 보여준다.
         수정은 /mypage/edit.jsp에서 한다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 마이페이지
        </p>

        <h1>마이페이지</h1>

        <p class="page-description">
            내 프로필과 내가 작성한 글을 확인하세요.
        </p>

    </section>

    <section class="profile-section">

        <div class="profile-card">

            <img id="profileViewPhoto"
                 class="profile-photo-large"
                 src="<%= contextPath %>/images/logo.png"
                 alt="프로필 이미지">

            <div class="profile-card-info">

                <h2 id="profileViewNickname"></h2>

                <p id="profileViewBio" class="profile-bio"></p>

                <div class="profile-meta">
                    <span id="profileViewCountry"></span>
                    <span id="profileViewEmail"></span>
                </div>

                <div class="profile-personal" id="profilePersonalInfo">
                </div>

                <a href="<%= contextPath %>/mypage/edit.jsp"
                   class="auth-submit profile-edit-button">
                    정보 수정
                </a>

            </div>

        </div>

    </section>

    <section class="page-heading">
        <h2>내가 작성한 글</h2>
    </section>

    <section class="post-list" id="myPostList">
    </section>

    <p class="empty-result"
       id="myPostsEmpty"
       hidden>
        아직 작성한 게시글이 없습니다.
    </p>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script src="<%= contextPath %>/js/posts-store.js"></script>

<script>
    const currentUser =
        mockAuth.getCurrentUser();

    const COUNTRY_LABELS = {
        KR: "한국",
        JP: "일본",
        ETC: "기타"
    };

    async function loadProfileView() {

        const doc = await firebase.firestore()
            .collection("users")
            .doc(currentUser.id)
            .get();

        const profile = doc.exists ? doc.data() : {};

        document.getElementById("profileViewNickname").textContent =
            profile.nickname || currentUser.nickname;

        document.getElementById("profileViewBio").textContent =
            profile.bio || "아직 소개가 없습니다.";

        const countryLabel = profile.country === "ETC"
            ? (profile.countryOther || "기타")
            : COUNTRY_LABELS[profile.country] || "-";

        document.getElementById("profileViewCountry").textContent =
            "국가 " + countryLabel;

        const email = profile.emailLocal
            ? profile.emailLocal + "@" + (profile.emailDomain === "custom"
                ? profile.emailDomainOther
                : profile.emailDomain)
            : currentUser.email;

        document.getElementById("profileViewEmail").textContent =
            "이메일 " + email;

        if (profile.photoUrl) {
            document.getElementById("profileViewPhoto").src = profile.photoUrl;
        }

        const personalInfoParts = [];

        if (profile.birthday) {
            personalInfoParts.push(
                "생일 " + profile.birthday
                + (profile.birthdayVisibility === "private" ? " (비공개)" : " (공개)")
            );
        }

        if (profile.name) {
            personalInfoParts.push(
                "이름 " + profile.name
                + (profile.nameVisibility === "private" ? " (비공개)" : " (공개)")
            );
        }

        document.getElementById("profilePersonalInfo").textContent =
            personalInfoParts.join(" · ");

    }

    loadProfileView();


    /*
     * 내가 작성한 글 목록 (본인 글이므로 항상 수정/삭제 버튼을 붙인다)
     */

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    async function loadMyPosts() {

        const posts = await postsStore.getAllPosts();

        const myPosts = posts.filter(function (post) {
            return post.authorUid === currentUser.id;
        });

        const myPostList = document.getElementById("myPostList");

        document.getElementById("myPostsEmpty").hidden = myPosts.length !== 0;

        myPostList.innerHTML = myPosts.map(function (post) {

            const displayDate =
                post.createdAt ? post.createdAt.slice(0, 10).replace(/-/g, ".") : "";

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
                + '<span>' + displayDate + '</span>'
                + '<span>조회 ' + (post.views || 0) + '</span>'
                + '<span>댓글 ' + (post.comments || 0) + '</span>'
                + '</div>'
                + '<div class="detail-actions local-post-actions">'
                + '<a href="<%= contextPath %>/posts/edit.jsp?id=' + post.id + '" class="detail-edit-button">수정</a>'
                + '<button type="button" class="detail-delete-button" data-post-id="' + post.id + '">삭제</button>'
                + '</div>'
                + '</div></article>';

        }).join("");

    }

    loadMyPosts();

    document.getElementById("myPostList").addEventListener("click", async function (event) {

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

        await postsStore.deletePost(postId, postTitle, currentUser.id, currentUser.nickname);

        loadMyPosts();

    });
</script>

</body>
</html>
