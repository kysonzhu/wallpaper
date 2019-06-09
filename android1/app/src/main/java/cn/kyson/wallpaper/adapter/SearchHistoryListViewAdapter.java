package cn.kyson.wallpaper.adapter;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import cn.kyson.wallpaper.R;

/**
 * 
 * @author dell
 *
 */
public class SearchHistoryListViewAdapter extends BaseAdapter {
//	public static final int SEARCH_HISTORY_SIZE = 9;

	private LayoutInflater inflater;
	//member
	private ArrayList<String> mSearchHistories;

	public SearchHistoryListViewAdapter(Context context,ArrayList<String> searchHistories) {
		this.mSearchHistories = searchHistories;
		inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	@SuppressLint("ViewHolder")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		convertView = inflater.inflate(R.layout.item_shousuo, null);
		TextView tv = (TextView) convertView.findViewById(R.id.item_shousuo_tv);
		ImageView imageView = (ImageView) convertView.findViewById(R.id.searchHistoryListView_imageView);
		if(position==0){
			tv.setText("清除历史");
			imageView.setVisibility(View.INVISIBLE);
			tv.setTextColor(Color.parseColor("#999999"));
		}else{
			String historyItem = mSearchHistories.get(position-1);
		    tv.setText(historyItem);
		}
		return convertView;
	}

	@Override
	public long getItemId(int arg0) {
		return arg0;
	}

	@Override
	public Object getItem(int position) {
		return mSearchHistories.get(position);
	}

	@Override
	public int getCount() {
//		Integer count = mSearchHistories.size();
//		return count > SEARCH_HISTORY_SIZE ? SEARCH_HISTORY_SIZE : count;
		if(mSearchHistories!=null){
			return mSearchHistories.size()+1;
		}else{
			return 0;
		}
	}

}
