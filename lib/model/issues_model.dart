class Issues {
  String? to;
  DateTime? createdDate;
  int? id;
  DateTime? updatedDate;
  String? subject;
  String? description;
  String? createdBy;
  String? updatedBy;
  bool? isOpen;

  Issues({
    this.to,
    this.createdDate,
    this.createdBy,
    this.subject,
    this.description,
    this.updatedBy,
    this.id,
    this.updatedDate,
    this.isOpen,
  });
  factory Issues.fromJson(Map<String, dynamic> data) {
    return Issues(
      to: data['assigned_to'],
      createdDate: DateTime.tryParse(data['created_at']),
      updatedDate: DateTime.tryParse(data['updated_at']),
      subject: data['subject'],
      description: data['description'],
      createdBy: data['created_by'],
      id: data['id'],
      updatedBy: data['updated_by'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'assigned_to': to,
      'created_at': createdDate,
      'updated_at': updatedDate,
      'subject': subject,
      'description': description,
      'id': id,
      'updated_by': updatedBy,
    };
  }
}

class IssueResponse {
  bool? status;
  String? message;
  List<Issues>? openIssues;
  List<Issues>? closedIssues;

  IssueResponse({this.status, this.message, this.openIssues, this.closedIssues});

  factory IssueResponse.fromJson(Map<String, dynamic> json) {
    return IssueResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      openIssues: (json['open_issues'] as List<dynamic>?)?.map((e) => Issues.fromJson(e as Map<String, dynamic>)).toList(),
      closedIssues: (json['closed_issues'] as List<dynamic>?)?.map((e) => Issues.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'open_issues': openIssues?.map((e) => e.toJson()).toList(),
      'closed_issues': closedIssues?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '$openIssues';
  }
}
