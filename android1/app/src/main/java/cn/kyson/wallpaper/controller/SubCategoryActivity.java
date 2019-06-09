package cn.kyson.wallpaper.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.app.WallpaperManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;

import com.jeremyfeinstein.slidingmenu.lib.SlidingMenu;
import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.adapter.HottestFragmentAdapter;
import cn.kyson.wallpaper.adapter.LatestFragmentAdapter;
import cn.kyson.wallpaper.adapter.MenuListViewAdapter;
import cn.kyson.wallpaper.adapter.RecommendedFragmentAdapter;
import cn.kyson.wallpaper.adapter.ViewPagerAdapter;
import cn.kyson.wallpaper.base.WallWrapperApplication;
import cn.kyson.wallpaper.base.WallWrapperBaseFragmentActivity;
import cn.kyson.wallpaper.base.WallWrapperEnvConfigure;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.service.MyService;
import cn.kyson.wallpaper.service.NetworkStatus;
import cn.kyson.wallpaper.service.WallWrapperServiceMediator;
import cn.kyson.wallpaper.utils.WipeCache;
import cn.kyson.wallpaper.viewmodel.SubCategoryViewModel;
import cn.kyson.wallpaper.viewmodel.WallWrapperViewModel;
import cn.kyson.wallpaper.widget.PullToRefreshView;
import cn.kyson.wallpaper.widget.PullToRefreshView.OnFooterRefreshListener;
import cn.kyson.wallpaper.widget.PullToRefreshView.OnHeaderRefreshListener;
import com.umeng.analytics.MobclickAgent;

@SuppressLint("NewApi")
public class SubCategoryActivity extends WallWrapperBaseFragmentActivity implements OnPageChangeListener, OnClickListener, OnHeaderRefreshListener, OnFooterRefreshListener, OnItemClickListener {

	private ViewPager pager;
	private ArrayList<Fragment> fragments;
	private ViewPagerAdapter mAdapter;
	private TextView subcategory_title_textview;
	public SlidingMenu menu;
	private Intent intent;
	private RadioButton recommendedButton;
	private RadioButton latestButton;
	private RadioButton hottestButton;

	private ImageView subcategoryBackImage;
	private ImageView subcategoryScreenImage;

	Boolean isFirstTimeFetchDataSubLatest = true;
	Boolean isFirstTimeFetchDataSubRecommended = true;
	Boolean isFirstTimeFetchDataHottest = true;

	private int currentPageSubLatest;
	private int currentPageSubRecommended;
	private int currentPageHottest;

	public static final int STEP_LOADIMAGE = 30;

	private static boolean isFromRefreshDataSubLatest;
	private static boolean isFromRefreshDataSubRecommended;
	private static boolean isFromRefreshDataHottest;

	private ArrayList<Group> latestGroups;
	private ArrayList<Group> recommendedGroups;
	private ArrayList<Group> hottestGroups;

	private int currentPage;

	private String cateId;

	private ListView menuListView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		currentPageSubLatest = 0;
		currentPageSubRecommended = 0;
		currentPageHottest = 0;
		currentPage = 0;
		isFromRefreshDataSubLatest = true;
		isFromRefreshDataSubRecommended = true;
		isFromRefreshDataHottest = true;
		latestGroups = new ArrayList<Group>();
		recommendedGroups = new ArrayList<Group>();
		hottestGroups = new ArrayList<Group>();
		setContentView(R.layout.activity_subcategory);

		subcategory_title_textview = (TextView) findViewById(R.id.subcategory_title_textview);
		subcategoryBackImage = (ImageView) findViewById(R.id.subcategory_back_image);
		subcategoryBackImage.setOnClickListener(this);

		pager = (ViewPager) findViewById(R.id.pager);
		pager.setOffscreenPageLimit(2);
		fragments = new ArrayList<Fragment>();

		SubLatestFragment sublatestFragment = new SubLatestFragment();
		SubRecommendedFragment subrecommendedFragment = new SubRecommendedFragment();
		HottestFragment hottestfragment = new HottestFragment();
		fragments.add(sublatestFragment);
		fragments.add(subrecommendedFragment);
		fragments.add(hottestfragment);

