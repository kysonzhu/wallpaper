package cn.kyson.wallpaper.service;

public class Constant {
	//΢��APPID
	public static final String appkey="799998892";
	//��Ȩ�ص�Ҳ
	public static final String redirect_url="http://open.weibo.com/apps/799998892/privilege/oauth";
	
	public static final String auth_url="https://api.weibo.com/oauth2/access_token";
	 public static final String user_show="https://api.weibo.com/2/users/show.json";
	public static final String appsecret="99d78db473cbcad79eda6088c9880cf8";
	
	//��������б����Ϣ
	//public static final String click_feilei_url = "http://sj.zol.com.cn/corp/bizhiClient/getGroupInfo.php?isAttion";
	//��ȡ��ֽ������Ϣ
	public static final String fenlei_url="http://sj.zol.com.cn/corp/bizhiClient/getCateInfo.php";
	//����������URL
	public static final String erji_fenlei_to_url="http://sj.zol.com.cn/corp/bizhiClient/getGroupInfo.php";
    //Ĭ���Ƽ��б���Ϣ
	public static final String tuijian_url="http://sj.zol.com.cn/corp/bizhiClient/getGroupInfo.php?isAttion=1";
	//Ĭ�������б���Ϣ ��ʱ������
	public static final String zuixin_url="http://sj.zol.com.cn/corp/bizhiClient/getGroupInfo.php?isNow=1";
	//Ĭ�������б���Ϣ
	public static final String zuire_url="http://sj.zol.com.cn/corp/bizhiClient/getGroupInfo.php?isDown=1";
	//����б�󵥸�ͼƬ��Ϣ��ϢpicSize
	public static final String show_bizi_url="http://sj.zol.com.cn/corp/bizhiClient/getGroupPic.php"; 
	//������ֽ��Ϣ
	public static final String sousuo_bizi_url="http://sj.zol.com.cn/corp/bizhiClient/getSearchInfo.php";
}
// http://sj.zol.com.cn/corp/bizhiClient/getSearchInfo.php?wd=��Ů
//cateId   ->  ����ID  ���ظô���ID�µ���ͼ��Ϣ
//subId    ->  ����ID  ���ظ�����ID�µ���ͼ��Ϣ
//picSize  ->  ҳ����ʾ�ߴ�  ���ظóߴ��ͼƬurl ��Ĭ�ϣ�208x312
//imgSize  ->  ɸѡ�ߴ�  ���ط�ϸóߴ����ͼ��Ϣ��Ĭ�ϣ�208x312
//start	   ->  �Ӷ�������ʼ ��ҳʹ�� Ĭ�� 0
//end	       ->  ȡ������  Ĭ��10
//isNow   ->  ��ʱ������
//isAttion->  ��֧��������
//isDown  ->  ������������