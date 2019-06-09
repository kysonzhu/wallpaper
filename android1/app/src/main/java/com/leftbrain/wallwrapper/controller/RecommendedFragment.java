package com.leftbrain.wallwrapper.controller;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.RelativeLayout;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.RecommendedFragmentAdapter;
import com.leftbrain.wallwrapper.base.WallWrapperEnvConfigure;
import com.leftbrain.wallwrapper.model.Group;
import com.leftbrain.wallwrapper.service.taskpool.Route;
import com.leftbrain.wallwrapper.service.taskpool.ViewModelManager;
import com.leftbrain.wallwrapper.viewmodel.ImageViewModel;
import com.leftbrain.wallwrapper.widget.PullToRefreshView;
import com.umeng.analytics.MobclickAgent;

public class RecommendedFragment extends Fragment implements OnItemClickListener {

	private GridView mPhotoWall;
	private PullToRefreshView mPullToRefreshView;

	private Activity activity;
	private RelativeLayout recommendedNetWorkRelativeLayout;
	private boolean mShowNoNetworkView;

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		this.activity = activity;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_recommended, container, false);

		mPullToRefreshView = (PullToRefreshView) view.findViewById(R.id.fragment_pull_recommended_view);
		MainActivity activity = (MainActivity) this.getActivity();
		mPullToRefreshView.setOnHeaderRefreshListener(activity);
		mPullToRefreshView.setOnFooterRefreshListener(activity);

		mPhotoWall = (GridView) view.findViewById(R.id.fragment_recommended_gridview);
		mPhotoWall.setSelector(new ColorDrawable(Color.TRANSPARENT));

		recommendedNetWorkRelativeLayout = (RelativeLayout) view.findViewById(R.id.recommended_netWork_relativeLayout);

		float width = (float) (WallWrapperEnvConfigure.getScreenWidth() / 3.0);
		mPhotoWall.setColumnWidth((int) width);

		mPhotoWall.setOnItemClickListener(this);

		if (this.mShowNoNetworkView) {
			recommendedNetWorkRelativeLayout.setVisibility(View.VISIBLE);
			mPullToRefreshView.setVisibility(View.GONE);
		} else {
			recommendedNetWorkRelativeLayout.setVisibility(View.GONE);
			mPullToRefreshView.setVisibility(View.VISIBLE);
		}

		return view;
	}

	public void setAdapter(RecommendedFragmentAdapter adapter) {
		if (null != mPhotoWall) {
			mPhotoWall.setAdapter(adapter);
		}
	}

	public RecommendedFragmentAdapter getAdapter() {
		return (RecommendedFragmentAdapter) mPhotoWall.getAdapter();
	}

	public void hideHeaderViewAndFooterView() {
		mPullToRefreshView.onHeaderRefreshComplete();
		mPullToRefreshView.onFooterRefreshComplete();
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		ImageViewModel viewModel = (ImageViewModel) ViewModelManager.manager().newViewModel(WrapperDetailActivity.class.getName());
		Group group = (Group) this.getAdapter().getDatas().get(arg2);
		viewModel.gId = group.gId;
		Route.route().nextController(activity, viewModel, Route.WITHOUT_RESULTCODE);
	}

	public void showNoNetworkView(boolean show) {
		if (show) {
			if (null != recommendedNetWorkRelativeLayout) {
				recommendedNetWorkRelativeLayout.setVisibility(View.VISIBLE);
				mPullToRefreshView.setVisibility(View.GONE);
			}
			mShowNoNetworkView = true;
		} else {
			if (null != recommendedNetWorkRelativeLayout) {
				recommendedNetWorkRelativeLayout.setVisibility(View.GONE);
				mPullToRefreshView.setVisibility(View.VISIBLE);
			}
			mShowNoNetworkView = false;
		}
	}

	public void setGONE() {
		recommendedNetWorkRelativeLayout.setVisibility(View.GONE);
		mPullToRefreshView.setVisibility(View.VISIBLE);
	}

	public void setVISIBLE() {
		recommendedNetWorkRelativeLayout.setVisibility(View.VISIBLE);
		mPullToRefreshView.setVisibility(View.GONE);
	}

	public void onResume() {
		super.onResume();
		MobclickAgent.onPageStart("RecommendedFragment"); // 统计页面
	}

	public void onPause() {
		super.onPause();
		MobclickAgent.onPageEnd("RecommendedFragment");
	}
}
