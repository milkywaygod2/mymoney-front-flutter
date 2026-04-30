import 'dart:io';

import 'package:drift/native.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/Enums.dart' show TransactionStatus;
import '../../core/interfaces/IAccountRepository.dart';
import '../../core/interfaces/ICounterpartyMatcher.dart';
import '../../core/interfaces/ICounterpartyRepository.dart';
import '../../core/interfaces/IExchangeRateRepository.dart';
import '../../core/interfaces/ILegalParameterRepository.dart';
import '../../core/interfaces/IPerspectiveRepository.dart';
import '../../core/interfaces/ITransactionRepository.dart';
import '../../features/account/data/AccountDao.dart';
import '../../features/account/data/AccountRepository.dart';
import '../../features/account/presentation/AccountBloc.dart';
import '../../features/account/usecase/CreateAccount.dart';
import '../../features/account/usecase/DeactivateAccount.dart';
import '../../features/counterparty/data/CounterpartyDao.dart';
import '../../features/counterparty/data/CounterpartyMatcher.dart';
import '../../features/counterparty/data/CounterpartyRepository.dart';
import '../../features/exchange/data/ExchangeRateDao.dart';
import '../../features/exchange/data/ExchangeRateRepository.dart';
import '../../features/exchange/usecase/ConvertCurrency.dart';
import '../../features/exchange/usecase/EvaluateUnrealizedFxGain.dart';
import '../../features/journal/data/TransactionDao.dart';
import '../../features/journal/data/TransactionRepository.dart';
import '../../features/entry/presentation/EntryBloc.dart';
import '../../features/journal/presentation/JournalBloc.dart';
import '../../features/journal/usecase/CreateTransaction.dart';
import '../../features/journal/usecase/DetectDuplicate.dart';
import '../../features/journal/usecase/PostTransaction.dart';
import '../../features/journal/usecase/VoidTransaction.dart';
import '../../features/ocr/data/ClassificationEngine.dart';
import '../../features/ocr/data/OcrService.dart';
import '../../features/ocr/presentation/OcrBloc.dart';
import '../../features/perspective/data/PerspectiveDao.dart';
import '../../features/perspective/data/PerspectiveRepository.dart';
import '../../features/perspective/presentation/PerspectiveBloc.dart';
import '../../core/interfaces/ICashFlowCodeRepository.dart';
import '../../features/report/data/CashFlowCodeDao.dart';
import '../../features/report/data/CashFlowCodeRepository.dart';
import '../../features/report/data/ReportQueryService.dart';
import '../../features/journal/presentation/JournalEvent.dart';
import '../../features/report/presentation/ReportBloc.dart';
import '../../features/tax/presentation/TaxEvent.dart';
import '../../features/report/usecase/CalculateFinancialRatios.dart';
import '../../features/report/usecase/ComparePeriods.dart';
import '../../features/report/usecase/GenerateBalanceSheet.dart';
import '../../features/report/usecase/GenerateCashFlowStatement.dart';
import '../../features/report/usecase/GenerateComprehensiveIncome.dart';
import '../../features/report/usecase/GenerateEquityChangeStatement.dart';
import '../../features/report/usecase/GenerateIncomeStatement.dart';
import '../../features/report/usecase/RunSettlement.dart';
import '../../features/sync/data/ConnectivityMonitor.dart'
    show ConnectivityMonitor, IConnectivityMonitor;
import '../../features/sync/data/OutboxProcessor.dart';
import '../../features/sync/data/SyncService.dart' show ISyncService, SyncService;
import '../../features/tax/data/LegalParameterDao.dart';
import '../../features/tax/data/LegalParameterRepository.dart';
import '../../features/tax/data/TaxRuleEngine.dart';
import '../../features/tax/presentation/TaxBloc.dart';
import '../../features/tax/usecase/AutoClassifyDeductibility.dart';
import '../../infrastructure/database/AppDatabase.dart';

/// DI 컨테이너 — get_it 기반 의존성 주입
final GetIt getIt = GetIt.instance;

