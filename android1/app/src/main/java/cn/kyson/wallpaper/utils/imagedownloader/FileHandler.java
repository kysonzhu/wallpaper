package cn.kyson.wallpaper.utils.imagedownloader;

/*
 *
 *  Created by 朱金�?on 14-01-08.
 *  Copyright (c) 2013�?SAIC. All rights reserved.
 */


import java.io.File;
import java.io.IOException;

import android.content.Context;
import android.os.Environment;


public class FileHandler {

	/**
	 * sd卡的根目�?	 */
	private static String mSdRootPath = Environment.getExternalStorageDirectory().getPath();
	/**
	 * 手机的缓存根目录
	 */
	private static String mDataRootPath = null;
	/**
	 * 保存Image的目录名
	 */
	private final static String FOLDER_NAME = "/leftbrain/image";

	public FileHandler(Context context) {
		mDataRootPath = context.getCacheDir().getPath();
	}
	
	private static FileHandler instance= null;
	
	public static FileHandler shareInstance(Context context){
		synchronized (FileHandler.class) {
			if (null == instance) {
				synchronized (FileHandler.class) {
					instance = new FileHandler(context);
				}
			}
		}
		return instance;
	}

	public boolean isFileExists(String fileName) {
		return new File(getStorageDirectory() + File.separator + fileName).exists();
	}

	private String getStorageDirectory() {
		return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) ? mSdRootPath + FOLDER_NAME : mDataRootPath + FOLDER_NAME;
	}


	public long getFileSize(String fileName) {
		return new File(getStorageDirectory() + File.separator + fileName).length();
	}

	public File createEmptyFileToDownloadDirectory(String fileName) {

		String downloadPath = getDownloadPath();
		File file = new File(downloadPath, fileName);

		File resultFile = FileHandler.createEmptyFileOrDirectory(file);

		return resultFile;
	}

	public File createEmptyFileToImageDirectory(String fileName) {

		String downloadPath = getImagePath();
		File file = new File(downloadPath, fileName);

		File resultFile = FileHandler.createEmptyFileOrDirectory(file);

		return resultFile;
	}

	// 判断文件是否存在，若不存在则创建
	private static File createEmptyFileOrDirectory(File file) {
		// 判断文件是否存在，若不存在则创建
		if (!file.exists()) {
			try {
				// 这里要取到父目录，否则会把文件当作目录来创建
				file.getParentFile().mkdirs();
				file.createNewFile();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		// 如果存在的话，还要判断是否是目录（因为linux系统中目录也会当作文件处理）
		else if (file.isDirectory()) {
			file.delete();
		}

		return file;
	}

	
	public File findFileByName(String fileNameString, String path) {
		File resultFile = null;
		if (fileNameString == null) {
			return null;
		}

		File file = new File(path);
		if (!file.isDirectory()) {
			return null;
		}

		for (File fileItem : file.listFiles()) {
			if (fileItem.getName().equalsIgnoreCase(fileNameString)) {
				resultFile = fileItem;
			}
		}
		return resultFile;
	}

	public String getImagePath() {
		return getStorageDirectory();
	}

	/**
	 * 取得图片目录
	 * 
	 * @return
	 */
	public String getDownloadPath() {
		return getStorageDirectory();
	}
}
