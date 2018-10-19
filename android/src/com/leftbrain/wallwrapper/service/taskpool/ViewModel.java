package com.leftbrain.wallwrapper.service.taskpool;

import java.util.concurrent.atomic.AtomicBoolean;

import android.app.Activity;

import com.leftbrain.wallwrapper.service.networkaccess.ServiceResponse;

public class ViewModel<T> {

	private String activityClass;
	private String activityToken;
	private String skipMethod;
	public Boolean showProgressBar;
	private Activity activity;
	private T model;
	public AtomicBoolean isDataReady = new AtomicBoolean(false);
	public AtomicBoolean isRefreshed = new AtomicBoolean(false);
	public AtomicBoolean isFailed = new AtomicBoolean(false);

	public T getModel() {
		return model;
	}

	public void setModel(T model) {
		this.model = model;
		ServiceResponse response = (ServiceResponse) model;
		isDataReady.set(true);
		paddingResult(response.getRequestMethod());
		processResult();

		if (null != this.activity) {
			if (activity instanceof BaseActivity) {
				((BaseActivity) activity).refreshData(response.getRequestMethod());
			} else if (activity instanceof BaseFragmentActivity) {
				((BaseFragmentActivity) activity).refreshData(response.getRequestMethod());
			}
		}
	}

	public void paddingResult(String method) {

	}

	public void processResult() {

	}

	public void requestFailed(T model) {
		isFailed.set(true);
		ServiceResponse response = (ServiceResponse) model;
		this.model = model;
		if (null != this.activity) {
			if (activity instanceof BaseActivity) {
				((BaseActivity) activity).requestFailedHandle(response.getRequestMethod(), response.getReturnCode(), response.getReturnDesc());
			} else if (activity instanceof BaseFragmentActivity) {
				((BaseFragmentActivity) activity).requestFailedHandle(response.getRequestMethod(), response.getReturnCode(), response.getReturnDesc());
			}
		}
	}

	public void setActivityToken(String acToken) {
		activityToken = acToken;
	}

	public String getActivityToken() {
		return activityToken;
	}

	public void setActivityClass(String clasString) {
		activityClass = clasString;
	}

	public String getActivityClass() {
		return activityClass;
	}

	public void setActivity(Activity activity) {
		this.activity = activity;
	}

	public Activity getActivity() {
		return activity;
	}

	public void setSkipMethod(String method) {
		this.skipMethod = method;
	}

	public String getSkipMethod() {
		return this.skipMethod;
	}
}