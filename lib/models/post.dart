class Post {
  final String title;
  final String fees;
  final String content;
  final String type;
  final String datetime;
  final String image;
  final String firstName;
  final String lastName;
  final String email;

  Post(
      {this.title,
      this.fees,
      this.content,
      this.type,
      this.datetime,
      this.image,
      this.firstName,
      this.lastName,
      this.email});

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      title: data["title"],
      fees: data["fees"],
      content: data["content"],
      type: data["type"],
      datetime: data["datetime"],
      image: data["image"],
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "fees": fees,
      "content": content,
      "type": type,
      "datetime": datetime,
      "image": image,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
    };
  }
}
