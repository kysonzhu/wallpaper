//
//  AboutUsViewController.m
//  WallWrapper ( https://github.com/kysonzhu/wallpaper.git )
//
//  Created by zhujinhui on 14-12-24.
//  Copyright (c) 2014年 zhujinhui( http://kyson.cn ). All rights reserved.
//

#import "AboutUsViewController.h"
#import "WPAboutUsTableViewHeaderView.h"
#define TAG_BTN_NAV_LEFT 1090
#import "WPWebViewController.h"
#import <StoreKit/StoreKit.h>
#import <UIAlertView+BlocksKit.h>

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    UIButton *leftNavigationBarButton;
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray    *titles;
@property (nonatomic, strong)WPAboutUsTableViewHeaderView *headerView;
@property (nonatomic, copy) NSString *selectProductID;
@end

@implementation AboutUsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleNavigationWithScrollView:self.tableView];
	// Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([WPAboutUsTableViewHeaderView headerHeight]);
        make.width.equalTo(self.headerView.superview);
    }];
//    self.tableView mas_mak
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 44.f;
    
    /**
     *  navigation bar left bar button
     */
    UIBarButtonItem *btnItem1 = [[UIBarButtonItem alloc]init];
    leftNavigationBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image1 = [UIImage imageNamed:@"icon_navi_back"];
    [leftNavigationBarButton setBackgroundImage:image1 forState:UIControlStateNormal];
    [leftNavigationBarButton setFrame:CGRectMake(0, 0, 20, 21)];
    [leftNavigationBarButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftNavigationBarButton.tag = TAG_BTN_NAV_LEFT;
    [btnItem1 setCustomView:leftNavigationBarButton];
    self.navigationItem.leftBarButtonItem = btnItem1;
    // 添加观察者
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}



-(void)buttonClicked:(UIButton *)button{
    switch (button.tag) {
        case TAG_BTN_NAV_LEFT:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapped:(UITapGestureRecognizer *)gesture{
    static int count = 0;
    if (count == 10) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"表白" message:@"Yanyufei我爱你!" delegate:nil cancelButtonTitle:@"接受" otherButtonTitles:@"接受", nil];
        [alert show];
        count = 0;
    }
    ++count;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return @"基本信息";
        }
            break;
        case 1:{
            return @"鸣谢";
        }
            
        default:
            break;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 3;
        }
            break;
        case 1:{
            return self.titles.count;
        }
            
        default:
            break;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nil"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nil"];
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    cell.textLabel.text = [NSString stringWithFormat:@"版本号:    %@",version];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"评价我们"];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"去广告"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = self.titles[indexPath.row];
        }
            break;
        default:
            break;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
            
        case 0:{
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                {
                    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id1334013423"];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
                }
                    break;
                case 2:
                {
                    if([SKPaymentQueue canMakePayments]){
                        // productID就是你在创建购买项目时所填写的产品ID
                        self.selectProductID = [NSString stringWithFormat:@"%@",@"cn.kyson.wallpaper.201801"];
                        [self requestProductID:self.selectProductID];
                    }else{
                        // NSLog(@"不允许程序内付费");
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先开启应用内付费购买功能。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertError show];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            WPWebViewController *webViewController = [[WPWebViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
            webViewController.title = self.titles[indexPath.row];
            switch (indexPath.row)
            {
                case 0:
                {
                    webViewController.loadingURL = @"https://www.jianshu.com/u/98c026b409f2";
                }
                    break;
                case 1:
                {
                    webViewController.loadingURL = @"http://www.baidu.com";

                }
                    break;
                case 2:
                {
                    webViewController.loadingURL = @"https://github.com/yaohuaiguangDear";

                }
                    break;
                case 3:
                {
                    webViewController.loadingURL = @"http://www.kyson.cn";

                }
                    break;
                    
                default:
                    break;
            }
            [self showDetailViewController:nav sender:nil];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 1.请求所有的商品ID
-(void)requestProductID:(NSString *)productID{
    // 1.拿到所有可卖商品的ID数组
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:productID, nil];
    NSSet *sets = [[NSSet alloc]initWithArray:productIDArray];
    
    // 2.向苹果发送请求，请求所有可买的商品
    // 2.1.创建请求对象
    SKProductsRequest *sKProductsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:sets];
    // 2.2.设置代理(在代理方法里面获取所有的可卖的商品)
    sKProductsRequest.delegate = self;
    // 2.3.开始请求
    [sKProductsRequest start];
}


#pragma mark 2.苹果那边的内购监听
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] == 0){
        return;
    }
    for (SKProduct *sKProduct in product)
    {
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:safeString(sKProduct.localizedDescription) cancelButtonTitle:@"不了" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self buyProduct:sKProduct];
            }
        }];
        
        if([sKProduct.productIdentifier isEqualToString:self.selectProductID])
        {
            
        }else{
        }
    }
}

