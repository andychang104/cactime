
class Contact{
  int id;
  String name;
  String phone;

  //Contact();

  Contact({
    this.id,
    this.name,
    this.phone});

  factory Contact.fromJson(Map<String, dynamic> parsedJson){
    return Contact(
      id:parsedJson['id'],
      name:parsedJson['name'],
      phone:parsedJson['phone'],
    );
  }

}