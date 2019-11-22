
import 'dart:convert';

class UserModuleEntity {
	UserModuleData data;
	int errorCode;
	String errorMsg;

	UserModuleEntity.fromParams({this.data, this.errorCode, this.errorMsg});

	factory UserModuleEntity(jsonStr) => jsonStr == null ? null : jsonStr is String ? new UserModuleEntity.fromJson(json.decode(jsonStr)) : new UserModuleEntity.fromJson(jsonStr);

	UserModuleEntity.fromJson(jsonStr) {
		data = jsonStr['data'] != null ? new UserModuleData.fromJson(jsonStr['data']) : null;
		errorCode = jsonStr['errorCode'];
		errorMsg = jsonStr['errorMsg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['errorCode'] = this.errorCode;
		data['errorMsg'] = this.errorMsg;
		return data;
	}
}

class UserModuleData {
	String password;
	String publicName;
	List<dynamic> chapterTops;
	String icon;
	String nickname;
	bool admin;
	List<int> collectIds;
	int id;
	int type;
	String email;
	String token;
	String username;
	String headImage ="https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=152324055,1103140196&fm=15&gp=0.jpg";

	UserModuleData({this.password, this.publicName, this.chapterTops, this.icon,
		this.nickname, this.admin, this.collectIds, this.id, this.type, this.email, this.token, this.username,this.headImage});

	UserModuleData.fromJson(Map<String, dynamic> json) {
		password = json['password'];
		publicName = json['publicName'];
		if (json['chapterTops'] != null) {
			chapterTops = new List<dynamic>();
		}
		icon = json['icon'];
		nickname = json['nickname'];
		admin = json['admin'];
		if (json['collectIds'] != null) {
			collectIds = new List<int>();
		}
		id = json['id'];
		type = json['type'];
		email = json['email'];
		token = json['token'];
		username = json['username'];
		headImage = headImage;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['password'] = this.password;
		data['publicName'] = this.publicName;
		if (this.chapterTops != null) {
      data['chapterTops'] =  this.chapterTops;
    }
		data['icon'] = this.icon;
		data['nickname'] = this.nickname;
		data['admin'] = this.admin;
		if (this.collectIds != null) {
      data['collectIds'] =  this.collectIds;
    }
		data['id'] = this.id;
		data['type'] = this.type;
		data['email'] = this.email;
		data['token'] = this.token;
		data['username'] = this.username;
		data['headImage'] = this.headImage;
		return data;
	}
}
