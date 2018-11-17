package com.leftbrain.wallwrapper.service.networkaccess;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import java.util.zip.GZIPInputStream;

import android.text.TextUtils;
import android.util.Log;

import com.google.gson.JsonObject;

/**
 * 
 * @author zhujinhui
 * 
 */
public class HttpURLConnectionHelper {

	public static final String REQUEST_METHOD_TYPE_GET = "GET";
	public static final String REQUEST_METHOD_TYPE_POST = "POST";

	public static String currentRequestMethod;

	static {
		currentRequestMethod = REQUEST_METHOD_TYPE_GET;
	}

	/***
	 * generate connection with get
	 * 
	 * @param host
	 * @param params
	 * @return
	 */
	public static HttpURLConnection getHttpURLConnectionWithGet(String host, Map<?, ?> params) {
		if (TextUtils.isEmpty(host)) {
			return null;
		}
		StringBuilder stringBuilder = new StringBuilder(host);
		//judge if the params is null
		if (null != params) {
			stringBuilder.append("?");
			for (Map.Entry<?, ?> entry : params.entrySet()) {
				String key = entry.getKey().toString();
				String value = java.net.URLEncoder.encode(entry.getValue().toString()) ;
				stringBuilder.append(key).append("=").append(value).append("&");
			}
			// delete char '&'
			stringBuilder.deleteCharAt(stringBuilder.length() - 1);
		}
		
		HttpURLConnection connection = null;
		try {
			URL url = new URL(stringBuilder.toString());
			LogUtils.d("kyson", "url:"+url);
			connection = (HttpURLConnection) url.openConnection();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			connection.disconnect();
			e.printStackTrace();
		}
		return connection;
	}

	/**
	 * generate connection with post
	 * 
	 * @param host
	 * @param params
	 * @return
	 */
	public static HttpURLConnection getHttpURLConnectionWithPost(String host, Map<?, ?> params) {
		URL url = null;
		HttpURLConnection httpURLConnection = null;
		try {
			url = new URL(host);

			JsonObject jsonObj = new JsonObject();
			for (Map.Entry<?, ?> entry : params.entrySet()) {
				jsonObj.addProperty(entry.getKey().toString(), entry.getValue().toString());
			}
			String requestStr = jsonObj.toString();
			httpURLConnection = (HttpURLConnection) url.openConnection();
			ByteArrayInputStream inputStream = new ByteArrayInputStream(requestStr.getBytes("utf-8"));

		} catch (IOException e) {
			// TODO Auto-generated catch block
			httpURLConnection.disconnect();

			e.printStackTrace();
		}

		return httpURLConnection;

	}

	/**
	 * fetch data from network
	 * 
	 * @param urlConn
	 * @return
	 */
	public static String getHttpResponseString(HttpURLConnection urlConn) {
		try {
			if (!TextUtils.isEmpty(urlConn.getContentEncoding())) {
				String encode = urlConn.getContentEncoding().toLowerCase();
				InputStream inputStream = urlConn.getInputStream();
				String resultString = null;
				if (!TextUtils.isEmpty(encode) && encode.indexOf("gzip") >= 0) {
					InputStream inputStream2 = new GZIPInputStream(inputStream);
					resultString = StreamUtils.convertStreamToString(inputStream2);
					inputStream2.close();
				} else {
					resultString = StreamUtils.convertStreamToString(inputStream);
				}
				return resultString;
			} else {
				String resultString = null;
				InputStream inputStream = urlConn.getInputStream();
				resultString = StreamUtils.convertStreamToString(inputStream);
				return resultString;
			}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} finally {
			urlConn.disconnect();
			urlConn = null;
		}
		return null;
	}

}
