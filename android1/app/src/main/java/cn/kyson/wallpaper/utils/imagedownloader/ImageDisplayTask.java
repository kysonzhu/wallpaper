package cn.kyson.wallpaper.utils.imagedownloader;

import java.io.File;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import android.graphics.Bitmap;

import cn.kyson.wallpaper.base.WallWrapperApplication;

/**
 * 
 * @author zhujinhui
 * 
 */
public class ImageDisplayTask implements Runnable {
	private ImageDisplayListener mListener;
	private String mFileName;
	
	public static final String ERROR_NO_FILE_FOUND = "no file found";
	public static final String ERROR_OUT_OF_MEMORY = "no file found";

	/******************************* all static objects blew is used to create a task pool ******************************************************/
	private static int ALIVE_TIME = 30;
	private static int CORE_SIZE = 5;
	private static int MAX_SIZE = 15;

	private static ArrayBlockingQueue<Runnable> runnables = new ArrayBlockingQueue<Runnable>(25);

	private static ThreadFactory factory = Executors.defaultThreadFactory();

	private static ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(CORE_SIZE, MAX_SIZE, ALIVE_TIME, TimeUnit.SECONDS, runnables, factory, new ThreadPoolExecutor.DiscardOldestPolicy());;

	public ImageDisplayTask(String fileNameString) {
		if (null == fileNameString) {
			throw new NullPointerException();
		}
		mFileName = fileNameString;
	}

	public String getFileName() {
		return mFileName;
	}

	/**
	 * 
	 * @return
	 */
	public String startDisPlay() {
		threadPoolExecutor.execute(this);
		return mFileName;
	}
	
	/**
	 * 
	 * @param fileName
	 * @return
	 */
	public boolean isImageExists(String fileName) {
		FileHandler fileHandler = FileHandler.shareInstance(WallWrapperApplication.getContext());
		String imageFolderString = fileHandler.getImagePath();
		File imageFile = fileHandler.findFileByName(fileName, imageFolderString);
		if (null == imageFile) {
			return false;
		}
		return true;
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		boolean isImageExists = ImageDisplayTask.this.isImageExists(mFileName);
		if (!isImageExists) {
			mListener.imageDisplayFailed(this, mFileName, ERROR_NO_FILE_FOUND);
			return;
		}
		FileHandler fileHandler = FileHandler.shareInstance(WallWrapperApplication.getContext());
		String imageFolderString = fileHandler.getImagePath();
		File imageFile = fileHandler.findFileByName(mFileName, imageFolderString);
		Bitmap bitmap = ImageUtils.readFileToBitmapWithCompress2(imageFile.toString());
		if (null != bitmap && !bitmap.isRecycled()) {
			MemoryCache memoryCache = new MemoryCache();
			memoryCache.cacheImageWithImageName(bitmap, mFileName);
			mListener.imageDisplayFinished(this,mFileName, bitmap);
		}else {
			if (null != bitmap) {
				bitmap.recycle();
			}
			bitmap = null;
			mListener.imageDisplayFailed(this, mFileName, ERROR_OUT_OF_MEMORY);
		}
	}

	public void setImageDisplayListener(ImageDisplayListener listener) {
		this.mListener = listener;
	}

}
