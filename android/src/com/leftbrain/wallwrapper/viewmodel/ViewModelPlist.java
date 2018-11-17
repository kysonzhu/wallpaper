package com.leftbrain.wallwrapper.viewmodel;

import java.util.HashMap;

import android.util.Log;

import com.leftbrain.wallwrapper.controller.MainActivity;
import com.leftbrain.wallwrapper.controller.SearchActivity;
import com.leftbrain.wallwrapper.controller.SearchListActivity;
import com.leftbrain.wallwrapper.controller.SecondaryCategorySelectedActivity;
import com.leftbrain.wallwrapper.controller.SplashActivity;
import com.leftbrain.wallwrapper.controller.SubCategoryActivity;
import com.leftbrain.wallwrapper.controller.WrapperDetailActivity;

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
