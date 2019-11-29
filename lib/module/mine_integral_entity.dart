class MineIntegralEntity {
	MineIntegralData data;
	int errorCode;
	String errorMsg;

	MineIntegralEntity({this.data, this.errorCode, this.errorMsg});

	MineIntegralEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new MineIntegralData.fromJson(json['data']) : null;
		errorCode = json['errorCode'];
		errorMsg = json['errorMsg'];
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

class MineIntegralData {
	int rank;
	int userId;
	int coinCount;
	String username;
	int level;

	MineIntegralData({this.rank, this.userId, this.coinCount, this.username,this.level});

	MineIntegralData.fromJson(Map<String, dynamic> json) {
		rank = json['rank'];
		userId = json['userId'];
		coinCount = json['coinCount'];
		username = json['username'];
		level = json['level'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['rank'] = this.rank;
		data['userId'] = this.userId;
		data['coinCount'] = this.coinCount;
		data['username'] = this.username;
		data['level'] = this.level;
		return data;
	}
}
