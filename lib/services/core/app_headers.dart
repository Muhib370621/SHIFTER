class AppHeaders {
  static getOnlyBearerHeaders(String accessToken) {
    Map<String, String>? authorizationHeader = {
      'Authorization': 'Bearer $accessToken',
    };

    print('Bearer $accessToken');
    return authorizationHeader;
  }

  static contentTypeWIthApplicationJsonOnly() {
    Map<String, String>? authorizationHeader = {
      "accept":"*/*",
      'Content-Type': 'application/json'
    };

    return authorizationHeader;
  }

  static contentTypeWIthFormData() {
    Map<String, String>? authorizationHeader = {
      'Content-Type': 'multipart/form-data',
    };

    return authorizationHeader;
  }

  static getHeadersWithBearerAndContentType(String accessToken) {
    Map<String, String>? authorizationHeader = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    return authorizationHeader;
  }
}