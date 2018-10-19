package com.leftbrain.wallwrapper.utils.imagedownloader;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Message;

/**
 * 
 * @author zhujinhui
 * 
 */
public class DiskCache implements ImageDisplayListener {

	public static final int DISPLAY_SUCCESS = 0;
	public static final int DISPLAY_FAILED = 1;

	private ImageDisplayListener mListener;

	@SuppressLint("HandlerLeak")
	final Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			switch (msg.what) {
			case DISPLAY_SUCCESS: {
				mListener.imageDisplayFinished(null, null, null);
			}
				break;
			case DISPLAY_FAILED: {
				mListener.imageDisplayFailed(null, null,(String) msg.obj);
			}

			default:
				break;
			}
			;
		}
	};

	/**
	 * 加载图片,如果没有，则加载默认图片
	 * 
	 * @param resId
	 * @param imageView
	 */
	public void loadImage(String fileName) {
		ImageDisplayTask imageDisplayTask = new ImageDisplayTask(fileName);
		imageDisplayTask.setImageDisplayListener(this);
		imageDisplayTask.startDisPlay();
	}

	public void setImageDisplayListener(ImageDisplayListener listener) {
		mListener = listener;
	}

	/****************************************/
	@Override
	public void imageDisplayStart(String imagePath) {
		// TODO Auto-generated method stub

	}

	@Override
	public void imageDisplayFinished(ImageDisplayTask task, String fileName, Bitmap bitmap) {
		// TODO Auto-generated method stub
		if (bitmap != null) {
			Message msg = handler.obtainMessage();
			msg.obj = null;
			msg.what = DISPLAY_SUCCESS;
			handler.sendMessage(msg);
		}
	}

	@Override
	public void imageDisplayFailed(ImageDisplayTask task, String fileName, String reason) {
		// TODO Auto-generated method stub
		Message msg = handler.obtainMessage();
		msg.obj = reason;
		msg.what = DISPLAY_FAILED;
		handler.sendMessage(msg);
	}

}
