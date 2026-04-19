import 'dart:io';

/// OCR 서비스 인터페이스 — 이미지 파일 → 텍스트 추출
///
/// 플랫폼별 구현 전략:
///   모바일(Android/iOS): ML Kit 온디바이스 (오프라인 동작)
///   Web/Desktop:         서버 위임 (C#/Python OCR API)
abstract interface class IOcrService {
  /// [image] 캡처된 이미지 파일 → 인식된 원시 텍스트 반환
  /// 인식 실패 시 빈 문자열 반환 (throw 금지 — 호출자가 신뢰도로 판단)
  Future<String> recognizeText(File image);

  /// 오프라인 상태에서 동작 가능 여부
  bool get isOfflineCapable;
}

// -----------------------------------------------------------------------------
// 모바일 구현 (ML Kit)
// -----------------------------------------------------------------------------

/// 모바일 온디바이스 OCR — Google ML Kit Text Recognition
///
/// TODO: pubspec.yaml에 google_mlkit_text_recognition 패키지 추가 필요
///   google_mlkit_text_recognition: ^0.13.0
///
/// 설치 후 아래 TODO 블록을 실제 ML Kit 코드로 교체:
///   import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
///   final _recognizer = TextRecognizer(script: TextRecognitionScript.korean);
class MobileOcrService implements IOcrService {
  @override
  bool get isOfflineCapable => true; // 온디바이스 처리

  @override
  Future<String> recognizeText(File image) async {
    // TODO: ML Kit 패키지 설치 후 구현
    //
    // 구현 예시:
    //   final inputImage = InputImage.fromFile(image);
    //   final recognized = await _recognizer.processImage(inputImage);
    //   return recognized.text;
    //
    // 현재는 stub — 패키지 미설치로 인해 빈 문자열 반환
    return '';
  }
}

// -----------------------------------------------------------------------------
// Web/Desktop 구현 (서버 위임 Stub)
// -----------------------------------------------------------------------------

/// 서버 위임 OCR — Web/Desktop 플랫폼용
///
/// TODO: C#/Python OCR API 구현 후 실제 HTTP 호출로 교체.
/// 현재 MVP에서는 stub 처리 (Phase 2 활성화 예정).
///
/// 설계 계약:
///   POST /api/ocr/recognize
///   Content-Type: multipart/form-data
///   Body: image 파일
///   Response: { "text": "인식된 텍스트", "confidence": 0.95 }
class ServerOcrService implements IOcrService {
  ServerOcrService({required this.baseUrl});

  /// C# 백엔드 OCR 엔드포인트 기준 URL
  final String baseUrl;

  @override
  bool get isOfflineCapable => false; // 서버 연결 필수

  @override
  Future<String> recognizeText(File image) async {
    // TODO: 서버 OCR API 연동 구현 (Phase 2)
    //
    // 구현 예시 (http 패키지 사용):
    //   final request = http.MultipartRequest(
    //     'POST', Uri.parse('$baseUrl/api/ocr/recognize'),
    //   );
    //   request.files.add(await http.MultipartFile.fromPath('image', image.path));
    //   final response = await request.send();
    //   final body = await response.stream.bytesToString();
    //   return jsonDecode(body)['text'] as String;
    //
    // 현재는 stub
    return '';
  }
}
