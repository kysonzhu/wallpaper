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
import cn.kyson.wallpaper.base.UserCenter;
import cn.kyson.wallpaper.base.WallWrapperEnvConfigure;
import cn.kyson.wallpaper.model.Group;
import cn.kyson.wallpaper.widget.AutoLoadImageView;

/**
 * 
 * @author dell
 * 
 */
public class RecommendedFragmentAdapter extends BaseAdapter {

	private ArrayList<Group> mGroups;
	private LayoutInflater inflater;

	public RecommendedFragmentAdapter(Context context, ArrayList<Group> arrayList) {
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

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final ViewHolder holder;
		Group group = mGroups.get(position);

		if (convertView == null) {
			convertView = inflater.inflate(R.layout.recommended_grid_item, null);
			holder = new ViewHolder(convertView);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.imageView.loadImage(group.coverImgUrl);
		boolean hasPraised = UserCenter.instance().hasGroupPraised(group.gId);
		String voteGood = group.voteGood;
		if (hasPraised) {
			int voteGoodNum = Integer.valueOf(null == voteGood ? "0" : voteGood) + 1;
			voteGood = voteGoodNum + "";
		}
		holder.zan_textview.setText(voteGood);
		String titleString = WallWrapperEnvConfigure.getProssedTitle(group.gName + "  (" + group.picNum + "张)",Integer.valueOf(group.picNum));
		holder.message_textview.setText(titleString);
		return convertView;
	}

	public ArrayList<Group> getDatas() {
		return mGroups;
	}

	static class ViewHolder {
		AutoLoadImageView imageView;
		TextView zan_textview;
		TextView message_textview;

		public ViewHolder(View view) {
			this.imageView = (AutoLoadImageView) view.findViewById(R.id.recommended_grid_autoloadimageview);
			LayoutParams para = this.imageView.getLayoutParams();
			int width = (int) ((int) WallWrapperEnvConfigure.getScreenWidth() / 3.0 - 5);
			para.width = width;
			para.height = (int) (width / WallWrapperEnvConfigure.GROUP_COVER_IMAGE_WIDTH * WallWrapperEnvConfigure.GROUP_COVER_IMAGE_HEIGHT);
			this.imageView.setLayoutParams(para);
			this.imageView.setScaleType(ScaleType.FIT_XY);
			this.zan_textview = (TextView) view.findViewById(R.id.recommended_zan_textview);
			this.message_textview = (TextView) view.findViewById(R.id.recommended_message_textview);
		}
	}

}
