class TaskModel {
  DateTime? createdAt;
  String? id;
  String? name;
  String? description;
  bool? isCompleted;
  bool? isPendingToUpdate;
  bool? isPendingToCreate;

  TaskModel({
    this.id,
    this.name,
    this.description,
    this.isCompleted,
    this.createdAt,
    this.isPendingToUpdate,
    this.isPendingToCreate,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isCompleted = json['isCompleted'];
    createdAt = DateTime.parse(json['createdAt']);
    isPendingToUpdate = json['isPendingToUpdate'] ?? false;
    isPendingToCreate = json['isPendingToCreate'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['isCompleted'] = isCompleted;
    data['createdAt'] = createdAt.toString();
    data['isPendingToUpdate'] = isPendingToUpdate;
    data['isPendingToCreate'] = isPendingToCreate;
    return data;
  }
}
