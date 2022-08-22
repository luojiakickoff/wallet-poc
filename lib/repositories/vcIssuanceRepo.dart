import 'package:http/http.dart' as http;

class VCIssuanceRepository {
  VCIssuanceRepository({required this.url, required this.client});

  final Uri url;
  final http.Client client;

  Future<http.Response> getVCIssuanceResponse() async {
    var response = await http.post(url);
    print("result: $response");
    return response;
  }
}