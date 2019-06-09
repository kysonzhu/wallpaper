package cn.kyson.wallpaper.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.model.Category;
import cn.kyson.wallpaper.widget.RoundAngleImageView;

public class CategoryListViewAdapter extends BaseAdapter {
	private ArrayList<Category> categorys;
	private LayoutInflater inflater;

	public CategoryListViewAdapter(final Context context, ArrayList<Category> categorys) {
		assert categorys != null;
		this.categorys = categorys;
		inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	public ArrayList<Category> getCategorys() {
		return categorys;
	}

	@Override
	public int getCount() {
		return (categorys == null) ? 0 : categorys.size();
	}

	@Override
	public Object getItem(int arg0) {
		return categorys.get(arg0);
	}

	@Override
	public long getItemId(int arg0) {
		return arg0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;

		if (convertView == null) {
			convertView = inflater.inflate(R.layout.category_listview_item, null);
			holder = new ViewHolder(convertView);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		Category category = categorys.get(position);
		holder.imageView.loadImage(category.coverImgUrl);
		holder.cateName_textview.setText(category.cateName);
		holder.keyword_textview.setText(category.keyword);
		return convertView;
	}

	static class ViewHolder {
		RoundAngleImageView imageView;
		TextView cateName_textview;
		TextView keyword_textview;

		public ViewHolder(View view) {
			this.imageView = (RoundAngleImageView) view.findViewById(R.id.category_listview_autoloadimageview);
			this.cateName_textview = (TextView) view.findViewById(R.id.category_listview_cateName);
			this.keyword_textview = (TextView) view.findViewById(R.id.category_listview_keyword);
		}

	}

}
