package com.leftbrain.wallwrapper.controller;

import java.net.URISyntaxException;
import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.Toast;

import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu;
import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.CategoryListViewAdapter;
import com.leftbrain.wallwrapper.adapter.LatestFragmentAdapter;
import com.leftbrain.wallwrapper.adapter.MenuListViewAdapter;
import com.leftbrain.wallwrapper.adapter.RecommendedFragmentAdapter;
import com.leftbrain.wallwrapper.adapter.ViewPagerAdapter;
import com.leftbrain.wallwrapper.base.WallWrapperBaseFragmentActivity;
import com.leftbrain.wallwrapper.base.WallWrapperEnvConfigure;
import com.leftbrain.wallwrapper.controller.CategoryFragment.CategoryFragmentListener;
import com.leftbrain.wallwrapper.model.Category;
import com.leftbrain.wallwrapper.model.Group;
import com.leftbrain.wallwrapper.service.MyService;
import com.leftbrain.wallwrapper.service.NetworkStatus;
import com.leftbrain.wallwrapper.service.WallWrapperServiceMediator;
import com.leftbrain.wallwrapper.service.taskpool.Route;
import com.leftbrain.wallwrapper.service.taskpool.ViewModelManager;
import com.leftbrain.wallwrapper.utils.WipeCache;
import com.leftbrain.wallwrapper.viewmodel.MainViewModel;
import com.leftbrain.wallwrapper.viewmodel.SearchViewModel;
import com.leftbrain.wallwrapper.viewmodel.SubCategoryViewModel;
import com.leftbrain.wallwrapper.viewmodel.WallWrapperViewModel;
import com.leftbrain.wallwrapper.widget.PullToRefreshView;
import com.leftbrain.wallwrapper.widget.PullToRefreshView.OnFooterRefreshListener;
import com.leftbrain.wallwrapper.widget.PullToRefreshView.OnHeaderRefreshListener;
import com.umeng.analytics.MobclickAgent;
import com.umeng.update.UmengUpdateAgent;

/**
 * main activity
 * 
 * @author dell
 * 
 */
public class MainActivity extends WallWrapperBaseFragmentActivity implements OnPageChangeListener, OnClickListener, CategoryFragmentListener, OnHeaderRefreshListener, OnFooterRefreshListener, OnItemClickListener {
	private ViewPager pager;
	private ArrayList<Fragment> fragments;
	private ViewPagerAdapter mAdapter;
	public SlidingMenu menu;
	private Intent intent;

	private RadioButton recommendedButton;
	private RadioButton latestButton;
	private RadioButton categoryButton;

	private ListView menuListView;

	private ImageView menuImageView;
	private ImageView searchImageView;

	Boolean isFirstTimeFetchDataLatest = true;
	Boolean isFirstTimeFetchDataRecommended = true;
	Boolean isFirstTimeFetchDataCategory = true;

	private int currentPageLatest;
	private int currentPageRecommended;

	public static final int STEP_LOADIMAGE = 30;

	private static boolean isFromRefreshData;
	private static boolean isFromRefreshDataRecommended;

	private ArrayList<Group> latestGroups;
	private ArrayList<Group> recommendedGroups;

	private int currentPage;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		UmengUpdateAgent.update(this);

		currentPageLatest = 0;
		currentPageRecommended = 0;
		currentPage = 0;
		isFromRefreshData = true;
		isFromRefreshDataRecommended = true;
		latestGroups = new ArrayList<Group>();
		recommendedGroups = new ArrayList<Group>();

		setContentView(R.layout.activity_main);

		pager = (ViewPager) findViewById(R.id.main_pager);
		pager.setOffscreenPageLimit(2);

		fragments = new ArrayList<Fragment>();
		menuImageView = (ImageView) findViewById(R.id.main_menu_imageView);
		menuImageView.setOnClickListener(this);// 菜单点击
		searchImageView = (ImageView) findViewById(R.id.main_search_imageview);
		searchImageView.setOnClickListener(this);// 搜索点击

		recommendedButton = (RadioButton) findViewById(R.id.main_recommended_radio);
		recommendedButton.setOnClickListener(this);
		latestButton = (RadioButton) findViewById(R.id.main_latest_radio);
		latestButton.setOnClickListener(this);
		categoryButton = (RadioButton) findViewById(R.id.main_category_radio);
		categoryButton.setOnClickListener(this);

		LatestFragment latestFragment = new LatestFragment();
		RecommendedFragment recommendedFragment = new RecommendedFragment();
		CategoryFragment categoryFragment = new CategoryFragment();
		categoryFragment.setCategoryFragmentListener(this);

		fragments.add(latestFragment);
		fragments.add(recommendedFragment);
		fragments.add(categoryFragment);

