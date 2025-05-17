import 'package:flutter/material.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _favoriteEvents = [];
  // Расширенная цветовая палитра
  final List<Color> _categoryColors = [
    const Color(0xFF025239), // Основной зеленый
    const Color(0xFF3A7D44), // Зеленый поярче
    const Color(0xFF4CAF50), // Ярко-зеленый
    const Color(0xFF8BC34A), // Салатовый
    const Color(0xFFCDDC39), // Лимонный
    const Color(0xFFFFC107), // Янтарный
    const Color(0xFFFF9800), // Оранжевый
    const Color(0xFFF44336), // Красный
    const Color(0xFFE91E63), // Розовый
    const Color(0xFF9C27B0), // Фиолетовый
    const Color(0xFF673AB7), // Глубокий фиолетовый
    const Color(0xFF3F51B5), // Индиго
    const Color(0xFF2196F3), // Синий
    const Color(0xFF03A9F4), // Голубой
    const Color(0xFF00BCD4), // Бирюзовый
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Концерты',
      'icon': Icons.live_tv_rounded,
      'colorIndex': 0,
    },
    {
      'title': 'Кино',
      'icon': Icons.movie_creation_rounded,
      'colorIndex': 1,
    },
    {
      'title': 'Спорт',
      'icon': Icons.sports_soccer_rounded,
      'colorIndex': 2,
    },
    {
      'title': 'Выставки',
      'icon': Icons.art_track_rounded,
      'colorIndex': 3,
    },
    {
      'title': 'Фестивали',
      'icon': Icons.celebration_rounded,
      'colorIndex': 4,
    },
    {
      'title': 'Театры',
      'icon': Icons.theater_comedy_rounded,
      'colorIndex': 5,
    },
    {
      'title': 'Еда',
      'icon': Icons.restaurant_rounded,
      'colorIndex': 6,
    },
    {
      'title': 'Наука',
      'icon': Icons.science_rounded,
      'colorIndex': 7,
    },
  ];

  // События по категориям
  final Map<String, List<Map<String, dynamic>>> _eventsByCategory = {
    'Концерты': [
      {
        'title': 'Концерт Xolidayboy"',
        'date': '23 мая 2025, 20:00',
        'place': 'Сибирь - Арена',
        'price': 'от 1600 ₽',
        'image': 'assets/images/xolidayboy.jpg',
        'description': 'Новосибирск ул. Немировича-Данченко, 160\n 23 мая 2025, пятница, 20:00',
      },
    ],
    'Кино': [
      {
        'id': '1',
        'title': 'Кракен',
        'date': 'c 17 апреля',
        'place': 'в 12 кинотеатрах',
        'price': 'от 500 ₽',
        'image': 'assets/images/Кракен.jpg',
        'description': 'Экипаж подводной лодки ищет пропавший крейсер и сталкивается с гигантским чудовищем. Звёзды российского кино в боевике от создателей «Экипажа» и «Т-34»',
        'ticketUrl': 'https://example.com/tickets/123',
      },
      {
        'title': 'В списках не значился',
        'date': 'с 1 мая',
        'place': 'в 14 кинотеатрах',
        'price': 'от 500 ₽',
        'image': 'assets/images/вСписках.jpg',
        'description': '19-летний лейтенант прибывает на службу в Брестскую крепость 21 июня 1941 года. Военная драма по повести Бориса Васильева',
      },
    ],
    'Спорт': [
      {
        'title': 'Футбольный матч',
        'date': '25 мая 2025, 19:30',
        'place': 'Стадион "Спартак"',
        'price': 'от 2000 ₽',
        'image': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
        'description': 'Чемпионат России по футболу. Спартак vs Зенит.',
      },
    ],
  };

  // Контроллеры анимаций
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('События', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(1.0, 1.0)),
                    ],
                  ),
                ),
                centerTitle: true,
                background: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF025239).withAlpha(204), // 80% opacity
                        Colors.transparent,
                      ],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _showSearchDialog(context),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_outlined, 
                        color: Color(0xFF025239)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Фильтры...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600),
                            ),
                          onTap: () => _showFilterBottomSheet(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final color = _categoryColors[category['colorIndex'] % _categoryColors.length];
              
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildCategoryCard(
                        title: category['title'] as String,
                        icon: category['icon'] as IconData,
                        color: color,
                        onTap: () {
                          _openCategoryEvents(context, category['title'] as String);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withAlpha(204), // 80% opacity
                color.withAlpha(102), // 40% opacity
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51), // 20% opacity
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategoryEvents(BuildContext context, String category) {
    final events = _eventsByCategory[category] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF6F6F6),
          appBar: AppBar(
            title: Text(category),
            backgroundColor: _categoryColors[_categories
                .firstWhere((c) => c['title'] == category)['colorIndex']],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 48,
                        color: const Color(0xFFB6BDAB),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Скоро здесь появятся события',
                        style: TextStyle(
                          color: Color(0xFF2C2C2A),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildEventCard(context, events[index]),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _openEventDetails(context, event);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
  child: event['image'].startsWith('http') 
      ? Image.network(  // Для сетевых изображений
          event['image'],
          height: 140,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
        )
      : Image.asset(  // Для локальных изображений
          event['image'],
          height: 140,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
        ),
),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildEventDetailRow(
                    Icons.calendar_today,
                    event['date'],
                  ),
                  const SizedBox(height: 8),
                  _buildEventDetailRow(
                    Icons.location_on,
                    event['place'],
                  ),
                  const SizedBox(height: 8),
                  _buildEventDetailRow(
                    Icons.attach_money,
                    event['price'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFB6BDAB)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF2C2C2A)),
        ),
      ],
    );
  }

  void _openEventDetails(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 16),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB6BDAB),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: event['image'].startsWith('http')
      ? Image.network(  // Для сетевых
          event['image'],
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
        )
      : Image.asset(  // Для локальных
          event['image'],
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
        ),
),
                      const SizedBox(height: 24),
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailSection(
                        Icons.calendar_today,
                        'Дата и время',
                        event['date'],
                      ),
                      _buildDetailSection(
                        Icons.location_on,
                        'Место',
                        event['place'],
                      ),
                      _buildDetailSection(
                        Icons.attach_money,
                        'Стоимость',
                        event['price'],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Описание',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C2C2A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C2C2A),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF025239),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // Реализовать открытие ссылки на покупку билетов
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Переход к покупке билетов'),
                              ),
                            );
                          },
                          child: const Text(
                            'Купить билет',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

Widget _buildErrorPlaceholder() {
  return Container(
    color: const Color(0xFFF6F6F6),
    child: Center(
      child: Icon(
        Icons.broken_image,
        color: const Color(0xFFB6BDAB),
        size: 40,
      ),
    ),
  );
}

  Widget _buildDetailSection(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: const Color(0xFF025239)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB6BDAB),
                  )),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C2C2A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Поиск событий...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF025239),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Искать'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Фильтры событий',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption('Бесплатные', false),
              _buildFilterOption('Сегодня', false),
              _buildFilterOption('Ближайшие', true),
              _buildFilterOption('Популярные', false),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF025239),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Применить фильтры'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {},
            activeColor: const Color(0xFF025239),
          ),
          Text(title),
        ],
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> event) {
  final favorites = _favoriteEvents; // List<Map> в состоянии
  final isFavorite = favorites.any((e) => e['id'] == event['id']);
  
  setState(() {
    if (isFavorite) {
      favorites.removeWhere((e) => e['id'] == event['id']);
    } else {
      favorites.add(event);
    }
  });
  
  // Здесь можно добавить сохранение в SharedPreferences или БД
}

}
