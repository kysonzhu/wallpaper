package cn.kyson.wallpaper.utils.imagedownloader;

import java.io.File;
import java.io.FileOutputStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;

import android.net.http.AndroidHttpClient;
import android.util.Log;

import cn.kyson.wallpaper.base.WallWrapperApplication;

/**
 * file downloader
 * 
 * @author zhujinhui
 * 
 */
public class FileDownloader {
	private String mFileUrlString = null;
	private FileDownloadListener mListener;
	public static final String ERROR_MESSAGE_IMAGESIZEERROR_STRING = "picture size error";
	public static final String ERROR_MESSAGE_404_STRING = "404 Not Found";

	private static final int STATUS_OK = 200;

	public FileDownloader(String fileUrlString) {
		// TODO Auto-generated constructor stub
		mFileUrlString = fileUrlString;
	}

	public void startDownload() {
		// TODO Auto-generated method stub
		AndroidHttpClient httpClient = AndroidHttpClient.newInstance(null);
		Log.i("kyson", "file url string :"+ mFileUrlString);
		HttpGet get = new HttpGet(mFileUrlString);
		File file = null;
		try {
			HttpResponse response = httpClient.execute(get);
			if (response.getStatusLine().getStatusCode() == STATUS_OK) {
				HttpEntity entity = response.getEntity();
				String fileNameString = MD5Encoder.encoding(mFileUrlString);
				file = FileHandler.shareInstance(WallWrapperApplication.getContext()).createEmptyFileToDownloadDirectory(fileNameString);
				Log.i("kyson", "file is size :"+ file.length());
				entity.writeTo(new FileOutputStream(file));
				if (ERROR_MESSAGE_IMAGESIZEERROR_STRING.length() != entity.getContentLength() ) {
					if (null != mListener) {
						Log.i("kyson", "file is size :"+ mFileUrlString);
						mListener.fileDownloadFininshed(mFileUrlString);
					}else {
						Log.i("kyson", "file is size :"+ "error");
						mListener.fileDownloadFailed(mFileUrlString, ERROR_MESSAGE_IMAGESIZEERROR_STRING);
					}
				}else{
					Log.i("kyson", "file is size :"+ "error");
					mListener.fileDownloadFailed(mFileUrlString, ERROR_MESSAGE_IMAGESIZEERROR_STRING);
				}
				
			} else if (response.getStatusLine().getStatusCode() == 404) {
				if (null != mListener) {
					Log.i("kyson", "file is size :"+ "404");
					mListener.fileDownloadFailed(mFileUrlString, ERROR_MESSAGE_404_STRING);
				}
				//
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			httpClient.close();
			httpClient = null;
		}
	}
	
	
	public void setFileDownloadListener(FileDownloadListener listener){
		mListener = listener;
	}

}
