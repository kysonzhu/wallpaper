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

public class SubRecommendedFragment extends Fragment implements OnItemClickListener {

	private GridView mPhotoWall;
	private PullToRefreshView mPullToRefreshView;

	private RelativeLayout sub_recommendedNetWorkRelativeLayout;
	private boolean mShowNoNetworkView;

	private Activity activity;

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
		View view = inflater.inflate(R.layout.fragment_sub_recommended, container, false);
		mPullToRefreshView = (PullToRefreshView) view.findViewById(R.id.fragment_pull_sub_recommended_view);
		SubCategoryActivity activity = (SubCategoryActivity) this.getActivity();
		mPullToRefreshView.setOnHeaderRefreshListener(activity);
		mPullToRefreshView.setOnFooterRefreshListener(activity);
		ViewGroup parent = (ViewGroup) view.getParent();
		if (parent != null) {
			parent.removeView(view);
		}
		sub_recommendedNetWorkRelativeLayout = (RelativeLayout) view.findViewById(R.id.sub_recommended_netWork_relativeLayout);

		mPhotoWall = (GridView) view.findViewById(R.id.fragment_sub_recommended_gridview);
		mPhotoWall.setSelector(new ColorDrawable(Color.TRANSPARENT));

		float width = (float) (WallWrapperEnvConfigure.getScreenWidth() / 3.0);
		mPhotoWall.setColumnWidth((int) width);

		mPhotoWall.setOnItemClickListener(this);

		if (this.mShowNoNetworkView) {
			sub_recommendedNetWorkRelativeLayout.setVisibility(View.VISIBLE);
			mPullToRefreshView.setVisibility(View.GONE);
		} else {
			sub_recommendedNetWorkRelativeLayout.setVisibility(View.GONE);
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
			if (null != sub_recommendedNetWorkRelativeLayout) {
				sub_recommendedNetWorkRelativeLayout.setVisibility(View.VISIBLE);
				mPullToRefreshView.setVisibility(View.GONE);
			}
			mShowNoNetworkView = true;
		} else {
			if (null != sub_recommendedNetWorkRelativeLayout) {
				sub_recommendedNetWorkRelativeLayout.setVisibility(View.GONE);
				mPullToRefreshView.setVisibility(View.VISIBLE);
			}
			mShowNoNetworkView = false;
		}
	}

	public void setGONE() {
		sub_recommendedNetWorkRelativeLayout.setVisibility(View.GONE);
		mPullToRefreshView.setVisibility(View.VISIBLE);
	}

	public void setVISIBLE() {
		sub_recommendedNetWorkRelativeLayout.setVisibility(View.VISIBLE);
		mPullToRefreshView.setVisibility(View.GONE);
	}

	public void onResume() {
	    super.onResume();
	    MobclickAgent.onPageStart("SubRecommendedFragment"); //统计页面
	}
	public void onPause() {
	    super.onPause();
	    MobclickAgent.onPageEnd("SubRecommendedFragment"); 
	}

}
