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
      phoneNumber: json['phoneNumber']??"",
      isAvailable: json['availability']??true,
      isDeleted: json['deleted']??false,
    );
  }


   Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'phoneNumber' : phoneNumber,
      'availability':isAvailable,
      'deleted':isDeleted,
    };
  }

  @override
    bool operator ==(Object other)=>
      identical(this, other) || other is Worker &&
      runtimeType == other.runtimeType &&
      id == other.id ;
  @override
    int get hashCode => id.hashCode;
}