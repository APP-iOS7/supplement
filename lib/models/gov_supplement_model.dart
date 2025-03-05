
class GovSupplementModel {
  final String entpName;
  final String itemName;
  final String itemSeq;
  final String? efcyQesitm;
  final String? useMethodQesitm;
  final String? atpnWarnQesitm;
  final String? atpnQesitm;
  final String? intrcQesitm;
  final String? seQesitm;
  final String? depositMethodQesitm;
  final String? openDe;
  final String? updateDe;
  final String? itemImage;
  final String? bizrno;

  GovSupplementModel({
    required this.entpName,
    required this.itemName,
    required this.itemSeq,
    this.efcyQesitm,
    this.useMethodQesitm,
    this.atpnWarnQesitm,
    this.atpnQesitm,
    this.intrcQesitm,
    this.seQesitm,
    this.depositMethodQesitm,
    this.openDe,
    this.updateDe,
    this.itemImage,
    this.bizrno,
  });

  factory GovSupplementModel.fromJson(Map<String, dynamic> json) {
    return GovSupplementModel(
      entpName: json["entpName"] ?? "",
      itemName: json["itemName"] ?? "",
      itemSeq: json["itemSeq"] ?? "",
      efcyQesitm: json["efcyQesitm"],
      useMethodQesitm: json["useMethodQesitm"],
      atpnWarnQesitm: json["atpnWarnQesitm"],
      atpnQesitm: json["atpnQesitm"],
      intrcQesitm: json["intrcQesitm"],
      seQesitm: json["seQesitm"],
      depositMethodQesitm: json["depositMethodQesitm"],
      openDe: json["openDe"],
      updateDe: json["updateDe"],
      itemImage: json["itemImage"],
      bizrno: json["bizrno"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "entpName": entpName,
      "itemName": itemName,
      "itemSeq": itemSeq,
      "efcyQesitm": efcyQesitm,
      "useMethodQesitm": useMethodQesitm,
      "atpnWarnQesitm": atpnWarnQesitm,
      "atpnQesitm": atpnQesitm,
      "intrcQesitm": intrcQesitm,
      "seQesitm": seQesitm,
      "depositMethodQesitm": depositMethodQesitm,
      "openDe": openDe,
      "updateDe": updateDe,
      "itemImage": itemImage,
      "bizrno": bizrno,
    };
  }
}
