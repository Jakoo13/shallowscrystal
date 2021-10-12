class UserModel {
  final String? uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? residence;
  String? avatarUrl;
  String? aboutMe;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.residence,
      this.avatarUrl,
      this.aboutMe});
}
