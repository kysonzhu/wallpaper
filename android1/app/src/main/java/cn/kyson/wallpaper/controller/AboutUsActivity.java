package cn.kyson.wallpaper.controller;

import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.TextView;

import cn.kyson.wallpaper.R;
import cn.kyson.wallpaper.base.WallWrapperBaseActivity;

public class AboutUsActivity extends WallWrapperBaseActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_aboutus);
		TextView textView = (TextView) findViewById(R.id.message_tv_tv);
		textView.setText(Html.fromHtml("<font color=\"#666666\">壁纸宝贝有部分资源来源于互联网，图片版权归原作者所有，若有侵权问题敬请告知，我们会立即处理。本站图片资源如果没有特殊声明，</font><font color=\"#333333\">一律禁止任何形式的转载和盗用。</font>"));
		//		SpannableStringBuilder style=new SpannableStringBuilder(string); 
//		style.setSpan(new b(R.color.color_gray_3), string.length() - 15, string.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
//		textView.setText(style);
	}

	public void guanyu_fanhui_click(View v) {
		this.finish();
	}

}
