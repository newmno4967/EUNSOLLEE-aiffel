// main.dart
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:camera/camera.dart'; // 카메라 사용을 위한 라이브러리
import 'screens/logo.dart'; // 로고 화면
import 'screens/login.dart'; // 로그인 화면
import 'screens/home.dart'; // 메인 화면
import 'screens/camera.dart'; // 카메라 화면
import 'screens/gallery.dart'; // 갤러리 화면
import 'screens/photo_analysis.dart'; // 사진 분석 화면

Future<void> main() async {
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 목록 가져오기
  final cameras = await availableCameras();

  // 첫 번째 카메라 선택
  final firstCamera = cameras.first;

  // 앱 실행
  runApp(MyApp(camera: firstCamera));
}

// 앱의 최상위 위젯
class MyApp extends StatelessWidget {
  // 카메라 정보
  final CameraDescription camera;

  // 생성자
  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp: Flutter 앱의 기본 구조
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      title: 'Travel Photo App', // 앱 제목
      theme: ThemeData(
        brightness: Brightness.light, // ✅ 배경을 밝게 설정
        scaffoldBackgroundColor: Colors.white, // ✅ 전체 배경색을 하얀색으로 변경
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // ✅ AppBar도 하얀색으로 변경
          elevation: 0, // ✅ 그림자 제거
          iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상 블랙
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // ✅ 기본 텍스트를 블랙으로 변경
        ),
      ),
      initialRoute: '/', // 앱 시작 라우트
      routes: {
        // 앱 라우트 정의
        '/': (context) => LogoScreen(camera: camera), // 로고 화면
        '/login': (context) => LoginScreen(camera: camera), // 로그인 화면
        '/home': (context) => HomeScreen(camera: camera), // 메인 화면
        '/camera': (context) => CameraScreen(camera: camera), // 카메라 화면
        '/gallery': (context) => const GalleryScreen(), // 갤러리 화면
      },
    );
  }
}



// api/chatgpt_api.dart
import 'dart:convert'; // JSON 변환을 위한 라이브러리
import 'package:http/http.dart' as http; // HTTP 통신을 위한 라이브러리

// ChatGPT API 호출 클래스
class ChatGPTAPI {
  final String apiKey = "YOUR_API_KEY"; // 🔑 API 키 입력

  // 장소 정보 가져오기
  Future<String> fetchPlaceInfo(String placeName) async {
    // API 엔드포인트 URL
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    try {
      // HTTP POST 요청
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey", // API 키 인증
          "Content-Type": "application/json" // Content-Type 설정
        },
        body: jsonEncode({
          // 요청 본문 (JSON 형식)
          "model": "gpt-3.5-turbo", // 사용할 모델
          "messages": [
            {
              "role": "system",
              "content": "당신은 한국어를 사용하는 여행 가이드입니다. 모든 답변을 JSON 형식으로 제공하세요."
            },
            {
              "role": "user",
              "content": """
              너는 여행 가이드 역할을 합니다. 
              아래 JSON 형식으로 응답하세요.

              {
                "지역": "도시 또는 국가명",
                "주소": "정확한 주소",
                "운영 시간": "운영 시간 정보",
                "홈페이지": "공식 웹사이트 URL",
                "여행지 정보": "관광지에 대한 설명 (100자 이하로 요약)"
              }

              '$placeName'에 대한 정보를 JSON 형식으로 제공하세요.
              응답은 반드시 JSON 형식으로 끝나야 합니다. 응답을 종료합니다.
              """
            }
          ],
          "max_tokens": 350 // 🔹 응답이 잘리지 않도록 충분한 토큰 제공
        }),
      );

