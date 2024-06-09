class Friend {
  String id;
  String name;
  String email;

  Friend({required this.id, required this.name, required this.email});

  // Convert a Friend object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Convert a Map object into a Friend object
  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
