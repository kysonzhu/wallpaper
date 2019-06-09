package com.leftbrain.wallwrapper.base;

import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;

import com.leftbrain.wallwrapper.service.taskpool.BaseActivity;
import com.leftbrain.wallwrapper.widget.dialog.CustomProgressDialog;
import com.umeng.analytics.MobclickAgent;

public class WallWrapperBaseActivity extends BaseActivity {

	private Dialog progressDialog;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	private void startProgressDialog(boolean hasCancle) {
		if (progressDialog == null) {
			createDialog(hasCancle);
		}
		progressDialog.show();
	}

	/**
	 * 加载progressView
	 */
	public void showProgress() {
		startProgressDialog(false);
	}

	public void showProgress(String message) {
		CustomProgressDialog.Builder customBuilder = new CustomProgressDialog.Builder(this);
		customBuilder.setTitle("").setMessage(message).setContentView(null);
		// 是否有返回
		customBuilder.setNegativeButton("", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});

		progressDialog = customBuilder.create();
		progressDialog.setCanceledOnTouchOutside(false);
		progressDialog.show();
	}

	private void createDialog(boolean hasCancle) {
		CustomProgressDialog.Builder customBuilder = new CustomProgressDialog.Builder(this);
		customBuilder.setTitle("").setMessage("正在加载中...").setContentView(null);
		if (hasCancle) {
			// 是否有返回
			customBuilder.setNegativeButton("", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
				}
			});
		}

		progressDialog = customBuilder.create();
		progressDialog.setCanceledOnTouchOutside(false);
	}

	/**
	 * 取消ProgressView
	 * 
	 * @param hasCancle
	 */
	public void dismissProgress() {
		if (progressDialog != null) {
			progressDialog.dismiss();
		}
	}

	public void dismissProgress(String message) {
		CustomProgressDialog.Builder customBuilder = new CustomProgressDialog.Builder(this);
		customBuilder.setTitle("").setMessage(message).setContentView(null);
		// 是否有返回
		customBuilder.setNegativeButton("", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				dialog.dismiss();
			}
		});

		progressDialog = customBuilder.create();
		progressDialog.setCanceledOnTouchOutside(false);
		progressDialog.show();
		
		new Handler().postDelayed(new Runnable() {
			public void run() {
				// execute the task
				WallWrapperBaseActivity.this.dismissProgress();
			}
		}, 3 * 1000);
	}
	
	

	public void onResume() {
		super.onResume();
		MobclickAgent.onResume(this);
	}

	public void onPause() {
		super.onPause();
		MobclickAgent.onPause(this);
	}

}
