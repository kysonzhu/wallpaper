package com.leftbrain.wallwrapper.service.taskpool;

@SuppressWarnings("rawtypes")
public interface Controller {

	public void setViewModel(ViewModel vModel);

	public ViewModel getViewModel();

	public void refreshData(String method);

	public void requestFailedHandle(String method, int errorCode, String errorMsg);

}
