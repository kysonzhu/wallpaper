package com.leftbrain.wallwrapper.service.networkaccess;

import java.net.URLConnection;

/**
 * 
 * @author zhujinhui
 * 
 */
public class ProtocolHandler {
	private RequestProtocol mRequestProtocol;
	private ResponseProtocol mResponProtocol;

	/**
	 * 
	 * @param protocol
	 * @param connection
	 */
	public void handleRequest(URLConnection connection) {
		if (null != mRequestProtocol && null != connection) {
			//charset
			String acceptCharset = null == mRequestProtocol.acceptCharset ? RequestProtocol.ACCEPT_CHARSET_UTF8: mRequestProtocol.acceptCharset;
			connection.setRequestProperty("Accept-Charset", acceptCharset);
			//acceptLaunuage
			String acceptLaunuage = null == mRequestProtocol.acceptLaunuage ? RequestProtocol.ACCEPT_LANGUAGE_ZH: mRequestProtocol.acceptLaunuage;
			connection.setRequestProperty("Accept-Language", acceptLaunuage);
			//contentType
			String contentType = null == mRequestProtocol.contentType ? RequestProtocol.CONTENT_TYPE_JSON: mRequestProtocol.contentType;
			connection.setRequestProperty("Content-type", contentType);
			//connection
			String connectionclose = null == mRequestProtocol.connection ? RequestProtocol.CONNECTION: mRequestProtocol.connection;
			connection.setRequestProperty("Connection", connectionclose);
		}
	}

	public ProtocolHandler(ResponseProtocol protocol,URLConnection connection) {
		this.mResponProtocol = protocol;
	}

	public ProtocolHandler() {

	}

	public static ProtocolHandler defaultRequestHandler() {
		ProtocolHandler protocolHandler = new ProtocolHandler();
		protocolHandler.mRequestProtocol = RequestProtocol.defaultRequestProtocol();
		return protocolHandler;
	}

	public void handleResponse() {

	}
	
	/***
	 * get and setters
	 */
	public RequestProtocol getRequestProtocol() {
		return mRequestProtocol;
	}
	
	public void setRequestProtocol(RequestProtocol protocol) {
		 mRequestProtocol = protocol;
	}

}
