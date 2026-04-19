/// Domain Event Bus 예약 인터페이스 (CW 섹션 15)
/// MVP에서는 UseCase 직접 호출, 향후 이벤트 기반으로 전환 시 활성화
abstract interface class IDomainEventBus {
  /// 도메인 이벤트 발행
  void publish(Object event);

  /// 이벤트 구독
  Stream<T> subscribe<T>();

  /// 구독 해제
  void dispose();
}
