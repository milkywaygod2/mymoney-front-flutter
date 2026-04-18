/// 타입 안전 ID — int 래핑, 제로코스트 추상화
/// extension type으로 런타임 오버헤드 없이 컴파일 타임 타입 안전성 보장
library;

extension type const TransactionId(int value) implements int {}

extension type const AccountId(int value) implements int {}

extension type const JournalEntryLineId(int value) implements int {}

extension type const CounterpartyId(int value) implements int {}

extension type const PerspectiveId(int value) implements int {}

extension type const OwnerId(int value) implements int {}

extension type const TagId(int value) implements int {}

extension type const PeriodId(int value) implements int {}

extension type const DimensionValueId(int value) implements int {}

extension type const ClassificationRuleId(int value) implements int {}

extension type const ExchangeRateId(int value) implements int {}

extension type const LegalParameterId(int value) implements int {}

extension type const OutboxEntryId(int value) implements int {}
