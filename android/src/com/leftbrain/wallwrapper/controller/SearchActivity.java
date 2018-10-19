package com.leftbrain.wallwrapper.controller;

import java.util.ArrayList;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnKeyListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.leftbrain.wallwrapper.R;
import com.leftbrain.wallwrapper.adapter.SearchHistoryListViewAdapter;
import com.leftbrain.wallwrapper.adapter.SearchResultListViewAdapter;
import com.leftbrain.wallwrapper.base.UserCenter;
import com.leftbrain.wallwrapper.base.WallWrapperBaseActivity;
import com.leftbrain.wallwrapper.model.Group;
import com.leftbrain.wallwrapper.service.WallWrapperServiceMediator;
import com.leftbrain.wallwrapper.service.taskpool.Route;
import com.leftbrain.wallwrapper.service.taskpool.ViewModelManager;
import com.leftbrain.wallwrapper.viewmodel.SearchDetailViewModel;
import com.leftbrain.wallwrapper.viewmodel.SearchViewModel;
import com.leftbrain.wallwrapper.viewmodel.WallWrapperViewModel;

/**
 * 
 * @author dell
 * 
 */
public class SearchActivity extends WallWrapperBaseActivity implements TextWatcher, OnItemClickListener {
	public LinearLayout linearLayout;
	public ImageView imageView;
	private ListView searchHistoryListView;
	private ListView searchResultListView;
	private EditText contentEditText;

	private ArrayList<String> searchResults;

	private boolean hasSearchResultDataFetched;
	private boolean isSearch;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		hasSearchResultDataFetched = false;
		setContentView(R.layout.activity_search);
		searchHistoryListView = (ListView) findViewById(R.id.search_history_listview);
		searchResultListView = (ListView) findViewById(R.id.search_result_listview);
		// set adapter

		if (null == UserCenter.instance().getSearchHistoryList(SearchActivity.this)) {
			searchResultListView.setVisibility(View.GONE);
		} else {
			ArrayList<String> historyList = UserCenter.instance().getSearchHistoryList(SearchActivity.this);
			SearchHistoryListViewAdapter adapter = new SearchHistoryListViewAdapter(this, historyList);
			searchHistoryListView.setAdapter(adapter);
			isSearch = true;
		}

		contentEditText = (EditText) findViewById(R.id.search_content_edittext);
		contentEditText.addTextChangedListener(this);

		searchHistoryListView.setOnItemClickListener(this);
		searchResultListView.setOnItemClickListener(this);

		contentEditText.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(View v, int keyCode, KeyEvent event) {
				if (keyCode == KeyEvent.KEYCODE_ENTER) {// 修改回车键功能
					if (contentEditText.getText().toString().trim().length() > 0) {
						((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE)).hideSoftInputFromWindow(SearchActivity.this.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
						UserCenter.instance().addSearchHistoryList(contentEditText.getText().toString(), SearchActivity.this);
						SearchDetailViewModel viewModel = (SearchDetailViewModel) ViewModelManager.manager().newViewModel(SearchListActivity.class.getName());
						viewModel.wd = contentEditText.getText().toString().trim();
						Route.route().nextController(SearchActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
					}
				}
				return false;
			}
		});
	}

	@Override
	public void afterTextChanged(Editable s) {
		if (TextUtils.isEmpty(s)) {
			// show searchHistoryListView
			searchResultListView.setVisibility(View.GONE);
			searchHistoryListView.setVisibility(View.VISIBLE);
			ArrayList<String> historyList = UserCenter.instance().getSearchHistoryList(SearchActivity.this);
			SearchHistoryListViewAdapter adapter = new SearchHistoryListViewAdapter(this, historyList);
			isSearch = true;
			searchHistoryListView.setAdapter(adapter);
		} else if(s.toString().length()>0){
			SearchViewModel viewModel = (SearchViewModel) this.baseViewModel;
			viewModel.start = "0";
			viewModel.wd = s.toString();
			doTask(viewModel, WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST);
		}

	}

	@Override
	public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
	}

	@Override
	public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
	}

	@Override
	public void refreshData(String method) {
		super.refreshData(method);

		if (method.equals(WallWrapperServiceMediator.SERVICENAME_GETSEARCHRESULTLLIST)) {
			WallWrapperViewModel viewModel = (WallWrapperViewModel) this.baseViewModel;
			ArrayList<Group> groups = viewModel.groups;
			if (groups.size() > 0) {
				// show search result listview
				searchResultListView.setVisibility(View.VISIBLE);
				searchHistoryListView.setVisibility(View.GONE);
				// set data to adapter
				searchResults = new ArrayList<String>();
				for (Group groupItem : groups) {
					searchResults.add(groupItem.gName);
				}
				SearchResultListViewAdapter adapter = new SearchResultListViewAdapter(SearchActivity.this, searchResults);
				isSearch = false;
				searchResultListView.setAdapter(adapter);
				hasSearchResultDataFetched = true;
			} else {
				isSearch = true;
				searchResultListView.setVisibility(View.GONE);
				searchHistoryListView.setVisibility(View.VISIBLE);
				hasSearchResultDataFetched = false;
			}

		}
	}

	@Override
	public void requestFailedHandle(String method, int errorCode, String errorMsg) {
		super.requestFailedHandle(method, errorCode, errorMsg);
		hasSearchResultDataFetched = false;
	}

	public void shousuo_fanhui_click(View v) {
		this.finish();
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		if (isSearch) {
			if (arg2 == 0) {
				UserCenter.instance().clearSearchHistoryList(SearchActivity.this);// clear
				searchHistoryListView.setVisibility(View.GONE);
			} else {
				String wd = UserCenter.instance().getSearchHistoryList(SearchActivity.this).get(arg2 - 1);
				SearchDetailViewModel viewModel = (SearchDetailViewModel) ViewModelManager.manager().newViewModel(SearchListActivity.class.getName());
				viewModel.wd = wd;
				Route.route().nextController(SearchActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
			}
		} else {
			if (searchResults.size() > 0) {
				SearchDetailViewModel viewModel = (SearchDetailViewModel) ViewModelManager.manager().newViewModel(SearchListActivity.class.getName());
				UserCenter.instance().addSearchHistoryList(searchResults.get(arg2), SearchActivity.this);
				viewModel.wd = searchResults.get(arg2);
				Route.route().nextController(SearchActivity.this, viewModel, Route.WITHOUT_RESULTCODE);
			}
		}
	}

}
