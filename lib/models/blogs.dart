class Blogs {
  String image, uid, authorname, title, description, likes, date, time;
  int timeStamp;
  Blogs(
      {this.image,
      this.uid,
      this.authorname,
      this.title,
      this.description,
      this.date,
      this.likes,
      this.time,
      this.timeStamp})
      : super();

  factory Blogs.fromJson(Map<String, dynamic> parsedJson) {
    return Blogs(
        image: parsedJson['image'] ?? '',
        uid: parsedJson['uid'] ?? '',
        authorname: parsedJson['authorname'] ?? '',
        title: parsedJson['title'] ?? '',
        description: parsedJson['description'] ?? '',
        date: parsedJson['date'] ?? '',
        likes: parsedJson['likes'] ?? '',
        time: parsedJson['time'] ?? '',
        timeStamp: parsedJson['timeStamp'] ?? '');
  }
}
