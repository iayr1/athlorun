import 'package:dartz/dartz.dart';
import 'package:athlorun/core/status/failures.dart';
import 'package:athlorun/features/home/data/models/response/wallet_response_model.dart';
import 'package:athlorun/features/home/domain/repository/home_repository.dart';

class GetWalletUsecase {
  final HomeRepository _homeRepository;
  const GetWalletUsecase(this._homeRepository);
  Future<Either<Failure, WalletResponseModel>> call(
      String id, String walletId) async {
    return _homeRepository.getUserWallet(id, walletId);
  }
}
