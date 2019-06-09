package cn.kyson.wallpaper.utils;

import java.io.File;

public class WipeCache {
	
	private static WipeCache wipeCache = null;

	public static WipeCache shareInstance() {
		synchronized (WipeCache.class) {
			if (null == wipeCache) {
				synchronized (WipeCache.class) {
					wipeCache = new WipeCache();
				}
			}
		}
		return wipeCache;
	}
	
   public void clear(){
	   File file = new File("/mnt/sdcard/leftbrain/image");
		if(file==null){
			return;
		}
		
		File[] files = file.listFiles();
		if(0==files.length){
			return;
		}
		int sum = files.length;
		for (int i = 0; i < files.length; i++) {
			files[i].delete();  
		}
   }
}
