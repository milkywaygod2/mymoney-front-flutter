import 'package:flutter/material.dart';

import '../../../core/domain/Counterparty.dart';
import '../../../core/domain/CounterpartyAlias.dart';
import '../../../core/interfaces/ICounterpartyRepository.dart';
import '../../../core/models/TypedId.dart';

/// 거래처 관리 페이지 — 리스트/검색/상세/추가
/// 아직 BLoC가 없으므로 직접 Repository를 받아 단순 StatefulWidget으로 구현.
/// Wave 7 Counterparty BLoC 완성 후 BlocBuilder로 마이그레이션 예정.
class CounterpartyPage extends StatefulWidget {
  const CounterpartyPage({super.key, required this.repository});

  final ICounterpartyRepository repository;

  @override
  State<CounterpartyPage> createState() => _CounterpartyPageState();
}

class _CounterpartyPageState extends State<CounterpartyPage> {
  /// 현재 검색어
  String _strQuery = '';

  /// 전체 거래처 목록 (최초 로드 + 저장 후 갱신)
  List<Counterparty> _listAll = [];

  /// 실시간 검색 필터 결과
  List<Counterparty> get _listFiltered {
    if (_strQuery.isEmpty) return _listAll;
    final strLower = _strQuery.toLowerCase();
    return _listAll.where((c) {
      // 이름/별칭/식별번호 모두 검색
      if (c.name.toLowerCase().contains(strLower)) return true;
      if (c.identifier?.toLowerCase().contains(strLower) == true) return true;
      return c.listAliases.any((a) => a.alias.toLowerCase().contains(strLower));
    }).toList();
  }

