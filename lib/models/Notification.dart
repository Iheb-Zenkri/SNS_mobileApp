import 'package:timeago/timeago.dart' as timeago;


class Notifications {
  final int id;
  int? userId;
  int ownerId ;
  bool isRead ;
  String type ;
  String description;
  String? username;
  String? picName;
  String? updatedDate;

  Notifications({required this.id, required this.ownerId, required this.isRead,
                  required this.type, required this.description,this.userId,
                  this.username,this.picName,this.updatedDate});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      ownerId: json['fromUserId'],
      isRead:  json['isRead'],
      type: json['type'],
      description: json['description'],
      userId :json['ownerUserId'],
      username: json['user']['username'],
      picName: json['user']['picName'],
      updatedDate: json['updatedAt']
    );
  }

  String getTimeAgo(){
    timeago.setLocaleMessages('fr', timeago.FrMessages());

  DateTime timestamp = DateTime.parse(updatedDate!);

  String timeAgoInFrench = timeago.format(timestamp, locale: 'fr');

    return timeAgoInFrench ;
  }

}
