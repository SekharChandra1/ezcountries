
class QueryString {
  
  String countryList() {
    return """
      query {
        countries {
          name
          languages {
            code
            name
          }
        }
      }
    """;
  }

  String languageList() {
    return """
      query Query {
        languages {
          name
          code
        }
      }
    """;
  }

  String countryByCode({String? code}) {
    return """
      query Query {
        country(code: "$code") {
        name
        }
      }
    """;
  }
}