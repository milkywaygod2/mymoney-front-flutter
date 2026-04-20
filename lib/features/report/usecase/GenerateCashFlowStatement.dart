import '../../../core/constants/Enums.dart';
import '../../../core/interfaces/ICashFlowCodeRepository.dart';
import '../../../core/models/CashFlowLineItem.dart';
import '../data/ReportQueryService.dart';
import 'GenerateIncomeStatement.dart';

/// 현금흐름표(CF) 생성 결과
class CashFlowStatement {
  const CashFlowStatement({
    required this.periodId,
    required this.listItems,
    required this.operatingTotal,
    required this.investingTotal,
    required this.financingTotal,
    required this.fxEffect,
    required this.netChange,
    required this.beginningCash,
    required this.endingCash,
  });

  final int periodId;
  final List<CashFlowLineItem> listItems;

  /// 5분류 합계
  final int operatingTotal;   // 영업활동
  final int investingTotal;   // 투자활동
  final int financingTotal;   // 재무활동
  final int fxEffect;         // 환율변동효과
  final int netChange;        // 현금 순변동
  final int beginningCash;    // 기초현금
  final int endingCash;       // 기말현금
}

/// GenerateCashFlowStatement — 5분류 간접법 CF 보고서 생성
///
/// [아키텍처 근거 — CW_ARCHITECTURE.md §7.6]
/// 1. PL에서 당기순이익 가져오기 (C110000 — Automatic)
/// 2. Account.cashFlowCategory 기반 JEL 변동 → CF 코드 자동 매핑
/// 3. CashFlowCodes 계층 구조로 집계 (Aggregate 노드)
/// 4. 영업/투자/재무/환율/순변동 5분류 산출
class GenerateCashFlowStatement {
  GenerateCashFlowStatement({
    required ReportQueryService queryService,
    required GenerateIncomeStatement generateIncomeStatement,
    required ICashFlowCodeRepository cashFlowCodeRepository,
  })  : _queryService = queryService,
        _generateIncomeStatement = generateIncomeStatement,
        _cfCodeRepo = cashFlowCodeRepository;

  final ReportQueryService _queryService;
  final GenerateIncomeStatement _generateIncomeStatement;
  final ICashFlowCodeRepository _cfCodeRepo;

  /// CF 생성
  ///
  /// [periodId] 결산 기간 ID
  Future<CashFlowStatement> execute({
    required int periodId,
  }) async {
    // 1. 당기순이익 (C110000 — Automatic)
    final incomeStatement = await _generateIncomeStatement.execute(periodId: periodId);
    final netIncome = incomeStatement.netIncome;

    // 2. B/S 계정별 변동 조회 — cashFlowCategory 기반 분류
    final listBsEntries = await _queryService.calculateBalanceSheet(periodId);

    // 운전자본 변동 계산: 채권채무 계정의 당기 변동
    var operatingWorkingCapitalChange = 0;
    for (final entry in listBsEntries) {
      // cashFlowCategory == receivablePayable인 계정의 변동은 영업활동
      // 유동자산 증가 → 현금 감소 (음수), 유동부채 증가 → 현금 증가 (양수)
      if (entry.equityTypePath.startsWith('ASSET.CURRENT.RECEIVABLE') ||
          entry.equityTypePath.startsWith('ASSET.CURRENT.PREPAID') ||
          entry.equityTypePath.startsWith('ASSET.CURRENT.INVENTORY')) {
        operatingWorkingCapitalChange -= entry.balance; // 자산 증가 = 현금 유출
      } else if (entry.equityTypePath.startsWith('LIABILITY.CURRENT.PAYABLE') ||
          entry.equityTypePath.startsWith('LIABILITY.CURRENT.ADVANCE') ||
          entry.equityTypePath.startsWith('LIABILITY.CURRENT.WITHHOLDING')) {
        operatingWorkingCapitalChange += entry.balance; // 부채 증가 = 현금 유입
      }
    }

    // 3. 비현금 항목 가감 (감가상각비 등 — P/L 비용 중 현금 유출 없는 항목)
    var nonCashAdjustment = 0;
    for (final expense in incomeStatement.listExpenses) {
      if (expense.equityTypePath.startsWith('EXPENSE.DEPRECIATION')) {
        nonCashAdjustment += expense.amount; // 감가상각비 가산
      }
    }

    // 영업활동 합계
    final operatingTotal = netIncome + nonCashAdjustment + operatingWorkingCapitalChange;

    // 4. 투자/재무 활동 — 비유동자산/차입금 변동에서 추출
    var investingTotal = 0;
    var financingTotal = 0;
    for (final entry in listBsEntries) {
      if (entry.equityTypePath.startsWith('ASSET.NON_CURRENT')) {
        investingTotal -= entry.balance; // 비유동자산 증가 = 투자 유출
      } else if (entry.equityTypePath.startsWith('LIABILITY.NON_CURRENT')) {
        financingTotal += entry.balance; // 비유동부채 증가 = 재무 유입
      } else if (entry.equityTypePath.startsWith('LIABILITY.CURRENT.SHORT_TERM_BORROWING')) {
        financingTotal += entry.balance; // 단기차입금 변동
      }
    }

    // 5. 환율변동효과 — 현금성 외화 계정의 환율 변동분
    // TODO: EvaluateUnrealizedFxGain 결과에서 현금성 계정분만 추출
    const fxEffect = 0;

    // 현금 순변동 + 기초/기말
    final netChange = operatingTotal + investingTotal + financingTotal + fxEffect;

    // 기초/기말 현금 — 현금성 자산 잔액
    var endingCash = 0;
    for (final entry in listBsEntries) {
      if (entry.equityTypePath.startsWith('ASSET.CURRENT.CASH')) {
        endingCash += entry.balance;
      }
    }
    final beginningCash = endingCash - netChange;

    // 6. CashFlowCodes 계층 구조로 출력
    final listAllCodes = await _cfCodeRepo.findAll();
    final listItems = <CashFlowLineItem>[];

    for (final cfCode in listAllCodes) {
      int amount;
      switch (cfCode.code) {
        case 'C100000': amount = operatingTotal; break;
        case 'C110000': amount = netIncome; break;
        case 'C120000': amount = nonCashAdjustment; break;
        case 'C130000': amount = operatingWorkingCapitalChange; break;
        case 'C200000': amount = investingTotal; break;
        case 'C300000': amount = financingTotal; break;
        case 'C400000': amount = fxEffect; break;
        case 'C500000': amount = netChange; break;
        case 'C6000000': amount = beginningCash; break;
        case 'C7000000': amount = endingCash; break;
        default: amount = 0; // Actual 항목은 개별 JEL 매핑 필요 (P3 확장)
      }

      listItems.add(CashFlowLineItem(
        code: cfCode.code,
        name: cfCode.name,
        amount: amount,
        level: cfCode.level,
        indexType: cfCode.indexType,
      ));
    }

    return CashFlowStatement(
      periodId: periodId,
      listItems: listItems,
      operatingTotal: operatingTotal,
      investingTotal: investingTotal,
      financingTotal: financingTotal,
      fxEffect: fxEffect,
      netChange: netChange,
      beginningCash: beginningCash,
      endingCash: endingCash,
    );
  }
}
