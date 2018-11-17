package com.leftbrain.wallwrapper.controller;

import android.os.Bundle;
import android.os.Handler;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.base.WallWrapperBaseActivity;
import com.leftbrain.wallwrapper.service.taskpool.Route;
import com.leftbrain.wallwrapper.service.taskpool.ViewModelManager;
import com.leftbrain.wallwrapper.viewmodel.MainViewModel;
import com.leftbrain.wallwrapper.viewmodel.SplashViewModel;
import com.umeng.analytics.MobclickAgent;

public class SplashActivity extends WallWrapperBaseActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);

		// =====================================
		MobclickAgent.updateOnlineConfig(this);
		MobclickAgent.openActivityDurationTrack(false);
		MobclickAgent.setDebugMode(true); // 使用普通测试流程
		// =====================================
		// do network request
		SplashViewModel viewModel = (SplashViewModel) ViewModelManager.manager().newViewModel(SplashActivity.class.getName());
		this.setViewModel(viewModel);
		viewModel.setActivity(this);

		new Handler().postDelayed(new Runnable() {
			public void run() {
				// execute the task
				gotoSelectSchoolOrMainActivity();
			}
		}, 2 * 1000);
	}

	/**
	 * 
	 */
	private void gotoSelectSchoolOrMainActivity() {
		MainViewModel viewModel = (MainViewModel) ViewModelManager.manager().newViewModel(MainActivity.class.getName());
		Route.route().nextController(SplashActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
		this.finish();
	}

}
