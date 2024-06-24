import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Music Recommendation',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final String clientId = 'YOUR_SPOTIFY_CLIENT_ID';
  final String clientSecret = 'YOUR_SPOTIFY_CLIENT_SECRET';
  final String redirectUri = 'YOUR_REDIRECT_URI';

  Future<void> _authenticate(BuildContext context) async {
    final String authUrl =
        'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&scope=user-read-private%20user-read-email%20playlist-read-private%20user-library-read%20user-top-read';

    if (await canLaunch(authUrl)) {
      await launch(authUrl);

      // 여기서는 리다이렉트 URI에서 코드를 수동으로 추출하여 사용
      final String authCode = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AuthCodePage()),
      );

      if (authCode != null) {
        final token = await _getAccessToken(authCode);
        if (token != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SongListPage(token: token),
            ),
          );
        }
      }
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  Future<String?> _getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticate(context),
          child: Text('Login with Spotify'),
        ),
      ),
    );
  }
}

class AuthCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 스포티파이에서 리다이렉트된 URI에서 코드 추출
    // 여기서는 사용자가 수동으로 코드를 입력하도록 함
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Auth Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: 'Auth Code'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, codeController.text);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class SongListPage extends StatelessWidget {
  final String token;

  SongListPage({required this.token});

  Future<List<dynamic>> fetchSpotifyRecommendations() async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/recommendations?limit=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['tracks'];
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Recommendations'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchSpotifyRecommendations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final song = snapshot.data![index];
                return ListTile(
                  leading: Image.network(song['album']['images'][0]['url']),
                  title: Text(song['name']),
                  subtitle: Text(song['artists'][0]['name']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
