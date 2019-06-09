package cn.kyson.wallpaper.model;

import java.io.Serializable;

@SuppressWarnings("serial")
public class ImageSize implements Serializable {
	public int width;
	public int height;
	
	public ImageSize(int width,int height) {
		// TODO Auto-generated constructor stub
		this.width = width;
		this.height = height;
	}
	
	public ImageSize() {
		// TODO Auto-generated constructor stub
		this.width = 0;
		this.height = 0;
	}
}
