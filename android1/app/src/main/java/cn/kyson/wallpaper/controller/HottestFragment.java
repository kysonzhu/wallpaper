package cn.kyson.wallpaper.controller;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.RelativeLayout;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.adapter.HottestFragmentAdapter;
import cn.kyson.wallpaper.base.WallWrapperEnvConfigure;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.service.taskpool.Route;
import cn.kyson.wallpaper.service.taskpool.ViewModelManager;
import cn.kyson.wallpaper.viewmodel.ImageViewModel;
import cn.kyson.wallpaper.widget.PullToRefreshView;
import com.umeng.analytics.MobclickAgent;

public class HottestFragment extends Fragment implements OnItemClickListener {

	private GridView mPhotoWall;
	private PullToRefreshView mPullToRefreshView;

	private RelativeLayout hottestNetWorkRelativeLayout;
	private boolean mShowNoNetworkView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	private Activity activity;

	@Override
	public void onAttach(Activity activity) {
		super.onAttach(activity);
		this.activity = activity;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_hottest, container, false);
		mPullToRefreshView = (PullToRefreshView) view.findViewById(R.id.fragment_pull_hottest_view);
		SubCategoryActivity activity = (SubCategoryActivity) this.getActivity();
		mPullToRefreshView.setOnHeaderRefreshListener(activity);
		mPullToRefreshView.setOnFooterRefreshListener(activity);
		ViewGroup parent = (ViewGroup) view.getParent();
		if (parent != null) {
			parent.removeView(view);
		}

		hottestNetWorkRelativeLayout = (RelativeLayout) view.findViewById(R.id.hottest_netWork_relativeLayout);

		mPhotoWall = (GridView) view.findViewById(R.id.fragment_hottest_gridview);
		mPhotoWall.setSelector(new ColorDrawable(Color.TRANSPARENT));

		float width = (float) (WallWrapperEnvConfigure.getScreenWidth() / 3.0);
		mPhotoWall.setColumnWidth((int) width);

		mPhotoWall.setOnItemClickListener(this);

		if (this.mShowNoNetworkView) {
			hottestNetWorkRelativeLayout.setVisibility(View.VISIBLE);
			mPullToRefreshView.setVisibility(View.GONE);
		} else {
			hottestNetWorkRelativeLayout.setVisibility(View.GONE);
			mPullToRefreshView.setVisibility(View.VISIBLE);
		}

		return view;
	}

	public void setAdapter(HottestFragmentAdapter adapter) {
		if (null != mPhotoWall) {
			mPhotoWall.setAdapter(adapter);
		} else {
			Log.i("kyson", "金金2dsfsdfsdt" + adapter.getCount());
		}
	}

	public HottestFragmentAdapter getAdapter() {
		return (HottestFragmentAdapter) mPhotoWall.getAdapter();
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
			if (null != hottestNetWorkRelativeLayout) {
				hottestNetWorkRelativeLayout.setVisibility(View.VISIBLE);
				mPullToRefreshView.setVisibility(View.GONE);
			}
			mShowNoNetworkView = true;
		} else {
			if (null != hottestNetWorkRelativeLayout) {
				hottestNetWorkRelativeLayout.setVisibility(View.GONE);
				mPullToRefreshView.setVisibility(View.VISIBLE);
			}
			mShowNoNetworkView = false;
		}
	}

	public void setGONE() {
		hottestNetWorkRelativeLayout.setVisibility(View.GONE);
		mPullToRefreshView.setVisibility(View.VISIBLE);
	}

	public void setVISIBLE() {
		hottestNetWorkRelativeLayout.setVisibility(View.VISIBLE);
		mPullToRefreshView.setVisibility(View.GONE);
	}

	public void onResume() {
	    super.onResume();
	    MobclickAgent.onPageStart("HottestFragment"); //统计页面
	}
	public void onPause() {
	    super.onPause();
	    MobclickAgent.onPageEnd("HottestFragment"); 
	}
}
