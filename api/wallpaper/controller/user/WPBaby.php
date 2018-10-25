<?php
/**
 * Created by PhpStorm.
 * User: kyson
 * Date: 12/02/2018
 * Time: 9:48 AM
 */

namespace controller\user;

header("Content-Type:text/html;charset=utf-8");
class WPBaby{

    public  $id;
    public $coverImageUrl;
    public $babyImgUrl;
    public $babyMOVUrl;

    public function getUserById(){
        echo "用户信息id {$_GET['id']} 的信息";
    }
    public function getUserList(){
        echo "用户列表";
    }
    public function getUserArticle(){
        echo "用户id {$_GET['uid']} 的文章列表";
    }
}