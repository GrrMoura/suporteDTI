class UsuarioModel {
  final int id;
  final String nome;
  final String foto;
  final String funcao;
  final String matricula;

  UsuarioModel(
      {required this.id,
      required this.nome,
      required this.foto,
      required this.funcao,
      required this.matricula});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      foto: json['foto'],
      funcao: json['funcao'],
      matricula: json['matricula']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'foto': foto,
        'nome': nome,
        'funcao': funcao,
        "matricula": matricula
      };
}