		mAdapter = new ViewPagerAdapter(getSupportFragmentManager(), fragments);
		pager.setAdapter(mAdapter);
		pager.setOnPageChangeListener(this);

		menu = new SlidingMenu(this);
		menu.setMode(SlidingMenu.LEFT);
		menu.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);
		menu.setShadowWidthRes(R.dimen.shadow_width);

		menu.setShadowDrawable(R.drawable.slidingmenu_shadow);
		menu.setBehindOffsetRes(R.dimen.slidingmenu_offset);
		menu.setFadeDegree(0.35f);
		menu.attachToActivity(this, SlidingMenu.SLIDING_CONTENT);
		menu.setMenu(R.layout.layout_menu);
		menu.setMode(SlidingMenu.LEFT);
		menu.setMenu(R.layout.layout_menu);
		long screenWidth = WallWrapperEnvConfigure.getScreenWidth();
		menu.setBehindWidth((int) (screenWidth * 0.7));

		menuListView = (ListView) menu.getMenu().findViewById(R.id.menu_listview);
		menuListView.setAdapter(new MenuListViewAdapter(this));
		menuListView.setOnItemClickListener(this);

	}

	@Override
	public void alreadyBindBaseViewModel() {
		// TODO Auto-generated method stub
		super.alreadyBindBaseViewModel();
		this.setCurrentPage(0);
	}

	@Override
	public void refreshData(String method) {
		super.refreshData(method);
		dismissProgress();
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST)) {
			RecommendedFragment fragment = (RecommendedFragment) fragments.get(1);
			fragment.hideHeaderViewAndFooterView();
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			ArrayList<Group> groups = viewModel.groups;
			if (null != groups) {
				if (MainActivity.isFromRefreshDataRecommended) {
					recommendedGroups.clear();
					recommendedGroups.addAll(groups);
					RecommendedFragmentAdapter adapter = new RecommendedFragmentAdapter(this, recommendedGroups);
					fragment.setAdapter(adapter);
				} else {
					// is load more
					recommendedGroups.addAll(groups);
					RecommendedFragmentAdapter adapter = fragment.getAdapter();
					// fragment.setAdapter(adapter);
					adapter.notifyDataSetChanged();
					// adapter.notifyAll();
				}
				fragment.setGONE();
			}

		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST)) {
			LatestFragment fragment = (LatestFragment) fragments.get(0);
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			fragment.hideHeaderViewAndFooterView();
			ArrayList<Group> groups = viewModel.groups;
			if (null != groups) {
				// is refresh data
				if (MainActivity.isFromRefreshData) {
					latestGroups.clear();
					latestGroups.addAll(groups);
					// GridView latestGridView = (GridView)
					// findViewById(R.id.fragment_latest_gridview);
					LatestFragmentAdapter adapter = new LatestFragmentAdapter(MainActivity.this, latestGroups);
					fragment.setAdapter(adapter);
				} else {
					// is load more
					latestGroups.addAll(groups);
					LatestFragmentAdapter adapter = fragment.getAdapter();
					// fragment.setAdapter(adapter);
					adapter.notifyDataSetChanged();
				}
				fragment.setGONE();
			}
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETCATEGORYLIST)) {
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			ArrayList<Category> categorys = viewModel.categorys;
			if (null != categorys) {
				CategoryFragment fragment = (CategoryFragment) fragments.get(2);
				CategoryListViewAdapter adapter = new CategoryListViewAdapter(this, categorys);
				fragment.setAdapter(adapter);
				fragment.setGONE();
			}
		}
	}

	public void setCurrentPage(int position) {
		pager.setCurrentItem(position);
		currentPage = position;
		onPageSelected(position);
	}

	private void highligthButton(int index) {
		switch (index) {
		case 0: {
			latestButton.setChecked(true);
			menu.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);
		}
			break;
		case 1: {
			recommendedButton.setChecked(true);
			menu.setTouchModeAbove(SlidingMenu.TOUCHMODE_MARGIN);
		}
			break;
		case 2: {
			categoryButton.setChecked(true);
			menu.setTouchModeAbove(SlidingMenu.TOUCHMODE_MARGIN);
		}
			break;
		default:
			break;
		}
	}

	@Override
	public void onPageSelected(int position) {
		currentPage = position;
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		if (null == viewModel)
			return;

		this.highligthButton(position);
		if (position == 0) {
			if (isFirstTimeFetchDataLatest) {
				int status = NetworkStatus.networkStatus();
				if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
					viewModel.start = currentPageLatest + "";
					doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST);
					isFirstTimeFetchDataLatest = false;
				} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
					LatestFragment latestFragment = (LatestFragment) fragments.get(position);
					latestFragment.showNoNetworkView(true);
					isFirstTimeFetchDataLatest = true;
				}
			}
		} else if (position == 1) {
			if (isFirstTimeFetchDataRecommended) {
				int status = NetworkStatus.networkStatus();
				if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
					showProgress();
					viewModel.start = currentPageRecommended + "";
					doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST);
					isFirstTimeFetchDataRecommended = false;
				} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
					RecommendedFragment recommendedFragment = (RecommendedFragment) fragments.get(position);
					recommendedFragment.showNoNetworkView(true);
					isFirstTimeFetchDataRecommended = true;
				}
			}
		} else {
			if (isFirstTimeFetchDataCategory) {
				int status = NetworkStatus.networkStatus();
				if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
					showProgress();
					doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETCATEGORYLIST);
					isFirstTimeFetchDataCategory = false;
				} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
					CategoryFragment categoryFragment = (CategoryFragment) fragments.get(position);
					categoryFragment.showNoNetworkView(true);
					isFirstTimeFetchDataCategory = true;
				}

			}
		}
	}

	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2) {
	}

	@Override
	public void onPageScrollStateChanged(int arg0) {
	}

	@SuppressLint("ServiceCast")
	@Override
	public void onClick(View view) {
		switch (view.getId()) {

		case R.id.main_latest_radio: {
			MainActivity.this.setCurrentPage(0);
		}
			break;
		case R.id.main_recommended_radio: {
			MainActivity.this.setCurrentPage(1);
		}
			break;
		case R.id.main_category_radio: {
			MainActivity.this.setCurrentPage(2);
		}
			break;
		case R.id.main_menu_imageView: {
			menu.showMenu();
		}
			break;

		case R.id.main_search_imageview: {
			SearchViewModel viewModel = (SearchViewModel) ViewModelManager.manager().newViewModel(SearchActivity.class.getName());
			Route.route().nextController(MainActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
		}
			break;

		}

	}

	public void latestNetWork(View v) {
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			viewModel.start = 0 + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST);
			isFirstTimeFetchDataLatest = false;
		}
	}

	@Override
	public void requestFailedHandle(String method, int errorCode, String errorMsg) {
		super.requestFailedHandle(method, errorCode, errorMsg);
		dismissProgress();
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST)) {
			if (!isFromRefreshData) {
				currentPageLatest -= STEP_LOADIMAGE;
			}
			LatestFragment fragment = (LatestFragment) fragments.get(0);
			fragment.hideHeaderViewAndFooterView();
		}
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST)) {
			if (!isFromRefreshDataRecommended) {
				currentPageRecommended -= STEP_LOADIMAGE;
			}
			RecommendedFragment recommendedFragment = (RecommendedFragment) fragments.get(1);
			recommendedFragment.hideHeaderViewAndFooterView();
		}
		if (1001 == errorCode) {
			Toast.makeText(this, "无结果", Toast.LENGTH_SHORT).show();
		} else {
			Toast.makeText(this, errorMsg, Toast.LENGTH_SHORT).show();
		}
		// Toast.makeText(MainActivity.this, errorMsg,
		// Toast.LENGTH_SHORT).show();
	}

	@Override
	public void categoryFragmentItemClicked(Category category) {
		// TODO Auto-generated method stub
		SubCategoryViewModel viewModel = (SubCategoryViewModel) ViewModelManager.manager().newViewModel(SubCategoryActivity.class.getName());
		viewModel.cateId = category.cateId;
		viewModel.issubcategory_screen = true;
		viewModel.cateShortName = category.cateShortName;
		Route.route().nextController(MainActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
	}

	/********************************** refresh footerview and header view call back method ******************************************/

	@Override
	public void onFooterRefresh(PullToRefreshView view) {
		// TODO Auto-generated method stub
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		switch (currentPage) {
		// latest
		case 0: {
			MainActivity.isFromRefreshData = false;
			currentPageLatest += STEP_LOADIMAGE;
			viewModel.start = currentPageLatest + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST);
			isFirstTimeFetchDataLatest = true;
		}
			break;
		case 1: {
			MainActivity.isFromRefreshDataRecommended = false;
			currentPageRecommended += STEP_LOADIMAGE;
			viewModel.start = currentPageRecommended + "";
			Log.i("kyson", currentPageRecommended + "         jinin");
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST);
			isFirstTimeFetchDataRecommended = true;
		}
			break;
		default:
			break;
		}

	}

	@Override
	public void onHeaderRefresh(PullToRefreshView view) {
		// TODO Auto-generated method stub
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		switch (currentPage) {
		// latest
		case 0: {
			MainActivity.isFromRefreshData = true;
			currentPageLatest = 0;
			viewModel.start = currentPageLatest + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST);
			isFirstTimeFetchDataLatest = true;
		}
			break;
		case 1: {
			MainActivity.isFromRefreshDataRecommended = true;
			currentPageRecommended = 0;
			viewModel.start = currentPageRecommended + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST);
			isFirstTimeFetchDataRecommended = true;
		}
			break;
		default:
			break;
		}

	}

	public void latestNetWorkClick(View v) {
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		LatestFragment latestFragment = (LatestFragment) fragments.get(currentPage);
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			latestFragment.setGONE();

			viewModel.start = currentPageLatest + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETLATESTLIST);
			isFirstTimeFetchDataLatest = false;
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			latestFragment.setVISIBLE();
			isFirstTimeFetchDataLatest = true;
		}
	}

	public void recommendedNetWorkClick(View v) {
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		RecommendedFragment recommendedFragment = (RecommendedFragment) fragments.get(currentPage);
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			showProgress();
			recommendedFragment.setGONE();
			viewModel.start = currentPageRecommended + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETRECOMMENDEDLIST);
			isFirstTimeFetchDataRecommended = false;
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			recommendedFragment.setVISIBLE();
			isFirstTimeFetchDataRecommended = true;
		}
	}

	public void categoryNetWorkClick(View v) {
		MainViewModel viewModel = (MainViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		CategoryFragment categoryFragment = (CategoryFragment) fragments.get(currentPage);
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			showProgress();
			categoryFragment.setGONE();
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETCATEGORYLIST);
			isFirstTimeFetchDataCategory = false;
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			categoryFragment.setVISIBLE();
			isFirstTimeFetchDataCategory = true;
		}
	}

	@SuppressLint("HandlerLeak")
	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				Toast.makeText(MainActivity.this, "清除缓存成功", Toast.LENGTH_SHORT).show();
				break;

			default:
				break;
			}

		}
	};

	@SuppressLint("ServiceCast")
	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		switch (arg2) {
		case 0: {
			MobclickAgent.onEvent(this, "1001");
			new Thread() {
				public void run() {
					WipeCache.shareInstance().clear();
					handler.sendEmptyMessage(0);
				}
			}.start();
		}
			break;
		case 1: {
			try {
				MobclickAgent.onEvent(this, "1005");
				startActivity(Intent.parseUri("http://sj.zol.com.cn/detail/58/57411.shtml", 0));
			} catch (URISyntaxException e) {
				e.printStackTrace();
			}
		}
			break;
		case 2: {
			{
				intent = new Intent();
				intent.setClass(MainActivity.this, AboutUsActivity.class);
				startActivity(intent);
			}
		}
			break;
		case 3: {
			intent = new Intent();
			intent.setClass(MainActivity.this, FeedbackActivity.class);
			startActivity(intent);
		}
			break;
		case 4: {
			Intent intent = new Intent(this, MyService.class);
			this.startService(intent);

			/*
			 * String fileString =
			 * WallWrapperApplication.getContext().getExternalFilesDir
			 * (Environment.DIRECTORY_DCIM).getPath(); File files = new
			 * File(fileString); if (files.isDirectory()) { int nums =
			 * files.listFiles().length; if (nums > 0) { for (int i = 0; i <
			 * nums; i++) { try { FileInputStream fis = new
			 * FileInputStream(files.listFiles()[0]); WallpaperManager wpm =
			 * (WallpaperManager) getSystemService(WALLPAPER_SERVICE);
			 * WindowManager wm = (WindowManager)
			 * getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
			 * 
			 * @SuppressWarnings("deprecation") int width =
			 * wm.getDefaultDisplay().getWidth();
			 * 
			 * @SuppressWarnings("deprecation") int height =
			 * wm.getDefaultDisplay().getHeight();
			 * wpm.suggestDesiredDimensions(width, height);
			 * 
			 * @SuppressWarnings("deprecation") BitmapDrawable pic = new
			 * BitmapDrawable(fis); Bitmap bitmap = pic.getBitmap(); bitmap =
			 * ThumbnailUtils.extractThumbnail(bitmap, width, height);
			 * WallpaperManager
			 * .getInstance(MainActivity.this).setBitmap(bitmap); } catch
			 * (FileNotFoundException e) { e.printStackTrace(); } catch
			 * (IOException e) { e.printStackTrace(); } } } }
			 */
		}
			break;
		case 5: {
			Intent intent = new Intent(this, MyService.class);
			this.startService(intent);
		}
			break;
		case 6: {
			Intent intent = new Intent(this, MyService.class);
			this.stopService(intent);
		}
			break;
		case 7: {
			Intent intent = new Intent(this, MyService.class);
			this.stopService(intent);
		}
			break;
		case 8: {

		}
			break;
		}

	}
}
