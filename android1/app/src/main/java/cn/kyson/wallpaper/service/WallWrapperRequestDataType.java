package cn.kyson.wallpaper.service;

import cn.kyson.wallpaper.service.networkaccess.RequestDataType;

public class WallWrapperRequestDataType extends RequestDataType {

	public static final String HOST = "http://sj.zol.com.cn";
	// get recommend list
	public static final String GETRECOMMENDLIST = HOST + "/corp/bizhiClient/getGroupInfo.php";
	// get latest list
	public static final String GETLATESTLIST = HOST + "/corp/bizhiClient/getGroupInfo.php";
	// get category list
	public static final String GETCATEGORYLIST = HOST + "/corp/bizhiClient/getCateInfo.php";
	// get hottest list
	public static final String GETHOTTESTLIST = HOST + "/corp/bizhiClient/getGroupInfo.php";
	// get hottest list
	public static final String GETSECONDARYCATEGORYSELECTEDLIST = HOST + "/corp/bizhiClient/getCateInfo.php";
	// get searchdetail list
	public static final String GETSEARCHDETAILLIST = HOST + "/corp/bizhiClient/getSearchInfo.php";
	// get images list
	public static final String GETIMAGES = HOST + "/corp/bizhiClient/getGroupPic.php";
}
