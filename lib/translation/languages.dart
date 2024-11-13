// Language model to handle language name and symbol
class LanguageModel {
  LanguageModel(this.language, this.symbol);

  final String language;
  final String symbol;
}

// Example of language list with English and Arabic options
final List<LanguageModel> languages = [
  LanguageModel("English", "en"),
  LanguageModel("Arabic", "ar"),
];