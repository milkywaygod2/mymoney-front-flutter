import 'TokenStorage.dart';

/// 인증 결과 VO
class AuthResult {
  const AuthResult({
    required this.isSuccess,
    this.tokens,
    this.errorMessage,
  });

  final bool isSuccess;

  /// 성공 시 JWT 토큰 쌍
  final TokenPair? tokens;

  /// 실패 시 오류 메시지
  final String? errorMessage;

  static AuthResult success(TokenPair tokens) =>
      AuthResult(isSuccess: true, tokens: tokens);

  static AuthResult failure(String message) =>
      AuthResult(isSuccess: false, errorMessage: message);
}

/// 인증 서비스 인터페이스
///
/// 구현 전략:
///   소셜 로그인: Google/Apple OAuth2 → ID 토큰 → C# 백엔드 검증 → JWT 발급
///   생체인증:    local_auth → 기기 인증 통과 → 저장된 JWT 재사용 (새 발급 없음)
///   JWT 관리:   C# ASP.NET Core Identity 자체 발급/검증 (외부 서비스 의존 없음)
abstract interface class IAuthService {
  /// Google OAuth2 로그인
  Future<AuthResult> signInWithGoogle();

  /// Apple OAuth2 로그인 (iOS/macOS 전용)
  Future<AuthResult> signInWithApple();

  /// 생체인증/PIN 앱 잠금 해제
  /// 반환: true=인증 성공, false=실패/취소
  Future<bool> authenticateWithBiometrics({String reason = '앱 잠금을 해제합니다'});

  /// 현재 로그인 상태 확인
  Future<bool> isLoggedIn();

  /// access_token 갱신 (만료 전 자동 호출)
  Future<AuthResult> refreshToken();

  /// 로그아웃 (토큰 삭제)
  Future<void> signOut();
}

/// 인증 서비스 구현체 — 소셜 OAuth2 + 생체인증 + JWT 관리
///
/// 패키지 설치 현황 (미설치 → stub 처리):
///   google_sign_in: ^6.2.1  → TODO
///   sign_in_with_apple: ^6.1.2  → TODO
///   local_auth: ^2.3.0  → TODO
///
/// C# 백엔드 인증 흐름:
///   1. Flutter: Google/Apple ID 토큰 획득
///   2. POST /api/auth/social { provider, idToken }
///   3. C# 백엔드: ID 토큰 검증 → ASP.NET Core Identity → JWT 발급
///   4. Flutter: JWT 저장 → 이후 API 호출에 Authorization: Bearer 헤더 사용
class AuthService implements IAuthService {
  AuthService({required ITokenStorage tokenStorage})
      : _tokenStorage = tokenStorage;

  final ITokenStorage _tokenStorage;

  /// C# 백엔드 기준 URL
  /// TODO: 환경변수 또는 flavor 기반 설정으로 교체
  // ignore: unused_field — _exchangeIdToken 구현 시 사용 예정
  static const String _backendBaseUrl = 'http://localhost:5000';

  // ---------------------------------------------------------------------------
  // 소셜 로그인
  // ---------------------------------------------------------------------------

  @override
  Future<AuthResult> signInWithGoogle() async {
    // TODO: google_sign_in 패키지 설치 후 구현
    //
    // 구현 예시:
    //   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    //   final account = await _googleSignIn.signIn();
    //   if (account == null) return AuthResult.failure('로그인 취소');
    //   final auth = await account.authentication;
    //   final idToken = auth.idToken;
    //   if (idToken == null) return AuthResult.failure('ID 토큰 획득 실패');
    //   return _exchangeIdToken(provider: 'google', idToken: idToken);
    return AuthResult.failure('TODO: google_sign_in 패키지 설치 필요');
  }

  @override
  Future<AuthResult> signInWithApple() async {
    // TODO: sign_in_with_apple 패키지 설치 후 구현
    //
    // 구현 예시:
    //   final credential = await SignInWithApple.getAppleIDCredential(
    //     scopes: [AppleIDAuthorizationScopes.email],
    //   );
    //   final idToken = credential.identityToken;
    //   if (idToken == null) return AuthResult.failure('ID 토큰 획득 실패');
    //   return _exchangeIdToken(provider: 'apple', idToken: idToken);
    return AuthResult.failure('TODO: sign_in_with_apple 패키지 설치 필요');
  }

  // ---------------------------------------------------------------------------
  // 생체인증
  // ---------------------------------------------------------------------------

  @override
  Future<bool> authenticateWithBiometrics({
    String reason = '앱 잠금을 해제합니다',
  }) async {
    // TODO: local_auth 패키지 설치 후 구현
    //
    // 구현 예시:
    //   final auth = LocalAuthentication();
    //   final isAvailable = await auth.canCheckBiometrics;
    //   if (!isAvailable) return false;
    //   return auth.authenticate(
    //     localizedReason: reason,
    //     options: const AuthenticationOptions(biometricOnly: false),
    //   );
    //
    // 생체인증은 새 JWT 발급이 아닌 기기 잠금 해제용
    // → 기존 저장된 JWT가 유효하면 재사용
    return true; // stub: 항상 성공
  }

  // ---------------------------------------------------------------------------
  // JWT 관리
  // ---------------------------------------------------------------------------

  @override
  Future<bool> isLoggedIn() async {
    final tokens = await _tokenStorage.load();
    if (tokens == null) return false;
    // access_token 만료 시 refresh 시도
    if (tokens.isExpired) {
      final result = await refreshToken();
      return result.isSuccess;
    }
    return true;
  }

  @override
  Future<AuthResult> refreshToken() async {
    // TODO: C# 백엔드 POST /api/auth/refresh 호출
    //
    // 구현 예시:
    //   final tokens = await _tokenStorage.load();
    //   if (tokens == null) return AuthResult.failure('저장된 토큰 없음');
    //   final response = await http.post(
    //     Uri.parse('$_backendBaseUrl/api/auth/refresh'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({'refreshToken': tokens.refreshToken}),
    //   );
    //   if (response.statusCode == 200) {
    //     final body = jsonDecode(response.body);
    //     final newTokens = TokenPair(
    //       accessToken: body['accessToken'],
    //       refreshToken: body['refreshToken'],
    //       expiresAt: DateTime.parse(body['expiresAt']),
    //     );
    //     await _tokenStorage.save(newTokens);
    //     return AuthResult.success(newTokens);
    //   }
    //   return AuthResult.failure('토큰 갱신 실패: ${response.statusCode}');
    return AuthResult.failure('TODO: C# 백엔드 API 연동 필요');
  }

  @override
  Future<void> signOut() async {
    // TODO: C# 백엔드 POST /api/auth/logout 호출 (refresh_token 무효화)
    await _tokenStorage.clear();
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  /// 소셜 ID 토큰 → C# 백엔드 교환 → JWT 저장
  ///
  /// TODO: http 패키지 설치 후 실제 구현
  // ignore: unused_element — signInWithGoogle/Apple stub 완성 시 호출 예정
  Future<AuthResult> _exchangeIdToken({
    required String provider,
    required String idToken,
  }) async {
    // TODO: POST $_backendBaseUrl/api/auth/social
    //   Body: { "provider": provider, "idToken": idToken }
    //   Response: { "accessToken": ..., "refreshToken": ..., "expiresAt": ... }
    return AuthResult.failure('TODO: 백엔드 API 연동 필요');
  }
}
