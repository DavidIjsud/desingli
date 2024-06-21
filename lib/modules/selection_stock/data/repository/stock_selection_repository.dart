import 'package:dartz/dartz.dart';
import 'package:designli/modules/selection_stock/data/models/symbol_look_up.dart';

import '../../../../components/failure/failure.dart';

abstract class StockRepository {
  Future<Either<Failure, List<SymbolLookUp>>> searchSymbol(
      {required String symbol});
}
