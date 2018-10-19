package com.leftbrain.wallwrapper.viewmodel;

import java.io.Serializable;

import com.leftbrain.wallwrapper.model.Category;

@SuppressWarnings("serial")
public class SubCategoryViewModel extends WallWrapperViewModel implements Serializable{

	public String cateId;
	public String cateShortName;
	public boolean issubcategory_screen;
	
	
	public Category category;

}
