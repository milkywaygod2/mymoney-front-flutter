import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AccountBloc.dart';
import 'AccountState.dart';
import 'widgets/ClusterMap.dart';

/// 지도 모드 — 5클러스터 시각화
class AccountMap extends StatelessWidget {
  const AccountMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.listAll.isEmpty) {
          return const Center(child: Text('계정과목이 없습니다'));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '계정과목 지도',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '버블을 탭하면 해당 분류 계정 목록, 핀치로 확대/축소합니다',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: ClusterMap(listAccounts: state.listAll),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
