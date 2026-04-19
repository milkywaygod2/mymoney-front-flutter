/// JWT 토큰 쌍 VO
class TokenPair {
  const TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;

  /// access_token 만료 시각
  final DateTime expiresAt;

  /// access_token이 만료되었거나 1분 이내에 만료되는지 여부
  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 1)));
}

/// JWT 토큰 저장소 인터페이스
///
/// 구현체는 플랫폼별로 교체 가능:
///   모바일: flutter_secure_storage (Keychain/Keystore)
///   Web:    HttpOnly Cookie (서버 발급) 또는 sessionStorage
abstract interface class ITokenStorage {
  /// 토큰 저장
  Future<void> save(TokenPair tokens);

  /// 저장된 토큰 조회 (없으면 null)
  Future<TokenPair?> load();

  /// 토큰 삭제 (로그아웃 시 호출)
  Future<void> clear();
}

/// SharedPreferences 기반 토큰 저장소 (개발/테스트용)
///
/// 보안 주의: SharedPreferences는 암호화되지 않음.
/// 프로덕션에서는 SecureTokenStorage(flutter_secure_storage)를 사용할 것.
///
/// TODO: pubspec.yaml에 shared_preferences 패키지 추가 필요
///   shared_preferences: ^2.3.2
///
/// 설치 후 아래 stub를 실제 구현으로 교체:
///   import 'package:shared_preferences/shared_preferences.dart';
class DevTokenStorage implements ITokenStorage {
  // 인메모리 fallback (패키지 미설치 시)
  TokenPair? _inMemory;

  @override
  Future<void> save(TokenPair tokens) async {
    // TODO: SharedPreferences 설치 후 실제 구현
    //
    // 구현 예시:
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.setString('access_token', tokens.accessToken);
    //   await prefs.setString('refresh_token', tokens.refreshToken);
    //   await prefs.setString('expires_at', tokens.expiresAt.toIso8601String());
    _inMemory = tokens;
  }

  @override
  Future<TokenPair?> load() async {
    // TODO: SharedPreferences 설치 후 실제 구현
    //
    // 구현 예시:
    //   final prefs = await SharedPreferences.getInstance();
    //   final access = prefs.getString('access_token');
    //   if (access == null) return null;
    //   final refresh = prefs.getString('refresh_token')!;
    //   final expiresAt = DateTime.parse(prefs.getString('expires_at')!);
    //   return TokenPair(accessToken: access, refreshToken: refresh, expiresAt: expiresAt);
    return _inMemory;
  }

  @override
  Future<void> clear() async {
    // TODO: SharedPreferences 설치 후 실제 구현
    //
    // 구현 예시:
    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.remove('access_token');
    //   await prefs.remove('refresh_token');
    //   await prefs.remove('expires_at');
    _inMemory = null;
  }
}

/// flutter_secure_storage 기반 토큰 저장소 (프로덕션용)
///
/// TODO: pubspec.yaml에 flutter_secure_storage 패키지 추가 필요
///   flutter_secure_storage: ^9.2.2
///
/// Android 추가 설정:
///   android/app/build.gradle: minSdkVersion 18 이상
///
/// 설치 후 아래 stub를 실제 구현으로 교체:
///   import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureTokenStorage implements ITokenStorage {
  // stub: 인메모리 fallback
  final DevTokenStorage _fallback = DevTokenStorage();

  @override
  Future<void> save(TokenPair tokens) => _fallback.save(tokens);

  @override
  Future<TokenPair?> load() => _fallback.load();

  @override
  Future<void> clear() => _fallback.clear();
}
