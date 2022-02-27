import 'dart:async';
import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

import 'package:countries/services/api.dart';
import 'package:countries/services/query_string.dart';


class Service {
  QueryString queryString = QueryString();
  Api api = Api();

  Future getAllCountries() async {
    final String query = queryString.countryList();
    final QueryResult result = await api.client.query(
      QueryOptions(
        document: gql(query),
      ),
    );

    return json.encode(result.data);
  }

  Future getAllLanguages() async {
    final String query = queryString.languageList();
    final QueryResult result = await api.client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    
    return json.encode(result.data?['languages']);
  }

  Future getCountryByCode(context, {String? code}) async {
    final String query = queryString.countryByCode(code:code);
    final QueryResult result = await api.client.query(
      QueryOptions(
        document: gql(query),
      ),
    );
    
    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Country code doesn't exists"),
        backgroundColor: Colors.red,
      ));
      return null;
    }
    
    return json.encode(result.data);
  }
}