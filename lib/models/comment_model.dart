class CommentModel {
  String? name;
  String? uId;
  String? imageProfile;
  String? dateTime;
  String? text;

  CommentModel({
    this.name,
    this.uId,
    this.imageProfile,
    this.dateTime,
    this.text,
});

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    imageProfile = json['imageProfile'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String, dynamic> toMap (){
    return {
      'name' : name,
      'uId' : uId,
      'imageProfile' : imageProfile,
      'dateTime' : dateTime,
      'text' : text,
    };
  }
}
