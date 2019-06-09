package cn.kyson.wallpaper.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.base.WallWrapperBaseActivity;
import cn.kyson.wallpaper.service.NetworkStatus;
import cn.kyson.wallpaper.service.WallWrapperServiceMediator;

public class FeedbackActivity extends WallWrapperBaseActivity implements OnClickListener {

	private Dialog dialog;
	private ImageView mImageView;
	private File mPhotoFile;
	private String mPhotoPath;
	public final static int CAMERA_RESULT = 8888;
	public final static String TAG = "xx";
	private EditText fankui_message, phone_num_tv;

	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			Toast.makeText(getApplicationContext(), "欢迎你的反馈", Toast.LENGTH_SHORT).show();
			finish();
		}
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_feedback);
		fankui_message = (EditText) findViewById(R.id.fankui_message_et);
		phone_num_tv = (EditText) findViewById(R.id.phone_num_tv);
	}

	public void yijian_fanhui_click(View v) {
		this.finish();
	}

	public void tijiao_click(View v) {
		final String message = fankui_message.getText().toString().trim();
		final String phone = phone_num_tv.getText().toString().trim();
		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			if (null == message || message.length() == 0) {
				Toast.makeText(this, "内容不可为空", Toast.LENGTH_SHORT).show();
				return;
			} else {
				new Thread() {
					public void run() {
//						WallWrapperServiceMediator.fankui_post(message, phone, android.os.Build.VERSION.RELEASE, "Android", "匿名");
						WallWrapperServiceMediator.feedback_post(message, phone, android.os.Build.VERSION.RELEASE, "Android", "匿名");
						handler.sendEmptyMessage(0);
					};
				}.start();
				return;
			}
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			Toast.makeText(this, "没有连接网络", Toast.LENGTH_SHORT).show();
		}
	}
	

	public void tianjia_click(View v) {
		dialog = new Dialog(this, R.style.Transparent);
		dialog.setContentView(R.layout.zdy_style);

		Window dialogWindow = dialog.getWindow();
		WindowManager.LayoutParams lp = dialogWindow.getAttributes();
		WindowManager wm = (WindowManager) FeedbackActivity.this.getSystemService(Context.WINDOW_SERVICE);
		int width = wm.getDefaultDisplay().getWidth();
		int height = wm.getDefaultDisplay().getHeight();
		lp.x = 0;
		lp.y = 0;
		lp.width = width;
		lp.height = height;
		lp.alpha = 0.7f;

		TextView textView1_quxiao = (TextView) dialogWindow.findViewById(R.id.textView1_quxiao);
		textView1_quxiao.setOnClickListener(this);
		TextView textView2_paizhao = (TextView) dialogWindow.findViewById(R.id.textView2_paizhao);
		textView2_paizhao.setOnClickListener(this);
		mImageView = (ImageView) dialogWindow.findViewById(R.id.imageView3_phone);
		dialog.show();
	}

	@Override
	public void onClick(View arg0) {
		switch (arg0.getId()) {
		case R.id.textView1_quxiao:
			dialog.dismiss();
			break;
		case R.id.textView2_paizhao:
			Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
			mPhotoPath = "mnt/sdcard/DCIM/Camera/" + getPhotoFileName();
			mPhotoFile = new File(mPhotoPath);
			intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mPhotoFile));
			startActivityForResult(intent, CAMERA_RESULT);
			break;

		default:
			break;
		}
	}

	private String getPhotoFileName() {
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat("'IMG'_yyyyMMdd_HHmmss");
		return dateFormat.format(date) + ".jpg";
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (requestCode == CAMERA_RESULT) {
			Bitmap bitmap = BitmapFactory.decodeFile(mPhotoPath, null);
			mImageView.setImageBitmap(bitmap);
		}
	}
}
