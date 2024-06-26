// ignore_for_file: unused_element
import 'package:langchain_core/chat_models.dart';
import 'package:langchain_core/llms.dart';
import 'package:langchain_core/output_parsers.dart';
import 'package:test/test.dart';

void main() {
  group('StringOutputParser tests', () {
    test('StringOutputParser from LLMResult', () async {
      const result = LLMResult(generations: [LLMGeneration('Hello world!')]);
      final res =
          await const StringOutputParser().parseResult(result.generations);
      expect(res, 'Hello world!');
    });

    test('StringOutputParser from ChatResult', () async {
      const result = ChatResult(
        generations: [ChatGeneration(AIChatMessage(content: 'Hello world!'))],
      );
      final res =
          await const StringOutputParser().parseResult(result.generations);
      expect(res, 'Hello world!');
    });
  });
}
