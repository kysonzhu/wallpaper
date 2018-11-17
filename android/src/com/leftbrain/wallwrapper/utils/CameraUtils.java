package com.leftbrain.wallwrapper.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import com.leftbrain.wallwrapper.base.WallWrapperApplication;
import com.leftbrain.wallwrapper.utils.imagedownloader.FileHandler;

public class CameraUtils {

	private static CameraUtils instance = null;

	public static CameraUtils shareInstance() {
		synchronized (CameraUtils.class) {
			if (null == instance) {
				synchronized (CameraUtils.class) {
					instance = new CameraUtils();
				}
			}
		}
		return instance;
	}

	public void removeImage(String fileName) {
		FileHandler fileNaHandler = FileHandler.shareInstance(WallWrapperApplication.getContext());
		File imageFile = fileNaHandler.findFileByName(fileName, fileNaHandler.getImagePath());
		if (null != imageFile) {
			String fileString = WallWrapperApplication.getContext().getExternalFilesDir(Environment.DIRECTORY_DCIM).getPath();
			File file = new File(fileString);
			if (file == null) {
				return;
			}
			File[] files = file.listFiles();
			if (0 == files.length) {
				return;
			}
			for (int i = 0; i < files.length; i++) {
				if (files[i] == imageFile) {
					files[i].delete();
				}
			}
		}
	}

	public void addImage(String fileName) {
		FileHandler fileNaHandler = FileHandler.shareInstance(WallWrapperApplication.getContext());
		File imageFile = fileNaHandler.findFileByName(fileName, fileNaHandler.getImagePath());
		if (null != imageFile) {
			String fileString = WallWrapperApplication.getContext().getExternalFilesDir(Environment.DIRECTORY_DCIM).getPath();
			boolean isAddImage = copy(imageFile, fileString);
			if (isAddImage) {

			}
		} else {
			Log.i("kyson", "fffffffffff");
		}
	}

	public void addImage(String folder, String fileName) {
//		boolean isAddImage = this.copy(fileName, folder);
	}
	
	public boolean copy(File imageFile, String toFilePath) {
		try {
			FileInputStream fis = new FileInputStream(imageFile);
			File file = new File(toFilePath,imageFile.getName()+".jpg");
			FileOutputStream fos = new FileOutputStream(file);
			int len = -1;
			byte[] b = new byte[1024 * 512];
			while ((len = fis.read(b)) != -1) {
				fos.write(b, 0, len);
			}
			
			FileInputStream fis2 = new FileInputStream(file);
//			Bitmap bitmap = BitmapFactory.decodeStream(fis2);
//			if (fis2 != null) {
//				fis2.close();
//				fis2 = null;
//			}
			
			byte[] data = getBytes(fis2);
            final BitmapFactory.Options options = new BitmapFactory.Options();
            //设置成true后decode不会返回bitmap,但可以返回bitmap的横像素和纵像素还有图片类型
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeByteArray(data, 0, data.length, options);
            // BitmapFactory.decodeStream(inputStream,null,options);
            options.inJustDecodeBounds = false;
            //bitmap=BitmapFactory.decodeStream(inputStream,null,options);
            Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length, options);
            fis2.close();
            fis2 = null;
			
		    try {
		        FileOutputStream fos2 = new FileOutputStream(file);
		        bitmap.compress(CompressFormat.JPEG, 100, fos2);
		        fos2.flush();
		        fos2.close();
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    
		 // 其次把文件插入到系统图库
		    try {
		        MediaStore.Images.Media.insertImage(WallWrapperApplication.getContext().getContentResolver(),
						file.getAbsolutePath(), imageFile.getName()+".jpg", null);
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    
		    WallWrapperApplication.getContext().sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://" + file.getPath())));
		    
			if (fis != null) {
				fis.close();
				fis = null;
			}
			if (fos != null) {
				fos.flush();
				fos.close();
				fos = null;
			}
			return true;
		} catch (Exception e) {
			Log.i("kyson", "999999999"+e);
		}
		return false;
	}

	
	
	public static byte[] getBytes(InputStream is) throws IOException {
        ByteArrayOutputStream outstream = new ByteArrayOutputStream();
        //把所有的变量收集到一起，然后一次性把数据发送出去
        byte[] buffer = new byte[1024]; // 用数据装
        int len = 0;
        while ((len = is.read(buffer)) != -1) {
            outstream.write(buffer, 0, len);
        }
        outstream.close();

        return outstream.toByteArray();
    }

}
