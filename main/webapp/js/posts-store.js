/*
 * Firestore "posts" / "postLogs" 컬렉션을 다루는 공용 모듈.
 * firebase-init.jspf가 먼저 로드되어 전역 firebase 객체가 있어야 동작한다.
 * 추후 Oracle JDBC 기반 게시판으로 교체될 예정이며, 그때는 이 파일만
 * 서버 API 호출로 바꾸면 되도록 함수 시그니처를 단순하게 유지했다.
 */

(function (global) {
    "use strict";

    function db() {
        return firebase.firestore();
    }

    async function getAllPosts() {

        const snapshot = await db().collection("posts").get();

        const posts = snapshot.docs.map(function (doc) {
            return Object.assign({ id: doc.id }, doc.data());
        });

        posts.sort(function (a, b) {
            return new Date(b.createdAt) - new Date(a.createdAt);
        });

        return posts;
    }

    async function getPostById(id) {

        const doc = await db().collection("posts").doc(id).get();

        if (!doc.exists) {
            return null;
        }

        return Object.assign({ id: doc.id }, doc.data());
    }

    /*
     * 쓰기 작업은 보안 규칙이 로그인 여부를 검사하므로
     * Firebase 세션 복원(authReady)이 끝난 뒤에 실행해야 한다.
     */

    async function ensureSignedIn() {

        const user = await window.authReady;

        if (!user) {
            throw new Error("로그인 세션이 없습니다. 다시 로그인해 주세요.");
        }
    }

    async function createPost(data) {

        await ensureSignedIn();

        const post = Object.assign({
            createdAt: new Date().toISOString(),
            views: 0,
            comments: 0
        }, data);

        const ref = await db().collection("posts").add(post);

        await addLog({
            type: "CREATE",
            postId: ref.id,
            postTitle: post.title,
            actorUid: post.authorUid,
            actorNickname: post.authorNickname
        });

        return ref.id;
    }

    async function updatePost(id, data, actorUid, actorNickname) {

        await ensureSignedIn();

        await db().collection("posts").doc(id).update(data);

        await addLog({
            type: "UPDATE",
            postId: id,
            postTitle: data.title,
            actorUid: actorUid,
            actorNickname: actorNickname
        });
    }

    async function deletePost(id, postTitle, actorUid, actorNickname) {

        await ensureSignedIn();

        await db().collection("posts").doc(id).delete();

        await addLog({
            type: "DELETE",
            postId: id,
            postTitle: postTitle,
            actorUid: actorUid,
            actorNickname: actorNickname
        });
    }

    async function addLog(logData) {

        const log = Object.assign({
            time: new Date().toISOString()
        }, logData);

        await db().collection("postLogs").add(log);
    }

    async function getAllLogs() {

        /*
         * postLogs는 관리자만 읽을 수 있으므로 세션 복원 후에 조회한다.
         */

        await window.authReady;

        const snapshot = await db().collection("postLogs").get();

        const logs = snapshot.docs.map(function (doc) {
            return Object.assign({ id: doc.id }, doc.data());
        });

        logs.sort(function (a, b) {
            return new Date(b.time) - new Date(a.time);
        });

        return logs;
    }


    /*
     * 예시 게시글 9개를 처음 한 번만 채워 넣는다.
     * posts 컬렉션에 이미 문서가 있으면 아무 것도 하지 않는다.
     * 관리자만 호출할 수 있도록 admin 화면에서만 버튼으로 노출한다.
     */

    const SEED_POSTS = [
        { title: "제주도 2박 3일 힐링 여행", body: "아름다운 바다와 카페, 맛집까지 알차게 다녀온 제주 여행 기록입니다.", country: "KR", countryLabel: "한국 여행지", style: "healing", image: "jeju.jpg", authorNickname: "바다소년", createdAt: "2026-09-10T09:00:00.000Z" },
        { title: "부산 해운대 맛집 총정리", body: "해운대 근처에서 직접 먹어보고 고른 진짜 맛집만 모았습니다.", country: "KR", countryLabel: "한국 여행지", style: "food", image: "korea.jpg", authorNickname: "먹부림", createdAt: "2026-09-05T09:00:00.000Z" },
        { title: "서울 근교 당일치기 액티비티 코스", body: "짧은 시간에도 알차게 즐길 수 있는 액티비티 코스를 소개합니다.", country: "KR", countryLabel: "한국 여행지", style: "activity", image: "korea.jpg", authorNickname: "주말러", createdAt: "2026-09-14T09:00:00.000Z" },
        { title: "후쿠오카 3박 4일, 먹고 걷고 또 먹은 여행", body: "첫 일본 자유여행에서 만족했던 맛집과 숙소, 교통 정보를 정리했습니다.", country: "JP", countryLabel: "일본 여행지", style: "food", image: "fukuoka.jpg", authorNickname: "여행좋아", createdAt: "2026-09-12T09:00:00.000Z" },
        { title: "오사카 쇼핑 스팟 완전 정리", body: "도톤보리부터 신사이바시까지 쇼핑 동선을 그대로 공유합니다.", country: "JP", countryLabel: "일본 여행지", style: "shopping", image: "japan.jpg", authorNickname: "쇼퍼홀릭", createdAt: "2026-09-01T09:00:00.000Z" },
        { title: "도쿄 디즈니랜드 완전 정복기", body: "대기 시간을 줄이는 동선과 꿀팁까지 한 번에 정리했습니다.", country: "JP", countryLabel: "일본 여행지", style: "activity", image: "japan.jpg", authorNickname: "디즈니덕후", createdAt: "2026-09-13T09:00:00.000Z" },
        { title: "처음 떠나는 유럽, 스페인 바르셀로나", body: "캄프 누에서의 열정을 느낄 수 있는 바르셀로나 여행을 준비합니다.", country: "ETC", countryLabel: "세계 여행지", style: "healing", image: "barcelona.jpg", authorNickname: "길위에서", createdAt: "2026-09-08T09:00:00.000Z" },
        { title: "방콕 길거리 맛집 탐방기", body: "현지인 추천 노점부터 유명 맛집까지 직접 다녀온 후기입니다.", country: "ETC", countryLabel: "세계 여행지", style: "food", image: "world.jpg", authorNickname: "street food", createdAt: "2026-08-30T09:00:00.000Z" },
        { title: "파리에서 놓치면 안 되는 쇼핑 리스트", body: "면세 쇼핑부터 로컬 편집숍까지 동선대로 정리했습니다.", country: "ETC", countryLabel: "세계 여행지", style: "shopping", image: "world.jpg", authorNickname: "파리지앵", createdAt: "2026-09-03T09:00:00.000Z" }
    ];

    async function seedIfEmpty() {

        await ensureSignedIn();

        const snapshot = await db().collection("posts").limit(1).get();

        if (!snapshot.empty) {
            return 0;
        }

        const batch = db().batch();

        SEED_POSTS.forEach(function (post) {

            const ref = db().collection("posts").doc();

            batch.set(ref, Object.assign({
                authorUid: "seed",
                views: 0,
                comments: 0
            }, post));

        });

        await batch.commit();

        return SEED_POSTS.length;
    }

    global.postsStore = {
        getAllPosts: getAllPosts,
        getPostById: getPostById,
        createPost: createPost,
        updatePost: updatePost,
        deletePost: deletePost,
        getAllLogs: getAllLogs,
        seedIfEmpty: seedIfEmpty
    };

})(window);
