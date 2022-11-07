class ResidenceModel {
  bool? flagOut;
  String? flagOutTime;
  String? name;
  int? position;

  ResidenceModel(
      {required this.flagOut,
      required this.flagOutTime,
      required this.name,
      required this.position});

  ResidenceModel.fromJson(Map<String, dynamic> json) {
    flagOut = json['flagOut'];
    flagOutTime = json['flagOutTime'];
    name = json['name'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['flagOut'] = flagOut;
    data['flagOutTime'] = flagOutTime;
    data['name'] = name;
    data['position'] = position;
    return data;
  }
}
