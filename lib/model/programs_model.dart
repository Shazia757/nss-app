class Program {
  int? id;
  String? name;
  String? description;
  DateTime? date;
  int? duration;
  String? createdBy;

  Program({
    this.id,
    this.name,
    this.description,
    this.date,
    this.duration,
    this.createdBy,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      duration: json['duration'] as int?,
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date?.toIso8601String(),
      'duration': duration,
      'created_by': createdBy,
    };
  }
}


class ProgramResponse {
  bool? status;
  String? message;
  List<Program>? programs;

  ProgramResponse({
    this.status,
    this.message,
    this.programs,
  });

  factory ProgramResponse.fromJson(Map<String, dynamic> json) {
    return ProgramResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      programs: (json['programs'] as List<dynamic>?)
          ?.map((e) => Program.fromJson(e as Map<String, dynamic>))
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