  bool _isLoading = false;
  String? _strError;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoading = true;
      _strError = null;
    });
    try {
      // 빈 쿼리로 전체 검색
      final listResult = await widget.repository.search('');
      setState(() {
        _listAll = listResult;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _strError = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('거래처 관리'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SearchBar(
            onChanged: (strValue) => setState(() => _strQuery = strValue),
          ),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        tooltip: '거래처 추가',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_strError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_strError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            TextButton(onPressed: _loadAll, child: const Text('다시 시도')),
          ],
        ),
      );
    }
    if (_listFiltered.isEmpty) {
      return Center(
        child: Text(
          _strQuery.isEmpty ? '등록된 거래처가 없습니다' : '"$_strQuery" 검색 결과 없음',
        ),
      );
    }
    return ListView.separated(
      itemCount: _listFiltered.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final counterparty = _listFiltered[index];
        return _CounterpartyTile(
          counterparty: counterparty,
          onTap: () => _showDetailSheet(context, counterparty),
        );
      },
    );
  }

  /// 거래처 상세 BottomSheet 표시
  void _showDetailSheet(BuildContext context, Counterparty counterparty) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _CounterpartyDetailSheet(
        counterparty: counterparty,
        repository: widget.repository,
        onChanged: _loadAll, // 수정 후 목록 갱신
      ),
    );
  }

  /// 거래처 추가 BottomSheet 표시
  void _showAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _CounterpartyAddSheet(
        repository: widget.repository,
        onSaved: _loadAll, // 저장 후 목록 갱신
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 검색 바
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: '이름, 별칭, 사업자번호 검색',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 거래처 리스트 타일
// ---------------------------------------------------------------------------

class _CounterpartyTile extends StatelessWidget {
  const _CounterpartyTile({required this.counterparty, this.onTap});

  final Counterparty counterparty;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: _TypeIcon(counterpartyType: counterparty.counterpartyType),
      title: Text(counterparty.name),
      subtitle: counterparty.identifier != null
          ? Text(
              '${_labelIdentifierType(counterparty.identifierType)}: ${counterparty.identifier}',
              style: const TextStyle(fontSize: 12),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ConfidenceBadge(level: counterparty.confidenceLevel),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  String _labelIdentifierType(IdentifierType type) => switch (type) {
        IdentifierType.business => '사업자',
        IdentifierType.personal => '주민',
        IdentifierType.none => '',
      };
}

/// 거래처 유형 아이콘
class _TypeIcon extends StatelessWidget {
  const _TypeIcon({this.counterpartyType});

  final String? counterpartyType;

  @override
  Widget build(BuildContext context) {
    final IconData iconData = switch (counterpartyType?.toUpperCase()) {
      'CORPORATE' => Icons.business,
      'INDIVIDUAL' => Icons.person,
      'GOVERNMENT' => Icons.account_balance,
      _ => Icons.store,
    };
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(iconData, size: 20,
          color: Theme.of(context).colorScheme.onPrimaryContainer),
    );
  }
}

/// 신뢰도 뱃지
class _ConfidenceBadge extends StatelessWidget {
  const _ConfidenceBadge({required this.level});

  final ConfidenceLevel level;

  @override
  Widget build(BuildContext context) {
    final (Color color, String label) = switch (level) {
      ConfidenceLevel.verified => (Colors.green, '인증'),
      ConfidenceLevel.high => (Colors.blue, '높음'),
      ConfidenceLevel.medium => (Colors.orange, '보통'),
      ConfidenceLevel.low => (Colors.red, '낮음'),
      ConfidenceLevel.unknown => (Colors.grey, '미상'),
    };
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 거래처 상세 BottomSheet
// ---------------------------------------------------------------------------

class _CounterpartyDetailSheet extends StatefulWidget {
  const _CounterpartyDetailSheet({
    required this.counterparty,
    required this.repository,
    required this.onChanged,
  });

  final Counterparty counterparty;
  final ICounterpartyRepository repository;
  /// 저장/삭제 후 상위 목록 갱신 콜백
  final VoidCallback onChanged;

  @override
  State<_CounterpartyDetailSheet> createState() =>
      _CounterpartyDetailSheetState();
}

class _CounterpartyDetailSheetState extends State<_CounterpartyDetailSheet> {
  late Counterparty _counterparty;
  final TextEditingController _ctrlAlias = TextEditingController();
  bool _isSaving = false;
  String? _strAliasError;

  @override
  void initState() {
    super.initState();
    _counterparty = widget.counterparty;
  }

  @override
  void dispose() {
    _ctrlAlias.dispose();
    super.dispose();
  }

  /// 별칭 추가 — INV-C3 유일성 검증 후 저장
  Future<void> _addAlias() async {
    final strAlias = _ctrlAlias.text.trim();
    if (strAlias.isEmpty) return;

    // 유일성 검증
    final isUnique = await widget.repository.isAliasUnique(strAlias);
    if (!isUnique) {
      setState(() => _strAliasError = '이미 다른 거래처에 등록된 별칭입니다 (INV-C3)');
      return;
    }

    setState(() {
      _isSaving = true;
      _strAliasError = null;
    });
    try {
      // 새 alias를 추가한 복사본 생성
      final listUpdated = [
        ..._counterparty.listAliases,
        CounterpartyAlias(
          id: 0, // DB 자동 채번 — 저장 후 실제 ID로 갱신됨
          counterpartyId: _counterparty.id,
          alias: strAlias,
        ),
      ];
      final updated = Counterparty.create(
        id: _counterparty.id,
        name: _counterparty.name,
        identifier: _counterparty.identifier,
        identifierType: _counterparty.identifierType,
        phone: _counterparty.phone,
        address: _counterparty.address,
        confidenceLevel: _counterparty.confidenceLevel,
        isRelatedParty: _counterparty.isRelatedParty,
        counterpartyType: _counterparty.counterpartyType,
        countryCode: _counterparty.countryCode,
        listAliases: listUpdated,
      );
      await widget.repository.save(updated);
      setState(() {
        _counterparty = updated;
        _isSaving = false;
      });
      _ctrlAlias.clear();
      widget.onChanged();
    } catch (e) {
      setState(() {
        _strAliasError = e.toString();
        _isSaving = false;
      });
    }
  }

  /// 별칭 삭제
  Future<void> _removeAlias(CounterpartyAlias alias) async {
    setState(() => _isSaving = true);
    try {
      final listUpdated = _counterparty.listAliases
          .where((a) => a.id != alias.id)
          .toList();
      final updated = Counterparty.create(
        id: _counterparty.id,
        name: _counterparty.name,
        identifier: _counterparty.identifier,
        identifierType: _counterparty.identifierType,
        phone: _counterparty.phone,
        address: _counterparty.address,
        confidenceLevel: _counterparty.confidenceLevel,
        isRelatedParty: _counterparty.isRelatedParty,
        counterpartyType: _counterparty.counterpartyType,
        countryCode: _counterparty.countryCode,
        listAliases: listUpdated,
      );
      await widget.repository.save(updated);
      setState(() {
        _counterparty = updated;
        _isSaving = false;
      });
      widget.onChanged();
    } catch (e) {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // 드래그 핸들
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                // 헤더
                Row(
                  children: [
                    _TypeIcon(counterpartyType: _counterparty.counterpartyType),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_counterparty.name,
                              style: Theme.of(context).textTheme.titleLarge),
                          _ConfidenceBadge(level: _counterparty.confidenceLevel),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),

                // 기본 정보 섹션
                _SectionTitle(title: '기본 정보'),
                _InfoRow(label: '유형', value: _counterparty.counterpartyType ?? '-'),
                _InfoRow(
                  label: _counterparty.identifierType == IdentifierType.business
                      ? '사업자번호'
                      : _counterparty.identifierType == IdentifierType.personal
                          ? '주민번호'
                          : '식별번호',
                  value: _counterparty.identifier ?? '-',
                ),
                _InfoRow(label: '연락처', value: _counterparty.phone ?? '-'),
                _InfoRow(label: '주소', value: _counterparty.address ?? '-'),
                _InfoRow(
                  label: '특수관계자',
                  value: _counterparty.isRelatedParty == true
                      ? '해당'
                      : _counterparty.isRelatedParty == false
                          ? '해당 없음'
                          : '미확인',
                ),
                const SizedBox(height: 12),
                const Divider(),

                // 별칭 섹션
                _SectionTitle(title: 'OCR 별칭 목록'),
                if (_counterparty.listAliases.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('등록된 별칭 없음', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ..._counterparty.listAliases.map(
                    (alias) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.label_outline, size: 18),
                      title: Text(alias.alias),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        tooltip: '별칭 삭제',
                        onPressed: _isSaving ? null : () => _removeAlias(alias),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),

                // 별칭 추가 입력란
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrlAlias,
                        decoration: InputDecoration(
                          hintText: '새 별칭 입력 (예: 스타벅스강남점)',
                          errorText: _strAliasError,
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addAlias(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _isSaving ? null : _addAlias,
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('추가'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 거래처 추가 BottomSheet
// ---------------------------------------------------------------------------

class _CounterpartyAddSheet extends StatefulWidget {
  const _CounterpartyAddSheet({
    required this.repository,
    required this.onSaved,
  });

  final ICounterpartyRepository repository;
  final VoidCallback onSaved;

  @override
  State<_CounterpartyAddSheet> createState() => _CounterpartyAddSheetState();
}

class _CounterpartyAddSheetState extends State<_CounterpartyAddSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ctrlName = TextEditingController();
  final TextEditingController _ctrlIdentifier = TextEditingController();
  final TextEditingController _ctrlPhone = TextEditingController();
  final TextEditingController _ctrlAddress = TextEditingController();

  IdentifierType _identifierType = IdentifierType.none;
  String? _strCounterpartyType;
  bool _isSaving = false;
  String? _strError;

  @override
  void dispose() {
    _ctrlName.dispose();
    _ctrlIdentifier.dispose();
    _ctrlPhone.dispose();
    _ctrlAddress.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _strError = null;
    });
    try {
      final counterparty = Counterparty.create(
        // ID는 DB 자동 채번 — save() 후 실제 ID로 갱신됨
        id: const CounterpartyId(0),
        name: _ctrlName.text.trim(),
        identifier: _ctrlIdentifier.text.trim().isEmpty
            ? null
            : _ctrlIdentifier.text.trim(),
        identifierType: _identifierType,
        phone: _ctrlPhone.text.trim().isEmpty ? null : _ctrlPhone.text.trim(),
        address:
            _ctrlAddress.text.trim().isEmpty ? null : _ctrlAddress.text.trim(),
        counterpartyType: _strCounterpartyType,
      );
      await widget.repository.save(counterparty);
      if (mounted) Navigator.of(context).pop();
      widget.onSaved();
    } catch (e) {
      setState(() {
        _strError = e.toString();
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 키보드가 올라올 때 시트가 밀려 올라가도록 padding 적용
    final double bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 시트 핸들
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('거래처 추가', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // 거래처명 (필수)
            TextFormField(
              controller: _ctrlName,
              decoration: const InputDecoration(
                labelText: '거래처명 *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '거래처명은 필수입니다' : null,
            ),
            const SizedBox(height: 12),

            // 유형 선택
            DropdownButtonFormField<String>(
              initialValue: _strCounterpartyType,
              decoration: const InputDecoration(
                labelText: '거래처 유형',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('선택 안 함')),
                DropdownMenuItem(value: 'CORPORATE', child: Text('법인')),
                DropdownMenuItem(value: 'INDIVIDUAL', child: Text('개인')),
                DropdownMenuItem(value: 'GOVERNMENT', child: Text('정부기관')),
              ],
              onChanged: (v) => setState(() => _strCounterpartyType = v),
            ),
            const SizedBox(height: 12),

            // 식별번호 유형 + 번호
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<IdentifierType>(
                    initialValue: _identifierType,
                    decoration: const InputDecoration(
                      labelText: '번호 유형',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: IdentifierType.none, child: Text('없음')),
                      DropdownMenuItem(
                          value: IdentifierType.business, child: Text('사업자')),
                      DropdownMenuItem(
                          value: IdentifierType.personal, child: Text('주민')),
                    ],
                    onChanged: (v) =>
                        setState(() => _identifierType = v ?? IdentifierType.none),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _ctrlIdentifier,
                    decoration: const InputDecoration(
                      labelText: '식별번호',
                      border: OutlineInputBorder(),
                    ),
                    // 번호 유형이 none이 아닌데 번호가 없으면 유효성 오류
                    validator: (v) {
                      if (_identifierType != IdentifierType.none &&
                          (v == null || v.trim().isEmpty)) {
                        return '번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 연락처
            TextFormField(
              controller: _ctrlPhone,
              decoration: const InputDecoration(
                labelText: '연락처',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            // 주소
            TextFormField(
              controller: _ctrlAddress,
              decoration: const InputDecoration(
                labelText: '주소',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 4),

            // 에러 메시지
            if (_strError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _strError!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
            const SizedBox(height: 12),

            // 저장 버튼
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 공통 헬퍼 위젯
// ---------------------------------------------------------------------------

/// 섹션 제목
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

/// key-value 정보 행
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
