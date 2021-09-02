class Room{
  static const COLLECTION_NAME = 'rooms';
  String id;
  String name;
  String description ;
  String cateogry;
  bool type;
  List usersJoined;

  Room({required this.name , required this.id , required this.description ,
    required this.cateogry, required this.type , required this.usersJoined });

  Room.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name : json['name']! as String,
    description: json['description']! as String,
    cateogry : json['cateogry']! as String,
    type : json['type']! as bool,
    usersJoined: json['usersJoined']! as List,
  );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'description' : description,
      'cateogry' : cateogry,
      'type' : type,
      'usersJoined': usersJoined,
    };
  }
}
/*
class Joined
{
  String UsedId;

  Joined({required this.UsedId});

  Joined.fromJson(Map<String, Object?> json)
      : this(
    UsedId: json['UsedId']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'UsedId': UsedId,
    };
  }

}

 */