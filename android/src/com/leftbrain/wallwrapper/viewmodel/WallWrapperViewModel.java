package com.leftbrain.wallwrapper.viewmodel;

import java.util.ArrayList;

import com.leftbrain.wallwrapper.model.Category;
import com.leftbrain.wallwrapper.model.Group;
import com.leftbrain.wallwrapper.model.Image;
import com.leftbrain.wallwrapper.service.WallWrapperServiceMediator;
import com.leftbrain.wallwrapper.service.networkaccess.ServiceResponse;
import com.leftbrain.wallwrapper.service.taskpool.ViewModel;

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
