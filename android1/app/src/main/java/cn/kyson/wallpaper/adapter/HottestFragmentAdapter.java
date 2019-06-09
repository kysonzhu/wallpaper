package cn.kyson.wallpaper.adapter;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.BaseAdapter;
import android.widget.ImageView.ScaleType;
import android.widget.TextView;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.base.WallWrapperEnvConfigure;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.widget.AutoLoadImageView;

public class HottestFragmentAdapter extends BaseAdapter {

	private ArrayList<Group> mGroups;
	private LayoutInflater inflater;

	public HottestFragmentAdapter(Context context, ArrayList<Group> arrayList) {
		assert arrayList != null;
		this.mGroups = arrayList;
		inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	@Override
	public int getCount() {
		return (mGroups == null) ? 0 : mGroups.size();
	}

	@Override
	public Object getItem(int position) {
		if (position <= 0 || position >= this.mGroups.size()) {
			throw new IllegalArgumentException("position<=0||position>=this.imageUrls.length");
		}
		return this.mGroups.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final ViewHolder holder;
		Group group = mGroups.get(position);
		if (convertView == null) {
			convertView = inflater.inflate(R.layout.zuire_layout, null);
			holder = new ViewHolder(convertView);
			holder.imageView.setTag(group.coverImgUrl.replace("\\", ""));
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.imageView.loadImage(group.coverImgUrl);
		holder.hottest_down_textview.setText("有" + group.downNum + "下载");
		String titleString = WallWrapperEnvConfigure.getProssedTitle(group.gName + "  (" + group.picNum + "张)",Integer.valueOf(group.picNum));
		holder.hottest_message_textview.setText(titleString);
		return convertView;
	}

	public ArrayList<Group> getDatas() {
		return mGroups;
	}

	static class ViewHolder {
		AutoLoadImageView imageView;
		TextView hottest_down_textview;
		TextView hottest_message_textview;

		public ViewHolder(View view) {
			this.imageView = (AutoLoadImageView) view.findViewById(R.id.hottest_grid_autoloadimageview);
			LayoutParams para = this.imageView.getLayoutParams();
			int width = (int) ((int) WallWrapperEnvConfigure.getScreenWidth() / 3.0 - 5);
			para.width = width;
			para.height = (int) (width / WallWrapperEnvConfigure.GROUP_COVER_IMAGE_WIDTH * WallWrapperEnvConfigure.GROUP_COVER_IMAGE_HEIGHT);
			this.imageView.setLayoutParams(para);
			this.imageView.setScaleType(ScaleType.FIT_XY);
			this.hottest_down_textview = (TextView) view.findViewById(R.id.hottest_down_textview);
			this.hottest_message_textview = (TextView) view.findViewById(R.id.hottest_message_textview);
		}

	}

}
