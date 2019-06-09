package cn.kyson.wallpaper.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;

import cn.kyson.wallpaper.model.Image;
import cn.kyson.wallpaper.widget.AutoLoadImageViewTwo;

public class WraperDetailViewpagerAdapter extends PagerAdapter implements OnClickListener {

	private ArrayList<Image> mImages;
	private Context mContext;

	public static final int OFFSET_IMAGE_VIEW = 10000;

	private WrapperDetailViewPagerListener mListener;

	public WraperDetailViewpagerAdapter(Context context, ArrayList<Image> images) {
		assert images != null;
		this.mImages = images;
		this.mContext = context;
	}

	@Override
	public boolean isViewFromObject(View arg0, Object arg1) {
		return arg0 == arg1;
	}

	@Override
	public void destroyItem(ViewGroup container, int position, Object object) {
		container.removeView((View) object);
	}

	@Override
	public Object instantiateItem(final ViewGroup container, final int position) {
		final AutoLoadImageViewTwo imageView = new AutoLoadImageViewTwo(mContext);
		imageView.setId(position + OFFSET_IMAGE_VIEW);
		Image image = mImages.get(position);
		imageView.setTag(image);
		imageView.loadImage(image.imgUrl,this);
		imageView.setScaleType(ScaleType.FIT_XY);
		imageView.setOnClickListener(this);
		container.addView(imageView);
		return imageView;
	}

	@Override
	public int getCount() {
		return mImages.size();
	}
	//========================
	/*private int mChildCount = 0;  
	@Override  
    public void notifyDataSetChanged() {           
          mChildCount = getCount();  
          super.notifyDataSetChanged();  
    }  
	@Override  
    public int getItemPosition(Object object)   {            
           if ( mChildCount > 0) {  
           mChildCount --;  
           return POSITION_NONE;  
           }  
           return super.getItemPosition(object);  
     }  */
	//========================

	@Override
	public void onClick(View view) {
		// TODO Auto-generated method stub
		if (null != mListener) {
			ImageView imageView = (ImageView) view;
			int index = imageView.getId() - OFFSET_IMAGE_VIEW;
			mListener.viewpagerItemDidClicked(index);
		} else {
			Log.i("kyson", "please set listener with method:setViewPagerItemClickListener");
		}
	}

	public ArrayList<Image> getArrayListImages() {
		if (mImages.size() > 0) {
			return mImages;
		} else {
			return null;
		}
	}
	
	
	/**
	 * WrapperDetailViewPagerListener
	 * 
	 * @author dell
	 * 
	 */
	public interface WrapperDetailViewPagerListener {
		/**
		 * get download error index
		 * 
		 * @param position
		 */
		public void wrapperDetailViewDownloadError(int position, Image image);

		/**
		 * get item click index
		 * 
		 * @param position
		 */
		public void viewpagerItemDidClicked(int position);

	}

	public void setWrapperDetailViewPagerListener(WrapperDetailViewPagerListener listener) {
		this.mListener = listener;
	}

	public ArrayList<Image> getImageList() {
		return mImages;
	}

}
