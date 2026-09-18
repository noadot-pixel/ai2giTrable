#!/usr/bin/env python3
"""
JSP 화면을 GitHub Pages용 정적 HTML로 변환한다.

GitHub Pages는 JSP를 실행하지 못한다. 하지만 이 프로젝트의 화면은 브라우저에서
Firebase(Firestore/Auth/Storage)를 직접 호출하는 구조라서, JSP의 서버 쪽 처리
(<%@ include %>, contextPath, activeNav)만 풀어주면 정적 파일로도 그대로 동작한다.

사용법 (저장소 루트에서):
    python tools/build-static.py

main/webapp 아래의 JSP를 고친 뒤에는 이 스크립트를 다시 실행해서 생성된 .html을
함께 커밋한다. 생성된 .html 파일은 직접 고치지 않는다(다시 실행하면 덮어써진다).

변환 규칙
  - <%@ include file="..." %>  : 해당 조각(.jspf)의 내용을 그 자리에 펼친다.
                                  firebase-init.jspf는 JSP와 같이 페이지당 한 번만 넣는다.
  - <%= contextPath %>/css|images|js/...  -> (상대경로)main/webapp/css|images|js/...
  - <%= contextPath %>/xxx.jsp             -> (상대경로)xxx.html
  - <% ... %> 스크립틀릿, <%@ ... %> 지시어, <%-- ... --%> 주석 : 제거
"""

import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
WEBAPP = os.path.join(ROOT, "main", "webapp")

# 정적 사본으로 만들 JSP (error.jsp는 서버가 넘겨주는 오류 정보를 쓰므로 제외)
SKIP = {"error.jsp"}

BANNER = (
    "<!--\n"
    "    GitHub Pages용 정적 사본입니다. (자동 생성 파일: 직접 고치지 마세요)\n"
    "    원본은 main/webapp/%s 이며, 원본을 고친 뒤 저장소 루트에서\n"
    "    `python tools/build-static.py` 를 실행하면 이 파일이 다시 만들어집니다.\n"
    "-->\n"
)


def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


def find_jsps():
    result = []
    for base, _dirs, files in os.walk(WEBAPP):
        if "WEB-INF" in base or "META-INF" in base:
            continue
        for name in files:
            if name.endswith(".jsp") and name not in SKIP:
                full = os.path.join(base, name)
                result.append(os.path.relpath(full, WEBAPP).replace(os.sep, "/"))
    return sorted(result)


def render(jsp_rel):
    depth = jsp_rel.count("/")
    up = "../" * depth

    source = read(os.path.join(WEBAPP, jsp_rel))

    match = re.search(r'<%\s*String\s+activeNav\s*=\s*"([^"]*)"\s*;\s*%>', source)
    active_nav = match.group(1) if match else ""

    included = set()

    def expand(text):
        def replace(m):
            name = m.group(1)

            if name.endswith("firebase-init.jspf"):
                if "firebase-init" in included:
                    return ""
                included.add("firebase-init")

            return expand(read(WEBAPP + name))

        return re.sub(r'<%@\s*include\s+file="([^"]+)"\s*%>', replace, text)

    text = expand(source)

    # JSP 주석
    text = re.sub(r"<%--.*?--%>", "", text, flags=re.S)

    # 헤더의 현재 메뉴 표시:  <%= "home".equals(activeNav) ? "active" : "" %>
    def nav_class(m):
        return "active" if m.group(1) == active_nav else ""

    text = re.sub(
        r'<%=\s*"([^"]*)"\.equals\(activeNav\)\s*\?\s*"active"\s*:\s*""\s*%>',
        nav_class, text)

    # 정적 자원(css/images/js)은 main/webapp 아래 원본을 그대로 재사용
    text = re.sub(r"<%=\s*contextPath\s*%>/(css|images|js)/",
                  lambda m: "%smain/webapp/%s/" % (up, m.group(1)), text)

    # 페이지 이동 링크: .jsp -> .html
    text = re.sub(r"<%=\s*contextPath\s*%>/([A-Za-z0-9_\-/]+)\.jsp",
                  lambda m: "%s%s.html" % (up, m.group(1)), text)

    # 남은 지시어/스크립틀릿 제거 (<%= 식은 아래에서 남아 있으면 오류로 처리)
    text = re.sub(r"<%@.*?%>", "", text, flags=re.S)
    text = re.sub(r"<%(?!=).*?%>", "", text, flags=re.S)

    leftover = re.findall(r"<%.*?%>", text, flags=re.S)
    if leftover:
        raise SystemExit("%s: 변환되지 않은 JSP 코드가 남았습니다: %r" % (jsp_rel, leftover[:3]))

    # 스크립틀릿을 지우고 남은 빈 줄 정리
    text = re.sub(r"\n{3,}", "\n\n", text).lstrip("\n")

    # <!DOCTYPE html> 바로 다음에 안내 주석
    text = re.sub(r"(<!DOCTYPE html>\s*)", lambda m: m.group(1) + BANNER % jsp_rel, text, count=1)

    return text


def main():
    pages = find_jsps()

    for jsp_rel in pages:
        html = render(jsp_rel)
        out_rel = jsp_rel[:-4] + ".html"
        out_path = os.path.join(ROOT, out_rel.replace("/", os.sep))

        os.makedirs(os.path.dirname(out_path), exist_ok=True)

        with open(out_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(html)

        print("생성: %-24s <- main/webapp/%s" % (out_rel, jsp_rel))

    # GitHub Pages가 Jekyll로 처리하지 않고 파일을 그대로 서빙하도록 한다.
    open(os.path.join(ROOT, ".nojekyll"), "a").close()

    print("\n%d개 페이지를 생성했습니다." % len(pages))


if __name__ == "__main__":
    sys.exit(main())
