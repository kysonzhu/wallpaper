package com.leftbrain.wallwrapper.base;

import android.app.Application;
import android.content.Context;
import android.content.res.Resources;

import com.leftbrain.wallwrapper.service.WallWrapperServiceMediator;
import com.leftbrain.wallwrapper.service.taskpool.TaskPool;
import com.leftbrain.wallwrapper.service.taskpool.ViewModelManager;
import com.leftbrain.wallwrapper.viewmodel.ViewModelPlist;

public class WallWrapperApplication extends Application {
	private static Context mContext;
	private static WallWrapperApplication application;
	private WallWrapperEnvConfigure envConfig;
	public UserCenter userCenter;

	public static final int LOCATION_TIME_OUT = 30 * 1000;

	@Override
	public void onCreate() {
		super.onCreate();
		ViewModelManager.manager().setViewModelPlist(ViewModelPlist.hashMap);
		TaskPool.sharedInstance().setServiceMediator(WallWrapperServiceMediator.sharedInstance());
		application = this;
		mContext = getApplicationContext();
		// envconfig
		envConfig = WallWrapperEnvConfigure.instance();
		envConfig.configurationEnvironment(mContext);
		userCenter = UserCenter.instance();

		setHttpHeader();
	}

	private void setHttpHeader() {
		// TODO Auto-generated method stub

		// SaikeMobileHead httpHeader = new SaikeMobileHead();
		// httpHeader.appCode = "pitch";
		// String devideId = PitchEnvConfig.instance().getDeviceId(mContext);
		// httpHeader.deviceId = devideId;
		// String appNum = CommonUtil.getAppVersionName(mContext);
		// httpHeader.appVersion = appNum;
		// httpHeader.plateformType = "android";
		// PitchServiceMediator.sharedInstance().setHttpHeader(httpHeader);
	}

	public static Context getContext() {
		return mContext;
	}

	public static Resources geResources() {
		return mContext.getResources();
	}

	public static WallWrapperApplication getInstance() {
		return application;
	}

	public void applicationExit() {
		android.os.Process.killProcess(android.os.Process.myPid());
	}

}
