import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:designli/components/exceptions/server_exceptions.dart';
import 'package:designli/components/failure/failure.dart';
import 'package:designli/components/network/end_points.dart';
import 'package:designli/components/network/network_client.dart';
import 'package:designli/modules/selection_stock/data/models/symbol_look_up.dart';
import 'package:designli/modules/selection_stock/data/models/symbol_lookup_request.dart';
import 'package:designli/modules/selection_stock/data/repository/stock_selection_repository.dart';

class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl({
    required networkClient,
    required endPoints,
  })  : _networkClient = networkClient,
        _endpoints = endPoints;

  final NetworkClient _networkClient;
  final Endpoints _endpoints;

  @override
  Future<Either<Failure, List<SymbolLookUp>>> searchSymbol(
      {required String symbol}) async {
    final request = SymbolLookUpRequest(
        url: _endpoints.symbolLookApi,
        symbol: symbol,
        token: _endpoints.tokenFinhub);

    try {
      final response = await _networkClient.get(Uri.parse(request.url));
      if (response.statusCode < HttpStatus.ok ||
          response.statusCode >= HttpStatus.badRequest) {
        throw ServerException(
          message: "Ocurrio un problema al traer los datos",
        );
      }

      final jsonBody = json.decode(response.body);

      final symbolsList = (jsonBody['result'] as List)
          .map((data) => SymbolLookUp.fromJson(data))
          .toList();

      return Right(symbolsList);
    } catch (e) {
      return Left(
        Failure(
          description: 'Unknown error , $e',
        ),
      );
    }
  }
}
