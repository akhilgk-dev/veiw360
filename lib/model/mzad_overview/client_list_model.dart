class Organization {
  final int id;
  final String organizationName;
  final String organizationNameAr;
  final String fileOrganizationImage;
  final String organizationImageUrl;

  Organization({
    required this.id,
    required this.organizationName,
    required this.organizationNameAr,
    required this.fileOrganizationImage,
    required this.organizationImageUrl,
  });

  // Factory method to create an Organization instance from JSON
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      organizationName: json['organization_name'],
      organizationNameAr: json['organization_name_ar'],
      fileOrganizationImage: json['file_organization_image'],
      organizationImageUrl: json['organization_image_url'],
    );
  }

  // Method to convert an Organization instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_name': organizationName,
      'organization_name_ar': organizationNameAr,
      'file_organization_image': fileOrganizationImage,
      'organization_image_url': organizationImageUrl,
    };
  }

  // Static method to create a list of Organization instances from a list of JSON objects
  static List<Organization> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Organization.fromJson(json)).toList();
  }
}
