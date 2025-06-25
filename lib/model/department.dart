class DepartmentList {
  bool? status;
  String? message;
 List<Department>? programs;

   DepartmentList({this.status, this.message, this.programs});

  factory DepartmentList.fromJson(Map<String, dynamic> json) {
    return DepartmentList(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      programs: (json['programs'] as List<dynamic>?)
          ?.map((e) => Department.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'programs': programs?.map((e) => e.toJson()).toList(),
    };
  }
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
