class User{
  String id ;
  String userName;
  String email ;
  static const String CollectionName = 'users';
  User({required this.email,required this.id,required this.userName});
  User.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    userName: json['userName']! as String,
    email: json['email']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email' : email,
    };
  }

}