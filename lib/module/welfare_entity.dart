import 'dart:convert';

class WelfareEntity {
	bool error;
	List<WelfareResult> results;

	factory WelfareEntity(jsonStr) => jsonStr == null ? null : jsonStr is String ? new WelfareEntity.fromJson(json.decode(jsonStr)) : new WelfareEntity.fromJson(jsonStr);

	WelfareEntity.fromJson(json) {
		error = json['error'];
		if (json['results'] != null) {
			results = new List<WelfareResult>();(json['results'] as List).forEach((v) { results.add(new WelfareResult.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['error'] = this.error;
		if (this.results != null) {
      data['results'] =  this.results.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class WelfareResult {
	String createdAt;
	String publishedAt;
	String sId;
	String source;
	bool used;
	String type;
	String url;
	String desc;
	String who;

	WelfareResult({this.createdAt, this.publishedAt, this.sId, this.source, this.used, this.type, this.url, this.desc, this.who});

	WelfareResult.fromJson(Map<String, dynamic> json) {
		createdAt = json['createdAt'];
		publishedAt = json['publishedAt'];
		sId = json['_id'];
		source = json['source'];
		used = json['used'];
		type = json['type'];
		url = json['url'];
		desc = json['desc'];
		who = json['who'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['createdAt'] = this.createdAt;
		data['publishedAt'] = this.publishedAt;
		data['_id'] = this.sId;
		data['source'] = this.source;
		data['used'] = this.used;
		data['type'] = this.type;
		data['url'] = this.url;
		data['desc'] = this.desc;
		data['who'] = this.who;
		return data;
	}
}
