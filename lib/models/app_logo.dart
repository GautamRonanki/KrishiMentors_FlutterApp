class AppLogo {
  String bannerImage;
  String lightLogo;
  String darkLogo;
  String smallLogo;
  String favicon;

  AppLogo(
      {this.bannerImage,
        this.lightLogo,
        this.darkLogo,
        this.smallLogo,
        this.favicon});

  AppLogo.fromJson(Map<String, dynamic> json) {
    bannerImage = json['banner_image'];
    lightLogo = json['light_logo'];
    darkLogo = json['dark_logo'];
    smallLogo = json['small_logo'];
    favicon = json['favicon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_image'] = this.bannerImage;
    data['light_logo'] = this.lightLogo;
    data['dark_logo'] = this.darkLogo;
    data['small_logo'] = this.smallLogo;
    data['favicon'] = this.favicon;
    return data;
  }
}
