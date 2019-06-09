package cn.kyson.wallpaper.service.networkaccess;

import java.net.HttpURLConnection;

import android.util.Log;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;

/**
 * service utils
 * 
 * @author zhujinhui
 * 
 */
public class ServiceUtils {
	private final static String TAG = "ServiceUtils";

	public static boolean isJsonString(String jsonString) {
		boolean result = false;
		try {
			JsonParser jp = new JsonParser();
			JsonElement je = jp.parse(jsonString);
			result = je.isJsonObject();
		} catch (JsonSyntaxException e) {
			e.printStackTrace();
			Log.e("ServiceUtils", "parse Json Error");
		}
		return result;
	}

	public static String getOpenAPIResult(ServiceResponse<?> serResponse, NetworkResponse netResponse) {
		String responseStr = null;
		if (netResponse.statusCode == HttpURLConnection.HTTP_OK) {
			String resultData = netResponse.data;
			if (!isJsonString(resultData)) {
				serResponse.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
				serResponse.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			} else {
				int errorCodeIndex;
				String errorCodeString;
				String tempString;
				if (!resultData.contains(",\"errorCode\"")) {
					errorCodeIndex = resultData.indexOf(",");
					errorCodeString = resultData.substring(1, errorCodeIndex);
					tempString = resultData.substring(errorCodeIndex + 1, resultData.length() - 1);
				} else {
					errorCodeIndex = resultData.indexOf("errorCode");
					errorCodeString = resultData.substring(errorCodeIndex - 1, resultData.length() - 1);
					tempString = resultData.substring(1, errorCodeIndex - 2);
				}
				String errorCode = errorCodeString.split(":")[1];
				if (errorCode.equals("\"0\"") || errorCode.equals("0")) {
					String resultString = tempString;
					int resultIndex = resultString.indexOf(":");
					String result = resultString.substring(resultIndex + 1, resultString.length());
					String subString = result.substring(0, 1);
					if (subString.equals("\"")) {
						responseStr = result.substring(1, result.length() - 1);
					} else {
						responseStr = result.replace("/", "\\/");
					}
					NetworkResponse networkRes = new NetworkResponse();
					networkRes.statusCode = HttpURLConnection.HTTP_OK;
					networkRes.data = responseStr;
					responseStr = getRequestResult(serResponse, networkRes);
				} else {
					int code = Integer.parseInt(errorCode.trim().replace("\"", ""));

					String errorMessageString = tempString;
					int resultIndex = errorMessageString.indexOf(":");
					String errorMessage = errorMessageString.substring(resultIndex + 1, errorMessageString.length());
					String message = errorMessage.substring(1, errorMessage.length() - 1);
					serResponse.setReturnCode(code);
					serResponse.setReturnDesc(message);
				}
			}
		} else {
			if (netResponse.statusCode == HttpURLConnection.HTTP_CLIENT_TIMEOUT || netResponse.statusCode == HttpURLConnection.HTTP_GATEWAY_TIMEOUT) {
				serResponse.setReturnCode(ServiceMediator.Service_Return_RequestTimeOut);
				serResponse.setReturnDesc(ServiceMediator.Service_Return_RequestTimeOut_Desc);
			} else {
				serResponse.setReturnCode(ServiceMediator.Service_Return_NetworkError);
				serResponse.setReturnDesc(ServiceMediator.Service_Return_NetworkError_Desc);
			}
		}
		return responseStr;
	}

	public static String getRequestResult(ServiceResponse<?> serResponse, NetworkResponse netResponse) {
		String responseStr = null;
		if (netResponse.statusCode == HttpURLConnection.HTTP_OK) {
			String resultData = netResponse.data;
			if (!isJsonString(resultData)) {
				serResponse.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
				serResponse.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			} else {
				int errorCodeIndex;
				String errorCodeString;
				String tempString;
				if (!resultData.contains(",\"errorCode\"")) {
					errorCodeIndex = resultData.indexOf(",");
					errorCodeString = resultData.substring(1, errorCodeIndex);
					tempString = resultData.substring(errorCodeIndex + 1, resultData.length() - 1);
				} else {
					errorCodeIndex = resultData.indexOf("errorCode");
					errorCodeString = resultData.substring(errorCodeIndex - 1, resultData.length() - 1);
					tempString = resultData.substring(1, errorCodeIndex - 2);
				}
				String errorCode = errorCodeString.split(":")[1];
				if (errorCode.equals("\"0\"") || errorCode.equals("0")) {
					String resultString = tempString;
					int resultIndex = resultString.indexOf(":");
					String result = resultString.substring(resultIndex + 1, resultString.length());
					String subString = result.substring(0, 1);
					if (subString.equals("\"")) {
						responseStr = result.substring(1, result.length() - 1);
					} else {
						responseStr = result.replace("/", "\\/");
					}
					serResponse.setReturnCode(ServiceMediator.Service_Return_Success);
				} else {
					int code = Integer.parseInt(errorCode.trim().replace("\"", ""));
					if (code >= 60101001 && code <= 60101008) {
						serResponse.setReturnCode(ServiceMediator.Service_Return_Error);
						serResponse.setReturnDesc(ServiceMediator.Service_Return_Error_Desc);
					} else {
						String errorMessageString = tempString;
						int resultIndex = errorMessageString.indexOf(":");
						String errorMessage = errorMessageString.substring(resultIndex + 1, errorMessageString.length());
						String message = errorMessage.substring(1, errorMessage.length() - 1);
						serResponse.setReturnCode(code);
						serResponse.setReturnDesc(message);
					}
				}
			}
		} else {
			if (netResponse.statusCode == HttpURLConnection.HTTP_CLIENT_TIMEOUT || netResponse.statusCode == HttpURLConnection.HTTP_GATEWAY_TIMEOUT) {
				serResponse.setReturnCode(ServiceMediator.Service_Return_RequestTimeOut);
				serResponse.setReturnDesc(ServiceMediator.Service_Return_RequestTimeOut_Desc);
			} else {
				serResponse.setReturnCode(ServiceMediator.Service_Return_NetworkError);
				serResponse.setReturnDesc(ServiceMediator.Service_Return_NetworkError_Desc);
			}
		}
		return responseStr;
	}
}
