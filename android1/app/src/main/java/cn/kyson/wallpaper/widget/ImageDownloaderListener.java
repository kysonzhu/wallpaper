package cn.kyson.wallpaper.widget;

/**
 * 
 * @author zhujinhui
 *
 */
public interface ImageDownloaderListener {

	/**
	 * 
	 * @param imageUrlString
	 */
	public void imageDownloadStarted(String imageUrlString);
	
	/**
	 * 
	 * @param imageUrlString
	 */
	public void imageDownloadFininshed(String imageUrlString);
	
	/**
	 * 
	 * @param imageUrlString
	 * @param percent
	 */
	public void imageDownloadProcess(String imageUrlString,float percent);
	
	/**
	 * 
	 * @param imageUrlString
	 * @param reason
	 */
	public void imageDownloadFailed(String imageUrlString,String reason);

}
