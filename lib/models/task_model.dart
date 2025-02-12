class TaskModel {
  String? id;
  String? name;
  String? description;
  bool? isCompleted;

  TaskModel({
    this.id,
    this.name,
    this.description,
    this.isCompleted,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
