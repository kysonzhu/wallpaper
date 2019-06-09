package cn.kyson.wallpaper.utils.imagedownloader;

import android.graphics.Bitmap;
import android.text.TextUtils;
import android.util.Log;

public class MemoryCache {
	private static final String TAG = "ImageCache";
	// 获取系统分配给每个应用程序的最大内存，每个应用系统分配32M
	private static int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
	// 给LruCache分配1/8 4M
	private static int cacheSize = maxMemory / 8;

	private static LruCache<String, Bitmap> mLruCache = new LruCache<String, Bitmap>(cacheSize) {

		@Override
		protected int sizeOf(String key, Bitmap value) {
			return value.getRowBytes() * value.getHeight() / 1024;
		}

		@Override
		protected void entryRemoved(boolean evicted, String key, Bitmap oldValue, Bitmap newValue) {
			super.entryRemoved(evicted, key, oldValue, newValue);
			if (evicted && null != oldValue && !oldValue.isRecycled()) {
				oldValue.recycle();
				oldValue = null;
			}
		}

	};

	/**
	 * 加载图片,如果没有，则加载默认图片
	 * 
	 * @param resId
	 * @param imageView
	 */
	public Bitmap loadImage(String imageUrlString) {
		Bitmap bitmap = null;
		if (!TextUtils.isEmpty(imageUrlString)) {
			String imageKey = MD5Encoder.encoding(imageUrlString);
			bitmap = mLruCache.get(imageKey);
		}
		if (bitmap != null && !bitmap.isRecycled()) {
			return bitmap;
		} else {
			return null;
		}
	}

	/**
	 * 缓存图片
	 * 
	 * @param imageNameString
	 *            文件名（不包含路径）
	 */
	public void cacheImage(Bitmap bitmap, String fileUrlString) {
		if (fileUrlString == null || bitmap == null) {
			Log.i(TAG, "参数传入有误,fileNameString或bitmap为空");
			return;
		}
		if (bitmap != null) {
			String imageKey = MD5Encoder.encoding(fileUrlString);
			mLruCache.put(imageKey, bitmap);
		}

	}
	
	public void cacheImageWithImageName(Bitmap bitmap, String fileName) {
		if (fileName == null || bitmap == null) {
			Log.i(TAG, "参数传入有误,fileNameString或bitmap为空");
			return;
		}
		if (bitmap != null) {
			mLruCache.put(fileName, bitmap);
		}

	}
	
	public void clear(){
		System.gc();
	}

}
