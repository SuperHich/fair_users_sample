class Location {
  final String city;
  final String country;
  final String state;
  final String street;
  final String timezone;

  Location({
    required this.city,
    required this.country,
    required this.state,
    required this.street,
    required this.timezone,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      country: json['country'],
      state: json['state'],
      street: json['street'],
      timezone: json['timezone'],
    );
  }
}