/*
 * DB 없이 로그인 상태만 흉내 내기 위한 목업 인증 모듈.
 * localStorage에 임시로만 저장하며, 실제 인증/암호화는 하지 않는다.
 * 추후 Oracle JDBC + 세션 기반 로그인으로 교체될 예정.
 */

(function (global) {
    "use strict";

    const STORAGE_KEY = "trable_mock_session";

    function login(user) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(user));
    }

    function logout() {
        localStorage.removeItem(STORAGE_KEY);
    }

    function getCurrentUser() {

        const raw = localStorage.getItem(STORAGE_KEY);

        if (!raw) {
            return null;
        }

        try {
            return JSON.parse(raw);
        } catch (error) {
            return null;
        }

    }

    function isLoggedIn() {
        return getCurrentUser() !== null;
    }


    /*
     * 관리자 판별은 Firestore의 admins/{uid} 문서 존재 여부로 확인한다.
     * 콘솔의 Firestore Database에서 admins 컬렉션에 해당 계정의 uid로
     * 문서를 하나 만들어 두면 그 계정은 관리자가 된다(보안 규칙상
     * 클라이언트에서는 admins 문서를 쓸 수 없고 콘솔에서만 추가 가능).
     * firebase-init.jspf가 먼저 로드되어 있어야 한다.
     */

    async function isAdmin() {

        const user = getCurrentUser();

        if (!user || !user.id) {
            return false;
        }

        try {

            const doc = await firebase.firestore()
                .collection("admins")
                .doc(user.id)
                .get();

            return doc.exists;

        } catch (error) {
            return false;
        }

    }

    global.mockAuth = {
        login: login,
        logout: logout,
        getCurrentUser: getCurrentUser,
        isLoggedIn: isLoggedIn,
        isAdmin: isAdmin
    };

})(window);
