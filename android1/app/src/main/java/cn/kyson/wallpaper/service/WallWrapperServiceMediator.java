package cn.kyson.wallpaper.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import android.util.Log;

import com.google.gson.reflect.TypeToken;
import cn.kyson.wallpaper.base.UserCenter;
import cn.kyson.wallpaper.model.Category;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.model.Image;
import cn.kyson.wallpaper.service.networkaccess.Field_Method_Parameter_Annotation;
import cn.kyson.wallpaper.service.networkaccess.JsonHandler;
import cn.kyson.wallpaper.service.networkaccess.MobileHeader;
import cn.kyson.wallpaper.service.networkaccess.NetworkAccess;
import cn.kyson.wallpaper.service.networkaccess.NetworkResponse;
import cn.kyson.wallpaper.service.networkaccess.ServiceMediator;
import cn.kyson.wallpaper.service.networkaccess.ServiceResponse;

public class WallWrapperServiceMediator extends ServiceMediator {
	static int sum_tuijan = 0;
	static int sum_zuixin = 0;
	static int sum_tuijian_two = 0;
	static int sum_zuixin_two = 0;
	static int sum_zuire_two = 0;
	static int sum_suosou = 0;

	public static final String SERVICENAME_GETRECOMMENDEDLIST = "getRecommendList";// 推荐
	public static final String SERVICENAME_GETLATESTLIST = "getLatestList";// 最新
	public static final String SERVICENAME_GETCATEGORYLIST = "getCategoryList";// 种类

	public static final String SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST = "getSubCategoryRecommendList";// sub推荐
	public static final String SERVICENAME_SUBCATEGORY_GETLATESTLIST = "getSubCategoryCategoryLatestList";// sub最新
	public static final String SERVICENAME_SUBCATEGORY_GETHOTTESTLIST = "getSubCategoryCategoryHottestList";// sub最热

	// 二级分类
	public static final String SERVICENAME_GETSECONDARYCATEGORYSELECTEDLIST = "getsecondarycategoryselectedlist";
	// 搜索的结果
	public static final String SERVICENAME_GETSEARCHRESULTLLIST = "getSearchResultList";
	// 专辑图片
	public static final String SERVICENAME_GETIMAGES = "getImages";

	private static WallWrapperServiceMediator instanceMediator = null;

	public void setHttpHeader(MobileHeader header) {
		// httpHeader = header;
	}

	public static WallWrapperServiceMediator sharedInstance() {
		synchronized (WallWrapperServiceMediator.class) {
			if (null == instanceMediator) {
				instanceMediator = new WallWrapperServiceMediator();
			}
		}
		return instanceMediator;
	}
	
	@Field_Method_Parameter_Annotation(args = { "gId" })
	public ServiceResponse<List<Image>> getImages(String gId) {
		// 默认初始化为失败信息
		ServiceResponse<List<Image>> response = new ServiceResponse<List<Image>>();
		response.setOperatCode(WallWrapperRequestDataType.GETIMAGES);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("gId", gId);
		paramsMap.put("picSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETIMAGES, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Image>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		} else {
			Log.i("kyson", response.getReturnCode() + "");
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "start", "wd" })
	public ServiceResponse<List<Group>> getSearchResultList(String start, String wd) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETSEARCHDETAILLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("wd", wd);
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		paramsMap.put("imgSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETSEARCHDETAILLIST, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		} else {
			Log.i("kyson", response.getReturnCode() + "");
		}

