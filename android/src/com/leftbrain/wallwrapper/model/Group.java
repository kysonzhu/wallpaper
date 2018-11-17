package com.leftbrain.wallwrapper.model;

public class Group {
	public String gId;
	public String gName;
	public String voteGood;
	public String subId;
	public String downNum;
	public String editDate;
	public String picNum;
	public String coverImgUrl;

	public static Group newGroupSample(){
		Group group = new Group();
		group.gId = "2121212";
		group.coverImgUrl = "http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1421830922198.jpg";
		return group;
	}

	@Override
	public String toString() {
		return "Group [gId=" + gId + ", gName=" + gName + ", voteGood=" + voteGood + ", subId=" + subId + ", downNum=" + downNum + ", editDate=" + editDate + ", picNum=" + picNum + ", coverImgUrl=" + coverImgUrl + "]";
	}
} 