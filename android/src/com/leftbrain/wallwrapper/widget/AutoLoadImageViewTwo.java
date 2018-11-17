package com.leftbrain.wallwrapper.widget;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;
import android.widget.Toast;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.WraperDetailViewpagerAdapter;
import com.leftbrain.wallwrapper.base.WallWrapperApplication;
import com.leftbrain.wallwrapper.base.WallWrapperEnvConfigure;
import com.leftbrain.wallwrapper.model.Image;
import com.leftbrain.wallwrapper.utils.imagedownloader.DiskCache;
import com.leftbrain.wallwrapper.utils.imagedownloader.FileDownloader;
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
public class AutoLoadImageViewTwo extends ImageView implements ImageDisplayListener, ImageDownloaderListener {

	// private ImageDownloaderListener mListener;
	private String mImageUrlString = null;
	private WraperDetailViewpagerAdapter mwraperDetailViewpagerAdapter;

	public AutoLoadImageViewTwo(Context context) {
		super(context);
	}

	public AutoLoadImageViewTwo(Context context, AttributeSet paramAttributeSet) {
		super(context, paramAttributeSet);
	}

	public AutoLoadImageViewTwo(Context context, AttributeSet attrs, int defStyleAttr) {
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
	 * @param wraperDetailViewpagerAdapter
	 */
	public void loadImage(String imageUrlString, WraperDetailViewpagerAdapter wraperDetailViewpagerAdapter) {
		String replacementString = "";
		String oldString = "\\";
		this.mwraperDetailViewpagerAdapter = wraperDetailViewpagerAdapter;
		final String imageUrl = imageUrlString.replace(oldString, replacementString);
		mImageUrlString = imageUrl;
		MemoryCache imageCache = new MemoryCache();
		Bitmap bitmap = imageCache.loadImage(mImageUrlString);
		if (null == bitmap) {
			// SET back ground color
			this.setImageBitmap(null);
			this.setBackgroundColor(WallWrapperApplication.getContext().getResources().getColor(R.color.randomcolor_0));
//			this.setBackgroundColor(WallWrapperEnvConfigure.getRandomColor());

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
		this.loadImage(mImageUrlString, mwraperDetailViewpagerAdapter);
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
	
	int i=0;

	@Override
	public void imageDownloadFailed(String imageUrlString, String reason) {
		i++;
		if(i==2){
			i=0;
			if(FileDownloader.ERROR_MESSAGE_404_STRING.equals(reason)){
			}else if(FileDownloader.ERROR_MESSAGE_IMAGESIZEERROR_STRING.equals(reason)){
				ArrayList<Image> imageList = mwraperDetailViewpagerAdapter.getArrayListImages();
				if (imageList != null) {
				ArrayList<Image> imagess = new ArrayList<Image>();
				for (int i = 0; i < imageList.size(); i++) {
					Image image2 = imageList.get(i);
					String imageString = image2.imgUrl.replace("\\", "").replace("720x1280", "640x960");
					if (imageUrlString.equals(imageString)) {
						imagess.add(image2);
						if (i+1  < imageList.size()) {
							this.loadImage(imageList.get(i + 1).imgUrl, mwraperDetailViewpagerAdapter);
						}
						break;
					}
				}
				imageList.removeAll(imagess);
				mwraperDetailViewpagerAdapter.notifyDataSetChanged();
				imagess.clear();
				}else{
					Toast.makeText(WallWrapperApplication.getContext(), "无尺寸图片", Toast.LENGTH_SHORT).show();
				}
			}else{
			}
		}else{
			this.loadImage(imageUrlString.replace("720x1280", "640x960"), mwraperDetailViewpagerAdapter);
		}
		// TODO Auto-generated method stub
		/*if(FileDownloader.ERROR_MESSAGE_404_STRING.equals(reason)){
		}else if(FileDownloader.ERROR_MESSAGE_IMAGESIZEERROR_STRING.equals(reason)){
			ArrayList<Image> imageList = mwraperDetailViewpagerAdapter.getArrayListImages();
			if (imageList != null) {
			ArrayList<Image> imagess = new ArrayList<Image>();
			for (int i = 0; i < imageList.size(); i++) {
				Image image2 = imageList.get(i);
				String imageString = image2.imgUrl.replace("\\", "");
				if (imageUrlString.equals(imageString)) {
					imagess.add(image2);
					if (i+1  < imageList.size()) {
						this.loadImage(imageList.get(i + 1).imgUrl, mwraperDetailViewpagerAdapter);
					}
					break;
				}
			}
			imageList.removeAll(imagess);
			mwraperDetailViewpagerAdapter.notifyDataSetChanged();
			imagess.clear();
			}else{
				Toast.makeText(WallWrapperApplication.getContext(), "无尺寸图片", Toast.LENGTH_SHORT).show();
			}
		}else{
		}*/
		
		// this.setImageBitmap(new BitmapDrawable(WallWrapperApplication.getContext().getResources().openRawResource(R.drawable.bg)).getBitmap());
	}

}
