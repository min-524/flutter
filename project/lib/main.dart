import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '싱어-송라이터',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/playlistDetail': (context) => PlaylistDetailScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('싱어-송라이터'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: '추천된 노래'),
              Tab(text: '검색'),
              Tab(text: '라이브러리'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RecommendationsTab(),
            SearchTab(),
            LibraryTab(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  // 홈으로 이동하는 로직 추가
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // 검색 탭으로 이동하는 로직 추가
                },
              ),
              IconButton(
                icon: Icon(Icons.library_music),
                onPressed: () {
                  // 라이브러리 탭으로 이동하는 로직 추가
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendationsTab extends StatelessWidget {
  final List<Map<String, String>> recommendedSongs = [
    {'title': '노래 제목 1', 'artist': '가수 이름 1'},
    {'title': '노래 제목 2', 'artist': '가수 이름 2'},
    {'title': '노래 제목 3', 'artist': '가수 이름 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recommendedSongs.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.music_note),
          title: Text(recommendedSongs[index]['title']!),
          subtitle: Text(recommendedSongs[index]['artist']!),
          onTap: () {
            // 노래 재생 또는 상세 정보 보기 기능 추가
          },
        );
      },
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: '검색어를 입력하세요',
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // 검색어 변경 시 처리할 로직 추가 가능
          },
        ),
      ),
    );
  }
}

class LibraryTab extends StatefulWidget {
  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  List<String> libraries = ['플레이리스트 1', '플레이리스트 2', '플레이리스트 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('라이브러리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: libraries.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(libraries[index]),
              onTap: () {
                Navigator.pushNamed(context, '/playlistDetail', arguments: libraries[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class PlaylistDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String playlistName = ModalRoute.of(context)!.settings.arguments as String;

    // 플레이리스트에 따른 노래 목록을 가져오는 로직 추가 (임의로 예시 노래 목록 생성)
    final List<Map<String, String>> playlistSongs = [
      {'title': '노래 제목 A', 'artist': '가수 이름 A'},
      {'title': '노래 제목 B', 'artist': '가수 이름 B'},
      {'title': '노래 제목 C', 'artist': '가수 이름 C'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$playlistName 플레이리스트'),
      ),
      body: ListView.builder(
        itemCount: playlistSongs.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(playlistSongs[index]['title']!),
            subtitle: Text(playlistSongs[index]['artist']!),
            onTap: () {
              // 노래 재생 또는 상세 정보 보기 기능 추가
            },
          );
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 여기서 인증 과정을 건너뛰고 바로 MainScreen으로 이동
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text('Skip Login'),
        ),
      ),
    );
  }
}
