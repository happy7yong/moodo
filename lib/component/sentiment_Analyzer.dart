import 'package:pytorch_mobile/enums/dtype.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';

class SentimentAnalyzer {
  late Model _model;

  Future<void> loadModel() async {
    try {
      _model = await PyTorchMobile.loadModel(
          'assets/sentiment_model_torchscript.pt');
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<String> analyzeSentiment(String text) async {
    // 여기에 텍스트를 모델 입력 형식으로 변환하는 로직 구현
    List<double> inputData = [/* 변환된 데이터 */];
    List<int> inputShape = [/* 입력 데이터의 shape */];

    final result =
        await _model.getPrediction(inputData, inputShape, DType.float32);

    // 결과 해석 (모델 출력에 따라 조정 필요)
    if (result?[0] > 0.66) {
      return "긍정";
    } else if (result?[0] > 0.33) {
      return "중립";
    } else {
      return "부정";
    }
  }
}
