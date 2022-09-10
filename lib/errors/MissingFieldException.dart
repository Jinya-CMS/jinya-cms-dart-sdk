class MissingFieldsException implements Exception {
  List<String> missingFields;

  MissingFieldsException(this.missingFields);
}
