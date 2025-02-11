import 'dart:developer';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize({
    required Function(String) onStatus,
    required Function(String) onError,
  }) async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speechToText.initialize(
        onStatus: (status) => onStatus(status),
        onError: (error) => onError(error.toString()),
        debugLogging: true,
      );
      return _isInitialized;
    } catch (e) {
      log('Speech recognition initialization error: $e');
      return false;
    }
  }

  void startListening({
    required Function(String, bool) onResult,
    String localeId = 'id-ID',
  }) {
    if (!_isInitialized) return;

    _speechToText.listen(
      onResult: (result) => onResult(
        result.recognizedWords,
        result.finalResult,
      ),
      localeId: localeId,
    );
  }

  void stopListening() {
    _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
}
