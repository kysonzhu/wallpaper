package cn.kyson.wallpaper.utils.imagedownloader;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;

import android.content.Context;
import android.net.http.AndroidHttpClient;

import cn.kyson.wallpaper.service.networkaccess.StreamUtils;

public class FileDownLoad {
	private static final int STATUS_OK = 200;
	private FileHandler mFileHandler;

	public FileDownLoad(Context context) {
		mFileHandler = new FileHandler(context);
	}

	public boolean downloadByUrlByGzip(String urlString, String fileName) {
		boolean downloadSucceed = false;

		AndroidHttpClient httpClient = AndroidHttpClient.newInstance(null);
		httpClient.getParams().setParameter("Accept-Encoding", "gzip");
		HttpPost post = new HttpPost(urlString);
		HttpResponse response = null;

		try {
			response = httpClient.execute(post);
			if (response.getStatusLine().getStatusCode() == STATUS_OK) {
				HttpEntity entity = response.getEntity();
				File file = mFileHandler.createEmptyFileToDownloadDirectory(fileName);

				InputStream inputStream = AndroidHttpClient.getUngzippedContent(entity);
				downloadSucceed = StreamUtils.writeStreamToFile(inputStream, file);
			} else {
				System.out.println("---");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			httpClient.close();
		}
		return downloadSucceed;
	}

	public boolean downloadByUrl(String urlString, String fileName) {
		boolean downloadSucceed = false;
		AndroidHttpClient httpClient = AndroidHttpClient.newInstance(null);
		// HttpPost post = new HttpPost(urlString);
		HttpGet get = new HttpGet(urlString);
		HttpResponse response = null;
		try {
			response = httpClient.execute(get);
			if (response.getStatusLine().getStatusCode() == STATUS_OK) {
				HttpEntity entity = response.getEntity();
				File file = mFileHandler.createEmptyFileToDownloadDirectory(fileName);
				entity.writeTo(new FileOutputStream(file));
				downloadSucceed = true;
			} else {
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			httpClient.close();
		}
		return downloadSucceed;
	}

	public File downloadByUrl(String urlString) {
		AndroidHttpClient httpClient = AndroidHttpClient.newInstance(null);
		HttpGet get = new HttpGet(urlString);
		File file = null;
		try {
			HttpResponse response = httpClient.execute(get);
			if (response.getStatusLine().getStatusCode() == STATUS_OK) {
				HttpEntity entity = response.getEntity();
				file = mFileHandler.createEmptyFileToDownloadDirectory(MD5Encoder.encoding(urlString));
				entity.writeTo(new FileOutputStream(file));
			} else if (response.getStatusLine().getStatusCode() == 404) {
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			httpClient.close();
			httpClient = null;
		}
		return file;
	}
}
