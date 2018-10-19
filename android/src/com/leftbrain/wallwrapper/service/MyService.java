package com.leftbrain.wallwrapper.service;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.Random;

import android.annotation.SuppressLint;
import android.app.Service;
import android.app.WallpaperManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ThumbnailUtils;
import android.os.IBinder;
import android.util.Log;
import android.view.WindowManager;

import com.leftbrain.wallwrapper.base.WallWrapperApplication;

public class MyService extends Service {

	private boolean flag = true;
	private MyThread myThread;
	String[] urlStrings = { "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025981841.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025915709.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025974330.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025968594.jpeg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025961661.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025954979.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025945389.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025937698.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025931659.jpg", "http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025923665.jpg",
			"http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/142502598853.jpg" };

	class MyThread extends Thread {
		@SuppressLint("ServiceCast")
		public void run() {
			while (flag) {

				try {
					// Thread.sleep(30000);
					Random random = new Random();
					int number = random.nextInt(urlStrings.length);
					byte[] data = readInputStream(new URL(urlStrings[number]).openStream());
					if (data.length>0 && data.length<50) {
						data = readInputStream(new URL(urlStrings[number].replace("720x1280", "640x960")).openStream());
					}else if(data==null || data.length==0){
						number = random.nextInt(urlStrings.length);
						data = readInputStream(new URL(urlStrings[number]).openStream());
					}
					Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
					Log.i("kyson", bitmap.getWidth() + "========");
					WallpaperManager wpm = (WallpaperManager) getSystemService(WALLPAPER_SERVICE);
					WindowManager wm = (WindowManager) WallWrapperApplication.getContext().getSystemService(Context.WINDOW_SERVICE);
					@SuppressWarnings("deprecation")
					int width = wm.getDefaultDisplay().getWidth();
					@SuppressWarnings("deprecation")
					int height = wm.getDefaultDisplay().getHeight();
					wpm.suggestDesiredDimensions(width, height);
					Bitmap bitmap2 = ThumbnailUtils.extractThumbnail(bitmap, width, height);
					WallpaperManager.getInstance(WallWrapperApplication.getContext()).setBitmap(bitmap2);
					Thread.sleep(60000);

				} catch (Exception ex) {
					ex.printStackTrace();
				}

				/*
				 * try { Thread.sleep(3000);
				 * 
				 * String fileString =
				 * WallWrapperApplication.getContext().getExternalFilesDir
				 * (Environment.DIRECTORY_DCIM).getPath(); File files = new
				 * File(fileString); Random r = new Random(); if
				 * (files.isDirectory()) { int nums = files.listFiles().length;
				 * if (nums > 0) { int i = r.nextInt(nums); try {
				 * FileInputStream fis = new
				 * FileInputStream(files.listFiles()[i]); WallpaperManager wpm =
				 * (WallpaperManager) getSystemService(WALLPAPER_SERVICE);
				 * WindowManager wm = (WindowManager)
				 * WallWrapperApplication.getContext
				 * ().getSystemService(Context.WINDOW_SERVICE);
				 * 
				 * @SuppressWarnings("deprecation") int width =
				 * wm.getDefaultDisplay().getWidth();
				 * 
				 * @SuppressWarnings("deprecation") int height =
				 * wm.getDefaultDisplay().getHeight();
				 * wpm.suggestDesiredDimensions(width, height);
				 * 
				 * @SuppressWarnings("deprecation") BitmapDrawable pic = new
				 * BitmapDrawable(fis); Bitmap bitmap = pic.getBitmap(); bitmap
				 * = ThumbnailUtils.extractThumbnail(bitmap, width, height);
				 * WallpaperManager
				 * .getInstance(WallWrapperApplication.getContext
				 * ()).setBitmap(bitmap); } catch (FileNotFoundException e) {
				 * e.printStackTrace(); } catch (IOException e) {
				 * e.printStackTrace(); } } }
				 * 
				 * } catch (Exception ex) { ex.printStackTrace(); }
				 */
			}
		}
	}

	public IBinder onBind(Intent intent) {
		return null;
	}

	public void onCreate() {
		super.onCreate();
			myThread = new MyThread();
			myThread.start();
	}

	@SuppressWarnings("deprecation")
	public void onStart(Intent intent, int startId) {
		super.onStart(intent, startId);
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		// TODO Auto-generated method stub
		return super.onStartCommand(intent, flags, startId);
	}

	public void onDestroy() {
		super.onDestroy();
		flag = false;
	}

	public static byte[] readInputStream(InputStream inStream) throws Exception {
		ByteArrayOutputStream outSteam = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024 * 1024];
		int len = 0;
		while ((len = inStream.read(buffer)) != -1) {
			outSteam.write(buffer, 0, len);
		}
		outSteam.close();
		inStream.close();
		return outSteam.toByteArray();
	}

}

// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025981841.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025915709.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025974330.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025968594.jpeg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025961661.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025954979.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025945389.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025937698.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025931659.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/1425025923665.jpg
// http://b.zol-img.com.cn/sjbizhi/images/8/720x1280/142502598853.jpg

