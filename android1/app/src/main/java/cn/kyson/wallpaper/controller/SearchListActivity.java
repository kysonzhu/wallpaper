package cn.kyson.wallpaper.controller;

import java.util.ArrayList;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.adapter.LatestFragmentAdapter;
import cn.kyson.wallpaper.base.WallWrapperBaseActivity;
import cn.kyson.wallpaper.base.WallWrapperEnvConfigure;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.service.NetworkStatus;
import cn.kyson.wallpaper.service.WallWrapperServiceMediator;
import cn.kyson.wallpaper.service.taskpool.Route;
import cn.kyson.wallpaper.service.taskpool.ViewModelManager;
import cn.kyson.wallpaper.viewmodel.ImageViewModel;
import cn.kyson.wallpaper.viewmodel.SearchDetailViewModel;
import cn.kyson.wallpaper.viewmodel.WallWrapperViewModel;
import cn.kyson.wallpaper.widget.PullToRefreshView;
import cn.kyson.wallpaper.widget.PullToRefreshView.OnFooterRefreshListener;
import cn.kyson.wallpaper.widget.PullToRefreshView.OnHeaderRefreshListener;

public class SearchListActivity extends WallWrapperBaseActivity implements OnItemClickListener, OnHeaderRefreshListener, OnFooterRefreshListener {

	private String wd;
	private GridView mPhotoWall;
	private TextView shuosou_to_tv;
	// private ArrayList<Group> groups;
	private PullToRefreshView mPullToRefreshView;

	private int currentPageSearchDetail;
	Boolean isFirstTimeFetchDataSearchDetail = true;

	private static boolean isFromRefreshData;
	private ArrayList<Group> recommendedGroups;
	private LatestFragmentAdapter adapter;
	public static final int STEP_LOADIMAGE = 30;

	private RelativeLayout searchDetailRelativeLayout;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_searchlist);
		shuosou_to_tv = (TextView) findViewById(R.id.shuosou_to_tv);

		isFromRefreshData = true;
		recommendedGroups = new ArrayList<Group>();

		mPullToRefreshView = (PullToRefreshView) findViewById(R.id.main_pull_refresh_view);
		mPullToRefreshView.setOnHeaderRefreshListener(this);
		mPullToRefreshView.setOnFooterRefreshListener(this);

		searchDetailRelativeLayout = (RelativeLayout) findViewById(R.id.searchdetail_relativeLayout);

		mPhotoWall = (GridView) findViewById(R.id.photo_wall);
		mPhotoWall.setSelector(new ColorDrawable(Color.TRANSPARENT));
		float width = (float) (WallWrapperEnvConfigure.getScreenWidth() / 3.0);
		mPhotoWall.setColumnWidth((int) width);

		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			this.showNoNetworkView(false);
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			this.showNoNetworkView(true);
		}

		mPhotoWall.setOnItemClickListener(this);
	}

	@Override
	public void refreshData(String method) {
		super.refreshData(method);
		dismissProgress();
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST)) {
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			ArrayList<Group> groups = viewModel.groups;
			if (null != groups) {
				if (isFirstTimeFetchDataSearchDetail) {// 是头部刷新
					recommendedGroups.clear();
					recommendedGroups.addAll(groups);
					adapter = new LatestFragmentAdapter(SearchListActivity.this, recommendedGroups);
					mPhotoWall.setAdapter(adapter);
					mPullToRefreshView.onHeaderRefreshComplete();
				} else {
					if (recommendedGroups.size() >= 30) {
						recommendedGroups.addAll(groups);
					} else {
						recommendedGroups.clear();
						recommendedGroups.addAll(groups);
					}
					// latestGroups.addAll(groups);
					adapter.notifyDataSetChanged();
					mPullToRefreshView.onFooterRefreshComplete();
				}
				this.showNoNetworkView(false);
			}
		}
	}

	@Override
	public void alreadyBindBaseViewModel() {
		super.alreadyBindBaseViewModel();
		SearchDetailViewModel viewModel = (SearchDetailViewModel) this.baseViewModel;
		wd = viewModel.wd;
		int length = wd.length();
		if(length>0 && length<6){
			shuosou_to_tv.setText(wd);
		}else if(length>5){
			shuosou_to_tv.setText(wd.substring(0, 5)+"...");
		}
		
		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			this.showNoNetworkView(false);
			showProgress();
			viewModel.start = currentPageSearchDetail + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST);
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			this.showNoNetworkView(true);
		}

	}

	public void showNoNetworkView(boolean show) {
		if (show) {
			if (null != searchDetailRelativeLayout) {
				searchDetailRelativeLayout.setVisibility(View.VISIBLE);
				mPullToRefreshView.setVisibility(View.GONE);
			}
		} else {
			if (null != searchDetailRelativeLayout) {
				searchDetailRelativeLayout.setVisibility(View.GONE);
				mPullToRefreshView.setVisibility(View.VISIBLE);
			}
		}
	}

	public void shousuo_to_fanhui_click(View v) {
		this.finish();
	}

	@Override
	public void onFooterRefresh(PullToRefreshView view) {
		isFirstTimeFetchDataSearchDetail = false;
		SearchDetailViewModel viewModel = (SearchDetailViewModel) this.baseViewModel;
		if (recommendedGroups.size() >= 30) {
			currentPageSearchDetail += STEP_LOADIMAGE;
		} else {
			currentPageSearchDetail = 0;
		}
		viewModel.start = currentPageSearchDetail + "";
		Log.i("kyson", currentPageSearchDetail + "");
		doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST);
	}

	@Override
	public void onHeaderRefresh(PullToRefreshView view) {
		isFirstTimeFetchDataSearchDetail = true;
		SearchDetailViewModel viewModel = (SearchDetailViewModel) this.baseViewModel;
		currentPageSearchDetail = 0;
		viewModel.start = currentPageSearchDetail + "";
		doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST);
	}

	@Override
	public void requestFailedHandle(String method, int errorCode, String errorMsg) {
		super.requestFailedHandle(method, errorCode, errorMsg);
		dismissProgress();
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST)) {
			if (!isFromRefreshData) {
				currentPageSearchDetail -= STEP_LOADIMAGE;
			}
			mPullToRefreshView.onFooterRefreshComplete();
			mPullToRefreshView.onHeaderRefreshComplete();
		}
		if (1001 == errorCode) {
			Toast.makeText(this, "无结果", Toast.LENGTH_SHORT).show();
		} else {
			Toast.makeText(this, errorMsg, Toast.LENGTH_SHORT).show();
		}
//		Toast.makeText(this, errorMsg, Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		ImageViewModel viewModel = (ImageViewModel) ViewModelManager.manager().newViewModel(WrapperDetailActivity.class.getName());
		if (null != recommendedGroups) {
			Group group = recommendedGroups.get(arg2);
			viewModel.gId = group.gId;
			Route.route().nextController(SearchListActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
		}
	}
	

	public void searchdetailClick(View v) {
		SearchDetailViewModel viewModel = (SearchDetailViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			this.showNoNetworkView(false);
			wd = viewModel.wd;
			viewModel.start = currentPageSearchDetail + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST);
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			this.showNoNetworkView(true);
		}
	}
}
