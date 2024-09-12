class Worker {
  final int id;
  String name;
  String phoneNumber;
  bool isAvailable ;
  bool isDeleted ;

  Worker({required this.id, 
        required this.name, 
        required this.phoneNumber,
        required this.isAvailable,
        required this.isDeleted
  });


  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'].toString(),
      isAvailable: json['availability'],
      isDeleted: json['deleted'],
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