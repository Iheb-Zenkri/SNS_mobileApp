class Client {
  final int id;
  String name;
  String phoneNumber;
  bool isDeleted ;
  String? note ;

  Client({required this.id, required this.name, required this.phoneNumber,
          required this.isDeleted, this.note});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'].toString(),
      isDeleted: json['deleted'],
      note: json['note']??""
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'phoneNumber' : phoneNumber,
      'deleted' : isDeleted,
      'note' : note??"",
    };
  }
}
