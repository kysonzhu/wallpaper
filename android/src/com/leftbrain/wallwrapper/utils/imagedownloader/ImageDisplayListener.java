package com.leftbrain.wallwrapper.utils.imagedownloader;

import android.graphics.Bitmap;

/**
 * 
 * @author zhujinhui
 * 
 */
public interface ImageDisplayListener {

	/**
	 * 
	 * @param imagePath
	 */
	public void imageDisplayStart(String fileName);

	/**
	 * 
	 * @param imagePath
	 */
	public void imageDisplayFinished(ImageDisplayTask task, String fileName, Bitmap bitmap);

	/**
	 * 
	 * @param task
	 * @param fileName
	 * @param reason
	 */
	public void imageDisplayFailed(ImageDisplayTask task, String fileName, String reason);

}
