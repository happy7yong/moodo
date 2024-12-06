import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:translator/translator.dart'; // 번역을 위한 패키지

Future<String> analyzeKoreanSentiment(String koreanText) async {
  final translator = GoogleTranslator();
  final Sentiment sentiment = Sentiment();

  // 한국어를 영어로 번역
  final translation = await translator.translate(koreanText, to: 'en');

  // 번역된 텍스트 분석
  final analysis = sentiment.analysis(translation.text);

  print('원문: $koreanText');
  print('번역: ${translation.text}');
  print('감정 분석 결과: $analysis');

  // 감정 점수에 따라 키워드 결정
  String sentimentKeyword;
  if (analysis['score'] >= 1) {
    sentimentKeyword = 'positive';
  } else if (analysis['score'] <= -1) {
    sentimentKeyword = 'negative';
  } else {
    sentimentKeyword = 'neutral'; // 점수가 1 미만, -1 초과인 경우
  }

  print('키워드: $sentimentKeyword');
  return sentimentKeyword; // 키워드 반환
}
