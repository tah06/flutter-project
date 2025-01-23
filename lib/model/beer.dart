class Beer {
  late final String name;
  late final String category;
  late final String countryOfOrigin;
  final DateTime tastedDate;
  late final String rating;
  late final String? comments;

  Beer({
    required this.name,
    required this.category,
    required this.countryOfOrigin,
    required this.tastedDate,
    required this.rating,
    this.comments,
  });

  // Factory constructor to create a Beer instance from a JSON map
  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      name: json['name'],
      category: json['category'],
      countryOfOrigin: json['countryOfOrigin'],
      tastedDate: DateTime.parse(json['tastedDate']),
      rating: json['rating'],
      comments: json['comments'],
    );
  }

  // Method to convert a Beer instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'countryOfOrigin': countryOfOrigin,
      'tastedDate': tastedDate.toIso8601String(),
      'rating': rating,
      'comments': comments,
    };
  }
}