		latestButton = (RadioButton) findViewById(R.id.radio_sub_latest);
		latestButton.setOnClickListener(this);
		recommendedButton = (RadioButton) findViewById(R.id.radio_sub_recommended);
		recommendedButton.setOnClickListener(this);
		hottestButton = (RadioButton) findViewById(R.id.radio_hottest);
		hottestButton.setOnClickListener(this);

		mAdapter = new ViewPagerAdapter(getSupportFragmentManager(), fragments);
		pager.setAdapter(mAdapter);
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

		pager.setOnPageChangeListener(this);

		menuListView = (ListView) menu.getMenu().findViewById(R.id.menu_listview);
		menuListView.setAdapter(new MenuListViewAdapter(this));
		menuListView.setOnItemClickListener(this);
	}

	@Override
	public void refreshData(String method) {
		super.refreshData(method);
		dismissProgress();
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST)) {
			SubRecommendedFragment fragment = (SubRecommendedFragment) fragments.get(1);
			fragment.hideHeaderViewAndFooterView();
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			ArrayList<Group> groups = viewModel.groups;
			if (null != groups) {
				if (SubCategoryActivity.isFromRefreshDataSubRecommended) {
					recommendedGroups.clear();
					recommendedGroups.addAll(groups);
					SharedPreferences preferences = this.getSharedPreferences("ZAN_SUM", Context.MODE_PRIVATE);
					for (Group group : recommendedGroups) {
						String you_zan = preferences.getString(group.gId, "gid");
						if (!"gid".equals(you_zan)) {
							group.voteGood = Integer.parseInt(group.voteGood) + 1 + "";
						}
					}
					RecommendedFragmentAdapter adapter = new RecommendedFragmentAdapter(this, recommendedGroups);
					fragment.setAdapter(adapter);
				} else {
					// is load more
					if (recommendedGroups.size() >= 30) {
						recommendedGroups.addAll(groups);
					} else {
						recommendedGroups.clear();
						recommendedGroups.addAll(groups);
					}
					// recommendedGroups.addAll(groups);
					RecommendedFragmentAdapter adapter = fragment.getAdapter();
					// fragment.setAdapter(adapter);
					adapter.notifyDataSetChanged();
					// adapter.notifyAll();
				}
				fragment.setGONE();
			}

		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST)) {
			SubLatestFragment fragment = (SubLatestFragment) fragments.get(0);
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			fragment.hideHeaderViewAndFooterView();
			ArrayList<Group> groups = viewModel.groups;
			if (null != groups) {
				// is refresh data
				if (SubCategoryActivity.isFromRefreshDataSubLatest) {
					latestGroups.clear();
					latestGroups.addAll(groups);
					LatestFragmentAdapter adapter = new LatestFragmentAdapter(this, latestGroups);
					fragment.setAdapter(adapter);
				} else {
					// is load more
					if (latestGroups.size() >= 30) {
						latestGroups.addAll(groups);
					} else {
						latestGroups.clear();
						latestGroups.addAll(groups);
					}
					LatestFragmentAdapter adapter = fragment.getAdapter();
					// fragment.setAdapter(adapter);
					adapter.notifyDataSetChanged();
					// adapter.notifyAll();
				}
				fragment.setGONE();
			}
		} else if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST)) {
			HottestFragment fragment = (HottestFragment) fragments.get(2);
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			fragment.hideHeaderViewAndFooterView();
			ArrayList<Group> groups = viewModel.groups;
			if (null != groups) {
				// is refresh data
				if (SubCategoryActivity.isFromRefreshDataHottest) {
					hottestGroups.clear();
					hottestGroups.addAll(groups);
					HottestFragmentAdapter adapter = new HottestFragmentAdapter(this, hottestGroups);
					fragment.setAdapter(adapter);
				} else {
					// is load more
					if (hottestGroups.size() >= 30) {
						hottestGroups.addAll(groups);
					} else {
						hottestGroups.clear();
						hottestGroups.addAll(groups);
					}
					// hottestGroups.addAll(groups);
					HottestFragmentAdapter adapter = fragment.getAdapter();
					// fragment.setAdapter(adapter);
					adapter.notifyDataSetChanged();
					// adapter.notifyAll();
				}
				fragment.setGONE();
			}
		}

	}

	@Override
	public void alreadyBindBaseViewModel() {
		super.alreadyBindBaseViewModel();
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		cateId = viewModel.cateId;
		boolean issubcategory_screen = viewModel.issubcategory_screen;
		Log.i("kyson", issubcategory_screen + "  第一次");
		subcategoryScreenImage = (ImageView) findViewById(R.id.subcategory_screen_image);
		if (issubcategory_screen) {
			subcategoryScreenImage.setVisibility(View.VISIBLE);
			subcategoryScreenImage.setOnClickListener(this);
		} else {
			subcategoryScreenImage.setVisibility(View.INVISIBLE);
			subcategoryScreenImage.setClickable(false);
		}
		subcategory_title_textview.setText(viewModel.cateShortName);
		this.setCurrentPage(0);
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
			hottestButton.setChecked(true);
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
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		if (null == viewModel)
			return;

		this.highligthButton(position);
		if (position == 0) {
			if (isFirstTimeFetchDataSubLatest) {
				int status = NetworkStatus.networkStatus();
				if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
					showProgress();
					viewModel.cateId = cateId;
					viewModel.start = currentPageSubLatest + "";
					doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST);
					isFirstTimeFetchDataSubLatest = false;
				} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
					SubLatestFragment subLatestFragment = (SubLatestFragment) fragments.get(position);
					subLatestFragment.showNoNetworkView(true);
					isFirstTimeFetchDataSubLatest = true;
				}
				// viewModel.cateId = cateId;
				// viewModel.start = currentPageSubLatest + "";
				// doTask(viewModel,
				// WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST);
				// isFirstTimeFetchDataSubLatest = false;
			}
		} else if (position == 1) {
			if (isFirstTimeFetchDataSubRecommended) {
				int status = NetworkStatus.networkStatus();
				if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
					showProgress();
					viewModel.cateId = cateId;
					viewModel.start = currentPageSubRecommended + "";
					doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST);
					isFirstTimeFetchDataSubRecommended = false;
				} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
					SubRecommendedFragment subRecommendedFragment = (SubRecommendedFragment) fragments.get(position);
					subRecommendedFragment.showNoNetworkView(true);
					isFirstTimeFetchDataSubRecommended = true;
				}
				// viewModel.cateId = cateId;
				// viewModel.start = currentPageSubRecommended + "";
				// doTask(viewModel,
				// WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST);
				// isFirstTimeFetchDataSubRecommended = false;
			}
		} else {
			if (isFirstTimeFetchDataHottest) {
				int status = NetworkStatus.networkStatus();
				if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
					showProgress();
					viewModel.cateId = cateId;
					viewModel.start = currentPageHottest + "";
					doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST);
					isFirstTimeFetchDataHottest = false;
				} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
					HottestFragment hottestFragment = (HottestFragment) fragments.get(position);
					hottestFragment.showNoNetworkView(true);
					isFirstTimeFetchDataHottest = true;
				}

				// viewModel.cateId = cateId;
				// viewModel.start = currentPageHottest + "";
				// doTask(viewModel,
				// WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST);
				// isFirstTimeFetchDataHottest = false;
			}
		}
	}

	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2) {
	}

	@Override
	public void onPageScrollStateChanged(int arg0) {
	}

	@Override
	public void onClick(View view) {
		switch (view.getId()) {

		case R.id.radio_sub_latest: {
			SubCategoryActivity.this.setCurrentPage(0);
		}
			break;
		case R.id.radio_sub_recommended: {
			SubCategoryActivity.this.setCurrentPage(1);
		}
			break;
		case R.id.radio_hottest: {
			SubCategoryActivity.this.setCurrentPage(2);
		}
			break;
		case R.id.subcategory_back_image:
			this.finish();
			break;
		case R.id.subcategory_screen_image:
			intent = new Intent();
			intent.putExtra("cateId", cateId);
			SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
			intent.putExtra("cateShortName", viewModel.cateShortName);
			intent.setClass(SubCategoryActivity.this, SecondaryCategorySelectedActivity.class);
			startActivity(intent);
			break;
		// case R.id.menu_clear: {
		// MobclickAgent.onEvent(this, "1001");
		// new Thread(){
		// public void run() {
		// WipeCache.shareInstance().clear();
		// handler.sendEmptyMessage(0);
		// }
		// }.start();
		// }
		// break;
		// case R.id.menu_evaluate: {
		// try {
		// startActivity(Intent.parseUri("http://sj.zol.com.cn/detail/58/57411.shtml",
		// 0));
		// } catch (URISyntaxException e) {
		// e.printStackTrace();
		// }
		// // http://sj.zol.com.cn/detail/58/57411.shtml
		// }
		// break;
		// case R.id.menu_opinion: {
		// intent = new Intent();
		// intent.setClass(SubCategoryActivity.this, FeedbackActivity.class);
		// startActivity(intent);
		// }
		// break;
		// case R.id.menu_about: {
		// intent = new Intent();
		// intent.setClass(SubCategoryActivity.this, AboutUsActivity.class);
		// startActivity(intent);
		// }
		// break;
		}
	}

	@Override
	public void requestFailedHandle(String method, int errorCode, String errorMsg) {
		super.requestFailedHandle(method, errorCode, errorMsg);

		if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST)) {
			if (!isFromRefreshDataSubLatest) {
				currentPageSubLatest -= STEP_LOADIMAGE;
			}
			SubLatestFragment fragment = (SubLatestFragment) fragments.get(0);
			fragment.hideHeaderViewAndFooterView();
		}
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST)) {
			if (!isFromRefreshDataSubRecommended) {
				currentPageSubRecommended -= STEP_LOADIMAGE;
			}
			SubRecommendedFragment fragment = (SubRecommendedFragment) fragments.get(1);
			fragment.hideHeaderViewAndFooterView();
		}
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST)) {
			if (!isFromRefreshDataHottest) {
				currentPageHottest -= STEP_LOADIMAGE;
			}
			HottestFragment fragment = (HottestFragment) fragments.get(2);
			fragment.hideHeaderViewAndFooterView();
		}
		Log.i("kyson", "errorMsg" + errorMsg);
		if (1001 == errorCode) {
			Toast.makeText(SubCategoryActivity.this, "无结果", Toast.LENGTH_SHORT).show();
		} else {
			Toast.makeText(SubCategoryActivity.this, errorMsg, Toast.LENGTH_SHORT).show();
		}
		dismissProgress();
		// this.finish();
	}

	@Override
	public void onFooterRefresh(PullToRefreshView view) {
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		switch (currentPage) {
		// latest
		case 0: {
			if (latestGroups.size() >= 30) {
				currentPageSubLatest += STEP_LOADIMAGE;
			} else {
				currentPageSubLatest = 0;
			}
			SubCategoryActivity.isFromRefreshDataSubLatest = false;
			viewModel.start = currentPageSubLatest + "";
			viewModel.cateId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST);
			isFirstTimeFetchDataSubLatest = true;
		}
			break;
		case 1: {
			SubCategoryActivity.isFromRefreshDataSubRecommended = false;
			if (recommendedGroups.size() >= 30) {
				currentPageSubRecommended += STEP_LOADIMAGE;
			} else {
				currentPageSubRecommended = 0;
			}
			// currentPageSubRecommended += STEP_LOADIMAGE;
			viewModel.start = currentPageSubRecommended + "";
			viewModel.cateId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST);
			isFirstTimeFetchDataSubRecommended = true;
		}
			break;
		case 2: {
			SubCategoryActivity.isFromRefreshDataHottest = false;
			if (hottestGroups.size() >= 30) {
				currentPageHottest += STEP_LOADIMAGE;
			} else {
				currentPageHottest = 0;
			}
			// currentPageHottest += STEP_LOADIMAGE;
			viewModel.start = currentPageHottest + "";
			viewModel.cateId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST);
			isFirstTimeFetchDataHottest = true;
		}
			break;
		default:
			break;
		}
	}

	@Override
	public void onHeaderRefresh(PullToRefreshView view) {
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		switch (currentPage) {
		// latest
		case 0: {
			SubCategoryActivity.isFromRefreshDataSubLatest = true;
			currentPageSubLatest = 0;
			viewModel.start = currentPageSubLatest + "";
			viewModel.cateId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST);
			isFirstTimeFetchDataSubLatest = true;
		}
			break;
		case 1: {
			SubCategoryActivity.isFromRefreshDataSubRecommended = true;
			currentPageSubRecommended = 0;
			viewModel.start = currentPageSubRecommended + "";
			viewModel.cateId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST);
			isFirstTimeFetchDataSubRecommended = true;
		}
			break;
		case 2: {
			SubCategoryActivity.isFromRefreshDataHottest = true;
			currentPageHottest = 0;
			viewModel.start = currentPageHottest + "";
			viewModel.cateId = cateId;
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST);
			isFirstTimeFetchDataHottest = true;
		}
			break;
		default:
			break;
		}
	}

	public void subLatestNetWorkClick(View v) {
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		SubLatestFragment subLatestFragment = (SubLatestFragment) fragments.get(currentPage);
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			subLatestFragment.setGONE();
			viewModel.cateId = cateId;
			viewModel.start = currentPageSubLatest + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETLATESTLIST);
			isFirstTimeFetchDataSubLatest = false;
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			subLatestFragment.setVISIBLE();
			isFirstTimeFetchDataSubLatest = true;
		}
	}

	public void subRecommendedNetWorkClick(View v) {
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		SubRecommendedFragment subRecommendedFragment = (SubRecommendedFragment) fragments.get(currentPage);
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			subRecommendedFragment.setGONE();
			viewModel.cateId = cateId;
			viewModel.start = currentPageSubRecommended + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETRECOMMENDEDLIST);
			isFirstTimeFetchDataSubRecommended = false;
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			subRecommendedFragment.setVISIBLE();
			isFirstTimeFetchDataSubRecommended = true;
		}
	}

	public void hottestNetWorkClick(View v) {
		SubCategoryViewModel viewModel = (SubCategoryViewModel) this.baseViewModel;
		int status = NetworkStatus.networkStatus();
		HottestFragment hottestFragment = (HottestFragment) fragments.get(currentPage);
		if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
			hottestFragment.setGONE();
			viewModel.cateId = cateId;
			viewModel.start = currentPageHottest + "";
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_SUBCATEGORY_GETHOTTESTLIST);
			isFirstTimeFetchDataHottest = false;
		} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
			hottestFragment.setVISIBLE();
			isFirstTimeFetchDataHottest = true;
		}
	}

	@SuppressLint("HandlerLeak")
	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				Toast.makeText(SubCategoryActivity.this, "清除缓存成功", Toast.LENGTH_SHORT).show();
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
				intent.setClass(SubCategoryActivity.this, AboutUsActivity.class);
				startActivity(intent);
			}
		}
			break;
		case 3: {
			intent = new Intent();
			intent.setClass(SubCategoryActivity.this, FeedbackActivity.class);
			startActivity(intent);
		}
			break;
		case 4: {
			
			Intent intent = new Intent(this, MyService.class);
	        this.startService(intent);
			
			/*String fileString = WallWrapperApplication.getContext().getExternalFilesDir(Environment.DIRECTORY_DCIM).getPath();
			File files = new File(fileString);
			if (files.isDirectory()) {
				int nums = files.listFiles().length;
				if (nums > 0) {
					for (int i = 0; i < nums; i++) {
						try {
							FileInputStream fis = new FileInputStream(files.listFiles()[0]);
							WallpaperManager wpm = (WallpaperManager) getSystemService(WALLPAPER_SERVICE);
							WindowManager wm = (WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
							@SuppressWarnings("deprecation")
							int width = wm.getDefaultDisplay().getWidth();
							@SuppressWarnings("deprecation")
							int height = wm.getDefaultDisplay().getHeight();
							wpm.suggestDesiredDimensions(width, height);
							@SuppressWarnings("deprecation")
							BitmapDrawable pic = new BitmapDrawable(fis);
							Bitmap bitmap = pic.getBitmap();
							bitmap = ThumbnailUtils.extractThumbnail(bitmap, width, height);
							WallpaperManager.getInstance(MainActivity.this).setBitmap(bitmap);
						} catch (FileNotFoundException e) {
							e.printStackTrace();
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
			}*/
		}
			break;
		case 5: {
			Intent intent = new Intent(this, MyService.class);
	        this.stopService(intent);
		}
		break;
		}

	}
}
