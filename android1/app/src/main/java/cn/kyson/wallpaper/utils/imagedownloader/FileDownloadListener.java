package cn.kyson.wallpaper.utils.imagedownloader;

public interface FileDownloadListener {

	/**
	 * 
	 * @param fileUrlString
	 */
	public void fileDownloadStarted(String fileUrlString);

	/**
	 * 
	 * @param fileUrlString
	 */
	public void fileDownloadFininshed(String fileUrlString);

	/**
	 * 
	 * @param fileUrlString
	 * @param percent
	 */
	public void fileDownloadProcess(String fileUrlString, float percent);

	/**
	 * 
	 * @param fileUrlString
	 * @param reason
	 */
	public void fileDownloadFailed(String fileUrlString, String reason);
}
