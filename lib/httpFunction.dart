import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'class.dart';
import 'setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

Future getJWT() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString('accessToken')!;
}

Future<String> authenticationUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  if (prefs.getInt('refreshTokenExpiresIn') == null) {
    return 'fail';
  } else {
    DateTime refreshTokenExpiresIn = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('refreshTokenExpiresIn')!);
    if (refreshTokenExpiresIn.isAfter(now)) {
      try {
        var httpPostReissue = await postReissue(
            prefs.getString('grantType'), prefs.getString('accessToken'), prefs.getInt('accessTokenExpiresIn'), prefs.getString('refreshToken'));

        prefs.setString('grantType', jsonDecode(httpPostReissue)['grantType']);
        prefs.setString('accessToken', jsonDecode(httpPostReissue)['accessToken']);
        prefs.setInt('accessTokenExpiresIn', jsonDecode(httpPostReissue)['accessTokenExpiresIn']);
        prefs.setString('refreshToken', jsonDecode(httpPostReissue)['refreshToken']);
        prefs.setInt('refreshTokenExpiresIn', jsonDecode(httpPostReissue)['refreshTokenExpiresIn']);

        return 'success';
      } catch (e) {
        print(e);
        return 'fail';
      }
    } else {
      return 'fail';
    }
  }
}
//GET METHOD

