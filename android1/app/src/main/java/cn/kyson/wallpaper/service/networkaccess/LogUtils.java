package cn.kyson.wallpaper.service.networkaccess;

import android.util.Log;

public class LogUtils {

	private static Boolean MYLOG_SWITCH = true;
	private static Boolean MYLOG_SWITCH_EXCEPT_ERROR = true;
	private static char MYLOG_TYPE = 'v';

	public static void w(String tag, Object msg) {
		log(tag, msg.toString(), 'w');
	}

	public static void e(String tag, Object msg) {
		log(tag, msg.toString(), 'e');
	}

	public static void d(String tag, Object msg) {
		log(tag, msg.toString(), 'd');
	}

	public static void i(String tag, Object msg) {
		log(tag, msg.toString(), 'i');
	}

	public static void v(String tag, Object msg) {
		log(tag, msg.toString(), 'v');
	}

	public static void w(String tag, String text) {
		log(tag, text, 'w');
	}

	public static void e(String tag, String text) {
		log(tag, text, 'e');
	}

	public static void d(String tag, String text) {
		log(tag, text, 'd');
	}

	public static void i(String tag, String text) {
		log(tag, text, 'i');
	}

	public static void v(String tag, String text) {
		log(tag, text, 'v');
	}

	private static void log(String tag, String msg, char level) {
		if (MYLOG_SWITCH) {
			if ('e' == level && ('e' == MYLOG_TYPE || 'v' == MYLOG_TYPE)) {
				Log.e(tag, msg);
			} else if ('w' == level && ('w' == MYLOG_TYPE || 'v' == MYLOG_TYPE) && MYLOG_SWITCH_EXCEPT_ERROR) {
				Log.w(tag, msg);
			} else if ('d' == level && ('d' == MYLOG_TYPE || 'v' == MYLOG_TYPE) && MYLOG_SWITCH_EXCEPT_ERROR) {
				Log.d(tag, msg);
			} else if ('i' == level && ('d' == MYLOG_TYPE || 'v' == MYLOG_TYPE) && MYLOG_SWITCH_EXCEPT_ERROR) {
				Log.i(tag, msg);
			} else if (MYLOG_SWITCH_EXCEPT_ERROR) {
				Log.v(tag, msg);
			}
		}
	}
}
