class ScannedProduct {
  final int id;
  final String barcode;
  final String productName;
  final String scanDate;
  final String imgURL;

  ScannedProduct({
    required this.id,
    required this.barcode,
    required this.productName,
    required this.scanDate,
    required this.imgURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'product_name': productName,
      'scan_date': scanDate,
      'img_url': imgURL,
    };
  }
}
