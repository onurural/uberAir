import 'dart:convert';

import 'package:uberAir/models/airport.dart';
import 'package:http/http.dart' as http;
import 'package:uberAir/models/flight.dart';

class AirportApiClient {
  static const _api_key = "ea187fa0a8msh9348745ba0d3c5fp1bbfe7jsn9f65d92822b9";
  static const String _baseUrl =
      "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com";
  Map<String, String> _rapidAPIheaders = {
    "x-rapidapi-key": _api_key,
    "x-rapidapi-host": _baseUrl,
    "content-type": "application/json",
  };
  Map<String, String> _skyscannerHeaders = {
    "content-type": "application/json",
    "Connection": "keep-alive",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept": "*/*",
    "Host": "<calculated when request is sent>",
  };
  Future<Flights> getDestinationID() async {
    
    final response = await http.get(
        "http://partners.api.skyscanner.net/apiservices/browseroutes/v1.0/FR/eur/en-US/us/anywhere/anytime/anytime?apikey=prtl6749387986743898559646983194",
        headers: _skyscannerHeaders);
    if (response.statusCode == 200) {
       return Flights.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Status code: ${response.statusCode}");
    }
  }

  //
  Future<Flights> fetchFlights(String inboundCity, String outboundCity,
      String outboundDate, String inboundDate) async {
    final response = await http.get(
        "http://partners.api.skyscanner.net/apiservices/browsedates/v1.0/TR/TRY/tur/$inboundCity/$outboundCity/$inboundDate/$outboundDate?apikey=prtl6749387986743898559646983194",
        headers: _skyscannerHeaders);
    if (response.statusCode != 404) {
      print("Status Code : ${response.statusCode}");
      print("${response.body}");
      return Flights.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch flight ${response.statusCode}");
    }
  }

  Future<Airport> fetchAirport(String city) async {
    final response = await http.get(
        "https://rapidapi.p.rapidapi.com/apiservices/autosuggest/v1.0/TR/TRY/tur/?query=$city",
        headers: _rapidAPIheaders);
    if (response.statusCode == 200) {
      // debugPrint(response.body.toString());
      // return parseJson(response.body);

      return Airport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch airports");
    }
  }
}