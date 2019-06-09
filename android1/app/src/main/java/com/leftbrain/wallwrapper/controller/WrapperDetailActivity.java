package com.leftbrain.wallwrapper.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.app.WallpaperManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.WraperDetailViewpagerAdapter;
import com.leftbrain.wallwrapper.adapter.WraperDetailViewpagerAdapter.WrapperDetailViewPagerListener;
import com.leftbrain.wallwrapper.base.UserCenter;
import com.leftbrain.wallwrapper.base.WallWrapperBaseActivity;
import com.leftbrain.wallwrapper.base.WallWrapperEnvConfigure;
import com.leftbrain.wallwrapper.model.Image;
import com.leftbrain.wallwrapper.model.ImageSize;
import com.leftbrain.wallwrapper.service.NetworkStatus;
import com.leftbrain.wallwrapper.service.WallWrapperServiceMediator;
import com.leftbrain.wallwrapper.utils.CameraUtils;
import com.leftbrain.wallwrapper.utils.imagedownloader.FileHandler;
import com.leftbrain.wallwrapper.utils.imagedownloader.ImageDownloader;
import com.leftbrain.wallwrapper.utils.imagedownloader.ImageUtils;
import com.leftbrain.wallwrapper.utils.imagedownloader.MD5Encoder;
import com.leftbrain.wallwrapper.viewmodel.ImageViewModel;
import com.leftbrain.wallwrapper.viewmodel.WallWrapperViewModel;
import com.leftbrain.wallwrapper.widget.ImageDownloaderListener;
import com.umeng.analytics.MobclickAgent;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.QZoneSsoHandler;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.weixin.controller.UMWXHandler;

@SuppressLint("ServiceCast")
public class WrapperDetailActivity extends WallWrapperBaseActivity implements OnClickListener, WrapperDetailViewPagerListener, ImageDownloaderListener {

	private String gid;
	private LinearLayout toolbarLinearLayout;
	private ImageView zan_click_iv;
	private TextView dianzan_tvdianzan_tv;
	private boolean hasClicked;
	// private HashMap<String, String> errorIndexsHashMap;
	private ArrayList<String> errorArrayList;

	private ViewPager viewPager;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		hasClicked = false;
		errorArrayList = new ArrayList<String>();
		setContentView(R.layout.activity_wrapperdetail);

		viewPager = (ViewPager) findViewById(R.id.vPager);
		// viewPager.setOffscreenPageLimit(12);
		toolbarLinearLayout = (LinearLayout) findViewById(R.id.wrapperdetail_toolbar_linearlayout);

		zan_click_iv = (ImageView) findViewById(R.id.wrapperdetail_votegood_imageview);
		dianzan_tvdianzan_tv = (TextView) findViewById(R.id.wrapperdetail_votegood_textview);

