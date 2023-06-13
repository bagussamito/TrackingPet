import 'dart:convert';

BarangModel barangModelFromJson(String str) =>
    BarangModel.fromJson(json.decode(str));

String barangModelToJson(BarangModel data) => json.encode(data.toJson());

class BarangModel {
  String namaBarang;
  String hargaBarang;
  String fotoBarang;

  BarangModel({
    required this.namaBarang,
    required this.hargaBarang,
    required this.fotoBarang,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) => BarangModel(
        namaBarang: json["nama_barang"] ?? "",
        hargaBarang: json["harga_barang"] ?? "",
        fotoBarang: json["foto_barang"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "nama_barang": namaBarang,
        "harga_barang": hargaBarang,
        "foto_barang": fotoBarang,
      };
}
