<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>접근 불가</title>
  <style>
    body {font-family: "Noto Sans KR", sans-serif; background:#faf8f0; margin:0}
    .wrap {min-height:60vh; display:flex; align-items:center; justify-content:center; flex-direction:column; gap:12px}
    a.btn {padding:10px 16px; border:1px solid #1a5d1a; border-radius:8px; color:#1a5d1a; text-decoration:none}
    a.btn:hover {background:#1a5d1a; color:#fff}
  </style>
</head>
<body>
  <div class="wrap">
    <h2>🚫 관리자만 접근할 수 있습니다.</h2>
    <p>권한이 없는 계정으로 접근하셨습니다.</p>
    <a class="btn" href="${pageContext.request.contextPath}/main.do">메인으로</a>
  </div>
</body>
</html>
