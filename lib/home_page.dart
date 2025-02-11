import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:go_router/go_router.dart';

import 'components/menu_button.dart';
import 'constants/routes.dart';
import 'services/speech_recognition_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _speechService = SpeechRecognitionService();
  String _recognizedText = '';
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 8),
              _buildRecognizedText(),
              const SizedBox(height: 36),
              _buildMenuGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari...',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: _handleListening,
        ),
      ),
    );
  }

  Widget _buildRecognizedText() {
    return Text(
      _recognizedText,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: const [
        MenuButton(
          text: 'Etam Kawa',
          route: AppRoutes.etamKawa,
        ),
        MenuButton(
          text: 'BPS',
          route: AppRoutes.bps,
        ),
        MenuButton(
          text: 'HRGS',
          route: AppRoutes.hrgs,
        ),
        MenuButton(
          text: 'PIC-BPS',
          route: AppRoutes.picBps,
        ),
        MenuButton(
          text: 'PSCM',
          route: AppRoutes.pscm,
        ),
        MenuButton(
          text: 'AM Service',
          route: AppRoutes.amService,
        ),
      ],
    );
  }

  Future<void> _handleListening() async {
    try {
      if (!_isListening) {
        bool available = await _speechService.initialize(
          onStatus: _handleSpeechStatus,
          onError: (error) => log('Error: $error'),
        );

        if (available) {
          setState(() => _isListening = true);
          _speechService.startListening(
            onResult: (words, isFinal) {
              if (isFinal) {
                _handleSpeechResult(words);
              }
            },
          );
        }
      } else {
        setState(() => _isListening = false);
        _speechService.stopListening();
      }
    } catch (e) {
      log('Speech recognition error: $e');
    }
  }

  void _handleSpeechStatus(String status) {
    log('Status: $status');
    if (status == 'done' || status == 'notListening') {
      setState(() => _isListening = false);
    }
  }

  void _handleSpeechResult(String recognizedWords) {
    setState(() {
      List<String> matchedRoutes = _findMatchingRoutes(recognizedWords);
      _recognizedText = recognizedWords;

      if (matchedRoutes.isEmpty) {
        _showErrorSnackBar();
      } else if (matchedRoutes.length == 1) {
        _navigateToRoute(matchedRoutes.first);
      } else {
        _showSelectionDialog(matchedRoutes);
      }
    });
  }

  List<String> _findMatchingRoutes(String input) {
    final words = AppRoutes.speechRoutes.keys.toList();
    final fuzzy = Fuzzy<String>(words, options: FuzzyOptions(threshold: 0.3));
    final result = fuzzy.search(input);
    return result.map((r) => r.item).toList();
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Incorrect input, please try again!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToRoute(String route) {
    Future.delayed(const Duration(seconds: 1), () {
      context.go(AppRoutes.speechRoutes[route]!);
      setState(() => _recognizedText = '');
    });
  }

  void _showSelectionDialog(List<String> matchedRoutes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: matchedRoutes.map((route) {
              return ListTile(
                title: Text(route.toUpperCase()),
                onTap: () {
                  Navigator.pop(context);
                  context.go(AppRoutes.speechRoutes[route]!);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
