class Room{
  static const COLLECTION_NAME = 'rooms';
  String id;
  String name;
  String description ;
  String cateogry;
  bool type;

  Room({required this.name , required this.id ,
    required this.description , required this.cateogry, required this.type });

  Room.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name : json['name']! as String,
    description: json['description']! as String,
    cateogry : json['cateogry']! as String,
    type : json['type']! as bool,
  );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'description' : description,
      'cateogry' : cateogry,
      'type' : type,
    };
  }
}