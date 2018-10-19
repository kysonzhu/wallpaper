package com.leftbrain.wallwrapper.base;

import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

import android.content.Context;
import android.graphics.Paint;
import android.util.Log;
import android.view.WindowManager;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.model.ImageSize;
import com.leftbrain.wallwrapper.service.taskpool.EnvironmentConfigure;

/**
 * 
 * environment configuration
 * 
 * @author dell
 * 
 */
public class WallWrapperEnvConfigure extends EnvironmentConfigure {

	public static float GROUP_COVER_IMAGE_HEIGHT = 312.f;
	public static float GROUP_COVER_IMAGE_WIDTH = 208.f;

	public static final int NO_IMAGE_HEIGHT_FOUND = 10000;
	private static WallWrapperEnvConfigure wallWrapperEnvConfigure;

	public static int getScreenWidth() {
		Context context = WallWrapperApplication.getContext();

		WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
		int width = wm.getDefaultDisplay().getWidth();

		Log.i("kyson", "width:" + width + "   height:" + getScreenHeight());
		return width;
	}

	/**
	 * 
	 * @return
	 */
	public static int getScreenHeight() {
		Context context = WallWrapperApplication.getContext();
		WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);

		int height = wm.getDefaultDisplay().getHeight();
		return height;
	}

	public static WallWrapperEnvConfigure instance() {
		// TODO Auto-generated method stub
		synchronized (WallWrapperEnvConfigure.class) {
			if (null == wallWrapperEnvConfigure) {
				wallWrapperEnvConfigure = new WallWrapperEnvConfigure();
			}
		}
		return wallWrapperEnvConfigure;
	}

	/**
	 * denominator is 16
	 */
	private String getScreenWidthNumerator() {
		int width = getScreenWidth();
		int height = getScreenHeight();
		float numerator = width / (height / 16.f);
		DecimalFormat df = new DecimalFormat("###.0");
		String dfString = df.format(numerator);

		ArrayList<String> allScreenNumerator = new ArrayList<String>();
		allScreenNumerator.add("8.9");
		allScreenNumerator.add("9");
		allScreenNumerator.add("9.37");
		allScreenNumerator.add("9.6");
		allScreenNumerator.add("10");
		allScreenNumerator.add("10.6");
		if (!allScreenNumerator.contains(dfString)) {
			numerator = 9;
		}
		return "" + numerator;
	}

	private int getNearestWidth() {
		int width = getScreenWidth();
		ArrayList<String> allScreenWidth = new ArrayList<String>();
		allScreenWidth.add("1080");
		allScreenWidth.add("800");
		allScreenWidth.add("768");
		allScreenWidth.add("750");
		allScreenWidth.add("720");
		allScreenWidth.add("640");
		allScreenWidth.add("600");
		allScreenWidth.add("540");
		allScreenWidth.add("480");
		allScreenWidth.add("320");
		allScreenWidth.add("240");
		if (!allScreenWidth.contains(width + "")) {
			width = getNearestNumber(allScreenWidth, width + "");
		}
		return width;
	}

	private int getHeight(int width) {
		int resultHeight = NO_IMAGE_HEIGHT_FOUND;

		HashMap<String, String> screenHashMap = new HashMap<String, String>();
		screenHashMap.put("1080", "1920");
		screenHashMap.put("800", "1280");
		screenHashMap.put("768", "1280");
		screenHashMap.put("750", "1334");
		screenHashMap.put("720", "1280");
		screenHashMap.put("640", "1136&960");
		screenHashMap.put("600", "1024");
		screenHashMap.put("540", "960");
		screenHashMap.put("480", "854&800");
		screenHashMap.put("320", "480");
		screenHashMap.put("240", "320");
		String widthString = width + "";
		String heightString = screenHashMap.get(widthString);

		if (null == heightString) {
			resultHeight = NO_IMAGE_HEIGHT_FOUND;
		} else {
			if (heightString.contains("&")) {
				String[] heights = heightString.split("&");
				for (String heightItem : heights) {
					if (heightItem.equals(getScreenHeight() + "")) {
						heightString = heightItem;
						resultHeight = Integer.valueOf(heightString);
						break;
					}
				}
			} else {
				int zolHeight = Integer.valueOf(heightString);
				int currentHeight = getScreenHeight();
				if (zolHeight != currentHeight) {
					resultHeight = NO_IMAGE_HEIGHT_FOUND;
				} else {
					resultHeight = Integer.valueOf(heightString);
				}
			}

		}

		return resultHeight;
	}

	private int getNearestNumber(ArrayList<String> numbers, String number) {
		int tempNumber = 0;
		int targetNumber = Integer.valueOf(number);
		int resultNumber = targetNumber;
		for (String numberItem : numbers) {
			int numberItemInteger = Integer.valueOf(numberItem);
			tempNumber = numberItemInteger - targetNumber;
			if (tempNumber < resultNumber) {
				resultNumber = tempNumber;
			}
		}
		return resultNumber;
	}

	/**
	 * 
	 * @return
	 */
	public ImageSize getImgSize() {
		ImageSize imageSize = new ImageSize();
		imageSize.width = getNearestWidth();
		imageSize.height = getHeight(imageSize.width);
		if (NO_IMAGE_HEIGHT_FOUND == imageSize.height) {
			String screenWidthNumerator = getScreenWidthNumerator();
			HashMap<String, ImageSize> screenHashMap = new HashMap<String, ImageSize>();
			screenHashMap.put("8.9", new ImageSize(750, 1334));
			screenHashMap.put("9", new ImageSize(720, 1280));
			screenHashMap.put("9.37", new ImageSize(600, 1024));
			screenHashMap.put("9.6", new ImageSize(768, 1280));
			screenHashMap.put("10", new ImageSize(800, 1280));
			screenHashMap.put("10.6", new ImageSize(640, 960));
			imageSize = screenHashMap.get(screenWidthNumerator);
		}
		return imageSize;
	}

	public static int getRandomColor() {
		int color = 0;
		Random random = new Random();
		int index = random.nextInt(8);
		switch (index) {
		case 0: {
			color = R.color.randomcolor_0;
		}
			break;
		case 1: {
			color = R.color.randomcolor_1;
		}
			break;
		case 2: {
			color = R.color.randomcolor_2;
		}
			break;
		case 3: {
			color = R.color.randomcolor_3;
		}
			break;
		case 4: {
			color = R.color.randomcolor_4;
		}
			break;
		case 5: {
			color = R.color.randomcolor_5;
		}
			break;
		case 6: {
			color = R.color.randomcolor_6;
		}
			break;
		case 7: {
			color = R.color.randomcolor_7;
		}
			break;

		}
		return WallWrapperApplication.getContext().getResources().getColor(color);

	}

	/**
	 * confirm that the title character number is ok
	 * 
	 * @param str
	 * @return
	 */
	public static String getProssedTitle(String str, int pageCount) {
		float width = getScreenWidth() / 3.f - 5;
		float dd = (float) new Paint().measureText(str,0,str.length());
		
		try {
			int lenghth = str.getBytes("gbk").length;
			if (lenghth > 30) {
				int location = getTrimLocaltion(str);
				String str2 = str.substring(0, location);
				StringBuilder builder = new StringBuilder(str2);
				if (0 != pageCount) {
					builder.append("..." + "(" + pageCount + "张)");
				}
				str2 = builder.toString();
				return str2;
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}

	private static boolean isChineaseCharacter(String character) {
		int lenghth = 0;
		try {
			lenghth = character.getBytes("gbk").length;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		int length2 = character.length();
		if (lenghth == length2) {
			return false;
		}
		return true;
	}

	/**
	 */
	private static int getTrimLocaltion(String title) {
		int length = title.length();
		int resultLocation = 0;
		int resultInex = 0;
		for (int i = 0; i < length; i++) {
			String characterString = title.substring(i, i + 1);
			if (isChineaseCharacter(characterString)) {
				resultLocation += 2;
			} else {
				++resultLocation;
			}
			if (resultLocation >= 27) {
				resultInex = i;
				break;
			}
		}

		return resultInex;
	}

}
