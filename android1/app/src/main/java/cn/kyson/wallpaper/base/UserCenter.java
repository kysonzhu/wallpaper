package cn.kyson.wallpaper.base;

import java.util.ArrayList;

import android.content.SharedPreferences;

import cn.kyson.wallpaper.controller.SearchActivity;
import cn.kyson.wallpaper.model.ImageSize;

/**
 * user center , save user information
 * 
 * @author dell
 * 
 */
public class UserCenter {
	
	public static final String VOTE_GOOD_GROUPS = "VOTE_GOOD_GROUPS";
	
	public static final String SIZE_IMAGE = "SIZE_IMAGE";

	private static UserCenter usercenter;

	public static UserCenter instance() {
		// TODO Auto-generated method stub
		synchronized (UserCenter.class) {
			usercenter = new UserCenter();
		}
		return usercenter;
	}

	/**
	 * 
	 * @return
	 */
	public ArrayList<String> getSearchHistoryList(SearchActivity searchActivity) {
		ArrayList<String> histories = new ArrayList<String>();
		SharedPreferences sp = searchActivity.getSharedPreferences("history_strs", 0);
		String save_history = sp.getString("history", "");
		if (save_history.length() == 0) {
			return null;
		} else {
			String[] hisArrays = save_history.split(",");
			for (int i = 0; i < hisArrays.length; i++) {
				histories.add(hisArrays[i]);
			}
			return histories;
		}
	}

	public void addSearchHistoryList(String count, SearchActivity searchActivity) {
		SharedPreferences sp = searchActivity.getSharedPreferences("history_strs", 0);
		String save_Str = sp.getString("history", "");
		String[] hisArrays = save_Str.split(",");
		for (int i = 0; i < hisArrays.length; i++) {
			if (hisArrays[i].equals(count)) {
				return;
			}
		}
		StringBuilder sb = new StringBuilder(save_Str);
		sb.append(count + ",");
		sp.edit().putString("history", sb.toString()).commit();
		return;
	}

	public void clearSearchHistoryList(SearchActivity searchActivity) {
		SharedPreferences sp = searchActivity.getSharedPreferences("history_strs", 0);
		sp.edit().putString("history", "").commit();
		return;
	}

	/**
	 * hasGroupPraised
	 * @param group
	 * @return
	 */
	public boolean hasGroupPraised(String gId) {
		boolean hasPraised = false;
		ArrayList<String> praisedGroups = WallWrapperEnvConfigure.instance().getObjectFromSharePreferences(VOTE_GOOD_GROUPS);
		if(null != praisedGroups){
		for (String groupIdItem : praisedGroups) {
			if(gId.equals(groupIdItem)){
				hasPraised = true;
				break;
			}
		}
		}
		return hasPraised;
	}
	
	/**
	 * setGroupPraised
	 * @param group
	 */
	public void setGroupPraised(String gId) {
		ArrayList<String> praisedGroups = WallWrapperEnvConfigure.instance().getObjectFromSharePreferences(VOTE_GOOD_GROUPS);
		if(null != praisedGroups){
			if(!this.hasGroupPraised(gId)){
				praisedGroups.add(gId);
				WallWrapperEnvConfigure.instance().saveObjectToSharePreferences(praisedGroups,VOTE_GOOD_GROUPS);
			}
		}else{
			praisedGroups = new ArrayList<String>();
			praisedGroups.add(gId);
			WallWrapperEnvConfigure.instance().saveObjectToSharePreferences(praisedGroups,VOTE_GOOD_GROUPS);
		}
	}
	
	/**
	 * cancelGroupPraised
	 * @param group
	 */
	public void cancelGroupPraised(String gId) {
		ArrayList<String> praisedGroups = WallWrapperEnvConfigure.instance().getObjectFromSharePreferences(VOTE_GOOD_GROUPS);
		if(null != praisedGroups){
			if(this.hasGroupPraised(gId)){
				praisedGroups.remove(gId);
				WallWrapperEnvConfigure.instance().saveObjectToSharePreferences(praisedGroups,VOTE_GOOD_GROUPS);
			}
		}else{
			praisedGroups = new ArrayList<String>();
			WallWrapperEnvConfigure.instance().saveObjectToSharePreferences(praisedGroups,VOTE_GOOD_GROUPS);
		}

	}

	public String getImgSize() {
		String resultImageSizeString = null;
		ImageSize imageSize = WallWrapperEnvConfigure.instance().getObjectFromSharePreferences(SIZE_IMAGE);
		if(null == imageSize){
			imageSize = WallWrapperEnvConfigure.instance().getImgSize();
			WallWrapperEnvConfigure.instance().saveObjectToSharePreferences(imageSize,SIZE_IMAGE);		
		}
		resultImageSizeString = imageSize.width + "x" + imageSize.height;


		return resultImageSizeString;
	}

}
