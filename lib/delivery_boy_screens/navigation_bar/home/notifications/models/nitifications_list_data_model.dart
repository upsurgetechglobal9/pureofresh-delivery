class NotificationsDataNewDataModel {
  String id;
  String fromTablePrimaryId;
  String comment;
  String fromTableName;
  String toTablePrimaryKey;
  String toTableName;
  String createdAt;
  String updatedAt;
  String status;
  String seenStatus;
  dynamic type;
  String displayTime;

  NotificationsDataNewDataModel({
    required this.id,
    required this.fromTablePrimaryId,
    required this.comment,
    required this.fromTableName,
    required this.toTablePrimaryKey,
    required this.toTableName,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.seenStatus,
    required this.type,
    required this.displayTime,
  });

  factory NotificationsDataNewDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationsDataNewDataModel(
      id: json["id"],
      fromTablePrimaryId: json["from_table_primary_id"] ?? 'NA',
      comment: json["comment"] ?? 'NA',
      fromTableName: json["from_table_name"] ?? 'NA',
      toTablePrimaryKey: json["to_table_primary_key"] ?? 'NA',
      toTableName: json["to_table_name"] ?? 'NA',
      createdAt: json["created_at"] ?? 'NA',
      updatedAt: json["updated_at"] ?? 'NA',
      status: json["status"] ?? 'NA',
      seenStatus: json["seen_status"] ?? 'NA',
      type: json["type"] ?? 'NA',
      displayTime: json["display_time"] ?? 'NA',
    );
  }
}