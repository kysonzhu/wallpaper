package cn.kyson.wallpaper.service.networkaccess;

import java.lang.reflect.Method;
import java.util.HashMap;

/**
 * 
 * @author zhujinhui
 * 
 */
public class ServiceMediator {

	private static HashMap<String, Method> methodMap;

	/**
	 * 返回码定义
	 */
	public final static int Service_Return_Success = 0;
	public final static String Service_Return_Success_Desc = "请求成功";
	public final static int Service_Return_Error = 90001;
	public final static String Service_Return_Error_Desc = "请求失败";
	public final static int Service_Return_JsonParseError = 90002;
	public final static String Service_Return_JsonParseError_Desc = "Json解析异常";
	// 网络异常
	public final static int Service_Return_RequestTimeOut = 90003;
	public final static String Service_Return_RequestTimeOut_Desc = "请求超时";
	public final static int Service_Return_NetworkError = 90004;
	public final static String Service_Return_NetworkError_Desc = "网络异常";
	public final static int Service_Return_CancelRequest = 90005;
	public final static String Service_Return_CancelRequest_Desc = "取消请求";
	// 服务器异常
	public final static int Service_Return_ServerError = 90006;
	public final static String Service_Return_ServerError_Desc = "服务器异常";

	public static MobileHeader httpHeader = new MobileHeader();

	public HashMap<String, Method> getMethodMap() {
		return methodMap;
	}

	public Method getMethodByName(String strName) {
		return methodMap.get(strName);
	}

	public ServiceMediator() {
		Method[] methods = this.getClass().getMethods();
		methodMap = new HashMap<String, Method>(128);
		for (int i = 0; i < methods.length; i++) {
			methodMap.put(methods[i].getName(), methods[i]);
		}
	}
}
