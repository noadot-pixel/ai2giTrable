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
     * 관리자 판별도 실제 DB 없이 이메일 목록으로 대신한다.
     * 추후 Firestore/Oracle의 admin 테이블(또는 컬럼)로 교체될 예정.
     * 테스트하려면 이 목록에 본인의 Firebase 테스트 계정 이메일을 추가한다.
     */

    const ADMIN_EMAILS = [
        "admin@trable.com"
    ];

    function isAdmin() {

        const user = getCurrentUser();

        return !!user
            && !!user.email
            && ADMIN_EMAILS.indexOf(user.email) !== -1;
    }

    global.mockAuth = {
        login: login,
        logout: logout,
        getCurrentUser: getCurrentUser,
        isLoggedIn: isLoggedIn,
        isAdmin: isAdmin
    };

})(window);
