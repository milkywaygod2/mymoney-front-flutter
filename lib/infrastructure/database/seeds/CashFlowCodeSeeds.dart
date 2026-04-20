/// CashFlowCodes 시드 데이터 — NAVER IFRS CF 코드 체계 기반 113행
/// 7분류 계층: 영업(C1)/투자(C2)/재무(C3)/환율(C4)/순변동(C5)/기초(C6)/기말(C7)
/// indexType: aggregate(합산) | actual(직접) | automatic(PL연동)
library;

/// 단일 CashFlowCode 시드 항목
class CfSeed {
  final String code;
  final String name;
  final String? parentCode;
  final String indexType; // aggregate | actual | automatic
  final int level;
  final int sortOrder;

  const CfSeed(this.code, this.name, this.parentCode, this.indexType, this.level, this.sortOrder);
}

/// CF 코드 시드 113행 — §7.6 구조 기준
const List<CfSeed> kCashFlowCodeSeeds = [
  // ===== C1: 영업활동 현금흐름 =====
  CfSeed('C100000', 'Cash flows from operating activities', null, 'aggregate', 1, 100),
  CfSeed('C110000', 'Profit(loss) for the period', 'C100000', 'automatic', 2, 110),
  CfSeed('C120000', 'Addition of expenses, deduction of income items not involving cash', 'C100000', 'aggregate', 2, 120),
  CfSeed('C120100', 'Bad debt expense', 'C120000', 'actual', 3, 1201),
  CfSeed('C120200', 'Other bad debt expense', 'C120000', 'actual', 3, 1202),
  CfSeed('C120300', 'Depreciation of tangible assets', 'C120000', 'actual', 3, 1203),
  CfSeed('C120400', 'Depreciation of intangible assets', 'C120000', 'actual', 3, 1204),
  CfSeed('C120500', 'Depreciation of investment property', 'C120000', 'actual', 3, 1205),
  CfSeed('C120600', 'Loss on valuation of inventories', 'C120000', 'actual', 3, 1206),
  CfSeed('C120700', 'Loss on disposal of tangible assets', 'C120000', 'actual', 3, 1207),
  CfSeed('C120800', 'Loss on disposal of intangible assets', 'C120000', 'actual', 3, 1208),
  CfSeed('C120900', 'Stock option expense', 'C120000', 'actual', 3, 1209),
  CfSeed('C121000', 'Foreign exchange loss', 'C120000', 'actual', 3, 1210),
  CfSeed('C121100', 'Foreign exchange translation loss', 'C120000', 'actual', 3, 1211),
  CfSeed('C121200', 'Interest expense (financial)', 'C120000', 'actual', 3, 1212),
  CfSeed('C121300', 'Loss on FVTPL financial instruments', 'C120000', 'actual', 3, 1213),
  CfSeed('C121400', 'Loss on derivative instruments', 'C120000', 'actual', 3, 1214),
  CfSeed('C121500', 'Impairment of financial assets', 'C120000', 'actual', 3, 1215),
  CfSeed('C121600', 'Impairment of subsidiaries investment', 'C120000', 'actual', 3, 1216),
  CfSeed('C121700', 'Loss on equity method investments', 'C120000', 'actual', 3, 1217),
  CfSeed('C121800', 'Provision for retirement benefits', 'C120000', 'actual', 3, 1218),
  CfSeed('C122100', 'Gain on disposal of tangible assets', 'C120000', 'actual', 3, 1221),
  CfSeed('C122200', 'Gain on disposal of intangible assets', 'C120000', 'actual', 3, 1222),
  CfSeed('C122210', 'Interest income (financial)', 'C120000', 'actual', 3, 12221),
  CfSeed('C122220', 'Dividend income', 'C120000', 'actual', 3, 12222),
  CfSeed('C122230', 'Foreign exchange gain', 'C120000', 'actual', 3, 12223),
  CfSeed('C122240', 'Foreign exchange translation gain', 'C120000', 'actual', 3, 12224),
  CfSeed('C122300', 'Gain on FVTPL financial instruments', 'C120000', 'actual', 3, 1223),
  CfSeed('C122400', 'Gain on derivative instruments', 'C120000', 'actual', 3, 1224),
  CfSeed('C122500', 'Gain on disposal of subsidiaries investment', 'C120000', 'actual', 3, 1225),
  CfSeed('C122600', 'Gain on equity method investments', 'C120000', 'actual', 3, 1226),
  CfSeed('C122700', 'Reversal of bad debt expense', 'C120000', 'actual', 3, 1227),
  CfSeed('C122800', 'Reversal of impairment', 'C120000', 'actual', 3, 1228),
  CfSeed('C122900', 'Income tax expense', 'C120000', 'actual', 3, 1229),
  CfSeed('C122950', 'Coin refund expense', 'C120000', 'actual', 3, 12295),
  CfSeed('C123000', 'Other non-cash items', 'C120000', 'actual', 3, 1230),

  // --- C13: 운전자본 변동 ---
  CfSeed('C130000', 'Changes in assets and liabilities from operating activities', 'C100000', 'aggregate', 2, 130),
  CfSeed('C130200', 'Decrease(increase) in trade receivables', 'C130000', 'actual', 3, 1302),
  CfSeed('C130300', 'Decrease(increase) in other receivables', 'C130000', 'actual', 3, 1303),
  CfSeed('C130400', 'Decrease(increase) in accrued income', 'C130000', 'actual', 3, 1304),
  CfSeed('C130500', 'Decrease(increase) in advance payments', 'C130000', 'actual', 3, 1305),
  CfSeed('C130600', 'Decrease(increase) in prepaid expenses', 'C130000', 'actual', 3, 1306),
  CfSeed('C130700', 'Decrease(increase) in inventories', 'C130000', 'actual', 3, 1307),
  CfSeed('C130800', 'Increase(decrease) in trade payables', 'C130000', 'actual', 3, 1308),
  CfSeed('C130900', 'Increase(decrease) in other payables', 'C130000', 'actual', 3, 1309),
  CfSeed('C131000', 'Increase(decrease) in accrued expenses', 'C130000', 'actual', 3, 1310),
  CfSeed('C131100', 'Increase(decrease) in advance received', 'C130000', 'actual', 3, 1311),
  CfSeed('C131200', 'Increase(decrease) in unearned revenue', 'C130000', 'actual', 3, 1312),
  CfSeed('C131300', 'Increase(decrease) in withholdings', 'C130000', 'actual', 3, 1313),
  CfSeed('C131400', 'Increase(decrease) in VAT payable', 'C130000', 'actual', 3, 1314),
  CfSeed('C131500', 'Payment of retirement benefits', 'C130000', 'actual', 3, 1315),
  CfSeed('C131510', 'Plan assets contribution', 'C130000', 'actual', 3, 13151),
  CfSeed('C131520', 'Increase(decrease) in provisions', 'C130000', 'actual', 3, 13152),
  CfSeed('C131530', 'Increase(decrease) in other current liabilities', 'C130000', 'actual', 3, 13153),
  CfSeed('C131540', 'Decrease(increase) in other current assets', 'C130000', 'actual', 3, 13154),
  CfSeed('C131550', 'Decrease(increase) in long-term receivables', 'C130000', 'actual', 3, 13155),
  CfSeed('C131600', 'Other changes in operating assets and liabilities', 'C130000', 'actual', 3, 1316),

  // --- C14~C17: 영업활동 이자/배당/법인세 ---
  CfSeed('C140000', 'Payment of interest', 'C100000', 'actual', 2, 140),
  CfSeed('C150000', 'Receipt of interest', 'C100000', 'actual', 2, 150),
  CfSeed('C160000', 'Receipt of dividends', 'C100000', 'actual', 2, 160),
  CfSeed('C170000', 'Income tax payments', 'C100000', 'actual', 2, 170),

  // ===== C2: 투자활동 현금흐름 =====
  CfSeed('C200000', 'Cash flows from investing activities', null, 'aggregate', 1, 200),
  CfSeed('C210000', 'Cash inflows from investing activities', 'C200000', 'aggregate', 2, 210),
  CfSeed('C210100', 'Disposal of short-term financial instruments', 'C210000', 'actual', 3, 2101),
  CfSeed('C210200', 'Disposal of short-term FVTPL assets', 'C210000', 'actual', 3, 2102),
  CfSeed('C210300', 'Disposal of short-term FVOCI assets', 'C210000', 'actual', 3, 2103),
  CfSeed('C210400', 'Disposal of amortized cost financial assets', 'C210000', 'actual', 3, 2104),
  CfSeed('C210500', 'Disposal of tangible assets', 'C210000', 'actual', 3, 2105),
  CfSeed('C210600', 'Disposal of intangible assets', 'C210000', 'actual', 3, 2106),
  CfSeed('C210700', 'Disposal of investment property', 'C210000', 'actual', 3, 2107),
  CfSeed('C210800', 'Disposal of long-term financial instruments', 'C210000', 'actual', 3, 2108),
  CfSeed('C210900', 'Disposal of long-term FVTPL assets', 'C210000', 'actual', 3, 2109),
  CfSeed('C210950', 'Disposal of long-term FVOCI assets', 'C210000', 'actual', 3, 21095),
  CfSeed('C211000', 'Disposal of subsidiaries investment', 'C210000', 'actual', 3, 2110),
  CfSeed('C211050', 'Disposal of associates investment', 'C210000', 'actual', 3, 21105),
  CfSeed('C211100', 'Collection of long-term loans', 'C210000', 'actual', 3, 2111),
  CfSeed('C211200', 'Collection of deposits', 'C210000', 'actual', 3, 2112),
  CfSeed('C211210', 'Decrease in restricted cash', 'C210000', 'actual', 3, 21121),

  CfSeed('C220000', 'Cash outflows from investing activities', 'C200000', 'aggregate', 2, 220),
  CfSeed('C220100', 'Acquisition of short-term financial instruments', 'C220000', 'actual', 3, 2201),
  CfSeed('C220200', 'Acquisition of short-term FVTPL assets', 'C220000', 'actual', 3, 2202),
  CfSeed('C220300', 'Acquisition of short-term FVOCI assets', 'C220000', 'actual', 3, 2203),
  CfSeed('C220400', 'Acquisition of amortized cost financial assets', 'C220000', 'actual', 3, 2204),
  CfSeed('C220500', 'Acquisition of tangible assets', 'C220000', 'actual', 3, 2205),
  CfSeed('C220550', 'Acquisition of intangible assets', 'C220000', 'actual', 3, 22055),
  CfSeed('C220600', 'Acquisition of investment property', 'C220000', 'actual', 3, 2206),
  CfSeed('C220700', 'Acquisition of long-term financial instruments', 'C220000', 'actual', 3, 2207),
  CfSeed('C220800', 'Acquisition of long-term FVTPL assets', 'C220000', 'actual', 3, 2208),
  CfSeed('C220900', 'Acquisition of long-term FVOCI assets', 'C220000', 'actual', 3, 2209),
  CfSeed('C220950', 'Acquisition of amortized cost long-term assets', 'C220000', 'actual', 3, 22095),
  CfSeed('C221000', 'Acquisition of subsidiaries investment', 'C220000', 'actual', 3, 2210),
  CfSeed('C221050', 'Acquisition of associates investment', 'C220000', 'actual', 3, 22105),
  CfSeed('C221100', 'Long-term loans granted', 'C220000', 'actual', 3, 2211),
  CfSeed('C221110', 'Payment of deposits', 'C220000', 'actual', 3, 22111),
  CfSeed('C221200', 'Increase in restricted cash', 'C220000', 'actual', 3, 2212),

  // ===== C3: 재무활동 현금흐름 =====
  CfSeed('C300000', 'Cash flow from financial activities', null, 'aggregate', 1, 300),
  CfSeed('C310000', 'Cash inflows from financial activities', 'C300000', 'aggregate', 2, 310),
  CfSeed('C310100', 'Proceeds from short-term borrowings', 'C310000', 'actual', 3, 3101),
  CfSeed('C310200', 'Proceeds from long-term borrowings', 'C310000', 'actual', 3, 3102),
  CfSeed('C310300', 'Proceeds from issuance of bonds', 'C310000', 'actual', 3, 3103),
  CfSeed('C310400', 'Proceeds from issuance of shares', 'C310000', 'actual', 3, 3104),
  CfSeed('C310500', 'Increase in finance lease liabilities', 'C310000', 'actual', 3, 3105),
  CfSeed('C310600', 'Other inflows from financial activities', 'C310000', 'actual', 3, 3106),

  CfSeed('C320000', 'Cash outflows from financial activities', 'C300000', 'aggregate', 2, 320),
  CfSeed('C320100', 'Repayment of short-term borrowings', 'C320000', 'actual', 3, 3201),
  CfSeed('C320200', 'Repayment of long-term borrowings', 'C320000', 'actual', 3, 3202),
  CfSeed('C320300', 'Repayment of bonds', 'C320000', 'actual', 3, 3203),
  CfSeed('C320400', 'Payment of dividends', 'C320000', 'actual', 3, 3204),
  CfSeed('C320500', 'Acquisition of treasury shares', 'C320000', 'actual', 3, 3205),
  CfSeed('C320600', 'Decrease in finance lease liabilities', 'C320000', 'actual', 3, 3206),

  // ===== C4: 환율변동효과 =====
  CfSeed('C400000', 'Exchange gains(losses) on cash and cash equivalents', null, 'actual', 1, 400),

  // ===== C5: 현금 순변동 =====
  CfSeed('C500000', 'Net increase in cash and cash equivalents', null, 'aggregate', 1, 500),

  // ===== C6: 기초현금 =====
  CfSeed('C6000000', 'Cash at the beginning of the period', null, 'actual', 1, 600),

  // ===== C7: 기말현금 =====
  CfSeed('C7000000', 'Cash at the end of the period', null, 'actual', 1, 700),
];
