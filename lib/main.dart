import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:designli/modules/main_page/presentation/main_page.dart';
import 'package:designli/modules/selection_stock/data/repository/stock_selection_repository.impl.dart';
import 'package:designli/modules/selection_stock/presentation/selection_stock_view_model.dart';
import 'package:designli/modules/splash_screen/splash.dart';
import 'package:designli/modules/watching_list/presentation/watch_list_viewmodel.dart';
import 'package:designli/services/authentication/auth0_authentication.dart';
import 'package:designli/services/network/end_points.dart';
import 'package:designli/services/network/network_client.dart';
import 'package:designli/services/sockets/finnhub_web_socket_service.impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'modules/main_page/presentation/login_auth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ValueNotifier<bool> _loadComponentsNotifier;
  late final Endpoints _endpoints;

  @override
  void initState() {
    super.initState();
    _loadComponentsNotifier = ValueNotifier(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComponents();
    });
  }

  Future<void> _loadComponents() async {
    await _loadJsonEndpoints();
    _loadComponentsNotifier.value = true;
  }

  Future<void> _loadJsonEndpoints() async {
    final String response =
        await rootBundle.loadString('assets/endpoints/endpoints.json');
    final Map<String, dynamic> data = jsonDecode(response);
    _endpoints = Endpoints.fromMap(data);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _loadComponentsNotifier,
        builder: (_, alreadyComponentsLoaded, Widget? w) {
          if (alreadyComponentsLoaded == false) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const SplashScreenPage(),
            );
          }
          final selectionViewModel = SelectionStockViewModel(
            stockRepository: StockRepositoryImpl(
                networkClient: NetworkClient(), endPoints: _endpoints),
          );
          final watchListViewModel = WatchListViewModel(
              finnhubWebSocketService:
                  FinnhubWebSocketServiceImpl(endpoints: _endpoints));
          selectionViewModel.initViewModel();
          watchListViewModel.initViewModel();

          Auth0 auth0 = Auth0(
            _endpoints.domainUrl,
            _endpoints.clientIdAuth0,
          );

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<Auth0AuthenticaionViewModel>(
                create: (_) => Auth0AuthenticaionViewModel(
                  auth0: auth0,
                ),
              ),
              ChangeNotifierProvider<SelectionStockViewModel>(
                create: (_) => selectionViewModel,
              ),
              ChangeNotifierProvider<WatchListViewModel>(
                create: (_) => watchListViewModel,
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const LoginAuth0Page(),
            ),
          );
        });
  }
}
