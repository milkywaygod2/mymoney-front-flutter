import 'package:get_it/get_it.dart';

/// DI 컨테이너 — get_it 기반 의존성 주입
final GetIt getIt = GetIt.instance;

/// DI 초기화 — 앱 시작 시 1회 호출
Future<void> configureDependencies() async {
  // TODO: injectable_generator 자동 등록으로 교체
  // Wave 2+에서 Repository, DAO, BLoC 등록 추가
}
