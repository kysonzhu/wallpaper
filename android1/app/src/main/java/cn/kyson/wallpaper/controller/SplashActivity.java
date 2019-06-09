package cn.kyson.wallpaper.controller;

import android.os.Bundle;
import android.os.Handler;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.base.WallWrapperBaseActivity;
import cn.kyson.wallpaper.service.taskpool.Route;
import cn.kyson.wallpaper.service.taskpool.ViewModelManager;
import cn.kyson.wallpaper.viewmodel.MainViewModel;
import cn.kyson.wallpaper.viewmodel.SplashViewModel;
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
