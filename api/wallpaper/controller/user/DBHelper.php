<?php
/**
 * Created by PhpStorm.
 * User: kyson
 * Date: 12/02/2018
 * Time: 12:03 AM
 */


namespace controller\user;

header("Content-Type:text/html;charset=utf-8");

class DBHelper
{
    private $connect;

    public function __construct()
    {
//         $this->connect = mysqli_connect('127.0.0.1','root','root','wallpaper','8889');
         $this->connect = mysqli_connect('127.0.0.1','这里是用户名','这里是密码','kysoncn_wallpaper','3306');
        // 检查连接
        if (!$this->connect)
        {
            die("连接错误: " . mysqli_connect_error());
        }
    }

    public function selectAll(){
        $sql = "SELECT * FROM baby_info";
        $result = $this->connect->query($sql);
        return $result;
    }

    public function selectBabyImage($babyId){
        $sql = "SELECT * FROM baby_image WHERE baby_id = ".$babyId;
        $result = $this->connect->query($sql);
        return $result;
    }


    public function inserBabyBrief($brief,$cover)
    {
        $sql = "select * from baby_info order by id desc LIMIT 1";
        $result = $this->connect->query($sql);
        $id = "0";
        $row = mysqli_fetch_array($result);
        if ($row)
        {
            $id = strval($row["id"]);
        }
        $sql2 = "INSERT INTO baby_info (cover_imgurl,brief) VALUES ('{$cover}','{$brief}')";
        $result2 = $this->connect->query($sql2);
        if ($result2) {
            $succuessId = strval(intval($id) + 1);
            return $succuessId;
        }
        return null;
    }

    public function inserBabyWith($detailURL,$detail,$babyId)
    {
        $sql = "INSERT INTO baby_image (baby_imgurl,image_desc,baby_id) VALUES ('{$detailURL}','{$detail}','{$babyId}')";
        $result = $this->connect->query($sql);
        return $result;
    }

//    live photo
    public function selectAllLivePaper(){
        $sql = "SELECT * FROM live_paper";
        $result = $this->connect->query($sql);
        return $result;
    }

    public function paperDetailWith($babyId)
    {
        $sql = "SELECT * FROM livepaper_detail  WHERE baby_id = ".$babyId;
        $result = $this->connect->query($sql);
        return $result;
    }

}

//$obj1 = new DBHelper();
//$obj1->selectAll();
//$obj1->selectBabyImage(2);
//$obj1->inserBabyBrief('909090','http://www.baidu.com');

