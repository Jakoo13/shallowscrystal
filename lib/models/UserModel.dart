class UserModel {
  final String? uid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? residence;
  final String? photoURL;
  String? avatarUrl;
  String? aboutMe;
  String? personalBest;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.residence,
      this.photoURL,
      this.avatarUrl,
      this.aboutMe,
      this.personalBest});
}
