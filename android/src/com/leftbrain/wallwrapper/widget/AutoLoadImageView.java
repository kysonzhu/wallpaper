package com.leftbrain.wallwrapper.widget;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

import com.leftbrain.wallwrapper.base.WallWrapperEnvConfigure;
import com.leftbrain.wallwrapper.utils.imagedownloader.DiskCache;
import com.leftbrain.wallwrapper.utils.imagedownloader.ImageDisplayListener;
import com.leftbrain.wallwrapper.utils.imagedownloader.ImageDisplayTask;
import com.leftbrain.wallwrapper.utils.imagedownloader.ImageDownloader;
import com.leftbrain.wallwrapper.utils.imagedownloader.MD5Encoder;
import com.leftbrain.wallwrapper.utils.imagedownloader.MemoryCache;

/**
 * 
 * @author zhujinhui
 * 
 */
public class AutoLoadImageView extends ImageView implements ImageDisplayListener, ImageDownloaderListener {

	// private ImageDownloaderListener mListener;
	private String mImageUrlString = null;

	public AutoLoadImageView(Context context) {
		super(context);
	}

	public AutoLoadImageView(Context context, AttributeSet paramAttributeSet) {
		super(context, paramAttributeSet);
	}

	public AutoLoadImageView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}

	@Override
	protected void onDraw(Canvas canvas) {
		try {
			super.onDraw(canvas);
		} catch (Exception e) {
			System.out.println("MyImageView  -> onDraw() Canvas: trying to use a recycled bitmap");
		}
	}

	/**
	 * load image from url
	 * 
	 * @param imageUrlString
	 */
	public void loadImage(String imageUrlString) {
		String replacementString = "";
		String oldString = "\\";
		final String imageUrl = imageUrlString.replace(oldString, replacementString);
		mImageUrlString = imageUrl;
		MemoryCache imageCache = new MemoryCache();
		Bitmap bitmap = imageCache.loadImage(mImageUrlString);
		if (null == bitmap) {
			// SET back ground color
			this.setImageBitmap(null);
			this.setBackgroundColor(WallWrapperEnvConfigure.getRandomColor());

			String imageName = MD5Encoder.encoding(mImageUrlString);
			DiskCache diskCache = new DiskCache();
			diskCache.setImageDisplayListener(this);
			diskCache.loadImage(imageName);
		} else {
			this.setImageBitmap(bitmap);
		}
	}

	@Override
	public void imageDisplayStart(String imagePath) {
		// TODO Auto-generated method stub

	}

	@Override
	public void imageDisplayFinished(ImageDisplayTask task, String fileName, final Bitmap bitmap) {
		// TODO Auto-generated method stub
		this.loadImage(mImageUrlString);
	}

	@Override
	public void imageDisplayFailed(ImageDisplayTask task, String fileName, String reason) {
		// TODO Auto-generated method stub
		if (reason.equals(ImageDisplayTask.ERROR_NO_FILE_FOUND)) {
			// start download image
			ImageDownloader imageDownloader2 = new ImageDownloader(mImageUrlString);
			imageDownloader2.setImageDownloadListener(this);
			imageDownloader2.startDownload();
		} else if (reason.equals(ImageDisplayTask.ERROR_OUT_OF_MEMORY)) {
			// remove memory cache item
			MemoryCache imageCache = new MemoryCache();
			imageCache.clear();
			// load again
			DiskCache diskCache = new DiskCache();
			diskCache.setImageDisplayListener(this);
			diskCache.loadImage(fileName);
		}

	}

	/************************************ ImageDownloaderListener **********************************/

	@Override
	public void imageDownloadStarted(String imageUrlString) {
		// TODO Auto-generated method stub

	}

	@Override
	public void imageDownloadFininshed(String imageUrlString) {
		String imageName = MD5Encoder.encoding(imageUrlString);
		DiskCache diskCache = new DiskCache();
		diskCache.setImageDisplayListener(this);
		diskCache.loadImage(imageName);
	}

	@Override
	public void imageDownloadProcess(String imageUrlString, float percent) {
		// TODO Auto-generated method stub

	}

	@Override
	public void imageDownloadFailed(String imageUrlString, String reason) {
		// TODO Auto-generated method stub
		Log.i("kyson", imageUrlString);
		
		
		
//		this.setImageBitmap(new BitmapDrawable(WallWrapperApplication.getContext().getResources().openRawResource(R.drawable.bg)).getBitmap());
	    
	}

}
