class WalletResponseModel {
  int? status;
  String? statusText;
  String? message;
  Data? data;

  WalletResponseModel({
    this.status,
    this.statusText,
    this.message,
    this.data,
  });

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) =>
      WalletResponseModel(
        status: json["status"],
        statusText: json["statusText"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statusText": statusText,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? balance;
  String? totalCoinsEarned;
  String? totalCoinsUsed;
  List<Transaction>? transactions;

  Data({
    this.id,
    this.balance,
    this.totalCoinsEarned,
    this.totalCoinsUsed,
    this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        balance: json["balance"],
        totalCoinsEarned: json["totalCoinsEarned"],
        totalCoinsUsed: json["totalCoinsUsed"],
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "totalCoinsEarned": totalCoinsEarned,
        "totalCoinsUsed": totalCoinsUsed,
        "transactions": transactions == null
            ? []
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Transaction {
  String? id;
  String? amount;
  String? type;
  String? source;
  String? status;

  Transaction({
    this.id,
    this.amount,
    this.type,
    this.source,
    this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        amount: json["amount"],
        type: json["type"]!,
        source: json["source"]!,
        status: json["status"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "type": type,
        "source": source,
        "status": status,
      };
}
