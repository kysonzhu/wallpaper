package cn.kyson.wallpaper.viewmodel;

import java.io.Serializable;

import cn.kyson.wallpaper.model.Category;

@SuppressWarnings("serial")
public class SubCategoryViewModel extends WallWrapperViewModel implements Serializable{

	public String cateId;
	public String cateShortName;
	public boolean issubcategory_screen;
	
	
	public Category category;

}
