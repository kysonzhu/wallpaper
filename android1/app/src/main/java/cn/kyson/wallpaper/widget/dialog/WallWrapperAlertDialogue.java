package cn.kyson.wallpaper.widget.dialog;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.PopupWindow;
import android.widget.TextView;

import cn.kyson.wallpaper.R;

public class WallWrapperAlertDialogue extends PopupWindow {

	private Context mContext;

	public WallWrapperAlertDialogue(Context context) {
		super(context);
		this.mContext = context;
	}

	public WallWrapperAlertDialogue buildWithInput(MessageDialogListener listener) {

		LayoutInflater inflater = LayoutInflater.from(mContext);
		View view = inflater.inflate(R.layout.dialog_vin, null);

		TextView btn_click = (TextView) view.findViewById(R.id.btn_click);

		btn_click.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				dismiss();
			}
		});

		this.setContentView(view);
		this.setWidth(LayoutParams.MATCH_PARENT);
		this.setHeight(LayoutParams.MATCH_PARENT);
		this.setFocusable(true);
		ColorDrawable dw = new ColorDrawable(-00000);
		this.setBackgroundDrawable(dw);
		this.setOutsideTouchable(false);

		return this;
	}

	public interface MessageDialogListener {

		public void confirm();

		public void cancel();
	}
}
