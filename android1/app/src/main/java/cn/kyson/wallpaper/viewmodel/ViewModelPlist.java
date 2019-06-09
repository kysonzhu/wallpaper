package cn.kyson.wallpaper.viewmodel;

import java.util.HashMap;

import android.util.Log;

import cn.kyson.wallpaper.controller.MainActivity;
import cn.kyson.wallpaper.controller.SearchActivity;
import cn.kyson.wallpaper.controller.SearchListActivity;
import cn.kyson.wallpaper.controller.SecondaryCategorySelectedActivity;
import cn.kyson.wallpaper.controller.SplashActivity;
import cn.kyson.wallpaper.controller.SubCategoryActivity;
import cn.kyson.wallpaper.controller.WrapperDetailActivity;

public class ViewModelPlist {
	
	public static HashMap<String, String> hashMap = new HashMap<String, String>();
		static {
			Log.i("-------", MainActivity.class.getName());
			hashMap.put(MainActivity.class.getName(), MainViewModel.class.getName());
			hashMap.put(SubCategoryActivity.class.getName(), SubCategoryViewModel.class.getName());
			hashMap.put(SecondaryCategorySelectedActivity.class.getName(), SecondaryCategorySelectedViewModel.class.getName());
			hashMap.put(SearchListActivity.class.getName(), SearchDetailViewModel.class.getName());
			hashMap.put(SearchActivity.class.getName(), SearchViewModel.class.getName());
			hashMap.put(WrapperDetailActivity.class.getName(), ImageViewModel.class.getName());
			hashMap.put(SplashActivity.class.getName(), SplashViewModel.class.getName());
		}

}
