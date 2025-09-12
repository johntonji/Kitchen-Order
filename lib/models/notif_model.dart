class NotifModel {
  String notiUuid;
  String? notiType;
  String? message;
  String? date;
  String? imageType;
  String? image;
  String? url;

  NotifModel({
   required this.notiUuid,
   this.notiType,
   this.message,
   this.date,
   this.imageType,
   this.image,
   this.url
  });

 factory NotifModel.fromJson(Map<String, dynamic> json) {
    return NotifModel(
      notiUuid: json['notification_uuid'] ?? '',
      notiType: json['notification_type'] ,
      message:  json['message'],
      date:json['date'] ?? '',
      imageType:json['image_type'] ?? '',
      image:json['image'] ?? '',
      url:json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["notification_uuid"]=notiUuid ;
    data['notification_type'] = notiType ??"";
    data['message'] = message ?? "";
    data["date"]=date;
    data["image_type"]=imageType;
    data["image"]=image;
    data["url"]=url;
    return data;
    
  }


}