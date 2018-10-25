<?php
/**
 * Created by PhpStorm.
 * User: kyson
 * Date: 12/02/2018
 * Time: 9:38 AM
 */

class WPRouter
{

    public static function dispatch($rules=array()){
        header("content-type:text/html;charset=utf-8");

        self::register();
        self::commandLine();
        self::router($rules);
        self::pathInfo();
    }

    //自动加载
    public static function loadClass($class){
        $class=str_replace('\\', '/', $class);
        $dir=str_replace('\\', '/', __DIR__);
        $class=$dir."/".$class.".php";
        if(!file_exists($class)){
            header("HTTP/1.1 404 Not Found");
        }
        require_once $class;
    }

    //命令行模式
    public static function commandLine(){
        if(php_sapi_name()=="cli"){
            $_SERVER['PATH_INFO']="";
            $argv = $_SERVER['argv'] ;
            print_r($argv);
            foreach ($argv as $k=>$v) {
                if($k==0) continue;
                $_SERVER['PATH_INFO'].="/".$v;
            }
        }
    }


    //路由模式
    public static function router($rules){
        $pathInfo = $_SERVER['PATH_INFO'];
        if(isset($pathInfo) && !empty($rules)){
            $pathInfo=ltrim($_SERVER['PATH_INFO'],"/");
            foreach ($rules as $k=>$v) {
                $reg="/".$k."/i";
                if(preg_match($reg,$pathInfo)){
                    $res=preg_replace($reg,$v,$pathInfo);
                    $_SERVER['PATH_INFO']='/'.$res;
                }
            }
        }
    }

    //pathinfo处理
    public static function pathInfo(){
        if(isset($_SERVER['PATH_INFO'])){
            $pathinfo = array_filter(explode("/", $_SERVER['PATH_INFO']));
            for($i=1;$i<=count($pathinfo);$i++){
                $key=isset($pathinfo[$i]) ? $pathinfo[$i] : '';
                $value=isset($pathinfo[$i+1]) ? $pathinfo[$i+1] :"";
                switch ($i) {
                    case 1:
                        $_GET['m']=$key;//目录名
                        break;
                    case 2:
                        $_GET['c']=ucfirst($key);//文件名
                        break;
                    case 3:
                        $_GET['a']=$key;//方法名
                        break;
                    default:
                        if($i>3){
                            if($i%2==0){
                                $_GET[$key]=$value;
                            }
                        }
                        break;
                }
            }
        }
        $_GET['m']=!empty($_GET['m']) ? $_GET['m'] : 'index';
        $_GET['c']=!empty($_GET['c']) ? ucfirst($_GET['c']) : 'index';
        $_GET['a']=!empty($_GET['a']) ? $_GET['a'] : 'index';
        $getM = $_GET['m'];
        $getC = $_GET['c'];
        $getA = $_GET['a'];
        $class="\\controller\\{$getM}\\{$getC}";
        $controller=new $class;
        if(method_exists($controller, $getA)){
//            $controller=new $class;
            $controller->$getA();
        }else{
            header("HTTP/1.1 404 Not Found");
            echo "404";
        }
    }

    //致命错误回调
    public static function shutdownCallback(){
        $e=error_get_last();
        if(!$e) return;
        self::myErrorHandler($e['type'],'<font color="red">Fatal Error</font> '.$e['message'],$e['file'],$e['line']);
    }

    //错误处理
    protected static function myErrorHandler($errno,$errstr,$errfile,$errline){
        list($micseconds,$seconds)=explode(" ",microtime());
        $micseconds=round($micseconds*1000);
        $micseconds=strlen($micseconds)==1 ? '0'.$micseconds : $micseconds;
        if(php_sapi_name()=="cli"){
            $break="\r\n";
        }else{
            $break="<br/>";
        }
        $mes="[".date("Y-m-d H:i:s",$seconds).":{$micseconds}] ".$errfile." ".$errline." line ".$errstr.$break;
        echo $mes;
    }

    //注册
    public static function register(){
        error_reporting(0);
        set_error_handler(function($errno,$errstr,$errfile,$errline){
            self::myErrorHandler($errno,$errstr,$errfile,$errline);
        });
        register_shutdown_function(function(){
            self::shutdownCallback();
        });
        spl_autoload_register("self::loadClass");
    }
}