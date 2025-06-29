import 'package:flutter/material.dart';
import 'package:capybooklist/services/weather_service.dart';
import 'package:capybooklist/models/weather.dart';
import 'package:capybooklist/db/user_dao.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;
  bool _isLoading = true;
  String _error = '';
  String _userName = '';
  String _userCity = 'Jakarta';

  final _weatherService = WeatherService();

  final List<String> _historyBooks = [
    'Book 1', 'Book 2', 'Book 3', 'Book 4', 'Book 5'
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUser();
    await _loadWeather();
  }

  Future<void> _loadUser() async {
    final user = await UserDao().getUser();
    if (mounted) {
      setState(() {
        _userName = user?.name ?? '';
        if (user?.city != null && user!.city.trim().isNotEmpty) {
          _userCity = user.city.trim();
        }
      });
    }
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await _weatherService.fetchWeather(_userCity);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load weather';
        _isLoading = false;
      });
    }
  }

  String _getWeatherIcon() {
    final desc = _weather?.description.toLowerCase() ?? '';
    if (desc.contains('clear') || desc.contains('cerah')) {
      return 'assets/images/hujian-cerah.png';
    } else if (desc.contains('cloud') || desc.contains('awan')) {
      return 'assets/images/awan-berangin-malam.png';
    } else if (desc.contains('rain') || desc.contains('hujan')) {
      return 'assets/images/hujan-malam.png';
    } else if (desc.contains('drizzle') || desc.contains('gerimis')) {
      return 'assets/images/gerimis-cerah.png';
    } else if (desc.contains('wind') || desc.contains('angin')) {
      return 'assets/images/angin.png';
    }
    return 'assets/images/awan-berangin-malam.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Picture1.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                ? Center(
              child: Text(
                _error,
                style: const TextStyle(color: Colors.white),
              ),
            )
                : _buildContent(),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_weather == null) {
      return const Center(
        child: Text(
          'No weather data available.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ---------- Layout 1 ----------
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weather!.cityName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          _getWeatherIcon(),
                          width: 28,
                          height: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    Text(
                      '${_weather!.temperature.toStringAsFixed(0)}°',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      _userName.isEmpty ? 'Hello 👋' : 'Hello $_userName 👋',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      'ingin baca apa hari ini ?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Image.asset(
                  'assets/images/rumah.png',
                  width: 320,
                  height: 320,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),

        // ---------- Layout 2 ----------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'History Books',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _historyBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final book = _historyBooks[index];
                    return Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white38),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.book, color: Colors.white, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            book,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
