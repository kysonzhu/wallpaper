package cn.kyson.wallpaper.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.model.Category;

public class SubCategoryAdapter extends BaseAdapter {

	private LayoutInflater inflater;
	private ArrayList<Category> array;

	public SubCategoryAdapter(Context context, ArrayList<Category> array) {
		this.array = array;
		inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	@Override
	public int getCount() {
		return (array == null) ? 1 : array.size() + 1;
	}

	@Override
	public Object getItem(int arg0) {
		return array.get(arg0);
	}

	@Override
	public long getItemId(int arg0) {
		return arg0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		convertView = inflater.inflate(R.layout.item_erji_feilei, null);
		ImageView imageView = (ImageView) convertView.findViewById(R.id.icon_into_pre);
		TextView tv = (TextView) convertView
				.findViewById(R.id.item_erji_feilei);
		if (position == 0) {
			tv.setTextColor(Color.parseColor("#1fb1e8"));
			tv.setText("全部");
			imageView.setImageResource(R.drawable.dd);
		} else {
			tv.setText(array.get(position - 1).cateName);
		}
		return convertView;
	}

}
