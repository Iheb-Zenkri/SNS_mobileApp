class Client {
  final int id;
  String name;
  String phoneNumber;

  Client({required this.id, required this.name, required this.phoneNumber});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'].toString(),
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'phoneNumber' : phoneNumber
    };
  }
}
