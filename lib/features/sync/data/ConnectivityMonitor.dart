import 'dart:async';

/// 네트워크 연결 상태 모니터 인터페이스
///
/// 앱 전역에서 구독하여 온라인/오프라인 전환 시 동기화 트리거에 활용
abstract interface class IConnectivityMonitor {
  /// 현재 온라인 여부 (즉시 조회)
  bool get isOnline;

  /// 연결 상태 변경 스트림 — true=온라인, false=오프라인
  Stream<bool> get streamOnline;

  /// 모니터링 시작 (앱 시작 시 호출)
  void start();

  /// 모니터링 중지 (앱 종료 시 호출)
  void dispose();
}

/// connectivity_plus 기반 네트워크 모니터
///
/// TODO: pubspec.yaml에 connectivity_plus 패키지 추가 필요
///   connectivity_plus: ^6.1.0
///
/// 설치 후 아래 stub를 실제 구현으로 교체:
///   import 'package:connectivity_plus/connectivity_plus.dart';
///
///   final _connectivity = Connectivity();
///   StreamSubscription? _sub;
///
///   void start() {
///     _sub = _connectivity.onConnectivityChanged.listen((results) {
///       final online = results.any((r) => r != ConnectivityResult.none);
///       _controller.add(online);
///       _isOnline = online;
///     });
///   }
class ConnectivityMonitor implements IConnectivityMonitor {
  ConnectivityMonitor() : _controller = StreamController<bool>.broadcast();

  final StreamController<bool> _controller;
  bool _isOnline = true; // stub: 항상 온라인으로 가정

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get streamOnline => _controller.stream;

  @override
  void start() {
    // TODO: connectivity_plus 설치 후 실제 구독 시작
    // 현재는 stub — 온라인 상태 유지
    _isOnline = true;
  }

  /// 테스트/개발 목적으로 온라인 상태를 강제 설정
  void setOnlineForTest(bool online) {
    _isOnline = online;
    _controller.add(online);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
