import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static var ip = "";

  //get
  static Future getWord() async {
    final get = Uri.parse("$ip/getword");
    final response = await http.get(get);
    return json.decode(response.body);
  }

  //post
  static Future check(int set) async {
    final cheakAnswer = Uri.parse('$ip/setanswer?answer=$set');
    final respose = await http.post(cheakAnswer);
  }

//get
  static Future getAllCategory() async {
    final allCategoryUrl = Uri.parse("$ip/getcategories");
    final response = await http.get(allCategoryUrl);
    return json.decode(response.body);
  }

//get
  static Future getTeams() async {
    final teams = Uri.parse("$ip/getteams");
    final response = await http.get(teams);
    return json.decode(response.body);
  }

//get
  static Future getLetters() async {
    final letter = Uri.parse("$ip/getletters");
    final response = await http.get(letter);
    return json.decode(response.body);
  }

//post
  static Future selectCategory(int index) async {
    final select = Uri.parse("$ip/selectcategory?id=$index");
    final response = await http.post(select);
  }

//post
  static Future textValue(int value) async {
    final select = Uri.parse("$ip/setfont?value=$value");
    final response = await http.post(select);
  }

  //post
  static Future nextRound() async {
    final next = Uri.parse("$ip/nextround");
    final response = await http.post(next);
  }

//post
  static Future spin() async {
    final spinner = Uri.parse("$ip/spin");
    final response = await http.post(spinner);
  }

  //post
  static Future sendLetter(String l) async {
    final letter = Uri.parse("$ip/selectletter?letter=$l");
    final response = await http.post(letter);
  }

  //post
  static Future sendTeamNum(int num) async {
    final number = Uri.parse("$ip/setteam?id=$num");
    final response = await http.post(number);
  }
}
