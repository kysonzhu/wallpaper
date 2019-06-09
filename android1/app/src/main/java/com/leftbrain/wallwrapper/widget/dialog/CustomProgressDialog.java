package com.leftbrain.wallwrapper.widget.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.text.TextUtils;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.leftbrain.wallwrapper.R;

/**
 * 
 * Create custom Dialog windows for your application Custom dialogs rely on
 * custom layouts wich allow you to create and use your own look & feel.
 * 
 * Under GPL v3 : http://www.gnu.org/licenses/gpl-3.0.html
 * 
 * @author antoine vianey
 * 
 */
public class CustomProgressDialog extends Dialog {

	public CustomProgressDialog(Activity activity, int theme) {
		super(activity, theme);
	}

	public CustomProgressDialog(Activity activity) {
		super(activity);
	}

	/**
	 * Helper class for creating a custom dialog
	 */
	public static class Builder {

		private Activity activity;
		private String title;
		private String message;
		private String positiveButtonText;
		private String negativeButtonText;
		private View contentView;

		private DialogInterface.OnClickListener positiveButtonClickListener, negativeButtonClickListener;

		public Builder(Activity activity) {
			this.activity = activity;
		}

		/**
		 * Set the Dialog message from String
		 * 
		 * @param title
		 * @return
		 */
		public Builder setMessage(String message) {
			this.message = message;
			return this;
		}

		/**
		 * Set the Dialog message from resource
		 * 
		 * @param title
		 * @return
		 */
		public Builder setMessage(int message) {
			this.message = (String) activity.getText(message);
			return this;
		}

		/**
		 * Set the Dialog title from resource
		 * 
		 * @param title
		 * @return
		 */
		public Builder setTitle(int title) {
			this.title = (String) activity.getText(title);
			return this;
		}

		/**
		 * Set the Dialog title from String
		 * 
		 * @param title
		 * @return
		 */
		public Builder setTitle(String title) {
			this.title = title;
			return this;
		}

		/**
		 * Set a custom content view for the Dialog. If a message is set, the
		 * contentView is not added to the Dialog...
		 * 
		 * @param v
		 * @return
		 */
		public Builder setContentView(View v) {
			this.contentView = v;
			return this;
		}

		/**
		 * Set the positive button resource and it's listener
		 * 
		 * @param positiveButtonText
		 * @param listener
		 * @return
		 */
		public Builder setPositiveButton(int positiveButtonText, DialogInterface.OnClickListener listener) {
			this.positiveButtonText = (String) activity.getText(positiveButtonText);
			this.positiveButtonClickListener = listener;
			return this;
		}

		/**
		 * Set the positive button text and it's listener
		 * 
		 * @param positiveButtonText
		 * @param listener
		 * @return
		 */
		public Builder setPositiveButton(String positiveButtonText, DialogInterface.OnClickListener listener) {
			this.positiveButtonText = positiveButtonText;
			this.positiveButtonClickListener = listener;
			return this;
		}

		/**
		 * Set the negative button resource and it's listener
		 * 
		 * @param negativeButtonText
		 * @param listener
		 * @return
		 */
		public Builder setNegativeButton(int negativeButtonText, DialogInterface.OnClickListener listener) {
			this.negativeButtonText = (String) activity.getText(negativeButtonText);
			this.negativeButtonClickListener = listener;
			return this;
		}

		/**
		 * Set the negative button text and it's listener
		 * 
		 * @param negativeButtonText
		 * @param listener
		 * @return
		 */
		public Builder setNegativeButton(String negativeButtonText, DialogInterface.OnClickListener listener) {
			this.negativeButtonText = negativeButtonText;
			this.negativeButtonClickListener = listener;
			return this;
		}

		/**
		 * Create the custom dialog
		 */
		public CustomProgressDialog create() {
			LayoutInflater inflater = activity.getLayoutInflater();
			// instantiate the dialog with the custom Theme
			final CustomProgressDialog dialog = new CustomProgressDialog(activity, R.style.Dialog);
			// View layout1 = inflater.inflate(R.layout.layout_mydialog, null);
			View layout = inflater.inflate(R.layout.layout_customprogress_dialog, null);
			LinearLayout addLayout = ((LinearLayout) layout.findViewById(R.id.add_layout));
			TextView messageText = ((TextView) layout.findViewById(R.id.loading_loadingmsg));
			dialog.addContentView(layout, new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
			Window dialogWindow = dialog.getWindow();
			WindowManager m = activity.getWindowManager();
			Display d = m.getDefaultDisplay(); // 获取屏幕宽、高用
			WindowManager.LayoutParams p = dialogWindow.getAttributes(); //
			// 获取对话框当前的参数值
			// p.height = (int) (d.getHeight() * 0.4); // 高度设置为屏幕的0.6
			p.width = (int) (d.getWidth() * 0.9); // 宽度设置为屏幕的0.65
			dialogWindow.setAttributes(p);

			// set the dialog title
			if (TextUtils.isEmpty(title)) {
				((LinearLayout) layout.findViewById(R.id.dialog_title_layout)).setVisibility(View.GONE);

			} else {
				((LinearLayout) layout.findViewById(R.id.dialog_title_layout)).setVisibility(View.VISIBLE);
				((TextView) layout.findViewById(R.id.title)).setText(title);
			}

			// set the confirm button
			if (positiveButtonText != null) {
				((Button) layout.findViewById(R.id.positiveButton)).setText(positiveButtonText);
				if (positiveButtonClickListener != null) {
					((Button) layout.findViewById(R.id.positiveButton)).setOnClickListener(new View.OnClickListener() {
						public void onClick(View v) {
							positiveButtonClickListener.onClick(dialog, DialogInterface.BUTTON_POSITIVE);
						}
					});
				}
			} else {
				// if no confirm button just set the visibility to GONE
				layout.findViewById(R.id.positiveButton).setVisibility(View.GONE);
			}
			// set the cancel button
			if (negativeButtonText != null) {
				if (negativeButtonClickListener != null) {
					((ImageView) layout.findViewById(R.id.negativeButton)).setOnClickListener(new View.OnClickListener() {
						public void onClick(View v) {
							negativeButtonClickListener.onClick(dialog, DialogInterface.BUTTON_NEGATIVE);
						}
					});
				}
			} else {
				// if no confirm button just set the visibility to GONE
				layout.findViewById(R.id.negativeButton).setVisibility(View.GONE);
			}
			// set the content message
			if (message != null) {
				messageText.setText(message);
				messageText.setVisibility(View.VISIBLE);
				addLayout.setVisibility(View.GONE);
			} else if (contentView != null) {
				// if no message set
				// add the contentView to the dialog body
				messageText.setVisibility(View.GONE);
				addLayout.setVisibility(View.VISIBLE);
				addLayout.removeAllViews();
				addLayout.addView(contentView, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
			}
			dialog.setContentView(layout);
			return dialog;
		}

	}

}