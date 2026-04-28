class WalletResponseModel {
  final String? walletId;
  final int balance;

  const WalletResponseModel({
    this.walletId,
    required this.balance,
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletResponseModel(
      walletId: json['wallet_id']?.toString(),
      balance: (json['balance'] as num?)?.toInt() ?? 0,
    );
  }
}