      // 응답 상태 코드 확인
      if (response.statusCode == 200) {
        // 응답 본문 파싱
        final data = json.decode(utf8.decode(response.bodyBytes));
        print("✅ API 응답: ${data["choices"][0]["message"]["content"]}");
        return data["choices"][0]["message"]["content"];
      } else {
        // API 오류 발생 시 오류 메시지 반환
        print("❌ ChatGPT API 오류: ${response.statusCode} - ${response.body}");
        return '{"오류": "정보를 가져오는 데 실패했습니다."}';
      }
    } catch (e) {
      // API 호출 중 오류 발생 시 오류 메시지 반환
      print("❌ ChatGPT API 호출 중 오류 발생: $e");
      return '{"오류": "데이터를 불러오는 중 오류가 발생했습니다."}';
    }
  }
}



// screens/home.dart
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:camera/camera.dart'; // 카메라 사용을 위한 라이브러리
import 'camera.dart'; // 카메라 화면
import 'gallery.dart'; // 갤러리 화면
import 'photo_analysis.dart'; // 사진 분석 화면

// 메인 화면 위젯
class HomeScreen extends StatelessWidget {
  // 카메라 정보
  final CameraDescription camera;

  // 생성자
  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱의 기본 레이아웃 구조
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 배경색 화이트
      appBar: AppBar(
        // AppBar: 앱 상단 바
        title: const Text("Travel Scanner",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true, // 제목 가운데 정렬
        actions: [
          // AppBar 액션 버튼
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        // 화면 내용이 넘칠 경우 스크롤 가능하도록 함
        child: Column(
          children: [
            _buildActionButtons(context), // 액션 버튼 영역
            _buildTravelStory(), // 여행 이야기 카드
            _buildRecommendedPlaces(), // 추천 여행지 리스트
            _buildMapSection(), // ✅ 수정된 부분
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context), // 하단 네비게이션 바
    );
  }

  // ✅ 버튼 영역 (사진 업로드 & 촬영 버튼)
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Upload Photo"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraScreen(camera: camera))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Take Photo"),
          ),
        ],
      ),
    );
  }

  // ✅ 여행 이야기 카드
  Widget _buildTravelStory() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset("assets/image1.jpg",
                  width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("여행 이야기 🌍",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("여행 중 만난 아름다운 순간!",
                          style: TextStyle(color: Colors.grey)),
                      IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 추천 여행지 리스트
  Widget _buildRecommendedPlaces() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("추천 여행지",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildPlaceItem("도쿄 스카이라인", "5일 여행"),
          _buildPlaceItem("뉴욕 자유의 여신상", "3일 여행"),
        ],
      ),
    );
  }

  Widget _buildPlaceItem(String name, String duration) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.black),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(duration, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // ✅ "여행 동선 추천" 섹션 수정 (제목과 컨테이너 분리)
  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "여행 동선 추천",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10), // ✅ 간격 추가
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "📍 지도 표시 (추후 추가 가능)",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 하단 네비게이션 바 (순서 변경: 홈, 카메라, 갤러리, 사진 분석)
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Camera"),
        BottomNavigationBarItem(
            icon: Icon(Icons.photo_library), label: "Gallery"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
      ],
      onTap: (index) {
        switch (index) {
          case 1: // 카메라 버튼
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraScreen(camera: camera)),
            );
            break;
          case 2: // 갤러리 버튼
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GalleryScreen()),
            );
            break;
          case 3: // 사진 분석 버튼
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const PhotoAnalysisScreen(imagePath: "assets/image1.jpg"),
              ),
            );
            break;
        }
      },
    );
  }
}



// screens/camera.dart
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:camera/camera.dart'; // 카메라 사용을 위한 라이브러리
import 'gallery.dart'; // 갤러리 화면

// 카메라 화면 위젯
class CameraScreen extends StatefulWidget {
  // 카메라 정보
  final CameraDescription camera;

  // 생성자
  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // 카메라 컨트롤러
  late CameraController _controller;

  // 컨트롤러 초기화 Future
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라 컨트롤러 초기화
    _controller = CameraController(
      widget.camera, // 사용할 카메라 선택
      ResolutionPreset.medium, // 해상도 설정
    );

