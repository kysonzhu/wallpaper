package com.leftbrain.wallwrapper.controller;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.SubCategoryAdapter;
import com.leftbrain.wallwrapper.base.WallWrapperBaseActivity;
import com.leftbrain.wallwrapper.model.Category;
import com.leftbrain.wallwrapper.service.NetworkStatus;
import com.leftbrain.wallwrapper.service.WallWrapperServiceMediator;
import com.leftbrain.wallwrapper.service.taskpool.Route;
import com.leftbrain.wallwrapper.service.taskpool.ViewModelManager;
import com.leftbrain.wallwrapper.viewmodel.SecondaryCategorySelectedViewModel;
import com.leftbrain.wallwrapper.viewmodel.SubCategoryViewModel;
import com.leftbrain.wallwrapper.viewmodel.WallWrapperViewModel;

public class SecondaryCategorySelectedActivity extends WallWrapperBaseActivity implements OnItemClickListener {

	private TextView erji_fenlei_tv;
	private String cateShortName;
	private String cateId;
	private ArrayList<Category> categories;
	private ListView erji_fenlei_lv;
	private SubCategoryAdapter erji_fenlei_Adapter;
	private RelativeLayout secondarycategoryselectedRelativeLayout;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_secondarycategoryselected);
		Intent intent = getIntent();
		cateId = intent.getStringExtra("cateId");
		cateShortName = intent.getStringExtra("cateShortName");
		erji_fenlei_tv = (TextView) findViewById(R.id.erji_fenlei_tv);
		erji_fenlei_tv.setText(cateShortName);
		erji_fenlei_lv = (ListView) findViewById(R.id.erji_fenlei_lv);

		secondarycategoryselectedRelativeLayout = (RelativeLayout) findViewById(R.id.secondarycategoryselected_relativeLayout);

		SecondaryCategorySelectedViewModel viewModel = (SecondaryCategorySelectedViewModel) ViewModelManager.manager().newViewModel(SecondaryCategorySelectedActivity.class.getName());
		this.setViewModel(viewModel);
		viewModel.setActivity(this);
		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			this.showNoNetworkView(false);
			viewModel.fatherId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSECONDARYCATEGORYSELECTEDLIST);
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			this.showNoNetworkView(true);
		}

		// this.setViewModel(viewModel);
		// viewModel.setActivity(this);
		// viewModel.fatherId=cateId;
		// doTask(viewModel,
		// WallWrapperServiceMediator.SERVICENAME_GETSECONDARYCATEGORYSELECTEDLIST);

		erji_fenlei_lv.setOnItemClickListener(this);
	}

	public void showNoNetworkView(boolean show) {
		if (show) {
			if (null != secondarycategoryselectedRelativeLayout) {
				secondarycategoryselectedRelativeLayout.setVisibility(View.VISIBLE);
				erji_fenlei_lv.setVisibility(View.GONE);
			}
		} else {
			if (null != secondarycategoryselectedRelativeLayout) {
				secondarycategoryselectedRelativeLayout.setVisibility(View.GONE);
				erji_fenlei_lv.setVisibility(View.VISIBLE);
			}
		}
	}

	@Override
	public void refreshData(String method) {
		super.refreshData(method);
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETSECONDARYCATEGORYSELECTEDLIST)) {
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			categories = viewModel.categorys;
			if (null != categories) {
				erji_fenlei_Adapter = new SubCategoryAdapter(getApplicationContext(), categories);
				erji_fenlei_lv.setAdapter(erji_fenlei_Adapter);
				this.setGONE();
			}
		}
	}

	public void fanhui_BeautyActivity_click(View v) {
		this.finish();
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		if (arg2 == 0) {
			this.finish();
		} else {
			SubCategoryViewModel viewModel = (SubCategoryViewModel) ViewModelManager.manager().newViewModel(SubCategoryActivity.class.getName());
			viewModel.cateId = categories.get(arg2 - 1).cateId;
			viewModel.cateShortName = categories.get(arg2 - 1).cateShortName;
			viewModel.issubcategory_screen = false;
			Route.route().nextController(SecondaryCategorySelectedActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
			this.finish();
		}
	}

	public void setGONE() {
		secondarycategoryselectedRelativeLayout.setVisibility(View.GONE);
		erji_fenlei_lv.setVisibility(View.VISIBLE);
	}

	public void setVISIBLE() {
		secondarycategoryselectedRelativeLayout.setVisibility(View.VISIBLE);
		erji_fenlei_lv.setVisibility(View.GONE);
	}

	public void secondarycategoryselectedClick(View v) {
		SecondaryCategorySelectedViewModel viewModel = (SecondaryCategorySelectedViewModel) ViewModelManager.manager().newViewModel(SecondaryCategorySelectedActivity.class.getName());
		this.setViewModel(viewModel);
		viewModel.setActivity(this);
		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			this.setGONE();
			viewModel.fatherId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSECONDARYCATEGORYSELECTEDLIST);
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			this.setVISIBLE();
		}
	}
}