#pragma mark 内购的代码调用
-(void)buyProduct:(SKProduct *)product{
    // 1.创建票据
    SKPayment *skpayment = [SKPayment paymentWithProduct:product];
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:{
                NSLog(@"正在购买");
            }break;
            case SKPaymentTransactionStatePurchased:{
                NSLog(@"购买成功");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasBuySuccess];
                [KVNProgress showSuccess];
                // 购买后告诉交易队列，把这个成功的交易移除掉
                [queue finishTransaction:transaction];
                [self buyAppleStoreProductSucceedWithPaymentTransactionp:transaction];
            }break;
            case SKPaymentTransactionStateFailed:{
                NSLog(@"购买失败");
                [KVNProgress showErrorWithStatus:@"购买失败"];
                // 购买失败也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"回复购买中,也叫做已经购买");
                // 回复购买中也要把这个交易移除掉
                [queue finishTransaction:transaction];
            }break;
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"交易还在队列里面，但最终状态还没有决定");
            }break;
            default:
                break;
        }
    }
}

// 苹果内购支付成功
- (void)buyAppleStoreProductSucceedWithPaymentTransactionp:(SKPaymentTransaction *)paymentTransactionp {
    NSString *transactionReceiptString= nil;
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    NSString *version = [UIDevice currentDevice].systemVersion;
    if([version intValue] >= 7.0)
    {
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        NSURLRequest * appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle]appStoreReceiptURL]];
        NSError *error = nil;
        NSData * receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest returningResponse:nil error:&error];
        transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    // 去验证是否真正的支付成功了
    [self checkAppStorePayResultWithBase64String:transactionReceiptString];
}

- (void)checkAppStorePayResultWithBase64String:(NSString *)base64String {
    
    /* 生成订单参数，注意沙盒测试账号与线上正式苹果账号的验证途径不一样，要给后台标明 */
    /*
     注意：
     自己测试的时候使用的是沙盒购买(测试环境)
     App Store审核的时候也使用的是沙盒购买(测试环境)
     上线以后就不是用的沙盒购买了(正式环境)
     所以此时应该先验证正式环境，在验证测试环境
     
     正式环境验证成功，说明是线上用户在使用
     正式环境验证不成功返回21007，说明是自己测试或者审核人员在测试
     */
    /*
     苹果AppStore线上的购买凭证地址是： https://buy.itunes.apple.com/verifyReceipt
     测试地址是：https://sandbox.itunes.apple.com/verifyReceipt
     */
    //    NSNumber *sandbox;
    NSString *sandbox;
#if (defined(APPSTORE_ASK_TO_BUY_IN_SANDBOX) && defined(DEBUG))
    //sandbox = @(0);
    sandbox = @"0";
#else
    //sandbox = @(1);
    sandbox = @"1";
#endif
    
    NSMutableDictionary *prgam = [[NSMutableDictionary alloc] init];;
    [prgam setValue:sandbox forKey:@"sandbox"];
    [prgam setValue:base64String forKey:@"reciept"];
    
    /*
     请求后台接口，服务器处验证是否支付成功，依据返回结果做相应逻辑处理
     0 代表沙盒  1代表 正式的内购
     最后最验证后的
     */
    /*
     内购验证凭据返回结果状态码说明
     21000 App Store无法读取你提供的JSON数据
     21002 收据数据不符合格式
     21003 收据无法被验证
     21004 你提供的共享密钥和账户的共享密钥不一致
     21005 收据服务器当前不可用
     21006 收据是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
     21007 收据信息是测试用（sandbox），但却被发送到产品环境中验证
     21008 收据信息是产品环境中使用，但却被发送到测试环境中验证
     */
    
    NSLog(@"字典==%@",prgam);
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
    }
    return _tableView;
}

-(NSArray *)titles{
    if (!_titles) {
        _titles = @[@"小菲菲",@"闫策",@"姚怀广",@"朱金辉"];
    }
    return _titles;
}


-(WPAboutUsTableViewHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [WPAboutUsTableViewHeaderView loadFromXib];
    }
    return _headerView;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