		return response;
	}

	/**
	 * get recommend list
	 * 
	 * @return
	 */
	@Field_Method_Parameter_Annotation(args = { "start" })
	public ServiceResponse<List<Group>> getRecommendList(String start) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETRECOMMENDLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		paramsMap.put("isAttion", "1");
		paramsMap.put("imgSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETRECOMMENDLIST, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "start", "cateId" })
	public ServiceResponse<List<Group>> getSubCategoryCategoryHottestList(String start, String cateId) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETRECOMMENDLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		paramsMap.put("cateId", cateId);
		paramsMap.put("isDown", "1");
		paramsMap.put("imgSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETRECOMMENDLIST, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "start", "cateId" })
	public ServiceResponse<List<Group>> getSubCategoryCategoryLatestList(String start, String cateId) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETRECOMMENDLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		paramsMap.put("cateId", cateId);
		paramsMap.put("isNow", "1");
		paramsMap.put("imgSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETRECOMMENDLIST, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "start", "cateId" })
	public ServiceResponse<List<Group>> getSubCategoryRecommendList(String start, String cateId) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETRECOMMENDLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		paramsMap.put("cateId", cateId);
		paramsMap.put("isAttion", "1");
		paramsMap.put("imgSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETRECOMMENDLIST, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "fatherId" })
	public ServiceResponse<List<Category>> getsecondarycategoryselectedlist(String fatherId) {
		// 默认初始化为失败信息
		ServiceResponse<List<Category>> response = new ServiceResponse<List<Category>>();
		response.setOperatCode(WallWrapperRequestDataType.GETSECONDARYCATEGORYSELECTEDLIST);
		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("fatherId", fatherId);
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETSECONDARYCATEGORYSELECTEDLIST, paramsMap);
		// HTTP结果返回
		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Category>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}
		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "start" })
	public ServiceResponse<List<Group>> getLatestList(String start) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETLATESTLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		paramsMap.put("isNow", "1");
		paramsMap.put("imgSize", UserCenter.instance().getImgSize());
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETLATESTLIST, paramsMap);

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = {})
	public ServiceResponse<List<Category>> getCategoryList() {
		// 默认初始化为失败信息
		ServiceResponse<List<Category>> response = new ServiceResponse<List<Category>>();
		response.setOperatCode(WallWrapperRequestDataType.GETCATEGORYLIST);
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETCATEGORYLIST, null); // HTTP结果返回
		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Category>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}

	@Field_Method_Parameter_Annotation(args = { "start" })
	public ServiceResponse<List<Group>> getHottestList(String start) {
		// 默认初始化为失败信息
		ServiceResponse<List<Group>> response = new ServiceResponse<List<Group>>();
		response.setOperatCode(WallWrapperRequestDataType.GETHOTTESTLIST);

		Map<String, String> paramsMap = new HashMap<String, String>();
		paramsMap.put("start", start);
		paramsMap.put("end", "30");
		// 参数转换为Json
		NetworkAccess networkAccess = new NetworkAccess();
		NetworkResponse netResponse = networkAccess.httpRequest(WallWrapperRequestDataType.GETHOTTESTLIST, paramsMap);
		// HTTP结果返回

		// 1.错误码转义
		String responseStr = WallWrapperServiceUtils.getListRequestResult(response, netResponse);
		if (response.getReturnCode() == ServiceMediator.Service_Return_Success) {
			// 返回成功 解析结果
			Type type = new TypeToken<List<Group>>() {
			}.getType();
			JsonHandler.jsonToList(responseStr, type, response);
		}

		return response;
	}


	public static String fankui_post(String content, String contact, String version, String system, String uuid) {
		String result = null;
		URL url = null;
		HttpURLConnection connection = null;
		InputStreamReader in = null;
		try {
//			url = new URL("http://www.abab.com/index.php?c=AbabInterface_Sj&a=Pic&param={\"content\":\"" + content + "\",\"system\":\"Android\",\"version\":\"" + version + "\",\"contact\":\"" + contact + "\",\"uuid\":\"匿名\"}");
			url = new URL("http://luhaojie.test.abab.com/index.php?c=AbabInterface_Sj&a=Pic&param={\"content\":\"" + content + "\",\"system\":\"Android\",\"version\":\"" + version + "\",\"contact\":\"" + contact + "\",\"uuid\":\""+uuid+"\"}");
			connection = (HttpURLConnection) url.openConnection();
			in = new InputStreamReader(connection.getInputStream());
			BufferedReader bufferedReader = new BufferedReader(in);
			StringBuffer strBuffer = new StringBuffer();
			String line = null;
			while ((line = bufferedReader.readLine()) != null) {
				strBuffer.append(line);
			}
			result = strBuffer.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
		return result;
	}
	
	public static String feedback_post(String content, String contact, String version, String system, String uuid) {
		String count = "";
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost httpPost = new HttpPost("http://luhaojie.test.abab.com/index.php");//?picSize=320x510&imgSize=320x510
		List<BasicNameValuePair> valuePairs = new ArrayList<BasicNameValuePair>();
			valuePairs.add(new BasicNameValuePair("c", "AbabInterface_Sj"));
			valuePairs.add(new BasicNameValuePair("a", "Pic"));
			valuePairs.add(new BasicNameValuePair("param", "{\"content\":\"" + content + "\",\"system\":\"Android\",\"version\":\"" + version + "\",\"contact\":\"" + contact + "\",\"uuid\":\""+uuid+"\"}"));						
		try {
			httpPost.setEntity(new UrlEncodedFormEntity(valuePairs, "UTF-8"));
			httpPost.setHeader("Content-Type",
					"application/x-www-form-urlencoded; charset=utf-8");
		} catch (UnsupportedEncodingException e2) {
			e2.printStackTrace();
		}
		try {
			HttpResponse response = httpClient.execute(httpPost);
			count = EntityUtils.toString(response.getEntity(), "utf-8");
		
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		return count;
		
	}
}

