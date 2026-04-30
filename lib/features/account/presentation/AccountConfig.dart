import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/Enums.dart';
import 'AccountBloc.dart';
import 'AccountState.dart';
import 'widgets/MetaphorPicker.dart';

/// 설정 모드 — 사용자 메타포 등록 UI
class AccountConfig extends StatefulWidget {
  const AccountConfig({super.key});

  @override
  State<AccountConfig> createState() => _AccountConfigState();
}

class _AccountConfigState extends State<AccountConfig> {
  AccountNature? _selectedNature;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '계정과목 메타포 설정',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'K-IFRS 계정 분류를 직관적인 이미지로 이해하세요',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              MetaphorPicker(
                selectedNature: _selectedNature,
                onSelected: (nature) =>
                    setState(() => _selectedNature = nature),
              ),
              const SizedBox(height: 24),
              if (_selectedNature != null) _SelectedNatureDetail(nature: _selectedNature!),
            ],
          ),
        );
      },
    );
  }
}

class _SelectedNatureDetail extends StatelessWidget {
  const _SelectedNatureDetail({required this.nature});
  final AccountNature nature;

  static const _kNatureInfo = {
    AccountNature.asset: (
      emoji: '🌳',
      title: '자산 — 나무',
      desc: '나무처럼 자라고 열매(수익)를 맺는 것. 현금, 예금, 부동산, 주식 등 내가 소유한 모든 것.',
    ),
    AccountNature.liability: (
      emoji: '🫙',
      title: '부채 — 항아리',
      desc: '항아리를 채운 빚. 언젠가는 비워야(갚아야) 하는 것. 대출, 카드값, 미지급금 등.',
    ),
    AccountNature.equity: (
      emoji: '🪣',
      title: '자본 — 양동이',
      desc: '나에게 남은 것(자산 - 부채). 저축, 투자 원금 등 순수 내 몫.',
    ),
    AccountNature.revenue: (
      emoji: '💧',
      title: '수익 — 물',
      desc: '흘러 들어오는 물. 급여, 이자, 배당 등 일정 기간 발생한 경제적 효익.',
    ),
    AccountNature.expense: (
      emoji: '🍎',
      title: '비용 — 사과',
      desc: '소비한 자원. 식비, 교통비, 통신비 등 일정 기간 지출한 자원.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final info = _kNatureInfo[nature];
    if (info == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(info.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Text(
                  info.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              info.desc,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