    // 컨트롤러 초기화
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱의 기본 레이아웃 구조
    return Scaffold(
      appBar: AppBar(title: const Text("📸 카메라")), // AppBar: 앱 상단 바
      body: FutureBuilder<void>(
        // FutureBuilder: 비동기 작업 결과 처리
        future: _initializeControllerFuture, // 초기화 Future
        builder: (context, snapshot) {
          // ConnectionState에 따라 다른 위젯 표시
          if (snapshot.connectionState == ConnectionState.done) {
            // 초기화 완료 시 카메라 미리보기 표시
            return CameraPreview(_controller);
          } else {
            // 초기화 중일 경우 로딩 индикатор 표시
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Column(
        // FloatingActionButton: 화면 하단에 떠 있는 버튼
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            // 사진 촬영 버튼
            onPressed: () async {
              try {
                // 컨트롤러 초기화 확인
                await _initializeControllerFuture;
                // 사진 촬영
                await _controller.takePicture();
              } catch (e) {
                // 오류 발생 시 오류 메시지 출력
                print("❌ 사진 촬영 오류: $e");
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 10), // 버튼 사이 간격
          FloatingActionButton(
            // 갤러리 화면으로 이동하는 버튼
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GalleryScreen()),
            ),
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}



// screens/gallery.dart
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'photo_analysis.dart'; // 사진 분석 화면

// 갤러리 화면 위젯
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  // 이미지 목록
  final List<String> images = const [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
    'assets/image4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱의 기본 레이아웃 구조
    return Scaffold(
      appBar: AppBar(title: const Text("🖼 갤러리")), // AppBar: 앱 상단 바
      body: GridView.builder(
        // GridView: 이미지들을 격자 형태로 표시
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 열 개수
          crossAxisSpacing: 10, // 열 간격
          mainAxisSpacing: 10, // 행 간격
        ),
        itemCount: images.length, // 이미지 개수
        itemBuilder: (context, index) {
          // 각 이미지에 대한 위젯 생성
          return GestureDetector(
            // GestureDetector: 이미지 클릭 이벤트 처리
            onTap: () {
              // 이미지 클릭 시 사진 분석 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PhotoAnalysisScreen(imagePath: images[index]),
                ),
              );
            },
            child: Hero(
              // Hero: 화면 전환 시 애니메이션 효과
              tag: "photo_${images[index].hashCode}", // ✅ Hero 태그를 고유하게 변경
              child: Image.asset(images[index], fit: BoxFit.cover), // 이미지 표시
            ),
          );
        },
      ),
    );
  }
}



// screens/photo_analysis.dart
import 'dart:convert'; // JSON 변환을 위한 라이브러리
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:url_launcher/url_launcher.dart'; // URL 실행을 위한 라이브러리
import '../api/chatgpt_api.dart'; // ChatGPT API 호출을 위한 파일
import 'home.dart'; // HomeScreen import
import 'camera.dart'; // CameraScreen import
import 'gallery.dart'; // GalleryScreen import
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // kIsWeb을 사용하기 위해 import 추가
import 'dart:io'; // File 클래스 사용을 위해 import 추가
import 'package:flutter/services.dart';

// 사진 분석 화면 위젯
class PhotoAnalysisScreen extends StatefulWidget {
  // 이미지 경로
  final String imagePath;
  // 카메라 정보
  final CameraDescription? camera;
  // 카메라 사용 가능 여부
  final bool useCamera;
  // 이미지 바이트 데이터
  final List<int>? imageBytes; // 바이트 데이터 받기 위한 변수 추가

  // 생성자
  const PhotoAnalysisScreen(
      {Key? key,
      required this.imagePath,
      this.camera,
      required this.useCamera,
      this.imageBytes})
      : super(key: key);