/// DI 초기화 — 앱 시작 시 1회 호출
Future<void> configureDependencies() async {
  // ─────────────────────────────────────────────
  // 1. 데이터베이스
  // ─────────────────────────────────────────────
  final db = AppDatabase(
    NativeDatabase.createInBackground(await _dbFile()),
  );
  getIt.registerSingleton<AppDatabase>(db);

  // ─────────────────────────────────────────────
  // 2. DAOs
  // ─────────────────────────────────────────────
  getIt.registerSingleton<AccountDao>(AccountDao(db));
  getIt.registerSingleton<TransactionDao>(TransactionDao(db));
  getIt.registerSingleton<PerspectiveDao>(PerspectiveDao(db));
  getIt.registerSingleton<CounterpartyDao>(CounterpartyDao(db));
  getIt.registerSingleton<ExchangeRateDao>(ExchangeRateDao(db));
  getIt.registerSingleton<LegalParameterDao>(LegalParameterDao(db));
  getIt.registerSingleton<CashFlowCodeDao>(CashFlowCodeDao(db));

  // ─────────────────────────────────────────────
  // 3. Repositories
  // ─────────────────────────────────────────────
  getIt.registerSingleton<IAccountRepository>(
    AccountRepository(getIt<AccountDao>()),
  );
  getIt.registerSingleton<ITransactionRepository>(
    TransactionRepository(getIt<TransactionDao>()),
  );
  getIt.registerSingleton<IPerspectiveRepository>(
    PerspectiveRepository(getIt<PerspectiveDao>()),
  );
  getIt.registerSingleton<ICounterpartyRepository>(
    CounterpartyRepository(getIt<CounterpartyDao>()),
  );
  getIt.registerSingleton<IExchangeRateRepository>(
    ExchangeRateRepository(getIt<ExchangeRateDao>()),
  );
  getIt.registerSingleton<ILegalParameterRepository>(
    LegalParameterRepository(getIt<LegalParameterDao>()),
  );

  // ─────────────────────────────────────────────
  // 4. Infrastructure
  // ─────────────────────────────────────────────
  final connectivityMonitor = ConnectivityMonitor()..start();
  getIt.registerSingleton<IConnectivityMonitor>(connectivityMonitor);

  // IServerApiClient는 외부 주입 필요 — stub null 처리 (S10 구현 전)
  final outboxProcessor = OutboxProcessor(
    db: db,
    // TODO: S10 서버 연동 시 실제 IServerApiClient 주입
    apiClient: _NoOpServerApiClient(),
  );
  getIt.registerSingleton<OutboxProcessor>(outboxProcessor);

  getIt.registerSingleton<ISyncService>(
    SyncService(
      db: db,
      outboxProcessor: outboxProcessor,
      connectivityMonitor: connectivityMonitor,
    ),
  );

  // ─────────────────────────────────────────────
  // 5. OCR / Classification
  // ─────────────────────────────────────────────
  getIt.registerSingleton<ClassificationEngine>(ClassificationEngine(db));
  getIt.registerSingleton<ICounterpartyMatcher>(
    CounterpartyMatcher(getIt<CounterpartyDao>()),
  );
  // TODO: S07 ML Kit 설치 후 MobileOcrService로 교체
  getIt.registerSingleton<IOcrService>(MobileOcrService());

  // ─────────────────────────────────────────────
  // 6. Report / Tax 인프라
  // ─────────────────────────────────────────────
  getIt.registerSingleton<ReportQueryService>(ReportQueryService(db));
  getIt.registerSingleton<ICashFlowCodeRepository>(
    CashFlowCodeRepository(dao: getIt<CashFlowCodeDao>()),
  );
  getIt.registerSingleton<TaxRuleEngine>(const TaxRuleEngine());

  // ─────────────────────────────────────────────
  // 7. UseCases
  // ─────────────────────────────────────────────
  // Account
  getIt.registerSingleton<CreateAccount>(
    CreateAccount(getIt<IAccountRepository>()),
  );
  getIt.registerSingleton<DeactivateAccount>(
    DeactivateAccount(getIt<IAccountRepository>()),
  );

  // Journal
  getIt.registerSingleton<CreateTransaction>(
    CreateTransaction(getIt<ITransactionRepository>()),
  );
  getIt.registerSingleton<PostTransaction>(
    PostTransaction(getIt<ITransactionRepository>()),
  );
  getIt.registerSingleton<VoidTransaction>(
    VoidTransaction(getIt<ITransactionRepository>()),
  );
  getIt.registerSingleton<DetectDuplicate>(
    DetectDuplicate(getIt<ITransactionRepository>()),
  );

  // Exchange
  getIt.registerSingleton<ConvertCurrency>(
    ConvertCurrency(getIt<IExchangeRateRepository>()),
  );
  getIt.registerSingleton<EvaluateUnrealizedFxGain>(
    EvaluateUnrealizedFxGain(getIt<IExchangeRateRepository>()),
  );

  // Report
  getIt.registerSingleton<GenerateIncomeStatement>(
    GenerateIncomeStatement(getIt<ReportQueryService>()),
  );
  getIt.registerSingleton<GenerateBalanceSheet>(
    GenerateBalanceSheet(getIt<ReportQueryService>()),
  );
  getIt.registerSingleton<RunSettlement>(
    RunSettlement(
      queryService: getIt<ReportQueryService>(),
      generateIncomeStatement: getIt<GenerateIncomeStatement>(),
      evaluateFxGain: getIt<EvaluateUnrealizedFxGain>(),
      transactionRepository: getIt<ITransactionRepository>(),
      accountRepository: getIt<IAccountRepository>(),
      db: db,
    ),
  );
  getIt.registerSingleton<GenerateCashFlowStatement>(
    GenerateCashFlowStatement(
      queryService: getIt<ReportQueryService>(),
      generateIncomeStatement: getIt<GenerateIncomeStatement>(),
      cashFlowCodeRepository: getIt<ICashFlowCodeRepository>(),
    ),
  );
  getIt.registerSingleton<GenerateEquityChangeStatement>(
    GenerateEquityChangeStatement(
      queryService: getIt<ReportQueryService>(),
      generateIncomeStatement: getIt<GenerateIncomeStatement>(),
    ),
  );

  // Tax
  getIt.registerSingleton<AutoClassifyDeductibility>(
    AutoClassifyDeductibility(
      transactionRepository: getIt<ITransactionRepository>(),
      accountRepository: getIt<IAccountRepository>(),
      legalParameterRepository: getIt<ILegalParameterRepository>(),
      ruleEngine: getIt<TaxRuleEngine>(),
    ),
  );

  // ─────────────────────────────────────────────
  // 8. BLoCs (singleton: Stream 연결을 위해 단일 인스턴스 유지)
  // ─────────────────────────────────────────────
  getIt.registerSingleton<JournalBloc>(
    JournalBloc(
      repository: getIt<ITransactionRepository>(),
      createTransaction: getIt<CreateTransaction>(),
      postTransaction: getIt<PostTransaction>(),
    ),
  );
  getIt.registerSingleton<AccountBloc>(
    AccountBloc(
      repository: getIt<IAccountRepository>(),
      transactionRepository: getIt<ITransactionRepository>(),
    ),
  );
  getIt.registerSingleton<PerspectiveBloc>(
    PerspectiveBloc(repository: getIt<IPerspectiveRepository>()),
  );
  getIt.registerSingleton<TaxBloc>(
    TaxBloc(
      autoClassifyDeductibility: getIt<AutoClassifyDeductibility>(),
    ),
  );
  // v2.0: 비율/OCI/기간비교 UseCase 등록
  getIt.registerLazySingleton<CalculateFinancialRatios>(
    () => CalculateFinancialRatios(getIt<ReportQueryService>()),
  );
  getIt.registerLazySingleton<GenerateComprehensiveIncome>(
    () => GenerateComprehensiveIncome(getIt<ReportQueryService>()),
  );
  getIt.registerLazySingleton<ComparePeriods>(
    () => ComparePeriods(getIt<ReportQueryService>()),
  );
  getIt.registerSingleton<ReportBloc>(
    ReportBloc(
      generateBalanceSheet: getIt<GenerateBalanceSheet>(),
      generateIncomeStatement: getIt<GenerateIncomeStatement>(),
      runSettlement: getIt<RunSettlement>(),
      queryService: getIt<ReportQueryService>(),
      calculateFinancialRatios: getIt<CalculateFinancialRatios>(),
      generateComprehensiveIncome: getIt<GenerateComprehensiveIncome>(),
      comparePeriods: getIt<ComparePeriods>(),
      generateCashFlowStatement: getIt<GenerateCashFlowStatement>(),
      generateEquityChangeStatement: getIt<GenerateEquityChangeStatement>(),
    ),
  );
  getIt.registerSingleton<OcrBloc>(
    OcrBloc(
      ocrService: getIt<IOcrService>(),
      classificationEngine: getIt<ClassificationEngine>(),
      counterpartyMatcher: getIt<ICounterpartyMatcher>(),
      createTransaction: getIt<CreateTransaction>(),
      accountRepository: getIt<IAccountRepository>(),
    ),
  );
  getIt.registerSingleton<EntryBloc>(
    EntryBloc(createTransaction: getIt<CreateTransaction>()),
  );

  // ─────────────────────────────────────────────
  // 9. BLoC Stream 연결 5경로 (CW 섹션 9.2)
  // ─────────────────────────────────────────────
  _connectBlocStreams();
}

