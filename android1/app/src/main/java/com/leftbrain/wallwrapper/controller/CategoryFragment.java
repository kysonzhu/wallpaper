package com.leftbrain.wallwrapper.controller;

import java.util.ArrayList;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.RelativeLayout;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.CategoryListViewAdapter;
import com.leftbrain.wallwrapper.model.Category;
import com.umeng.analytics.MobclickAgent;

public class CategoryFragment extends Fragment implements OnItemClickListener {
	
	private ListView categorylistview;
    private ArrayList<Category> categorys;
    private RelativeLayout categoryNetWorkRelativeLayout;
    private CategoryFragmentListener mListener;
    private boolean mShowNoNetworkView;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View view = inflater.inflate(R.layout.fragment_category, container,
					false);
		
		ViewGroup parent = (ViewGroup) view.getParent();
		if (parent != null) {
			parent.removeView(view);
		}
		categorylistview = (ListView) view.findViewById(R.id.category_listview);
		categoryNetWorkRelativeLayout = (RelativeLayout) view.findViewById(R.id.category_netWork_relativeLayout);
		categorylistview.setOnItemClickListener(this);
		if(this.mShowNoNetworkView){
			categoryNetWorkRelativeLayout.setVisibility(View.VISIBLE);
			categorylistview.setVisibility(View.GONE);
		}else{
			categoryNetWorkRelativeLayout.setVisibility(View.GONE);
			categorylistview.setVisibility(View.VISIBLE);
		}
		return view;
	}

	@Override
	public void onItemClick(AdapterView<?> arg0,  View view, int position, long id) {
		if(null != mListener){
			Category category = categorys.get(position);
			mListener.categoryFragmentItemClicked(category);
		}else{
			Log.i("kyson", "CategoryFragmentListener is null,please set listener first");
		}

	}
	
	public void setAdapter(CategoryListViewAdapter adapter) {
		if (null != categorylistview) {
			categorys = adapter.getCategorys();
			categorylistview.setAdapter(adapter);
		}
	}
	
	/**
	 * CategoryFragmentListener,dealing onItemClick event
	 * @author dell
	 *
	 */
	public interface CategoryFragmentListener{
		public void categoryFragmentItemClicked(Category category);
	}
	
	public void setCategoryFragmentListener(CategoryFragmentListener listener){
		this.mListener = listener;
	}
	
	public void showNoNetworkView(boolean show){
		if(show){
			if(null != categoryNetWorkRelativeLayout){
				categoryNetWorkRelativeLayout.setVisibility(View.VISIBLE);
				categorylistview.setVisibility(View.GONE);
			}
			mShowNoNetworkView = true;
		}else{
			if(null != categoryNetWorkRelativeLayout){
				categoryNetWorkRelativeLayout.setVisibility(View.GONE);
				categorylistview.setVisibility(View.VISIBLE);
			}
			mShowNoNetworkView = false;
		}
	}

	public void setGONE() {
		categoryNetWorkRelativeLayout.setVisibility(View.GONE);
		categorylistview.setVisibility(View.VISIBLE);
	}

	public void setVISIBLE() {
		categoryNetWorkRelativeLayout.setVisibility(View.VISIBLE);
		categorylistview.setVisibility(View.GONE);
	}
	//--------------------------------------
	public void onResume() {
	    super.onResume();
	    MobclickAgent.onPageStart("CategoryFragment"); //统计页面
	}
	public void onPause() {
	    super.onPause();
	    MobclickAgent.onPageEnd("CategoryFragment"); 
	}
	   //--------------------------------------
}
