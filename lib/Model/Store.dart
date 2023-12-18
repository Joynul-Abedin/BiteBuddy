class Store {
  String? id;
  final String name;
  final Address address;
  final Location location;
  final String owner; // Assuming owner ID is sufficient
  final Contact contact;
  final String description;
  final List<String> categories;
  final List<String> menu; // Assuming menu contains IDs of FoodItems
  final Hours hours;
  final List<Rating> ratings;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  Store({
    this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.owner,
    required this.contact,
    required this.description,
    required this.categories,
    required this.menu,
    required this.hours,
    required this.ratings,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      name: json['name'],
      address: Address.fromJson(json['address']),
      location: Location.fromJson(json['location']),
      owner: json['owner'],
      contact: Contact.fromJson(json['contact']),
      description: json['description'],
      categories: List<String>.from(json['categories']),
      menu: List<String>.from(json['menu'].map((item) => item.toString())),
      hours: Hours.fromJson(json['hours']),
      ratings: List<Rating>.from(
          json['ratings'].map((item) => Rating.fromJson(item))),
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['address'] = address.toJson();
    data['location'] = location.toJson();
    data['owner'] = owner;
    data['contact'] = contact.toJson();
    data['description'] = description;
    data['categories'] = categories;
    data['menu'] = menu;
    data['hours'] = hours.toJson();
    data['ratings'] = ratings.map((item) => item.toJson()).toList();
    data['images'] = images;
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedAt'] = updatedAt.toIso8601String();
    return data;
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zipCode'] = zipCode;
    data['country'] = country;
    return data;
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Contact {
  final String phone;
  final String email;
  final String website;

  Contact({
    required this.phone,
    required this.email,
    required this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'],
      email: json['email'],
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['email'] = email;
    data['website'] = website;
    return data;
  }
}

class Hours {
  final Map<String, OpenClose> dayHours;

  Hours({required this.dayHours});

  factory Hours.fromJson(Map<String, dynamic> json) {
    Map<String, OpenClose> hours = {};
    json.forEach((key, value) {
      hours[key] = OpenClose.fromJson(value);
    });
    return Hours(dayHours: hours);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    dayHours.forEach((key, value) {
      data[key] = value.toJson();
    });
    return data;
  }
}

class OpenClose {
  final String open;
  final String close;

  OpenClose({required this.open, required this.close});

  factory OpenClose.fromJson(Map<String, dynamic> json) {
    return OpenClose(
      open: json['open'],
      close: json['close'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open'] = open;
    data['close'] = close;
    return data;
  }
}

class Rating {
  final double rating;
  final String user; // Assuming the user ID is sufficient
  final String review;
  final DateTime date;

  Rating({
    required this.rating,
    required this.user,
    required this.review,
    required this.date,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'].toDouble(),
      user: json['user'],
      review: json['review'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['user'] = user;
    data['review'] = review;
    data['date'] = date.toIso8601String();
    return data;
  }
}
