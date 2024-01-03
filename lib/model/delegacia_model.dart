class DelegaciaModel {
  final int id;
  final String name;
  final String path;
  final String region;

  DelegaciaModel(
      {required this.id,
      required this.name,
      required this.path,
      required this.region});

  factory DelegaciaModel.fromJson(Map<String, dynamic> json) => DelegaciaModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      region: json['region']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'path': path, 'name': name, 'region': region};
}
