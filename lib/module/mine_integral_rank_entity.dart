class MineIntegralRankEntity {
	MineIntegralRankData data;
	int errorCode;
	String errorMsg;

	MineIntegralRankEntity({this.data, this.errorCode, this.errorMsg});

	MineIntegralRankEntity.fromJson(Map<String, dynamic> json) {
		data = json['data'] != null ? new MineIntegralRankData.fromJson(json['data']) : null;
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

class MineIntegralRankData {
	bool over;
	int pageCount;
	int total;
	int curPage;
	int offset;
	int size;
	List<MineIntegralRankDataData> datas;

	MineIntegralRankData({this.over, this.pageCount, this.total, this.curPage, this.offset, this.size, this.datas});

	MineIntegralRankData.fromJson(Map<String, dynamic> json) {
		over = json['over'];
		pageCount = json['pageCount'];
		total = json['total'];
		curPage = json['curPage'];
		offset = json['offset'];
		size = json['size'];
		if (json['datas'] != null) {
			datas = new List<MineIntegralRankDataData>();(json['datas'] as List).forEach((v) { datas.add(new MineIntegralRankDataData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['over'] = this.over;
		data['pageCount'] = this.pageCount;
		data['total'] = this.total;
		data['curPage'] = this.curPage;
		data['offset'] = this.offset;
		data['size'] = this.size;
		if (this.datas != null) {
      data['datas'] =  this.datas.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class MineIntegralRankDataData {
	int level;
	int rank;
	int userId;
	int coinCount;
	String username;

	MineIntegralRankDataData({this.level, this.rank, this.userId, this.coinCount, this.username});

	MineIntegralRankDataData.fromJson(Map<String, dynamic> json) {
		level = json['level'];
		rank = json['rank'];
		userId = json['userId'];
		coinCount = json['coinCount'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['level'] = this.level;
		data['rank'] = this.rank;
		data['userId'] = this.userId;
		data['coinCount'] = this.coinCount;
		data['username'] = this.username;
		return data;
	}
}
