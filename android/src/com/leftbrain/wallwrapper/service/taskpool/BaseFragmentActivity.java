package com.leftbrain.wallwrapper.service.taskpool;

import java.util.ArrayList;
import java.util.List;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

@SuppressWarnings("rawtypes")
public class BaseFragmentActivity extends FragmentActivity implements Controller {
	public ViewModel baseViewModel;
	private List<String> requestTokens;
	private String activityToken;

	@Override
	protected void onCreate(Bundle arg0) {
		// TODO Auto-generated method stub
		super.onCreate(arg0);
		requestTokens = new ArrayList<String>();
		Intent intent = getIntent();
		if (null != intent.getExtras()) {
			activityToken = intent.getExtras().getString(Route.ACTIVITY_TOKEN_KEY);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	protected void onStart() {
		// TODO Auto-generated method stub
		super.onStart();
		if (null == baseViewModel) {
			baseViewModel = ViewModelManager.manager().viewModelForKey(activityToken);
			baseViewModel.setActivity(this);
			alreadyBindBaseViewModel();
			if (baseViewModel.isDataReady.get() && !baseViewModel.isRefreshed.get()) {
				refreshData(baseViewModel.getSkipMethod());
			} else if (baseViewModel.isFailed.get()) {
				baseViewModel.requestFailed(baseViewModel.getModel());
			}
		}
	}

	public void alreadyBindBaseViewModel() {

	}

	@Override
	public void setViewModel(ViewModel vModel) {
		// TODO Auto-generated method stub
		baseViewModel = vModel;
	}

	@Override
	public ViewModel getViewModel() {
		// TODO Auto-generated method stub
		return baseViewModel;
	}

	@Override
	public void refreshData(String method) {
		// TODO Auto-generated method stub
		baseViewModel.isRefreshed.set(true);
	}

	@Override
	public void requestFailedHandle(String method, int errorCode, String errorMsg) {
		// TODO Auto-generated method stub
	}

	public String doTask(ViewModel viewModel, String method) {
		String token = TaskPool.sharedInstance().doTask(viewModel, method);
		if (null != token) {
			requestTokens.add(token);
		}
		return token;
	}

	public void cancelTask(String token) {
		requestTokens.remove(token);
		TaskPool.sharedInstance().removeTask(token);
	}

	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		for (int i = 0; i < requestTokens.size(); i++) {
			String token = requestTokens.get(i);
			TaskPool.sharedInstance().removeTask(token);
		}
		ViewModelManager.manager().destoryViewModel(activityToken);
	}
	
}
