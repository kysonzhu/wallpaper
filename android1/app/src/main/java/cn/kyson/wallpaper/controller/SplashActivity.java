package cn.kyson.wallpaper.controller;

import android.Manifest;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Toast;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.base.WallWrapperBaseActivity;
import cn.kyson.wallpaper.service.taskpool.Route;
import cn.kyson.wallpaper.service.taskpool.ViewModelManager;
import cn.kyson.wallpaper.viewmodel.MainViewModel;
import cn.kyson.wallpaper.viewmodel.SplashViewModel;

import com.qw.soul.permission.SoulPermission;
import com.qw.soul.permission.bean.Permission;
import com.qw.soul.permission.callbcak.CheckRequestPermissionListener;
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
		SoulPermission.getInstance()
				.checkAndRequestPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE, new CheckRequestPermissionListener() {
					@Override
					public void onPermissionOk(Permission permission) {
						new Handler().postDelayed(new Runnable() {
							public void run() {
								// execute the task
								gotoSelectSchoolOrMainActivity();
							}
						}, 2 * 1000);
					}

					@Override
					public void onPermissionDenied(Permission permission) {
						Toast.makeText(SplashActivity.this, "存储空间权限授予失败，请授予后重试", Toast.LENGTH_SHORT).show();
					}
				});
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