  @override
  _PhotoAnalysisScreenState createState() => _PhotoAnalysisScreenState();
}

class _PhotoAnalysisScreenState extends State<PhotoAnalysisScreen> {
  // 검색어 입력 컨트롤러
  final TextEditingController _searchController = TextEditingController();
  // ChatGPT API 응답 데이터
  Map<String, String>? _chatGptData;
  // 로딩 상태
  bool _isLoading = false;
  // 에러 메시지
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print("PhotoAnalysisScreen - imagePath: ${widget.imagePath}");
  }

  // 장소 검색 함수
  void _searchPlace() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print("🔍 검색어: ${_searchController.text}");
      String data = await ChatGPTAPI().fetchPlaceInfo(_searchController.text);

      if (!data.trim().endsWith("}")) {
        print("⚠️ JSON 응답이 불완전함 → 자동 복구 시도");
        data += '"}';
      }

      setState(() {
        _chatGptData = _parsePlaceInfo(data);
        print("🧐 최종 저장된 JSON 데이터: $_chatGptData");
        _isLoading = false;
      });
    } catch (e) {
      print("❌ API 호출 중 오류 발생: $e");
      setState(() {
        _errorMessage = "데이터를 불러오는 중 오류가 발생했습니다.";
        _isLoading = false;
      });
    }
  }

  // JSON 파싱 함수
  Map<String, String> _parsePlaceInfo(String rawData) {
    try {
      final jsonData = json.decode(rawData);
      print("✅ JSON 파싱 성공: $jsonData");

      return {
        "지역": jsonData["지역"]?.trim() ?? "정보 없음",
        "주소": jsonData["주소"]?.trim() ?? "정보 없음",
        "운영 시간": jsonData["운영 시간"]?.trim() ?? "정보 없음",
        "홈페이지": jsonData["홈페이지"]?.trim() ?? "정보 없음",
        "여행지 정보": jsonData["여행지 정보"]?.trim() ?? "정보 없음",
      };
    } catch (e) {
      print("❌ JSON 파싱 실패: $e");
      return {
        "지역": "정보 없음",
        "주소": "정보 없음",
        "운영 시간": "정보 없음",
        "홈페이지": "정보 없음",
        "여행지 정보": "정보 없음",
      };
    }
  }

  // URL 실행 함수
  void _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  // 이미지 위젯 빌드 함수
  Widget _buildImageWidget() {
    if (kIsWeb && widget.imageBytes != null) {
      // 웹 환경: imageBytes를 사용하여 표시
      return Image.memory(
        Uint8List.fromList(widget.imageBytes!),
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      // 로컬 에셋 또는 파일 이미지
      return Image.asset(
        widget.imagePath,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "What destination\nwould you like to explore?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImageWidget(), // 분리된 함수 사용
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "여행 장소를 입력하세요",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black),
                          onPressed: _searchPlace,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onSubmitted: (value) {
                        _searchPlace();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () {
                      // 검색 옵션 또는 필터링 기능 구현 (선택 사항)
                    },
                  ),
                ],
              ),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              if (_errorMessage != null)
                Center(
                    child: Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red))),
              if (!_isLoading && _errorMessage == null && _chatGptData != null)
                _buildPlaceInfo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // 앱바 빌드 함수
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Travel Scanner",
          style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 16),
      ),
    );
  }

  /// 🏛️ 관광지 정보 UI
  Widget _buildPlaceInfo() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        _infoCard(Icons.location_on, "지역", _chatGptData?["지역"] ?? "정보 없음"),
        _infoCard(Icons.map, "주소", _chatGptData?["주소"] ?? "정보 없음"),
        _infoCard(
            Icons.access_time, "운영 시간", _chatGptData?["운영 시간"] ?? "정보 없음"),
        if (_chatGptData?["홈페이지"] != "정보 없음")
          GestureDetector(
            onTap: () => _launchURL(_chatGptData?["홈페이지"] ?? ""),
            child: _infoCard(Icons.link, "홈페이지", "클릭하여 이동"),
          ),
        _highlightCard(
            Icons.info, "여행지 설명", _chatGptData?["여행지 정보"] ?? "정보 없음"),
      ],
    );
  }

  /// 🔹 일반 정보 카드 (다시 추가됨)
  Widget _infoCard(IconData icon, String title, String content) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: Text(content, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }

  /// 🌟 **여행지 설명을 ListView 형태로 강조**
  Widget _highlightCard(IconData icon, String title, String content) {
    List<String> descriptionList =
        content.split('.').where((s) => s.trim().isNotEmpty).toList();

    return Card(
      color: Colors.grey[200], // 💡 강조
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (descriptionList.isNotEmpty)
              Column(
                children: descriptionList
                    .map((sentence) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            "• ${sentence.trim()}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87),
                          ),
                        ))
                    .toList(),
              ),
            if (descriptionList.isEmpty)
              const Text("정보 없음",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Camera"),
        BottomNavigationBarItem(
            icon: Icon(Icons.photo_library), label: "Gallery"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Setting"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                      camera: widget.camera, useCamera: widget.useCamera)),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CameraScreen(
                      camera: widget.camera, useCamera: widget.useCamera)),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GalleryScreen(
                      camera: widget.camera, useCamera: widget.useCamera)),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhotoAnalysisScreen(
                      imagePath: "assets/image1.jpg",
                      camera: widget.camera,
                      useCamera: widget.useCamera)),
            );
            break;

          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                      camera: widget.camera, useCamera: widget.useCamera)),
            );
            break;
        }
      },
    );
  }
}



