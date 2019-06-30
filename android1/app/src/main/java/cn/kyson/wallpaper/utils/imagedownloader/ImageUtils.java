package cn.kyson.wallpaper.utils.imagedownloader;

import java.io.File;
import java.io.FileOutputStream;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.WindowManager;

import cn.kyson.wallpaper.base.WallWrapperApplication;
import cn.kyson.wallpaper.model.ImageSize;

/**
 * 图片工具，包括图片保存，
 * 
 */
public class ImageUtils {
	private static final String TAG = "ImageUtils";

	@SuppressLint("NewApi")
	public static Bitmap readFileToBitmapWithCompress(String imageFilePathString) {

		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(imageFilePathString, options);
		int w = options.outWidth;
		int h = options.outHeight;
		Log.i("before compress", "width" + w + "height" + h);

		float hh = 800f;
		float ww = 480f;
		int be = 1;
		if (w > h && w > ww) {
			be = (int) (options.outWidth / ww);
		} else if (w < h && h > hh) {
			be = (int) (options.outHeight / hh);
		}
		if (be <= 0)
			be = 1;
		options.inSampleSize = be;
		options.inJustDecodeBounds = false;
		Bitmap resultBmp = null;
		try {
			resultBmp = BitmapFactory.decodeFile(imageFilePathString, options);
			if (resultBmp != null)
				Log.i("wenjuan", "after compress" + resultBmp.getRowBytes() * resultBmp.getHeight());
		} catch (OutOfMemoryError err) {
			Log.i("<>", "readFileToBitmapWithCompress OutOfMemoryError");
			if (resultBmp != null) {
				resultBmp.recycle();
				resultBmp = null;
			}

		}
		return resultBmp;
	}

	public static void writeBitmap2File(Bitmap bitmap, File file) {
		if (bitmap == null || file == null)
			return;
		FileOutputStream fos = null;
		try {
			// save to the local file
			fos = new FileOutputStream(file);
			bitmap.compress(CompressFormat.PNG, 100, fos);
			fos.flush();
		} catch (Exception e) {
			Log.e(TAG, "write the bitmap to file exception", e);
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (Exception e) {

				} finally {
					fos = null;
				}
			}
		}
	}

	@SuppressLint("NewApi")
	public static Bitmap readFileToBitmapWithCompress2(String imageFilePathString) {

		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(imageFilePathString, options);
		int w = options.outWidth;
		int h = options.outHeight;
		Log.i("before compress", "width:" + w + "height:" + h);

		float hh = 800f;
		float ww = 480f;
		int be = 1;
		if (w > h && w > ww) {
			be = (int) (options.outWidth / ww);
		} else if (w < h && h > hh) {
			be = (int) (options.outHeight / hh);
		}
		if (be <= 0)
			be = 1;
		options.inSampleSize = be;
		options.inJustDecodeBounds = false;
		Bitmap resultBmp = null;
		try {
			resultBmp = BitmapFactory.decodeFile(imageFilePathString, options);
			int w1 = options.outWidth;
			int h1 = options.outHeight;
			Log.i("before compress", "width:" + w1 + "height:" + h1);
			if (resultBmp != null)
				Log.i("wenjuan", "after compress" + resultBmp.getRowBytes() * resultBmp.getHeight());
		} catch (OutOfMemoryError err) {
			Log.i("<>", "readFileToBitmapWithCompress OutOfMemoryError");
			if (resultBmp != null) {
				resultBmp.recycle();
				resultBmp = null;
			}
			Runtime.getRuntime().gc();
		}
		return resultBmp;
	}

	/**
	 * 
	 * @param imageFilePathString
	 * @param size
	 * @return
	 */
	public static Bitmap readFileToBitmapToSize(String imageFilePathString, ImageSize size) {
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(imageFilePathString, options);

		DisplayMetrics metrics = new DisplayMetrics();
		WindowManager wm = (WindowManager) WallWrapperApplication.getContext().getSystemService(Context.WINDOW_SERVICE);
		wm.getDefaultDisplay().getMetrics(metrics);
		float f = metrics.densityDpi / 160.f;
		int w = options.outWidth ;
		int h = options.outHeight;
		
		Bitmap bitmap = ImageUtils.readFileToBitmapWithCompress(imageFilePathString);
//		options.inJustDecodeBounds = false;
//		Matrix matrix = new Matrix();
//		matrix.postScale(f,f);
//		if(bitmap==null){
//			return null;
//		}else{
//		Bitmap resizeBmp = Bitmap.createBitmap(bitmap,0,0,w,h,matrix,true);
//		return resizeBmp;
//		}
		return bitmap;
	}

//	public static boolean hasPermission(@NonNull Context context, @NonNull String permission) {
//		if (ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED
//				|| PermissionChecker.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
//			return false;
//		}
//
//		return true;
//	}

}
