package com.leftbrain.wallwrapper.model;

/**
 * category 
 * @author dell
 *
 */
public class Category {
	public String cateId;
	public String cateName;
	public String cateShortName;
	public String cateEnglish;
	public String level;
	public String fatherId;
	public String keyword;
	public String coverImgUrl;
	
	public static Category newCategorySample(){
		Category category = new Category();
		category.cateName = "美女";
		category.coverImgUrl = "http://b.zol-img.com.cn/sjbizhi/images/8/208x312/1421830922198.jpg";
		return category;
	}

	@Override
	public String toString() {
		return "Category [cateId=" + cateId + ", cateName=" + cateName + ", cateShortName=" + cateShortName + ", cateEnglish=" + cateEnglish + ", level=" + level + ", fatherId=" + fatherId + ", keyword=" + keyword + ", coverImgUrl=" + coverImgUrl + "]";
	}
	
	
}