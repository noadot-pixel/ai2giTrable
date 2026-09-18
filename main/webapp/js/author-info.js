/*
 * 게시글 카드/상세에 작성자의 프로필 정보(자기소개, 국가 등)를
 * 바로 표시해준다. Firestore users/{uid} 문서를 읽어와 채운다.
 * firebase-init.jspf(Firestore)가 먼저 로드되어 있어야 한다.
 * 비로그인 방문자도 볼 수 있도록 users 컬렉션은 공개 읽기로 열어둔다.
 */

(function (global) {
    "use strict";

    const COUNTRY_LABELS = {
        KR: "한국",
        JP: "일본",
        ETC: "기타"
    };

    const profileCache = {};

    function escapeHtml(text) {

        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    async function fetchProfile(uid) {

        if (profileCache[uid]) {
            return profileCache[uid];
        }

        try {

            const doc = await firebase.firestore()
                .collection("users")
                .doc(uid)
                .get();

            const data = doc.exists ? doc.data() : {};

            profileCache[uid] = data;

            return data;

        } catch (error) {

            return {};
        }

    }

    function buildInlineHtml(fallbackNickname, profile) {

        const countryLabel = profile.country === "ETC"
            ? (profile.countryOther || "기타")
            : (COUNTRY_LABELS[profile.country] || "");

        const photoHtml = /^https?:\/\//.test(profile.photoUrl || "")
            ? '<img class="author-info-photo" src="' + escapeHtml(profile.photoUrl) + '" alt="">'
            : '<span class="author-info-photo author-info-photo-empty"></span>';

        return '<div class="author-info-card">'
            + photoHtml
            + '<div class="author-info-text">'
            + '<p class="author-info-bio">'
            + escapeHtml(profile.bio || "아직 소개가 없습니다.")
            + '</p>'
            + (countryLabel
                ? '<p class="author-info-meta">' + escapeHtml(countryLabel) + '</p>'
                : '')
            + '</div></div>';

    }

    /*
     * container(.author-info) 요소 하나를 채운다.
     * data-author-uid / data-author-nickname 속성을 읽어서 사용한다.
     */

    async function renderAuthorInfo(container) {

        const uid = container.dataset.authorUid;

        if (!uid) {
            return;
        }

        const profile = await fetchProfile(uid);

        container.innerHTML =
            buildInlineHtml(container.dataset.authorNickname || "", profile);

    }

    function initAuthorInfo(root) {

        const containers =
            (root || document).querySelectorAll(".author-info");

        containers.forEach(function (container) {
            renderAuthorInfo(container);
        });

    }

    /*
     * 글/댓글에는 작성 당시 닉네임이 복사돼 있어서, 닉네임을 바꿔도 그대로 남는다.
     * data-nickname-uid 속성이 있는 요소는 users/{uid}의 "현재" 닉네임으로 바꿔 보여준다.
     * (프로필 문서가 없거나 조회에 실패하면 원래 적혀 있던 닉네임을 그대로 둔다.)
     */

    async function resolveNicknames(root) {

        const nodes =
            (root || document).querySelectorAll("[data-nickname-uid]");

        await Promise.all(Array.from(nodes).map(async function (node) {

            const profile = await fetchProfile(node.dataset.nicknameUid);

            if (profile.nickname) {
                node.textContent = profile.nickname;
            }

        }));

    }

    global.initAuthorInfo = initAuthorInfo;
    global.resolveNicknames = resolveNicknames;

})(window);
