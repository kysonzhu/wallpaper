package com.leftbrain.wallwrapper.service.taskpool;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.StreamCorruptedException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Base64;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.base.WallWrapperApplication;

public class EnvironmentConfigure {

	/** 设备Id */
	public static String uuid;

	/** 挡板状态 */
	public static boolean mockState = false;

	/**
	 * 判断当前请求是否为挡板数据类型
	 * 
	 * @param type
	 * @return
	 */
	public static boolean currentRequestTypeIsMock(String type) {
		if (type.startsWith("http://") || type.startsWith("https://")) {
			return false;
		}
		return true;
	}

	public SharedPreferences sp;
	private static String CONFIG_PREFERENCES = "config_preferences";

	public void configurationEnvironment(Context context) {
		sp = context.getSharedPreferences(CONFIG_PREFERENCES, Context.MODE_PRIVATE);
	}

	/**
	 * 储存一个对象到share preferences
	 */
	public <T> void saveObjectToSharePreferences(T object, String key) {
		if (object != null && key != null) {
			SharedPreferences.Editor editor = sp.edit();
			List<Object> list = new ArrayList<Object>();
			list.add(object);

			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			try {
				ObjectOutputStream oos = new ObjectOutputStream(baos);
				oos.writeObject(list);
				String strList = new String(Base64.encode(baos.toByteArray(), Base64.DEFAULT));
				editor.putString(key, strList);
				editor.commit();
				oos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				try {
					baos.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	/**
	 * 从share preferences获取一个对象
	 */
	public <T> T getObjectFromSharePreferences(String shaPreName) {
		List<Object> list;
//		sp = WallWrapperApplication.getContext().getSharedPreferences(CONFIG_PREFERENCES, Context.MODE_PRIVATE);
		String message = sp.getString(shaPreName, "");
		byte[] buffer = Base64.decode(message.getBytes(), Base64.DEFAULT);
		ByteArrayInputStream bais = new ByteArrayInputStream(buffer);
		try {
			ObjectInputStream ois = new ObjectInputStream(bais);
			list = (List<Object>) ois.readObject();
			ois.close();
			return (T) list.get(0);
		} catch (StreamCorruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				bais.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
	
}
