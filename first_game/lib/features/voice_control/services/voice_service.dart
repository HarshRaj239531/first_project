import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/voice_command_model.dart';

class VoiceService {
  final List<String> _sampleResponses = [
    'Turning on the living room lights...',
    'Setting AC temperature to 22°C.',
    'Locking the front door.',
    'Starting the ceiling fan.',
    'Playing music on the kitchen speaker.',
    'Turning off all bedroom lights.',
    'Setting thermostat to eco mode.',
    'Camera feed activated.',
  ];

  int _responseIndex = 0;

  Future<VoiceCommand> processCommand(String text) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final response = _sampleResponses[_responseIndex % _sampleResponses.length];
    _responseIndex++;
    return VoiceCommand(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      response: response,
      timestamp: DateTime.now(),
      status: VoiceCommandStatus.executed,
    );
  }

  Stream<String> simulateSpeechRecognition() async* {
    final words = ['Turn', 'on', 'the', 'living', 'room', 'lights'];
    for (final w in words) {
      await Future.delayed(const Duration(milliseconds: 300));
      yield w;
    }
  }

  @visibleForTesting
  String generateFakeText() {
    final commands = [
      'Turn on living room lights',
      'Set AC to 22 degrees',
      'Lock front door',
      'Start the fan',
      'Turn off all lights',
    ];
    return commands[DateTime.now().second % commands.length];
  }
}
