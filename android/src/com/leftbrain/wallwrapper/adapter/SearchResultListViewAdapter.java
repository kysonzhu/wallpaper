package com.leftbrain.wallwrapper.adapter;

import java.util.ArrayList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.leftbrain.wallwrapper.R;

/**
 * 
 * @author dell
 * 
 */
public class SearchResultListViewAdapter extends BaseAdapter {

	private LayoutInflater inflater;
	// member
	private ArrayList<String> mList;

	public SearchResultListViewAdapter(Context context, ArrayList<String> searchHistories) {
		this.mList = searchHistories;
		inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	}

	@SuppressLint("ViewHolder")
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		convertView = inflater.inflate(R.layout.search_result_list_item, null);
		String historyItem = mList.get(position);
		TextView tv = (TextView) convertView.findViewById(R.id.item_shousuo_tv);
		tv.setText(historyItem);
		return convertView;
	}

	@Override
	public long getItemId(int arg0) {
		return arg0;
	}

	@Override
	public Object getItem(int position) {
		return mList.get(position);
	}

	@Override
	public int getCount() {
		return mList.size();
	}

}
