/*
 *
 *  Created by 朱金�?on 14-01-08.
 *  Copyright (c) 2013�?SAIC. All rights reserved.
 */
package cn.kyson.wallpaper.utils.imagedownloader;

import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


import android.text.TextUtils;

/**
 * md5加密,
 *
 */
public class MD5Encoder {
	//�����ַ�
		public static String encoding(String fileName) {
			if (TextUtils.isEmpty(fileName)) {
				System.out.println("�ַ�Ϊ�գ�����ʧ��");
				return null;
			}
			String resultString = MD5Encoder.getMD5Str(fileName);
			return resultString;
		}
		//����url
		public static String encoding(URL fileUrl) {
			String urlString = fileUrl.toString();
			return MD5Encoder.encoding(urlString);
		}
		
		/**
		 * ȡ��md5��32λ�ַ�ȡ�õ��ַ��ΪСд��
		 * @param str Ҫ�����ܵ��ַ�
		 * @return
		 */
		private static String getMD5Str(String str) {    
	        MessageDigest messageDigest = null;    
	    
	        try {    
	            messageDigest = MessageDigest.getInstance("MD5");    
	    
	            messageDigest.reset();    
	    
	            messageDigest.update(str.getBytes("UTF-8"));    
	        } catch (NoSuchAlgorithmException e) {    
	            System.out.println("NoSuchAlgorithmException caught!");    
	            System.exit(-1);    
	        } catch (UnsupportedEncodingException e) {    
	            e.printStackTrace();    
	        }    
	    
	        byte[] byteArray = messageDigest.digest();    
	    
	        StringBuffer md5StrBuff = new StringBuffer();    
	    
	        for (int i = 0; i < byteArray.length; i++) {                
	            if (Integer.toHexString(0xFF & byteArray[i]).length() == 1)    
	                md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));    
	            else    
	                md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));    
	        }    
	    
	        return md5StrBuff.toString();    
	    }   
}
