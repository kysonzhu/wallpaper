package com.leftbrain.wallwrapper.service.networkaccess;

import java.net.HttpURLConnection;
import java.util.Map;

/**
 * 
 * @author zhujinhui
 * 
 */
public class NetworkAccess {

	ProtocolHandler mProtocolHandler = null;

	public NetworkAccess(ProtocolHandler handler) {
		mProtocolHandler = handler;
	}
	
	public NetworkAccess() {
		mProtocolHandler = ProtocolHandler.defaultRequestHandler();
	}

	/**
	 * http request
	 * 
	 * @param requestUrl
	 * @param params
	 * @return
	 */
	public NetworkResponse httpRequest(String requestUrl, Map<?, ?> params) {
		HttpURLConnection connection = null;
		final NetworkResponse networkResponse = new NetworkResponse();

		if (HttpURLConnectionHelper.currentRequestMethod.equals(HttpURLConnectionHelper.REQUEST_METHOD_TYPE_GET)) {
			connection = HttpURLConnectionHelper.getHttpURLConnectionWithGet(requestUrl, params);
		} else {
			connection = HttpURLConnectionHelper.getHttpURLConnectionWithPost(requestUrl, params);
		}
		// set header information
		if (null == mProtocolHandler) {
			mProtocolHandler = ProtocolHandler.defaultRequestHandler();
		}
		mProtocolHandler.handleRequest(connection);

		// get data from network
		try {
			if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
				String responseString = HttpURLConnectionHelper.getHttpResponseString(connection);
				networkResponse.statusCode = HttpURLConnection.HTTP_OK;
				networkResponse.data = responseString;
				LogUtils.d("kyson", "Response:" + responseString);
			} else {
				LogUtils.d("HttpError", connection.getResponseCode() + ":" + connection.getResponseMessage());
				networkResponse.statusCode = connection.getResponseCode();
				networkResponse.codeDesc = connection.getResponseMessage();
				networkResponse.data = "";
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			connection.disconnect();
			connection = null;
			e.printStackTrace();
		}

		return networkResponse;
	}

	public NetworkResponse httpRequestByGzip() {

		return null;
	}

	public NetworkResponse httpsRequest() {

		return null;
	}

	public NetworkResponse httpsRequestByGzip() {
		return null;
	}

}
