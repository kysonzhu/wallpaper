package com.leftbrain.wallwrapper.service;

import com.leftbrain.wallwrapper.base.WallWrapperApplication;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class NetworkStatus {

	public static final int NETWORK_STATUS_REACHABLE = 0;
	public static final int NETWORK_STATUS_NOTREACHABLE = 1;

	public static int networkStatus(){
		Context context = WallWrapperApplication.getContext();
		if (context != null) {
			ConnectivityManager mConnectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo mNetworkInfo = mConnectivityManager.getActiveNetworkInfo();
			if (mNetworkInfo != null) {
				if (mNetworkInfo.isAvailable()) {
					return NETWORK_STATUS_REACHABLE;
				} else {
					return NETWORK_STATUS_NOTREACHABLE;
				}
			}
		}
		return NETWORK_STATUS_NOTREACHABLE;
	}
}