/// BLoC 간 Stream 연결 — singleton 등록 완료 후 1회 호출
void _connectBlocStreams() {
  final perspectiveBloc = getIt<PerspectiveBloc>();
  final journalBloc = getIt<JournalBloc>();
  final reportBloc = getIt<ReportBloc>();
  final taxBloc = getIt<TaxBloc>();

  // 1~3. PerspectiveBloc → JournalBloc / ReportBloc / TaxBloc
  // (단일 subscription으로 통합 — 3개별 listen 시 동일 이벤트가 3번 dispatch됨)
  perspectiveBloc.stream.listen((state) {
    if (state.effectivePerspective != null) {
      // 1. Perspective 변경 → 거래 리필터링
      journalBloc.add(LoadTransactions(perspective: state.effectivePerspective));
      // 2. Perspective 변경 → 보고서 갱신
      reportBloc.add(LoadDashboard(perspective: state.effectivePerspective));
      // 3. Perspective 변경 → 미판정 항목 갱신
      taxBloc.add(const LoadPendingItems());
    }
  });

  // 4. JournalBloc → TaxBloc (TransactionPosted → 세무 자동판정)
  // 이전 상태와 비교하여 신규 posted 거래만 처리 — 매 로드마다 전체 재판정 방지
  var setPrevPostedIds = <int>{};
  journalBloc.stream.listen((state) {
    if (state.isLoading) return;
    final setCurrPostedIds = state.listTransactions
        .where((t) => t.status == TransactionStatus.posted)
        .map((t) => t.id.value)
        .toSet();
    final setNewlyPosted = setCurrPostedIds.difference(setPrevPostedIds);
    setPrevPostedIds = setCurrPostedIds;
    if (setNewlyPosted.isNotEmpty) {
      taxBloc.add(RunAutoClassification(
        listTransactionIds: state.listTransactions
            .where((t) => setNewlyPosted.contains(t.id.value))
            .map((t) => t.id)
            .toList(),
        asOfDate: DateTime.now(),
      ));
    }
  });

  // 5. JournalBloc → ReportBloc (거래 목록 로드 완료 → 대시보드 갱신)
  // isLoading 완료 + 거래 목록 존재 시에만 트리거 (초기 빈 상태 제외)
  journalBloc.stream.listen((state) {
    if (!state.isLoading && state.listTransactions.isNotEmpty) {
      reportBloc.add(const LoadDashboard());
    }
  });
}

/// DB 파일 경로 — getApplicationDocumentsDirectory() 기반
Future<File> _dbFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File(p.join(dir.path, 'mymoney.db'));
}

/// S10 서버 연동 전 No-Op 어댑터 — 전송 없이 성공 반환
class _NoOpServerApiClient implements IServerApiClient {
  @override
  Future<bool> sendEntry(OutboxEntry entry) async => true;

  @override
  Future<List<Map<String, dynamic>>> fetchDelta(DateTime sinceAt) async => [];
}
