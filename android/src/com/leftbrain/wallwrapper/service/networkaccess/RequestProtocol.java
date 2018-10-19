package com.leftbrain.wallwrapper.service.networkaccess;

/**
 * 
 * @author zhujinhui
 * 
 */
public class RequestProtocol {
	public static final String REQUEST_METHOD_TYPE_GET = "GET";
	public static final String REQUEST_METHOD_TYPE_POST = "POST";
	public static final String ACCEPT_LANGUAGE_ZH = "zh-cn,zh";
	public static final String ACCEPT_CHARSET_UTF8 = "utf-8";
	public static final String CONTENT_TYPE_JSON = "application/json";
	public static final String CONNECTION = "close";

	public String requestType;

	public String acceptLaunuage;
	public String acceptCharset;
	public String contentType;
	public String connection;

	public static RequestProtocol defaultRequestProtocol() {
		RequestProtocol requestProtocol = new RequestProtocol();
		requestProtocol.requestType = REQUEST_METHOD_TYPE_GET;
		requestProtocol.acceptLaunuage = ACCEPT_CHARSET_UTF8;
		requestProtocol.acceptCharset = ACCEPT_LANGUAGE_ZH;
		requestProtocol.contentType = CONTENT_TYPE_JSON;
		requestProtocol.connection = CONNECTION;
		return requestProtocol;
	}

}
