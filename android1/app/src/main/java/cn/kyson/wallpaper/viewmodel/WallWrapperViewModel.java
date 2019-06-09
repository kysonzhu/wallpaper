package cn.kyson.wallpaper.viewmodel;

import java.util.ArrayList;

import cn.kyson.wallpaper.model.Category;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.model.Image;
import cn.kyson.wallpaper.service.WallWrapperServiceMediator;
import cn.kyson.wallpaper.service.networkaccess.ServiceResponse;
import cn.kyson.wallpaper.service.taskpool.ViewModel;

@SuppressWarnings("rawtypes")
public class WallWrapperViewModel extends ViewModel {

	public ArrayList<Group> groups;
	public ArrayList<Image> images;
	public ArrayList<Category> categorys;
	public String start;
	public String cateId;

	@SuppressWarnings("unchecked")
	@Override
	public void paddingResult(String method) {
		// TODO Auto-generated method stub
		super.paddingResult(method);
		ServiceResponse response = (ServiceResponse) getModel();

		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETCATEGORYLIST)) {
			categorys = (ArrayList<Category>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETSECONDARYCATEGORYSELECTEDLIST)) {
			categorys = (ArrayList<Category>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETIMAGES)) {
			images = (ArrayList<Image>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST)) {
			groups = (ArrayList<Group>) response.getResponse();
		}

	}
}
