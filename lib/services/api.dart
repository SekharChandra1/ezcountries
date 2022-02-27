import 'package:graphql_flutter/graphql_flutter.dart';

class Api {
  final HttpLink httpLink = HttpLink(
    'https://countries.trevorblades.com/graphql',
  );

  final AuthLink authLink = AuthLink(
    getToken: () => "",
  );
  

  late Link link = authLink.concat(httpLink);
  late GraphQLClient client = GraphQLClient(link: link, cache: GraphQLCache());
}