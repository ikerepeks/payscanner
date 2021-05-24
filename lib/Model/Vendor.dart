class Vendor {
  final String email;
  final String token;

  Vendor({this.email, this.token});

  Vendor.fromMap(Map<String, dynamic> res)
      : email = res["email"],
        token = res["token"];

  Map<String, Object> toMap() {
    return {'email': email, 'token': token};
  }

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      email: json['email'],
      token: json['access_token'],
    );
  }
}
