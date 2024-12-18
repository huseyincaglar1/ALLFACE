import 'package:demoaiemo/pages/activity_page.dart';
import 'package:flutter/material.dart';

class SuggestionToggles extends StatefulWidget {
  final List<String> modelBasedSuggestions;
  final List<String> myDecisionSuggestions;
  final List<String> mostChosenSuggestions;

  const SuggestionToggles({
    Key? key,
    required this.modelBasedSuggestions,
    required this.myDecisionSuggestions,
    required this.mostChosenSuggestions,
  }) : super(key: key);

  @override
  _SuggestionTogglesState createState() => _SuggestionTogglesState();
}

class _SuggestionTogglesState extends State<SuggestionToggles> {
  bool _modelBasedExpanded = false;
  bool _myDecisionExpanded = false;
  bool _mostChosenExpanded = false;

  Map<String, dynamic> _getRouteArguments() {
    return ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  }

  void _navigateToActivityPage(String suggestion) {
    final args = _getRouteArguments();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityPage(
            suggestion: suggestion, mood: args["emotion"]), // Örnek mood
      ),
    );
  }

  Widget _buildSuggestionList(List<String> suggestions) {
    if (suggestions.isEmpty) {
      return Center(child: Text('Henüz öneri bulunmuyor.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics:
          NeverScrollableScrollPhysics(), // Disable scrolling of inner ListView
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () => _navigateToActivityPage(suggestions[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Make the entire content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text('Model Tabanlı Etkinlik Önerileri'),
              children: [
                _buildSuggestionList(widget.modelBasedSuggestions),
              ],
              initiallyExpanded: _modelBasedExpanded,
              onExpansionChanged: (value) {
                setState(() {
                  _modelBasedExpanded = value;
                });
              },
            ),
            ExpansionTile(
              title: Text('Benim Seçimlerime Göre Etkinlik Önerileri'),
              children: [
                _buildSuggestionList(widget.myDecisionSuggestions),
              ],
              initiallyExpanded: _myDecisionExpanded,
              onExpansionChanged: (value) {
                setState(() {
                  _myDecisionExpanded = value;
                });
              },
            ),
            ExpansionTile(
              title:
                  Text('Tüm Kullanıcıların En Çok Tercih Ettiği Etkinlikler'),
              children: [
                _buildSuggestionList(widget.mostChosenSuggestions),
              ],
              initiallyExpanded: _mostChosenExpanded,
              onExpansionChanged: (value) {
                setState(() {
                  _mostChosenExpanded = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
