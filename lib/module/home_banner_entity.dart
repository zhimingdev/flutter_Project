import 'dart:convert';

class HomeBannerEntity {
	List<HomeBannerData> data;
	int errorCode;
	String errorMsg;

//	HomeBannerEntity({this.data, this.errorCode, this.errorMsg});

	factory HomeBannerEntity(jsonStr) => jsonStr == null ? null : jsonStr is String ? new HomeBannerEntity.fromJson(json.decode(jsonStr)) : new HomeBannerEntity.fromJson(jsonStr);

	HomeBannerEntity.fromJson(json) {
		if (json['data'] != null) {
			data = new List<HomeBannerData>();(json['data'] as List).forEach((v) { data.add(new HomeBannerData.fromJson(v)); });
		}
		errorCode = json['errorCode'];
		errorMsg = json['errorMsg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		data['errorCode'] = this.errorCode;
		data['errorMsg'] = this.errorMsg;
		return data;
	}
}

class HomeBannerData {
	String imagePath;
	int id;
	int isVisible;
	String title;
	int type;
	String url;
	String desc;
	int order;

	HomeBannerData({this.imagePath, this.id, this.isVisible, this.title, this.type, this.url, this.desc, this.order});

	HomeBannerData.fromJson(Map<String, dynamic> json) {
		imagePath = json['imagePath'];
		id = json['id'];
		isVisible = json['isVisible'];
		title = json['title'];
		type = json['type'];
		url = json['url'];
		desc = json['desc'];
		order = json['order'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['imagePath'] = this.imagePath;
		data['id'] = this.id;
		data['isVisible'] = this.isVisible;
		data['title'] = this.title;
		data['type'] = this.type;
		data['url'] = this.url;
		data['desc'] = this.desc;
		data['order'] = this.order;
		return data;
	}
}
