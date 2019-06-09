package com.leftbrain.wallwrapper.service.taskpool;

import java.util.HashMap;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Message;

import com.leftbrain.wallwrapper.service.networkaccess.ServiceMediator;
import com.leftbrain.wallwrapper.service.networkaccess.ServiceResponse;

@SuppressLint("HandlerLeak")
@SuppressWarnings({ "unchecked", "rawtypes" })
public class ViewModelManager {
	private static ViewModelManager vmManager;
	private HashMap<String, ViewModel> viewModelMap;
	private HashMap<String, String> viewModelPlist;

	public static ViewModelManager manager() {
		synchronized (Route.class) {
			if (vmManager == null) {
				vmManager = new ViewModelManager();
			}
			return vmManager;
		}
	}

	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			handlerMessage(msg);
		}
	};

	public Handler getHandler() {
		return handler;
	}

	public ViewModelManager() {
		viewModelMap = new HashMap<String, ViewModel>();
	}

	public void handlerMessage(Message msg) {
		ServiceResponse response = (ServiceResponse) msg.obj;
		String classKey = response.getActivityToken();
		ViewModel model = viewModelForKey(classKey);
		if (null != model) {
			switch (msg.what) {
			case ServiceMediator.Service_Return_Success:
				model.setModel(response);
				break;
			default:
				model.requestFailed(response);
				break;
			}
		}
	}

	public void setViewModelPlist(HashMap<String, String> map) {
		viewModelPlist = map;
	}

	public ViewModel newViewModel(String classString) {
		String activityToken = classString + "@" + TaskPool.sharedInstance().getActivityCounter();

		ViewModel resultViewModel = viewModelMap.get(activityToken);
		if (null == resultViewModel) {
			String strClass = viewModelPlist.get(classString);
			try {
				resultViewModel = (ViewModel) Class.forName(strClass).newInstance();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			resultViewModel.setActivityToken(activityToken);
			resultViewModel.setActivityClass(classString);
			viewModelMap.put(activityToken, resultViewModel);
		}
		return resultViewModel;
	}

	public ViewModel viewModelForKey(String classString) {
		ViewModel resultViewModel = viewModelMap.get(classString);
		return resultViewModel;
	}

	public void destoryViewModel(String classString) {
		viewModelMap.remove(classString);
	}
}
