package cn.kyson.wallpaper.service.networkaccess;

/**
 * 
 * @author zhujinhui
 * 
 */
public class RequestDataType {
	String mRequestType = null;

	public RequestDataType() {

	}

	public RequestDataType(String type) {
		this.mRequestType = type;
	}

	public String getRequestType() {
		return this.mRequestType;
	}

}
