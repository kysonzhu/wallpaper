package com.leftbrain.wallwrapper.service.networkaccess;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

public class JsonHandler {

	public static <T> void jsonToObject(String json, Class<T> cls, ServiceResponse<T> response) {
		T resultObject = null;

		try {
			resultObject = JsonHandler.jsonToObject(json, cls);
		} catch (Exception e) {
			e.printStackTrace();
			response.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			response.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
			return;
		}
		response.setResponse(resultObject);
		response.setReturnCode(ServiceMediator.Service_Return_Success);
	}

	public static <T> void jsonToList(String json, Type type, ServiceResponse<List<T>> response) {
		List<T> resultObject = null;

		try {
			resultObject = JsonHandler.jsonToList(json, type);
		} catch (Exception e) {
			e.printStackTrace();
			response.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			response.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
			return;
		}
		response.setResponse(resultObject);
		response.setReturnCode(ServiceMediator.Service_Return_Success);
		return;
	}

	public static void jsonToBoolean(String json, ServiceResponse<Boolean> response) {
		if (json != null) {
			if (json.equals("1")) {
				response.setResponse(true);
			} else {
				response.setResponse(false);
			}
			response.setReturnCode(ServiceMediator.Service_Return_Success);
			return;
		} else {
			response.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			response.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
		}
	}

	public static void jsonToString(String json, ServiceResponse<String> response) {
		if (json != null) {
			response.setResponse(json);
			response.setReturnCode(ServiceMediator.Service_Return_Success);
			return;
		} else {
			response.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			response.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
		}
	}

	public static void jsonToNumber(String json, ServiceResponse<Number> response) {
		int num = -1;
		num = Integer.parseInt(json);
		if (num != -1) {
			response.setResponse(num);
			response.setReturnCode(ServiceMediator.Service_Return_Success);
			return;
		} else {
			response.setReturnDesc(ServiceMediator.Service_Return_JsonParseError_Desc);
			response.setReturnCode(ServiceMediator.Service_Return_JsonParseError);
		}
	}

	public static <T> T jsonToObject(String json, Class<T> obj) {
		return new Gson().fromJson(json, obj);
	}

	public static String objectToJson(Object obj) {
		Gson gson = new Gson();
		String jsonString = gson.toJson(obj);
		return jsonString;
	}

	@SuppressWarnings("unchecked")
	public static <T> List<T> jsonToList(String json, Class<T> cls) {
		Gson gson = new Gson();
		List<T> list = new ArrayList<T>();
		ArrayList<?> temp = gson.fromJson(json, ArrayList.class);
		for (int i = 0; i < temp.size(); i++) {
			Map<String, Object> map = (Map<String, Object>) temp.get(i);
			list.add((T) jsonToObject(new Gson().toJson(map), cls));
		}
		return list;
	}

	public static <T> List<T> jsonToList(String json, Type type) {
		List<T> list = new Gson().fromJson(json, type);
		return list;
	}
}
