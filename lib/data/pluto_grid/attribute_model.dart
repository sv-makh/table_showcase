class AttributeModel {
  String? id;
  String? type;
  String? programName;
  String? name;
  String? description;
  String? value;
  String? classAttributeId;

  AttributeModel({
    this.id,
    this.type,
    this.programName,
    this.name,
    this.description,
    this.value,
    this.classAttributeId,
  });

  AttributeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    programName = json['programName'];
    name = json['name'];
    description = json['description'];
    value = json['value'];
    classAttributeId = json['classAttributeId'];
  }
}