package cn.kyson.wallpaper.service.networkaccess;

public class ServiceResponse<T> {
	private int returnCode;
	private String returnDesc;
	private String operatCode;
	private T response;
	private String requestToken;

	private String method;
	private String activityClass;
	private String activityToken;

	public String getActivityClass() {
		return activityClass;
	}

	public void setActivityClass(String aClass) {
		activityClass = aClass;
	}

	public String getActivityToken() {
		return activityToken;
	}

	public void setActivityToken(String token) {
		activityToken = token;
	}

	public String getRequestMethod() {
		return method;
	}

	public void setRequestMethod(String md) {
		method = md;
	}

	public String getRequestToken() {
		return requestToken;
	}

	public void setRequestToken(String token) {
		requestToken = token;
	}

	public int getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(int returnCode) {
		this.returnCode = returnCode;
	}

	public String getReturnDesc() {
		return returnDesc;
	}

	public void setReturnDesc(String returnDesc) {
		this.returnDesc = returnDesc;
	}

	public String getOperatCode() {
		return operatCode;
	}

	public void setOperatCode(String operatCode) {
		this.operatCode = operatCode;
	}

	public T getResponse() {
		return response;
	}

	public void setResponse(T response) {
		this.response = response;
	}

	private final int Default_Service_Code = ServiceMediator.Service_Return_Error;
	private final String Default_Service_Message = ServiceMediator.Service_Return_Error_Desc;

	public ServiceResponse() {
		this.returnCode = Default_Service_Code;
		this.returnDesc = Default_Service_Message;
	}
}
