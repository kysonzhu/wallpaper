<?php
/**
 * Created by PhpStorm.
 * User: kyson
 * Date: 11/02/2018
 * Time: 11:52 PM
 */


namespace controller\user;

include('DBHelper.php');

header("Content-Type:text/html;charset=utf-8");

class BabyInfo
{
    public function __construct()
    {
        header("Content-type:text/html;charset=utf-8");//字符编码设置
    }

    /*
     * 获取baby列表
     * */
    public function getBabyList(){

        // 初始化一个 cURL 对象
        $curl = curl_init();
        // 设置你需要抓取的URL
        $ramdomPage = rand(1,610);
        $originURL = 'http://api.kongyouran.com/znfllist/?page='.$ramdomPage.'&ver=1';
        curl_setopt($curl, CURLOPT_URL, $originURL);
        // 设置header 响应头是否输出
        // 设置cURL 参数，要求结果保存到字符串中还是输出到屏幕上。
        // 1如果成功只将结果返回，不自动输出任何内容。如果失败返回FALSE
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        // 运行cURL，请求网页
        $data2 = curl_exec($curl);
        // 关闭URL请求
        curl_close($curl);
        // 显示获得的数据
//        echo $data2;
        /*
         * 添加第一个数组
         * */
        $data = array();
        $arr2 = json_decode($data2,true);
        $array = $arr2["list"];
        //第三种遍历方式,可同时用于索引数组和关联数组，只取出value。（会改变数组当前指针）
        foreach ($array as $value) {
            $user = new WPBaby();
            $user->id = $value['JieID'];
            $user->coverImageUrl = $value['HeadPic'];
            //array_push($data,$user);
        }
        array_shift($data);
        /*
                 * 添加第二个数组
                 * */
        $dbHelper = new DBHelper();
        $result = $dbHelper->selectAll();
        $data4 = array();
        while ($row = mysqli_fetch_array($result))
        {
            $user = new WPBaby();
            $user->id = $row["id"];
            $user->coverImageUrl = $row["cover_imgurl"];
            array_push($data4,$user);
        }
        $data4 = array_reverse($data4);//逆序

        $data = array_merge($data,$data4);

        $json = json_encode($data);//把数据转换为JSON数据.
        header('Content-type:text/json');
        echo "{".'"status"'.":".'"ok"'.','.'"content"'.":".$json."}";
    }

    /*
     * 获取baby图片列表*/
    public function babyImageDetail(){
        //异常情况判断
        $postId = $_POST['id'];
        if (!isset($postId))
        {
            echo "{".'"status"'.":".'"failed"'.','.'"errorMsg"'.":"."参数不正确"."}";
            return;
        }

        // 初始化一个 cURL 对象
        $curl = curl_init();
        $originURL = 'http://api.kongyouran.com/znflcontent/?id='.$postId;
        // 设置你需要抓取的URL
        curl_setopt($curl, CURLOPT_URL, $originURL);
        // 设置header 响应头是否输出
        // 设置cURL 参数，要求结果保存到字符串中还是输出到屏幕上。
        // 1如果成功只将结果返回，不自动输出任何内容。如果失败返回FALSE
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        // 运行cURL，请求网页
        $data2 = curl_exec($curl);
        // 关闭URL请求
        curl_close($curl);
        $arr2 = json_decode($data2,true);
        $array = $arr2["ListContent"];

        $data = array();
        //第三种遍历方式,可同时用于索引数组和关联数组，只取出value。（会改变数组当前指针）
        foreach ($array as $value) {
            $user = new WPBaby();
            $user->babyImgUrl = $value;
            //array_push($data,$user);
        }

        $dbHelper = new DBHelper();
        $result = $dbHelper->selectBabyImage($postId);
        while ($row = mysqli_fetch_array($result))
        {
            $user = new WPBaby();
            $user->babyImgUrl = $row["baby_imgurl"];
            array_push($data,$user);
        }
        $json = json_encode($data);//把数据转换为JSON数据.
        header('Content-type:text/json');
        echo "{".'"status"'.":".'"ok"'.','.'"content"'.":".$json."}";
    }

    /*
     * 获取baby图片列表*/
    public function babyImageDetailPost()
    {
        //异常情况判断
        $postTitle = $_POST['title'];
        $postCover = $_POST['cover'];
        $dbHelper = new DBHelper();
        $babyBriefResult = null;
        if (!isset($postTitle) || !isset($postCover))
        {
            echo "{".'"status"'.":".'"failed"'.','.'"errorMsg"'.":"."参数不正确"."}";
            return;
        } else {
            $babyBriefResult = $dbHelper->inserBabyBrief($postTitle,$postCover);
        }
        if (!$babyBriefResult){
            echo "{".'"status"'.":".'"failed"'.','.'"errorMsg"'.":"."参数不正确"."}";
            return;
        }

        for ($x=1; $x< 10; $x++)
        {
            $urlIndex = 'url'.strval($x); //获取url1,url2。。。等变量名
            $realURL = $_POST[$urlIndex];
            $success = 0;
            if (isset($realURL) && $this->file_exists($realURL))
            {
                $detailIndex = 'detail'.strval($x);
                $realDetail = $_POST[$detailIndex];
                $result = $dbHelper->inserBabyWith($realURL,$realDetail,$babyBriefResult);
                if ($result){
                    $success = 1;
                }else{
                    $success = 0;
                    break;
                }
            }

            if ($success == 0){
                echo "{".'"status"'.":".'"failed"'.','.'"errorMsg"'.":"."数据插入失败"."}";
            }else{
                echo "{".'"status"'.":".'"ok"'.','.'"content"'.":''}";
            }

        }

    }

    public function appConfig()
    {
        $data = array(
            "showallbaby" => "1",
        );
        $json = json_encode($data);//把数据转换为JSON数据.
        echo "{".'"status"'.":".'"ok"'.','.'"content"'.":".$json."}";
    }

    public function livePaperList()
    {
        $dbHelper = new DBHelper();
        $result = $dbHelper->selectAllLivePaper();
        $data = array();
        while ($row = mysqli_fetch_array($result))
        {
            $user = new WPBaby();
            $user->id = $row["id"];
            $user->coverImageUrl = $row["cover_imgurl"];
            $user->babyMOVUrl = $row["detail_url"];
            array_push($data,$user);
        }
        $data = array_reverse($data);//逆序
        $json = json_encode($data);//把数据转换为JSON数据.
        header('Content-type:text/json');
        echo "{".'"status"'.":".'"ok"'.','.'"content"'.":".$json."}";
    }

    private function file_exists($url)
    {
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_NOBODY, true);
        $result = curl_exec($curl);
        $found = false;
        if ($result !== false) {
            return true;
        }
        return false;
    }
}

