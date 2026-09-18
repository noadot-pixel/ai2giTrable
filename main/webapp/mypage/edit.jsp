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

    <title>회원정보 수정 - 여행만들기</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/common.css">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/mystyle.css">
</head>

<body>

<script src="<%= contextPath %>/js/mock-auth.js"></script>

<script>
    /*
     * 회원정보 수정은 로그인한 계정만 이용할 수 있다.
     */

    if (!mockAuth.isLoggedIn()) {

        const shouldGoToLogin = confirm(
            "회원정보 수정은 로그인 후 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?"
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
         회원정보 수정
         Firestore users/{uid} 문서를 그대로 불러와서 채운 뒤 저장한다.
         프로필 이미지는 Firebase Storage에 올리고 다운로드 URL만 문서에 저장한다.
    ========================== -->

    <section class="page-heading">

        <p class="breadcrumb">
            <a href="<%= contextPath %>/index.jsp">홈</a>
            〉 <a href="<%= contextPath %>/mypage.jsp">마이페이지</a>
            〉 회원정보 수정
        </p>

        <h1>회원정보 수정</h1>

        <p class="page-description">
            내 프로필 정보를 수정하세요.
        </p>

    </section>

    <section class="write-section mypage-section">

        <form id="profileForm">

            <div class="write-field">

                <label for="profilePhoto">
                    프로필 이미지
                </label>

                <div class="profile-photo-field">

                    <img id="profilePhotoPreview"
                         class="profile-photo-preview"
                         src="<%= contextPath %>/images/logo.png"
                         alt="프로필 이미지 미리보기">

                    <input type="file"
                           id="profilePhoto"
                           name="profilePhoto"
                           accept="image/*">

                </div>

                <p class="write-field-note">
                    5MB 이하 이미지 파일만 업로드할 수 있습니다.
                </p>

            </div>

            <div class="write-field">

                <label for="profileNickname">
                    닉네임
                </label>

                <input type="text"
                       id="profileNickname"
                       name="profileNickname">

            </div>

            <div class="write-field">

                <label for="profileBio">
                    자기소개
                </label>

                <textarea id="profileBio"
                          name="profileBio"
                          rows="4"
                          placeholder="자신을 간단히 소개해 주세요"></textarea>

            </div>

            <div class="write-field">

                <label for="profileCountry">
                    국가
                </label>

                <select id="profileCountry"
                        name="profileCountry">

                    <option value="KR">한국</option>
                    <option value="JP">일본</option>
                    <option value="ETC">기타</option>

                </select>

            </div>

            <div class="write-field"
                 id="profileCountryOtherField"
                 hidden>

                <label for="profileCountryOther">
                    국가 직접 입력
                </label>

                <input type="text"
                       id="profileCountryOther"
                       name="profileCountryOther"
                       placeholder="국가를 입력해 주세요">

            </div>

            <div class="write-field">

                <label for="profileEmailLocal">
                    이메일
                </label>

                <div class="email-input-group">

                    <input type="text"
                           id="profileEmailLocal"
                           name="profileEmailLocal"
                           placeholder="이메일 아이디">

                    <span class="email-at">@</span>

                    <select id="profileEmailDomain"
                            name="profileEmailDomain">

                        <option value="naver.com">naver.com</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="daum.net">daum.net</option>
                        <option value="hanmail.net">hanmail.net</option>
                        <option value="custom">직접입력</option>

                    </select>

                </div>

            </div>

            <div class="write-field"
                 id="profileEmailDomainOtherField"
                 hidden>

                <label for="profileEmailDomainOther">
                    도메인 직접 입력
                </label>

                <input type="text"
                       id="profileEmailDomainOther"
                       name="profileEmailDomainOther"
                       placeholder="example.com">

            </div>

            <div class="mypage-personal-section">

                <p class="filter-label">개인정보</p>

                <div class="write-field">

                    <label for="profileBirthday">
                        생일
                    </label>

                    <input type="date"
                           id="profileBirthday"
                           name="profileBirthday">

                    <div class="radio-group">

                        <label class="radio-option">
                            <input type="radio"
                                   name="birthdayVisibility"
                                   value="public"
                                   checked>
                            공개
                        </label>

                        <label class="radio-option">
                            <input type="radio"
                                   name="birthdayVisibility"
                                   value="private">
                            비공개
                        </label>

                    </div>

                </div>

                <div class="write-field">

                    <label for="profileName">
                        이름
                    </label>

                    <input type="text"
                           id="profileName"
                           name="profileName"
                           placeholder="이름을 입력해 주세요">

                    <div class="radio-group">

                        <label class="radio-option">
                            <input type="radio"
                                   name="nameVisibility"
                                   value="public"
                                   checked>
                            공개
                        </label>

                        <label class="radio-option">
                            <input type="radio"
                                   name="nameVisibility"
                                   value="private">
                            비공개
                        </label>

                    </div>

                </div>

            </div>

            <button type="submit"
                    class="auth-submit">
                저장하기
            </button>

        </form>

    </section>

</main>

<%@ include file="/common/footer.jspf" %>

<%@ include file="/common/auth-scripts.jspf" %>

<script>
    /*
     * 국가를 "기타"로, 이메일 도메인을 "직접입력"으로 선택했을 때만
     * 자유 입력란을 보여준다.
     */

    const countrySelect =
        document.getElementById("profileCountry");

    const countryOtherField =
        document.getElementById("profileCountryOtherField");

    countrySelect.addEventListener("change", function () {
        countryOtherField.hidden = countrySelect.value !== "ETC";
    });

    const emailDomainSelect =
        document.getElementById("profileEmailDomain");

    const emailDomainOtherField =
        document.getElementById("profileEmailDomainOtherField");

    emailDomainSelect.addEventListener("change", function () {
        emailDomainOtherField.hidden = emailDomainSelect.value !== "custom";
    });


    /*
     * 프로필 이미지를 고르면 바로 미리보기로 보여준다.
     * 실제 업로드는 저장할 때 한 번만 일어난다.
     */

    const profilePhotoInput =
        document.getElementById("profilePhoto");

    const profilePhotoPreview =
        document.getElementById("profilePhotoPreview");

    let selectedPhotoFile = null;

    profilePhotoInput.addEventListener("change", function () {

        const file = profilePhotoInput.files[0];

        if (!file) {
            return;
        }

        selectedPhotoFile = file;

        const reader = new FileReader();

        reader.onload = function (event) {
            profilePhotoPreview.src = event.target.result;
        };

        reader.readAsDataURL(file);

    });


    /*
     * 계정(uid)별로 Firestore users 문서에서 프로필을 불러오고 저장한다.
     * 실제로는 Oracle DB의 회원 테이블에 저장될 정보다.
     */

    const currentUser =
        mockAuth.getCurrentUser();

    const userDocRef =
        firebase.firestore().collection("users").doc(currentUser.id);

    async function loadProfile() {

        const doc = await userDocRef.get();
        const saved = doc.exists ? doc.data() : null;

        document.getElementById("profileNickname").value =
            (saved && saved.nickname) || currentUser.nickname;

        document.getElementById("profileBio").value =
            (saved && saved.bio) || "";

        document.getElementById("profileCountry").value =
            (saved && saved.country) || "KR";

        countryOtherField.hidden =
            document.getElementById("profileCountry").value !== "ETC";

        document.getElementById("profileCountryOther").value =
            (saved && saved.countryOther) || "";

        document.getElementById("profileEmailLocal").value =
            (saved && saved.emailLocal) || "";

        document.getElementById("profileEmailDomain").value =
            (saved && saved.emailDomain) || "naver.com";

        emailDomainOtherField.hidden =
            document.getElementById("profileEmailDomain").value !== "custom";

        document.getElementById("profileEmailDomainOther").value =
            (saved && saved.emailDomainOther) || "";

        document.getElementById("profileBirthday").value =
            (saved && saved.birthday) || "";

        document.getElementById("profileName").value =
            (saved && saved.name) || "";

        if (saved && saved.photoUrl) {
            profilePhotoPreview.src = saved.photoUrl;
        }

        const birthdayVisibility =
            (saved && saved.birthdayVisibility) || "public";

        document.querySelector(
            'input[name="birthdayVisibility"][value="' + birthdayVisibility + '"]'
        ).checked = true;

        const nameVisibility =
            (saved && saved.nameVisibility) || "public";

        document.querySelector(
            'input[name="nameVisibility"][value="' + nameVisibility + '"]'
        ).checked = true;

    }

    loadProfile();


    const profileForm =
        document.getElementById("profileForm");

    profileForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const nickname =
            document.getElementById("profileNickname").value.trim();

        if (nickname === "") {
            alert("닉네임을 입력해 주세요.");
            return;
        }

        const emailLocal =
            document.getElementById("profileEmailLocal").value.trim();

        if (emailLocal === "") {
            alert("이메일 아이디를 입력해 주세요.");
            return;
        }

        const emailDomain =
            emailDomainSelect.value === "custom"
                ? document.getElementById("profileEmailDomainOther").value.trim()
                : emailDomainSelect.value;

        if (emailDomain === "") {
            alert("이메일 도메인을 입력해 주세요.");
            return;
        }

        const country =
            countrySelect.value;

        const countryOther =
            document.getElementById("profileCountryOther").value.trim();

        if (country === "ETC" && countryOther === "") {
            alert("국가를 직접 입력해 주세요.");
            return;
        }

        const birthdayVisibility =
            document.querySelector(
                'input[name="birthdayVisibility"]:checked'
            ).value;

        const nameVisibility =
            document.querySelector(
                'input[name="nameVisibility"]:checked'
            ).value;

        const profile = {
            nickname: nickname,
            bio: document.getElementById("profileBio").value.trim(),
            country: country,
            countryOther: countryOther,
            emailLocal: emailLocal,
            emailDomain: emailDomainSelect.value,
            emailDomainOther: document.getElementById("profileEmailDomainOther").value.trim(),
            birthday: document.getElementById("profileBirthday").value,
            birthdayVisibility: birthdayVisibility,
            name: document.getElementById("profileName").value.trim(),
            nameVisibility: nameVisibility
        };

        /*
         * Firestore/Storage 보안 규칙은 mockAuth(localStorage)가 아니라
         * 실제 Firebase 인증 상태를 검사한다. Firebase는 저장된 세션을
         * 비동기로 복원하므로 복원이 끝날 때까지 기다린 뒤 확인한다.
         * 둘이 어긋나 있으면(예: 브라우저의 로그인 세션이 끊긴 경우)
         * 경로의 uid와 실제 인증된 uid가 달라 거부된다.
         */

        const firebaseUser = await window.authReady;

        if (!firebaseUser || firebaseUser.uid !== currentUser.id) {

            alert(
                "로그인 세션이 만료되어 저장할 수 없습니다. "
                + "다시 로그인한 뒤 시도해 주세요."
            );

            location.href = "<%= contextPath %>/auth/login.jsp";

            return;
        }

        /*
         * 새 이미지를 골랐을 때만 업로드한다.
         * Firebase Storage가 콘솔에서 활성화돼 있어야 동작한다.
         */

        if (selectedPhotoFile) {

            try {

                const storageRef =
                    firebase.storage().ref("profile-images/" + firebaseUser.uid);

                await storageRef.put(selectedPhotoFile);

                profile.photoUrl = await storageRef.getDownloadURL();

            } catch (error) {

                alert("프로필 이미지 업로드에 실패했습니다: " + error.message);

                return;
            }

        }

        await userDocRef.set(profile, { merge: true });

        /*
         * 헤더에 표시되는 닉네임도 함께 갱신
         */

        mockAuth.login(Object.assign({}, currentUser, {
            nickname: nickname
        }));

        alert("프로필이 저장되었습니다.");

        location.href = "<%= contextPath %>/mypage.jsp";

    });
</script>

</body>
</html>
