package cn.kyson.wallpaper.adapter;

import java.util.ArrayList;

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

public class LatestFragmentAdapter extends BaseAdapter {

	private ArrayList<Group> mGroups;
	private LayoutInflater inflater;

	public LatestFragmentAdapter(Context context, ArrayList<Group> arrayList) {
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
		return this.mGroups.get(position);
	}

	public ArrayList<Group> getDatas() {
		return mGroups;
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
			convertView = inflater.inflate(R.layout.latest_grid_item, null);
			holder = new ViewHolder(convertView);
			holder.imageView.setTag(group.coverImgUrl.replace("\\", ""));
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.imageView.loadImage(group.coverImgUrl);
		holder.timeTextView.setText(group.editDate.subSequence(0, 11));
		String str = null == group.picNum ? group.gName : group.gName + "(" + group.picNum + "张)";
		String titleString = "";
		if(null == group.picNum){
			titleString = WallWrapperEnvConfigure.getProssedTitle(str,0);
		}else{
			titleString = WallWrapperEnvConfigure.getProssedTitle(str,Integer.valueOf(group.picNum));
		}
		holder.groupTitleTextView.setText(titleString);
		return convertView;
	}

	static class ViewHolder {
		AutoLoadImageView imageView;
		TextView timeTextView;
		TextView groupTitleTextView;

		public ViewHolder(View view) {
			imageView = (AutoLoadImageView) view.findViewById(R.id.lastest_grid_autoloadimageview);
			LayoutParams para = this.imageView.getLayoutParams();
			int width = (int) ((int) WallWrapperEnvConfigure.getScreenWidth() / 3.0 - 5);
			para.width = width;
			para.height = (int) (width / WallWrapperEnvConfigure.GROUP_COVER_IMAGE_WIDTH * WallWrapperEnvConfigure.GROUP_COVER_IMAGE_HEIGHT);
			this.imageView.setLayoutParams(para);
			this.imageView.setScaleType(ScaleType.FIT_XY);
			this.timeTextView = (TextView) view.findViewById(R.id.lastest_time_textview);
			this.groupTitleTextView = (TextView) view.findViewById(R.id.lastest_message_textview);
		}

	}

}
