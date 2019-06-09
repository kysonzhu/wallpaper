package cn.kyson.wallpaper.service;

import android.util.Log;

import cn.kyson.wallpaper.service.networkaccess.NetworkResponse;
import cn.kyson.wallpaper.service.networkaccess.ServiceResponse;
import cn.kyson.wallpaper.service.networkaccess.ServiceUtils;

public class WallWrapperServiceUtils extends ServiceUtils {

	public static String getListRequestResult(ServiceResponse<?> serResponse, NetworkResponse netResponse) {
		String responseStr = ServiceUtils.getRequestResult(serResponse, netResponse);
		String tempString = null; // 获取"result":""或者"errorMsg":""
		// if do not have list or List ,means it is an object
		if (null != responseStr) {
			if (responseStr.contains("list") || responseStr.contains("List")) {
				// get the index of the response
				int objectListIndex;
				int tempIndex = responseStr.indexOf("List");
				objectListIndex = (-1 == tempIndex) ? responseStr.indexOf("list") : tempIndex;
				tempString = responseStr.substring(objectListIndex + 6, responseStr.length() - 1);
			}
		} else {
			Log.i("kyson", "response is null");
		}

		return tempString;

	}

	public static String getObjectRequestResult(ServiceResponse<?> serResponse, NetworkResponse netResponse) {
		String responseStr = ServiceUtils.getRequestResult(serResponse, netResponse);
		String tempString = null; // 获取"result":""或者"errorMsg":""
		// if do not have list or List ,means it is an object
		if (null != responseStr) {
			int tempIndex = responseStr.indexOf(":");
			int objectIndex = (-1 == tempIndex) ? responseStr.indexOf("：") : tempIndex;
			tempString = responseStr.substring(objectIndex + 1, responseStr.length() - 1);
		} else {
			Log.i("kyson", "response is null");
		}
		return tempString;

	}

	public static String getBooleanRequestResult(ServiceResponse<?> serResponse, NetworkResponse netResponse) {
		String responseStr = ServiceUtils.getRequestResult(serResponse, netResponse);
		String tempString = null; // 获取"result":""或者"errorMsg":""
		// if do not have list or List ,means it is an object
		if (null != responseStr) {
			int tempIndex = responseStr.indexOf(":");
			int objectIndex = (-1 == tempIndex) ? responseStr.indexOf("：") : tempIndex;
			tempString = responseStr.substring(objectIndex + 2, responseStr.length() - 2);
		} else {
			Log.i("kyson", "response is null");
		}

		return tempString;

	}

}
