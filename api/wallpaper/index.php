<?php
/**
 * Created by PhpStorm.
 * User: kyson
 * Date: 12/02/2018
 * Time: 9:33 AM
 */


$pathInfo = $_SERVER['PATH_INFO'];
if(isset($pathInfo)){
    //路由映射
    $rules=array(
        '^baby$'=>'user/BabyInfo/getBabyList',//获取baby列表
        '^babyImageDetail$'=>'user/BabyInfo/babyImageDetail',//获取某个baby
        '^addBaby$'=>'user/BabyInfo/babyImageDetailPost',//添加某个baby
        '^appConfig$'=>'user/BabyInfo/appConfig',//config
        '^livePaperList$'=>'user/BabyInfo/livePaperList',//动态壁纸
        '^livePaperDetail$'=>'user/BabyInfo/livePaperDetail',//动态壁纸详情

    );
    require_once "WPRouter.php";
    WPRouter::dispatch($rules);
}else{
    echo "welcome to wallpaper";
}