		LinearLayout vGoodLinearLayout = (LinearLayout) findViewById(R.id.wrapperDetail_linearLayout_vgood_click);
		vGoodLinearLayout.setOnClickListener(this);
		LinearLayout lockscreenLinearLayout = (LinearLayout) findViewById(R.id.wrapperDetail_linearLayout_lockscreen_click);
		lockscreenLinearLayout.setOnClickListener(this);
		LinearLayout shareLinearLayout = (LinearLayout) findViewById(R.id.wrapperDetail_linearLayout_share_click);
		shareLinearLayout.setOnClickListener(this);
		LinearLayout tableLinearLayout = (LinearLayout) findViewById(R.id.wrapperDetail_linearLayout_Table_click);
		tableLinearLayout.setOnClickListener(this);
		LinearLayout downLoadLinearLayout = (LinearLayout) findViewById(R.id.wrapperDetail_linearLayout_downLoad_click);
		downLoadLinearLayout.setOnClickListener(this);
		
	}

	@Override
	public void alreadyBindBaseViewModel() {
		super.alreadyBindBaseViewModel();
		ImageViewModel viewModel = (ImageViewModel) this.baseViewModel;
		gid = viewModel.gId;
		if (UserCenter.instance().hasGroupPraised(gid)) {
			zan_click_iv.setImageResource(R.drawable.tab_ic_col_pre);
			dianzan_tvdianzan_tv.setTextColor(Color.parseColor("#fe5d6c"));
		}
		if (NetworkStatus.NETWORK_STATUS_NOTREACHABLE == NetworkStatus.networkStatus()) {
			showProgress("没有网络");
		} else {
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETIMAGES);
		}
	}

	@Override
	public void refreshData(String method) {
		super.refreshData(method);
		dismissProgress();
		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETIMAGES)) {
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			ArrayList<Image> arrayList = viewModel.images;
			for (Image image : arrayList) {
				Log.i("kyson", image.imgUrl);
			}
			if (null != arrayList) {
				WraperDetailViewpagerAdapter adapter = new WraperDetailViewpagerAdapter(this, arrayList);
				adapter.setWrapperDetailViewPagerListener(this);
				viewPager.setAdapter(adapter);
			}
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.wrapperDetail_linearLayout_vgood_click:
		case R.id.wrapperdetail_votegood_imageview: {
			int status = NetworkStatus.networkStatus();
			if (status == NetworkStatus.NETWORK_STATUS_REACHABLE) {
				MobclickAgent.onEvent(this, "1004");
				if (!UserCenter.instance().hasGroupPraised(gid)) {
					UserCenter.instance().setGroupPraised(gid);
					zan_click_iv.setImageResource(R.drawable.tab_ic_col_pre);
					dianzan_tvdianzan_tv.setTextColor(Color.parseColor("#fe5d6c"));
				} else {
					UserCenter.instance().cancelGroupPraised(gid);
					zan_click_iv.setImageResource(R.drawable.tab_ic_col_def);
					dianzan_tvdianzan_tv.setTextColor(Color.parseColor("#666666"));
				}
			} else if (status == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
				Toast.makeText(WrapperDetailActivity.this, "没有网络", Toast.LENGTH_SHORT).show();
			}
		}
			break;
		case R.id.wrapperDetail_linearLayout_downLoad_click: {
			int status2 = NetworkStatus.networkStatus();
			if (status2 == NetworkStatus.NETWORK_STATUS_REACHABLE) {
				final int currentItemIndex = viewPager.getCurrentItem();
				WraperDetailViewpagerAdapter adapter = (WraperDetailViewpagerAdapter) viewPager.getAdapter();
				final ArrayList<Image> images = adapter.getArrayListImages();
				if (images != null) {
					showProgress("正在加速下载中...");
					MobclickAgent.onEvent(this, "1003");
					if (null != images && images.size() > 0) {
						// MobclickAgent.onEvent(this, "1002");
						Image image = images.get(currentItemIndex);
						ImageDownloader downloader = new ImageDownloader(image.imgUrl);
						downloader.setImageDownloadListener(this);
						downloader.startDownload();
					} else {
						Toast.makeText(this, "下载失败", 1 * 1000).show();
						dismissProgress();
					}
				}else{
					Toast.makeText(this, "下载失败", 1 * 1000).show();
				}
			} else if (status2 == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
				Toast.makeText(WrapperDetailActivity.this, "没有网络", Toast.LENGTH_SHORT).show();
			}
		}

			break;
		case R.id.wrapperDetail_linearLayout_Table_click: {
			int status3 = NetworkStatus.networkStatus();
			if (status3 == NetworkStatus.NETWORK_STATUS_REACHABLE) {
				int currentItemIndex = viewPager.getCurrentItem();
				WraperDetailViewpagerAdapter adapter = (WraperDetailViewpagerAdapter) viewPager.getAdapter();
				final ArrayList<Image> images = adapter.getArrayListImages();
				// showProgress();
				Toast.makeText(this, "正在设置...", Toast.LENGTH_SHORT).show();
				if (images != null) {
					Image image = images.get(currentItemIndex);
					FileHandler fileHandler = FileHandler.shareInstance(this);
					File file = fileHandler.findFileByName(MD5Encoder.encoding(image.imgUrl.replace("\\", "")), fileHandler.getImagePath());
					ImageSize size = new ImageSize(WallWrapperEnvConfigure.getScreenWidth(), WallWrapperEnvConfigure.getScreenHeight());
					Bitmap bitmap = ImageUtils.readFileToBitmapToSize(file.toString(), size);
					if(bitmap==null){
						 file = fileHandler.findFileByName(MD5Encoder.encoding(image.imgUrl.replace("\\", "").replace("720x1280", "640x960")), fileHandler.getImagePath());
						 bitmap = ImageUtils.readFileToBitmapToSize(file.toString(), size);
					}
					if (null != bitmap) {
						try {
							MobclickAgent.onEvent(this, "1002");
							
							WallpaperManager wpm = (WallpaperManager) getSystemService(WALLPAPER_SERVICE);
							int width = WallWrapperEnvConfigure.getScreenWidth();
							int height = WallWrapperEnvConfigure.getScreenHeight();
							wpm.suggestDesiredDimensions(width, height);
							
							bitmap = ThumbnailUtils.extractThumbnail(bitmap, width, height);
							WallpaperManager.getInstance(this).setBitmap(bitmap);
							dismissProgress();
							Toast.makeText(this, "生成桌面壁纸成功!", Toast.LENGTH_SHORT).show();
						} catch (IOException e) {
							e.printStackTrace();
							dismissProgress();
							Toast.makeText(this, "生成桌面壁纸失败!", Toast.LENGTH_SHORT).show();
						}
					} else {
						
						dismissProgress();
						Toast.makeText(this, "生成桌面壁纸失败!", Toast.LENGTH_SHORT).show();
					}
				} else {
					dismissProgress();
					Toast.makeText(this, "生成桌面壁纸失败!", Toast.LENGTH_SHORT).show();
				}
			} else if (status3 == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
				Toast.makeText(WrapperDetailActivity.this, "没有网络", Toast.LENGTH_SHORT).show();
			}
		}
			break;
		case R.id.wrapperDetail_linearLayout_lockscreen_click:
			this.finish();
			break;
		case R.id.wrapperDetail_linearLayout_share_click: {
			int status4 = NetworkStatus.networkStatus();
			if (status4 == NetworkStatus.NETWORK_STATUS_REACHABLE) {
				toolbarLinearLayout.setVisibility(View.GONE);
				hasClicked = true;
				int currentItemIndex4 = viewPager.getCurrentItem();
				WraperDetailViewpagerAdapter adapter4 = (WraperDetailViewpagerAdapter) viewPager.getAdapter();
				final ArrayList<Image> images4 = adapter4.getArrayListImages();

				QZoneSsoHandler qZoneSsoHandler = new QZoneSsoHandler(WrapperDetailActivity.this, "1103993167", "54d02757fd98c53a2300063b");
				qZoneSsoHandler.addToSocialSDK();

				UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler(WrapperDetailActivity.this, "1103993167", "54d02757fd98c53a2300063b");
				qqSsoHandler.addToSocialSDK();
				qqSsoHandler.setTitle("高清壁纸管家");

				// 添加微信平台
				UMWXHandler wxHandler = new UMWXHandler(WrapperDetailActivity.this, "wx5c7035562be049ac", "d785b6006c978d906c3bfdededbc92e3");
				wxHandler.addToSocialSDK();
				// 设置分享标题
				wxHandler.setTitle("高清壁纸管家");

				// 添加微信朋友圈
				UMWXHandler wxCircleHandler = new UMWXHandler(WrapperDetailActivity.this, "wx5c7035562be049ac", "d785b6006c978d906c3bfdededbc92e3");
				wxCircleHandler.setToCircle(true);
				wxCircleHandler.addToSocialSDK();
				wxCircleHandler.setTitle("高清壁纸管家");

				final UMSocialService mController = UMServiceFactory.getUMSocialService("com.umeng.share");
				// 设置分享内容
				mController.setShareContent("来自高清壁纸管家的优美图片");
				// 设置分享图片, 参数2为图片的url地址
				mController.setShareMedia(new UMImage(this, "http://app.zol.com.cn/bizhi/detail_" + gid + "_" + images4.get(currentItemIndex4).pId + ".html#p" + (currentItemIndex4 + 1)));

				mController.getConfig().removePlatform(SHARE_MEDIA.RENREN, SHARE_MEDIA.DOUBAN, SHARE_MEDIA.SINA, SHARE_MEDIA.TENCENT);
				Log.i("kyson", currentItemIndex4 + "   ppppppp");
				mController.openShare(this, false);
				MobclickAgent.onEvent(this, "1000");
			} else if (status4 == NetworkStatus.NETWORK_STATUS_NOTREACHABLE) {
				Toast.makeText(WrapperDetailActivity.this, "没有网络", Toast.LENGTH_SHORT).show();
			}
		}
			break;
		default:
			break;
		}
	}

	/************************* WrapperDetailViewPagerListener ********************************/
	@Override
	public void viewpagerItemDidClicked(int position) {
		if (hasClicked) {
			toolbarLinearLayout.setVisibility(View.VISIBLE);
			hasClicked = false;
		} else {
			toolbarLinearLayout.setVisibility(View.GONE);
			hasClicked = true;
		}
	}

	@Override
	public void wrapperDetailViewDownloadError(int position, Image image) {
		// TODO Auto-generated method stub
		boolean hasAdded = false;
		for (String errorItem : errorArrayList) {
			if (errorItem.equals(position + "")) {
				hasAdded = true;
				break;
			}
		}
		if (!hasAdded) {
			errorArrayList.add(image.imgUrl);
		}

		WraperDetailViewpagerAdapter adapter = ((WraperDetailViewpagerAdapter) viewPager.getAdapter());
		ArrayList<Image> imageList = adapter.getImageList();

		ArrayList<Image> imagess = new ArrayList<Image>();

		for (String imageUrl : errorArrayList) {
			for (Image image2 : imageList) {
				String imageString = image2.imgUrl;
				if (imageUrl.equals(imageString)) {
					imagess.add(image2);
					break;
				}
			}
		}

		imageList.removeAll(imagess);
		adapter.notifyDataSetChanged();
		imagess.clear();

	}

	@Override
	public void requestFailedHandle(String method, int errorCode, String errorMsg) {
		// TODO Auto-generated method stub
		super.requestFailedHandle(method, errorCode, errorMsg);
		dismissProgress();
	}

	/*************************************** imagedownload *************************************************/
	@Override
	public void imageDownloadStarted(String imageUrlString) {
		// TODO Auto-generated method stub

	}

	public void imageDownloadFininshed(String imageUrlString) {
		// TODO Auto-generated method stub
		i=0;
		Toast.makeText(this, "下载成功", 2 * 1000).show();
		CameraUtils.shareInstance().addImage(MD5Encoder.encoding(imageUrlString));
		dismissProgress();
	}

	@Override
	public void imageDownloadProcess(String imageUrlString, float percent) {
		// TODO Auto-generated method stub

	}

	int i=0;
	@Override
	public void imageDownloadFailed(String imageUrlString, String reason) {
		// TODO Auto-generated method stub
		i++;
		if(i==2){
			i=0;
			Toast.makeText(this, "下载失败", 1 * 1000).show();
			dismissProgress();
		}else{
			ImageDownloader downloader = new ImageDownloader(imageUrlString.replace("720x1280", "640x960"));
			downloader.setImageDownloadListener(this);
			downloader.startDownload();
		}
		
	}

}
