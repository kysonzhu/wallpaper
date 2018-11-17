package com.leftbrain.wallwrapper.service.networkaccess;

public class NetworkResponse {

	public static int DEFAULT_STATUS_CODE = ServiceMediator.Service_Return_Error;
	public static String DEFAULT_CODE_DESC = ServiceMediator.Service_Return_Error_Desc;
	public static String DEFAULT_DATA = "null";

	public int statusCode;

	public String codeDesc;

	public String data;

	public NetworkResponse() {
		data = null;
		statusCode = NetworkResponse.DEFAULT_STATUS_CODE;
		codeDesc = NetworkResponse.DEFAULT_DATA;
	}

}