// screens/login.dart
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:camera/camera.dart'; // 카메라 사용을 위한 라이브러리
import 'home.dart'; // 메인 화면

// 로그인 화면 위젯
class LoginScreen extends StatefulWidget {
  // 카메라 정보
  final CameraDescription camera;

  // 생성자
  const LoginScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 아이디 입력 컨트롤러
  final TextEditingController _idController = TextEditingController();

  // 비밀번호 입력 컨트롤러
  final TextEditingController _passwordController = TextEditingController();

  // 에러 메시지
  String? _errorMessage;

  // 로그인 함수
  void _login() {
    // 입력 유효성 검사 및 에러 메시지 설정
    setState(() {
      if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
        _errorMessage = "아이디와 비밀번호를 입력해주세요.";
      } else {
        _errorMessage = null;
        // 메인 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(camera: widget.camera)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱의 기본 레이아웃 구조
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 배경색 하얀색
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("로그인",
                  style: TextStyle(fontSize: 28, color: Colors.black)),
              const SizedBox(height: 20),
              _buildTextField("아이디", _idController),
              const SizedBox(height: 15),
              _buildTextField("비밀번호", _passwordController, obscureText: true),
              const SizedBox(height: 15),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // ✅ 버튼 색상 블랙
                  foregroundColor: Colors.white, // ✅ 버튼 텍스트 색상 화이트
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
                child: const Text("로그인"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 텍스트 필드 생성 함수
  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey[200], // ✅ 입력 필드 배경색 변경
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}



// screens/logo.dart
import 'package:flutter/material.dart'; // Flutter UI 라이브러리
import 'package:camera/camera.dart'; // 카메라 사용을 위한 라이브러리
import 'login.dart'; // 로그인 화면

// 로고 화면 위젯
class LogoScreen extends StatefulWidget {
  // 카메라 정보
  final CameraDescription camera;

  // 생성자
  const LogoScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후 로그인 화면으로 이동
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(camera: widget.camera)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold: 앱의 기본 레이아웃 구조
    return Scaffold(
      backgroundColor: Colors.white, // ✅ 배경색 화이트
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // ✅ 세로 중앙 정렬
          children: [
            Image.asset(
              'assets/logo.png', // ✅ 아이콘 이미지
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20), // ✅ 아이콘과 텍스트 사이 여백
            const Text(
              "Travel Scanner",
              style: TextStyle(
                fontSize: 20, // ✅ 글자 크기
                fontWeight: FontWeight.bold, // ✅ 볼드체
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
