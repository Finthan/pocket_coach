class User {
  late int id;
  late String username;
  late int age;
  late String lastMessage;
  late String time;
  late String status;
  late String unReadMessage;
  late bool isRead;

  User(
    this.id,
    this.username,
    this.age,
    this.lastMessage,
    this.time,
    this.status,
    this.unReadMessage,
    this.isRead,
  );
}

class Message {
  late bool isMe;
  late String message;
  late String time;

  Message(this.isMe, this.message, this.time);
}

class Training {
  late String nameIcon;
  late String name;
  late String date;

  Training(this.nameIcon, this.name, this.date);
}
