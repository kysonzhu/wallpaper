package com.leftbrain.wallwrapper.service.networkaccess;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

import android.util.Log;

public class StreamUtils {
	public static String convertStreamToString(InputStream inputStream) throws IOException {
		if (inputStream != null) {
			InputStreamReader insr = new InputStreamReader(inputStream);
			Writer writer = new StringWriter();
			int length = 1024;
			char[] buffer = new char[length];
			try {
				Reader reader = new BufferedReader(insr, length);
				int n;
				while ((n = reader.read(buffer)) != -1) {
					writer.write(buffer, 0, n);
				}
				reader.close();
			} finally {
				writer.close();
				insr.close();
			}
			return writer.toString();
		} else {
			return null;
		}
	}
	
	public static boolean writeStreamToFile(InputStream inputStream,File file) {
		boolean writeSucceed = false;
		if (inputStream == null || file == null) {
			return false;
		}
		if (file.isDirectory()) {
			return false;
		}
		
		FileOutputStream fileOutputStream = null;

	    int ch = 0;  
		try {  
	        fileOutputStream = new FileOutputStream(file);  

	        while((ch=inputStream.read()) != -1){  
	        	fileOutputStream.write(ch);  
	        }  
	    } catch (IOException e1) {  
	        e1.printStackTrace();  
	    } finally{  
	        try {
				fileOutputStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}  
	        try {
				inputStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}  
	    } 
		return writeSucceed;
	}
}
