package com.leftbrain.wallwrapper.adapter;

import java.net.URISyntaxException;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.base.WallWrapperApplication;
import com.leftbrain.wallwrapper.controller.AboutUsActivity;
import com.leftbrain.wallwrapper.controller.FeedbackActivity;
import com.leftbrain.wallwrapper.service.MyService;
import com.leftbrain.wallwrapper.utils.WipeCache;
import com.umeng.analytics.MobclickAgent;

public class MenuListViewAdapter extends BaseAdapter {

	private String[] menu_Strings = WallWrapperApplication.getContext().getResources().getStringArray(R.array.menu_string);
	private int[] menu_image = { R.drawable.ic_lef_del, R.drawable.ic_lef_remove, R.drawable.ic_lef_feedback, R.drawable.ic_lef_on, R.drawable.ic_lef_on, R.drawable.ic_lef_on, R.drawable.ic_lef_on, R.drawable.ic_lef_on };
	private LayoutInflater inflater;
	private Intent intent;
	private Context context;

	public MenuListViewAdapter(final Context context) {
		this.context = context;
		inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	@Override
	public int getCount() {
		return (menu_Strings == null) ? 0 : menu_Strings.length;
	}

	@Override
	public Object getItem(int arg0) {
		return menu_Strings[arg0];
	}

	@Override
	public long getItemId(int arg0) {
		return arg0;
	}

	@SuppressLint("InflateParams")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;

		if (convertView == null) {
			convertView = inflater.inflate(R.layout.menu_listview_item, null);
			holder = new ViewHolder(convertView);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.imageView.setBackgroundResource(menu_image[position]);
		holder.textview.setText(menu_Strings[position]);
		holder.textview.setOnClickListener(new Menu_Click(position));
		return convertView;
	}

	static class ViewHolder {
		ImageView imageView;
		TextView textview;

		public ViewHolder(View view) {
			this.imageView = (ImageView) view.findViewById(R.id.menu_listview_imageview);
			this.textview = (TextView) view.findViewById(R.id.menu_listview_textview);
		}

	}

	class Menu_Click implements OnClickListener {

		private int position;

		public Menu_Click(int position) {
			this.position = position;
		}

		@Override
		public void onClick(View v) {
			switch (position) {
			case 0: {
				MobclickAgent.onEvent(context, "1001");
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
					MobclickAgent.onEvent(context, "1005");
					context.startActivity(Intent.parseUri("http://sj.zol.com.cn/detail/58/57411.shtml", 0));
				} catch (URISyntaxException e) {
					e.printStackTrace();
				}
			}
				break;
			case 2: {
				{
					intent = new Intent();
					intent.setClass(context, AboutUsActivity.class);
					context.startActivity(intent);
				}
			}
				break;
			case 3: {
				intent = new Intent();
				intent.setClass(context, FeedbackActivity.class);
				context.startActivity(intent);
			}
				break;
			case 4: {

				Intent intent = new Intent(context, MyService.class);
				context.startService(intent);

				/*
				 * String fileString =
				 * context.getExternalFilesDir
				 * (Environment.DIRECTORY_DCIM).getPath(); File files = new
				 * File(fileString); if (files.isDirectory()) { int nums =
				 * files.listFiles().length; if (nums > 0) { for (int i = 0; i <
				 * nums; i++) { try { FileInputStream fis = new
				 * FileInputStream(files.listFiles()[0]); WallpaperManager wpm =
				 * (WallpaperManager) getSystemService(WALLPAPER_SERVICE);
				 * WindowManager wm = (WindowManager)
				 * getApplicationContext().getSystemService
				 * (Context.WINDOW_SERVICE);
				 * 
				 * @SuppressWarnings("deprecation") int width =
				 * wm.getDefaultDisplay().getWidth();
				 * 
				 * @SuppressWarnings("deprecation") int height =
				 * wm.getDefaultDisplay().getHeight();
				 * wpm.suggestDesiredDimensions(width, height);
				 * 
				 * @SuppressWarnings("deprecation") BitmapDrawable pic = new
				 * BitmapDrawable(fis); Bitmap bitmap = pic.getBitmap(); bitmap
				 * = ThumbnailUtils.extractThumbnail(bitmap, width, height);
				 * WallpaperManager
				 * .getInstance(MainActivity.this).setBitmap(bitmap); } catch
				 * (FileNotFoundException e) { e.printStackTrace(); } catch
				 * (IOException e) { e.printStackTrace(); } } } }
				 */
			}
				break;
			case 5: {
				Intent intent = new Intent(context, MyService.class);
				context.stopService(intent);
			}
				break;
			}
		}

	}

	@SuppressLint("HandlerLeak")
	private Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case 0:
				Toast.makeText(context, "清除缓存成功", Toast.LENGTH_SHORT).show();
				break;

			default:
				break;
			}

		}
	};

}
