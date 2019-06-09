package cn.kyson.wallpaper.utils.imagedownloader;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.util.Log;

import cn.kyson.wallpaper.base.WallWrapperApplication;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

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

	private final OkHttpClient okHttpClient;

	private static final int STATUS_OK = 200;

	public FileDownloader(String fileUrlString) {
		// TODO Auto-generated constructor stub
		mFileUrlString = fileUrlString;
		okHttpClient = new OkHttpClient();
	}

	public void startDownload() {
		// TODO Auto-generated method stub
//		AndroidHttpClient httpClient = AndroidHttpClient.newInstance(null);
		OkHttpClient client = new OkHttpClient();
		Request request = new Request.Builder().url(mFileUrlString).build();


		Log.i("kyson", "file url string :"+ mFileUrlString);
//		HttpGet get = new HttpGet(mFileUrlString);

		okHttpClient.newCall(request).enqueue(new Callback() {

			@Override
			public void onFailure(Call call, IOException e) {

			}

			@Override
			public void onResponse(Call call, Response response) throws IOException {

				InputStream is = null;
				byte[] buf = new byte[2048];
				int len = 0;
				FileOutputStream fos = null;
				// 储存下载文件的目录
				String fileNameString = MD5Encoder.encoding(mFileUrlString);
				File file = FileHandler.shareInstance(WallWrapperApplication.getContext()).createEmptyFileToDownloadDirectory(fileNameString);
				Log.i("kyson", "file is size :" + file.length());


				try {
					is = response.body().byteStream();
					long total = response.body().contentLength();
					fos = new FileOutputStream(file);
					long sum = 0;
					while ((len = is.read(buf)) != -1) {
						fos.write(buf, 0, len);
						sum += len;
						int progress = (int) (sum * 1.0f / total * 100);
						// 下载中
//						listener.onDownloading(progress);
					}
					fos.flush();
					// 下载完成
//					listener.onDownloadSuccess();


				} catch (Exception e) {
//					listener.onDownloadFailed();
				} finally {
					try {
						if (is != null)
							is.close();
					} catch (IOException e) {
					}
					try {
						if (fos != null)
							fos.close();
					} catch (IOException e) {
					}
				}
			}
		});
	}
	
	public void setFileDownloadListener(FileDownloadListener listener){
		mListener = listener;
	}

}
