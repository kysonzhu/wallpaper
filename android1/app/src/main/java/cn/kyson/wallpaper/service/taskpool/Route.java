package cn.kyson.wallpaper.service.taskpool;

import android.app.Activity;
import android.content.Intent;

@SuppressWarnings("rawtypes")
public class Route {
	public static String ACTIVITY_TOKEN_KEY = "activity_token_key";
	private static Route sRoute;
	public static int WITHOUT_RESULTCODE = -1;

	public static Route route() {
		synchronized (Route.class) {
			if (sRoute == null) {
				sRoute = new Route();
			}
			return sRoute;
		}
	}

	public void nextController(Activity currentActivity, ViewModel viewModel, int resultCode) {
		Intent intent;
		try {
			intent = new Intent(currentActivity, Class.forName(viewModel.getActivityClass()));
			viewModel.showProgressBar = false;
			intent.putExtra(ACTIVITY_TOKEN_KEY, viewModel.getActivityToken());

			if (resultCode == WITHOUT_RESULTCODE) {
				currentActivity.startActivity(intent);
			} else {
				currentActivity.startActivityForResult(intent, resultCode);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void nextController(Activity currentActivity, ViewModel viewModel, int resultCode, String method) {
		try {
			if (method != null) {
				TaskPool.sharedInstance().doTask(viewModel, method);
				viewModel.setSkipMethod(method);
				viewModel.showProgressBar = true;
			}

			Intent intent = new Intent(currentActivity, Class.forName(viewModel.getActivityClass()));
			intent.putExtra(ACTIVITY_TOKEN_KEY, viewModel.getActivityToken());

			if (resultCode == WITHOUT_RESULTCODE) {
				currentActivity.startActivity(intent);
			} else {
				currentActivity.startActivityForResult(intent, resultCode);
			}
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}
}
