import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../features/account/presentation/AccountBloc.dart';
import '../features/entry/presentation/EntryBloc.dart';
import '../features/journal/presentation/JournalBloc.dart';
import '../features/ocr/presentation/OcrBloc.dart';
import '../features/perspective/presentation/PerspectiveBloc.dart';
import '../features/report/presentation/ReportBloc.dart';
import '../features/tax/presentation/TaxBloc.dart';
import 'router/AppRouter.dart';
import 'theme/AppTheme.dart';

/// MyMoney 앱 루트 위젯
class MyMoneyApp extends StatelessWidget {
  const MyMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<JournalBloc>()),
        BlocProvider.value(value: getIt<AccountBloc>()),
        BlocProvider.value(value: getIt<EntryBloc>()),
        BlocProvider.value(value: getIt<PerspectiveBloc>()),
        BlocProvider.value(value: getIt<TaxBloc>()),
        BlocProvider.value(value: getIt<ReportBloc>()),
        BlocProvider.value(value: getIt<OcrBloc>()),
      ],
      child: MaterialApp.router(
        title: 'MyMoney',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
