class Validador {
  // Validar número de CPF
  static bool cpfIsValid(String? cpf) {
    if (cpf == null || cpf == '') return false;

    // Obter somente os números do CPF
    var numeros = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Testar se o CPF possui 11 dígitos
    if (numeros.length != 11) return false;

    // Testar se todos os dígitos do CPF são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numeros)) return false;

    // Dividir dígitos
    List<int> digitos =
        numeros.split('').map((String d) => int.parse(d)).toList();

    // Calcular o primeiro dígito verificador
    var calcDv1 = 0;
    for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
      calcDv1 += digitos[10 - i] * i;
    }
    calcDv1 %= 11;
    var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

    // Testar o primeiro dígito verificado
    if (digitos[9] != dv1) return false;

    // Calcular o segundo dígito verificador
    var calcDv2 = 0;
    for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
      calcDv2 += digitos[11 - i] * i;
    }
    calcDv2 %= 11;
    var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

    // Testar o segundo dígito verificador
    if (digitos[10] != dv2) return false;

    return true;
  }

  static bool dataNascimentoIsValid({String? dtNascimento}) {
    if (dtNascimento!.length < 10) {
      return (false);
    }

    final dtSplitada = dtNascimento.split('/');

    if (dtSplitada.length == 3) {
      final dia = int.tryParse(dtSplitada[0]);
      final mes = int.tryParse(dtSplitada[1]);
      final ano = int.tryParse(dtSplitada[2]);

      if (ano! >= DateTime.now().year || ano < DateTime.now().year - 100) {
        return false;
      }

      final date = DateTime(ano, mes!, dia!);
      if (date.year == ano && date.month == mes && date.day == dia) {
        return true;
      }
    }
    return false;
  }
}
