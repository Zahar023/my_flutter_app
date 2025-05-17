import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatItem {
  final int id;
  final String name;
  final String lastMessage;
  final bool isGroup;
  final bool isUnread;
  final bool isPersonal;
  final DateTime lastMessageTime;

  const ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.isGroup,
    required this.isUnread,
    required this.isPersonal,
    required this.lastMessageTime,
  });
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryColor = const Color(0xFF025239);
  final Color secondaryColor = const Color(0xFFB6BDAB);
  final Color backgroundColor = const Color(0xFFF6F6F6);
  final Color textColor = const Color(0xFF2C2C2A);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              floating: true,
              snap: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Transform.scale(
                  scaleY: -1,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      primaryColor.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: _tabController.index == 0
                          ? 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'
                          : 'https://images.unsplash.com/photo-1527529482837-4698179dc6ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: primaryColor),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              backgroundColor: primaryColor,
              title: AnimatedOpacity(
                opacity: innerBoxIsScrolled ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _tabController.index == 0
                    ? const Text('Общение')
                    : const Text('Лента событий'),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: secondaryColor,
                onTap: (index) => setState(() {}),
                tabs: const [
                  Tab(text: 'Чаты', icon: Icon(Icons.chat_bubble_outline)),
                  Tab(text: 'Лента', icon: Icon(Icons.event_note)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            const Expanded(child: ChatSection()),
            const Expanded(child: EventFeedSection()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: Icon(
          _tabController.index == 0 ? Icons.add_comment : Icons.post_add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final Color primaryColor = const Color(0xFF025239);
  final Color secondaryColor = const Color(0xFFB6BDAB);
  final Color textColor = const Color(0xFF2C2C2A);
  
  String activeFilter = 'Все чаты';
  final List<ChatItem> allChats = List.generate(10, (index) {
    final isGroup = index % 3 == 0;
    final isUnread = index % 4 == 0;
    final isPersonal = !isGroup;
    
    return ChatItem(
      id: index,
      name: isGroup ? 'Группа ${index + 1}' : 'Пользователь ${index + 1}',
      lastMessage: 'Последнее сообщение в чате ${index + 1}',
      isGroup: isGroup,
      isUnread: isUnread,
      isPersonal: isPersonal,
      lastMessageTime: DateTime.now().subtract(Duration(hours: index % 5 + 1)),
    );
  });

  List<ChatItem> get filteredChats {
    switch (activeFilter) {
      case 'Личные':
        return allChats.where((chat) => chat.isPersonal).toList();
      case 'Группы':
        return allChats.where((chat) => chat.isGroup).toList();
      case 'Непрочитанные':
        return allChats.where((chat) => chat.isUnread).toList();
      default:
        return allChats;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Поиск в чатах...',
              prefixIcon: Icon(Icons.search, color: secondaryColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterChip('Все чаты'),
              const SizedBox(width: 8),
              _buildFilterChip('Личные'),
              const SizedBox(width: 8),
              _buildFilterChip('Группы'),
              const SizedBox(width: 8),
              _buildFilterChip('Непрочитанные'),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredChats.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final chat = filteredChats[index];
              return _buildChatCard(context, chat);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String text) {
    final isActive = activeFilter == text;
    return FilterChip(
      label: Text(text),
      selected: isActive,
      onSelected: (bool value) {
        setState(() {
          activeFilter = text;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: primaryColor,
      labelStyle: TextStyle(
        color: isActive ? Colors.white : textColor,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isActive ? primaryColor : secondaryColor,
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, ChatItem chat) {
    final timeString = _formatTime(chat.lastMessageTime);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                chatName: chat.name,
                isGroup: chat.isGroup,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: chat.isGroup
                      ? primaryColor.withOpacity(0.1)
                      : secondaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  chat.isGroup ? Icons.group : Icons.person,
                  color: chat.isGroup ? primaryColor : textColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: TextStyle(
                        fontWeight: chat.isUnread ? FontWeight.bold : FontWeight.normal,
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeString,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  if (chat.isUnread)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return time.hour > 12
        ? '${time.hour - 12}:${time.minute.toString().padLeft(2, '0')} PM'
        : '${time.hour}:${time.minute.toString().padLeft(2, '0')} AM';
  }
}

class EventFeedSection extends StatelessWidget {
  final Color primaryColor = const Color(0xFF025239);
  final Color textColor = const Color(0xFF2C2C2A);

  const EventFeedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'type': 'coffee',
        'username': 'Алексей',
        'place': 'Кафе "Утро"',
        'time': '10:00',
        'description': 'Кто хочет выпить кофе в центре?'
      },
      {
        'type': 'movie',
        'username': 'Мария',
        'place': 'Кинотеатр "Звезда"',
        'time': '14:30',
        'description': 'Иду на премьеру нового фильма'
      },
      {
        'type': 'walk',
        'username': 'Иван',
        'place': 'Центральный парк',
        'time': '18:00',
        'description': 'Прогулка по набережной вечером'
      },
      {
        'type': 'lunch',
        'username': 'Ольга',
        'place': 'Ресторан "Восток"',
        'time': '12:00',
        'description': 'Обедаем в новом ресторане'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildEventCard(events[index]);
      },
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Шапка события
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['username']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Приглашает присоединиться',
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Контент события
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['description']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      event['place']!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      event['time']!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Присоединиться',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Написать'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String chatName;
  final bool isGroup;

  const ChatDetailScreen({
    super.key,
    required this.chatName,
    required this.isGroup,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Привет! Как дела?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 30))),
    ChatMessage(
      text: 'Отлично, спасибо! А у тебя?',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 25))),
    ChatMessage(
      text: 'Тоже всё хорошо. Пойдешь на концерт завтра?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 20))),
    ChatMessage(
      text: 'Да, конечно! Уже купил билеты',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 15))),
    ChatMessage(
      text: 'Отлично! Встречаемся у входа в 18:00',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 10))),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF025239);
    final backgroundColor = const Color(0xFFF6F6F6);
    final textColor = const Color(0xFF2C2C2A);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatName),
            if (widget.isGroup)
              const Text(
                '5 участников',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1519681393784-d120267933ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.05),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message, primaryColor, textColor);
                },
              ),
            ),
          ),
          _buildMessageInput(primaryColor, textColor),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, Color primaryColor, Color textColor) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(
                widget.isGroup ? Icons.group : Icons.person,
                size: 18,
                color: primaryColor,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isMe ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isMe)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (widget.isGroup && !isMe)
                    Text(
                      message.isMe ? 'Вы' : 'Участник ${_messages.indexOf(message) % 3 + 1}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isMe ? Colors.white : textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFFB6BDAB),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe)
            const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageInput(Color primaryColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: primaryColor),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Написать сообщение...',
                hintStyle: const TextStyle(color: Color(0xFFB6BDAB)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF6F6F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  setState(() {
                    _messages.insert(
                      0,
                      ChatMessage(
                        text: _messageController.text,
                        isMe: true,
                        time: DateTime.now(),
                      ),
                    );
                    _messageController.clear();
                  });
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}