Future<List<Day>> getCalendar() async {
  String jwt = await getJWT();
  DateTime now = DateTime.now();
  String nowString = '${now.year}-${now.month}-${now.day}';
  http.Response response = await http.get(
    Uri.parse(serverIP + 'schedules/calendar/$nowString'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseDays, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<WeekSchedulesCalendar> getWholeSchedules() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'schedules/whole'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseWeekSchedulesCalendar, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<WeekSchedules> getPartSchedules(String updateStart, String updateEnd) async {
  String jwt = await getJWT();

  http.Response response = await http.get(
    Uri.parse(serverIP + 'schedules/part/${updateStart}/${updateEnd}'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseWeekSchedules, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<Labels>> getLabels() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'labels'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseLabels, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<Archives>> getRoutinesCategory() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'category'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseArchives, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<Archives>> getArchives() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'archives'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseArchives, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<CustomRoutines>> getCustomRoutines() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'customRoutines'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseCustomRoutines, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Member> getMyInfo() async {
  String jwt = await getJWT();
  http.Response response = await http.get(
    Uri.parse(serverIP + 'user/info'),
    headers: {HttpHeaders.authorizationHeader: "Bearer $jwt", HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"},
  );
  if (response.statusCode == 200) {
    return compute(parseMember, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

List<RoutinesCategory> parseCategory(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<RoutinesCategory>((json) => RoutinesCategory.fromJson(json)).toList();
}

List<Archives> parseArchives(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Archives>((json) => Archives.fromJson(json)).toList();
}

List<CustomRoutines> parseCustomRoutines(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CustomRoutines>((json) => CustomRoutines.fromJson(json)).toList();
}

List<Day> parseDays(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Day>((json) => Day.fromJson(json)).toList();
}

List<Labels> parseLabels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Labels>((json) => Labels.fromJson(json)).toList();
}

WeekSchedulesCalendar parseWeekSchedulesCalendar(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return WeekSchedulesCalendar.fromJson(parsed);
}

WeekSchedules parseWeekSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return WeekSchedules.fromJson(parsed);
}

Schedule parseSchedule(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Schedule.fromJson(parsed);
}

Archives parseArchive(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Archives.fromJson(parsed);
}

CustomRoutines parseCustomRoutine(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return CustomRoutines.fromJson(parsed);
}

Routines parseRoutine(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Routines.fromJson(parsed);
}

Member parseMember(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Member.fromJson(parsed);
}

Memos parseMemo(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return Memos.fromJson(parsed);
}

//POST METHOD

Future postArchives(Archives archives) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'archives'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {"title": archives.title, "content": archives.content, "url": archives.url},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postCustomRoutines(CustomRoutines customRoutines) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'customRoutines'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {"title": customRoutines.title, "icon": customRoutines.icon, "duration": customRoutines.duration},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postRoutinesGroups(RoutinesGroups routinesGroups) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'routinesGroups'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {"title": routinesGroups.title, "routinesList": routinesGroups.routinesList, "duration": routinesGroups.duration},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postRoutines(Routines routines) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'routines'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {"title": routines.title, "icon": routines.icon, "duration": routines.duration},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Memos> postRoutinesMemos(Memos memos) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'routines/memos'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "routines_id": memos.routines_id,
        "content": memos.content,
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseMemo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Schedule> postSchedules(Schedule schedule) async {
  String jwt = await getJWT();

  http.Response response = await http.post(
    Uri.parse(serverIP + 'schedules'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "title": schedule.title,
        "content": schedule.content,
        "start_date": schedule.startDate!.toIso8601String(),
        "end_date": schedule.endDate!.toIso8601String(),
        "labels": schedule.labels
      },
    ),
  );
  if (response.statusCode == 200) {
    return compute(parseSchedule, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postSignUp(String email, String password, String name) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'auth/signup'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8", HttpHeaders.acceptHeader: "application/json; charset=UTF-8"},
    body: jsonEncode(
      {"email": email, "password": password, "name": name},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postLogin(String email, String password) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'auth/login'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8", HttpHeaders.acceptHeader: "application/json; charset=UTF-8"},
    body: jsonEncode(
      {"email": email, "password": password},
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(jsonDecode(response.body)["message"]);
  }
}

Future postLogout(String? grantType, String? accessToken, int? accessTokenExpiresIn, String? refreshToken) async {
  String jwt = await getJWT();
  http.Response response = await http.post(
    Uri.parse(serverIP + 'auth/logout'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      HttpHeaders.acceptHeader: "application/json; charset=UTF-8"
    },
    body: jsonEncode(
      {
        "grantType": grantType,
        "accessToken": accessToken,
        "accessTokenExpiresIn": accessTokenExpiresIn,
        "refreshToken": refreshToken,
      },
    ),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future postReissue(String? grantType, String? accessToken, int? accessTokenExpiresIn, String? refreshToken) async {
  http.Response response = await http.post(
    Uri.parse(serverIP + 'auth/reissue'),
    headers: {HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8", HttpHeaders.acceptHeader: "application/json; charset=UTF-8"},
    body: jsonEncode(
      {
        "grantType": grantType,
        "accessToken": accessToken,
        "accessTokenExpiresIn": accessTokenExpiresIn,
        "refreshToken": refreshToken,
      },
    ),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

//Delete

Future<String> deleteArchives(Archives archives) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'archives/${archives.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteCustomRoutines(CustomRoutines customRoutines) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'customRoutines/${customRoutines.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteRoutines(Routines routines) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'routines/${routines.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteRoutinesMemos(Memos memos) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'routines/memos/${memos.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<String> deleteSchedules(Schedule schedules) async {
  String jwt = await getJWT();
  final url = Uri.parse(serverIP + 'schedules/${schedules.id}');
  final request = http.Request("DELETE", url);
  request.headers.addAll(<String, String>{
    HttpHeaders.authorizationHeader: "Bearer $jwt",
    HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
  });

  final response = await request.send();
  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

//PUT

Future<Archives> updateArchives(Archives archives) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'archives/${archives.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "title": archives.title,
      "content": archives.content,
      "url": archives.url,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseArchive, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<CustomRoutines> updateCustomRoutines(CustomRoutines customRoutines) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'customRoutines/${customRoutines.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "icon": customRoutines.icon,
      "title": customRoutines.title,
      "duration": customRoutines.duration,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseCustomRoutine, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Routines> updateRoutines(Routines routines) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'routines/${routines.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "icon": routines.icon,
      "title": routines.title,
      "duration": routines.duration,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseRoutine, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Memos> updateRoutinesMemos(Memos memos) async {
  String jwt = await getJWT();
  http.Response response = await http.put(
    Uri.parse(serverIP + 'routines/memos/${memos.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "content": memos.content,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseMemo, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<List<Labels>> updateLabels(List<Labels> labelsList) async {
  String jwt = await getJWT();
  List jsonList = [];
  labelsList.map((item) => jsonList.add(item.toJson())).toList();

  http.Response response = await http.put(
    Uri.parse(serverIP + 'labels'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "labels_list": jsonList,
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseLabels, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}

Future<Schedule> updateSchedules(Schedule schedules) async {
  String jwt = await getJWT();

  http.Response response = await http.put(
    Uri.parse(serverIP + 'schedules/${schedules.id}'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
    },
    body: jsonEncode({
      "title": schedules.title,
      "content": schedules.content,
      "start_date": schedules.startDate!.toIso8601String(),
      "end_date": schedules.endDate!.toIso8601String(),
      "labels": schedules.labels
    }),
  );
  if (response.statusCode == 200) {
    return compute(parseSchedule, response.body);
  } else {
    throw Exception("error: status code ${response.statusCode}");
  }
}
