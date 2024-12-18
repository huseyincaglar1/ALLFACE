import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../util/suggestion_toggles.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  String? detectedEmotion;
  List<String> _modelBasedSuggestions = [];
  List<String> _myDecisionSuggestions = [];
  List<String> _mostChosenSuggestions = [];
  bool _isLoading = true;
  String url = 'http://10.11.13.76';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserEmotion();
    _fetchActivitySuggestion();
    _getMostFrequentActivityUser();
    _getMostFrequentActivityAll();
  }

  Future<DocumentSnapshot?> _getUserDocument() async {
    try {
      return await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }

  Future<void> _fetchActivitySuggestion() async {
    final args = _getRouteArguments();
    if (args == null) return;
    print(args['emotion']);

    final userDoc = await _getUserDocument();
    if (userDoc == null) return;

    int age;
    if (userDoc['Age'] is String) {
      age = int.parse(userDoc['Age']);
    } else {
      age = userDoc['Age'];
    }

    String gender = userDoc['Gender'];
    String job = userDoc['Occupation'];

    try {
      final response = await _postRequest('http://10.11.13.76:5000/predict', {
        'yas': age,
        'meslek': job,
        'cinsiyet': gender,
        'mood': args["emotion"].toLowerCase(),
      });

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['predictions'] != null) {
          setState(() {
            _modelBasedSuggestions =
                List<String>.from(decodedResponse['predictions']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _modelBasedSuggestions = ["No suggestions found."];
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _modelBasedSuggestions = ["Failed to get suggestions."];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _modelBasedSuggestions = ["Error occurred: $e"];
        _isLoading = false;
      });
    }
  }

  Future<void> _getMostFrequentActivityUser() async {
    final args = _getRouteArguments();
    if (args == null) return;

    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.email!;

    try {
      final response = await _postRequest(
          'http://10.11.13.76:5000/get_most_frequent_activity', {
        'user_id': userId,
        'mood': args["emotion"].toLowerCase(),
      });

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print(decodedResponse);

        if (decodedResponse['most_frequent_activity_user'] != null &&
            decodedResponse['most_frequent_activity_user'] is String) {
          setState(() {
            _myDecisionSuggestions = [
              decodedResponse['most_frequent_activity_user']
            ];
          });
        } else {
          setState(() {
            _myDecisionSuggestions = ["Kullanıcının tercihi yok."];
          });
        }
      } else {
        print(
            'Kullanıcı aktiviteleri isteği başarısız oldu. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> _getMostFrequentActivityAll() async {
    final args = _getRouteArguments();
    if (args == null) return;

    try {
      final response = await _postRequest(
          'http://10.11.13.76:5000/get_most_frequent_activity', {
        'user_id': 'all_users',
        'mood': args["emotion"].toLowerCase(),
      });

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        print(decodedResponse);

        if (decodedResponse['most_frequent_activity_all'] != null) {
          if (decodedResponse['most_frequent_activity_all'] is List) {
            setState(() {
              _mostChosenSuggestions = List<String>.from(
                  decodedResponse['most_frequent_activity_all']);
            });
          } else {
            setState(() {
              _mostChosenSuggestions = [
                decodedResponse['most_frequent_activity_all'].toString()
              ];
            });
          }
        } else {
          setState(() {
            _mostChosenSuggestions = ["Hiçbir kullanıcı önerisi yok."];
          });
        }
      } else {
        print(
            'Tüm kullanıcı aktiviteleri isteği başarısız oldu. Status Code: ${response.statusCode}');
        setState(() {
          _mostChosenSuggestions = ["Hiçbir kullanıcı önerisi yok."];
        });
      }
    } catch (e) {
      print('Hata: $e');
      setState(() {
        _mostChosenSuggestions = ["Bir hata oluştu."];
      });
    }
  }

  Map<String, dynamic>? _getRouteArguments() {
    return ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  }

  Future<void> _fetchUserEmotion() async {
    final args = _getRouteArguments();
    if (args != null) {
      setState(() {
        detectedEmotion = args['emotion'];
        _isLoading = false;
      });
    } else {
      setState(() {
        detectedEmotion = 'Unknown';
        _isLoading = false;
      });
    }
  }

  Future<http.Response> _postRequest(
      String endpoint, Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(body),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Öneri Sayfası")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Algilanan Duygu: $detectedEmotion",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SuggestionToggles(
                      modelBasedSuggestions: _modelBasedSuggestions,
                      myDecisionSuggestions: _myDecisionSuggestions.isNotEmpty
                          ? _myDecisionSuggestions
                          : ["Kullanıcının tercihi yok."],
                      mostChosenSuggestions: _mostChosenSuggestions.isNotEmpty
                          ? _mostChosenSuggestions
                          : ["Hiçbir kullanıcı önerisi yok."],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
