class DelegaciaModel {
  final int id;
  final String name;
  final String path;
  final String region;
  String? contact;
  String? address;

  DelegaciaModel(
      {required this.id,
      required this.name,
      required this.path,
      required this.region,
      this.address,
      this.contact});

  factory DelegaciaModel.fromJson(Map<String, dynamic> json) => DelegaciaModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      region: json['region'],
      address: json['address'],
      contact: json['contact']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'name': name,
        'region': region,
        'address': address,
        'contact': contact
      };
}
