class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String place;
  final String price;
  final String image;
  final String category;
  final String creatorId;
  final bool isMyEvent;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.place,
    required this.price,
    required this.image,
    required this.category,
    required this.creatorId,
    this.isMyEvent = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'place': place,
      'price': price,
      'image': image,
      'category': category,
      'creatorId': creatorId,
      'isMyEvent': isMyEvent,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      place: map['place'],
      price: map['price'],
      image: map['image'],
      category: map['category'],
      creatorId: map['creatorId'],
      isMyEvent: map['isMyEvent'] ?? false,
    );
  }
}