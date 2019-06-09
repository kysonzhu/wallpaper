package cn.kyson.wallpaper.model;

public class Image {
	public String gid;
	public String gname;
	public String imgUrl;
	public String pId; 
	
    public static Image newImageSample(){
    	Image image = new Image();
    	image.gid = "2121212";
    	image.imgUrl = "http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1421830922198.jpg";
		return image;
	}
}
