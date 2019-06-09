package com.leftbrain.wallwrapper.utils.imagedownloader;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Message;

import com.leftbrain.wallwrapper.widget.ImageDownloaderListener;

/**
 * image download
 * 
 * @author zhujinhui
 * 
 */
public class ImageDownloader  implements Runnable, FileDownloadListener{
	private ImageDownloaderListener mListener;
	private String mImageUrlString = null;
	
	private static final  int MESSAGE_DOWNLOAD_RESULT = 100;

	/******************************* all static objects blew is used to create a task pool ******************************************************/
	private static int ALIVE_TIME = 30;
	private static int CORE_SIZE = 5;
	private static int MAX_SIZE = 15;

	private static ArrayBlockingQueue<Runnable> runnables = new ArrayBlockingQueue<Runnable>(25);

	private static ThreadFactory factory = Executors.defaultThreadFactory();

	private static ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(CORE_SIZE, MAX_SIZE, ALIVE_TIME, TimeUnit.SECONDS, runnables, factory, new ThreadPoolExecutor.DiscardOldestPolicy());

	
	@SuppressLint("HandlerLeak")
	final Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			switch (msg.what) {
			case MESSAGE_DOWNLOAD_RESULT:{
				//if msg detail is null, it means download successfully
				if (null == msg.obj) {
					   ImageDownloader.this.mListener.imageDownloadFininshed(mImageUrlString);
				}else {
					   ImageDownloader.this.mListener.imageDownloadFailed(mImageUrlString, (String) msg.obj);
				}
			}
				
				break;

			default:
				break;
			}
		}
	};
	
	public ImageDownloader(String imageUrlString) {
		imageUrlString = imageUrlString.replace("\\", "");
		mImageUrlString = imageUrlString;
	}

	public void startDownload(){
		// TODO Auto-generated method stub
		threadPoolExecutor.execute(this);
	}

	public void setImageDownloadListener(ImageDownloaderListener listener) {
		// TODO Auto-generated method stub
		this.mListener = listener;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		FileDownloader fileDownloader = new FileDownloader(mImageUrlString);
		fileDownloader.setFileDownloadListener(this);
		fileDownloader.startDownload();
	}
	
	/************************************************************/

	@Override
	public void fileDownloadStarted(String fileUrlString) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void fileDownloadFininshed(String fileUrlString) {
		// TODO Auto-generated method stub
		Message msg = handler.obtainMessage();
		msg.what = MESSAGE_DOWNLOAD_RESULT;
		msg.obj = null;
		handler.sendMessage(msg);
	}

	@Override
	public void fileDownloadProcess(String fileUrlString, float percent) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void fileDownloadFailed(String fileUrlString, String reason) {
		// TODO Auto-generated method stub
		Message msg = handler.obtainMessage();
		msg.what = MESSAGE_DOWNLOAD_RESULT;
		msg.obj = reason;
		handler.sendMessage(msg);
	}

}
