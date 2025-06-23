class DepartmentModel {
  bool? status;
  String? message;
}

class Department {
  String? name;
  String? category;
  int? id;
  Department({
    this.id,
    this.category,
    this.name,
  });
  factory Department.fromJson(Map<String, dynamic>? data) {
    return Department(
      id: data?['id'],
      category: data?['category'],
      name: data?['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
    };
  }
}
