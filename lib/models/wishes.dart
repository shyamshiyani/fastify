class Festival {
  String Festivals;

  Festival({
    required this.Festivals,
  });

  factory Festival.fromMap({required var data}) {
    return Festival(Festivals: data['festivals'] as String);
  }
}
