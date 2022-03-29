class Restaurant {
  String id;
  String restName;
  String imageUrl;
  double latitude;
  double longitude;
  String locality;

  Restaurant(this.id, this.restName,
      {this.imageUrl, this.latitude, this.longitude, this.locality});

  @override
  bool operator ==(Object other) {
    if (other is Restaurant) {
      return this.id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}
