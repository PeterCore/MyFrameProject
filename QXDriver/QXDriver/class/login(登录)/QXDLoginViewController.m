//
//  QXDLoginViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/11.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXDLoginViewController.h"
#import "QXTextField.h"
#import "UIImage+Color.h"
#import "NSString+ZCHelper.h"
#import "QXLoginHandle.h"
#import "UIDevice+Hardware.h"
#import "QXForgetPassWordViewController.h"
#import "QXHomeViewController.h"
#import "NSObject+LKDBHelper.h"
#import "MapTestViewController.h"
#import "NavigtionTestViewController.h"
@interface QXDLoginViewController ()<UITextFieldDelegate>{

}

@property(nonatomic,strong)TPKeyboardAvoidingScrollView *avoidingScrollView;
@property(nonatomic,strong)QXTextField *phoneTextField;
@property(nonatomic,strong)QXTextField *passWordTextField;
@property(nonatomic,strong)UIButton    *passWordSecure_button;
@property(nonatomic,strong)UIButton    *forgetPassWord_button;
@property(nonatomic,strong)UIButton    *loginButton;
@property(nonatomic,strong)UILabel     *agreementLabel;
@property(nonatomic,assign)BOOL        phoneInvaild;

@property(nonatomic,assign)NSInteger index;

@end

@implementation QXDLoginViewController

#pragma mark --- 初始化导航栏
-(NSMutableAttributedString*)navigtionTitle{
    return [NSMutableAttributedString attributedWithSubstring:@"登录时间账号" textColor:FEWordColor font:18];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    UIButton *sender = [[UIButton alloc] init];
    sender.tag = 1;
    sender.backgroundColor = [UIColor yellowColor];
    [sender addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender];
    [sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(@100);
        make.height.equalTo(@44);
    }];
    
    UIButton *sender1 = [[UIButton alloc] init];
    sender1.tag = 2;
    sender1.backgroundColor = [UIColor blueColor];
    [sender1 addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender1];
    [sender1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(sender.mas_bottom).offset(12);
        make.height.equalTo(@44);
    }];

    UIButton *sender2 = [[UIButton alloc] init];
    sender2.tag = 3;
    sender2.backgroundColor = [UIColor greenColor];
    [sender2 addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sender2];
    [sender2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(sender1.mas_bottom).offset(12);
        make.height.equalTo(@44);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //[self __layout];
    [self layoutMapView];
}

-(void)senderClick:(UIButton*)sender{
    if (sender.tag == 1) {
        [[QXTrackCorrectManager shareManager] removeALLTraceLocations];
    }
    else if(sender.tag == 2){
        [self.navigationController pushViewController:[[MapTestViewController alloc] init] animated:YES];
    }
    else if (sender.tag == 3){
        [self.navigationController pushViewController:[[NavigtionTestViewController alloc] init] animated:YES];

    }
    
}


-(void)layoutMapView{
    

       //[mapView addAnnotationsWithOriginCoordinateAnddestCoordinate:orgin dest:dest];
    

    
//    QXLocationInfo *info = [[QXCLLocationManager shareManager] fetchCurrentLocation];
//    if (!info) {
//        NSLog(@"2121212");
//    }
    
  
    
    
   // NSMutableArray *traceLocations = [QXTraceLocation searchWithWhere:nil];
    
    //NSLog(@"12121");
//    NSArray *copys = [[NSUserDefaults standardUserDefaults] objectForKey:@"traceLocations"];
//    NSLog(@"%@",copys);
   
}


-(void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanage:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
}

#pragma mark --- init layout

-(void)__layout{
    if (!self.avoidingScrollView) {
        self.avoidingScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, IPHONE_W, IPHONE_H-64)];
        self.avoidingScrollView.scrollEnabled = YES;
        self.avoidingScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.avoidingScrollView];
    }
    
    [self.avoidingScrollView addSubview:self.phoneTextField];
    [self.avoidingScrollView addSubview:self.passWordTextField];
    [self.avoidingScrollView addSubview:self.forgetPassWord_button];
    [self.avoidingScrollView addSubview:self.loginButton];
    [self.avoidingScrollView addSubview:self.agreementLabel];

}



#pragma mark ---- agreement
-(void)agreementGesture:(UITapGestureRecognizer*)ges{
    
    
}

#pragma mark --- forgetPassWord
-(void)forgetPassWord:(UIButton*)sender{
    
    QXForgetPassWordViewController *forgetVc = [[QXForgetPassWordViewController alloc] init];
    [self.navigationController pushViewController:forgetVc animated:YES];
}

#pragma mark -- login
-(void)login:(UIButton*)sender{
    NSString *phone = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    NSString *password = self.passWordTextField.text;

    //[SVProgressHUD showLoadingView:@"登录中.."];
    
    [QXLoginHandle loginWithPhone:phone passWord:password priority:NetWorkManagerPriorityVeryLow progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            //[SVProgressHUD dismiss];
            QXLoginResponse *loginResponse = [QXLoginResponse mj_objectWithKeyValues:responseObject];
            if (loginResponse.success == 1) {
                
                QXHomeViewController *homeVc = [[QXHomeViewController alloc] init];
                [self.navigationController pushViewController:homeVc animated:YES];
                QXUserDefaults.uid = loginResponse.data.uuid;
                QXUserDefaults.token = loginResponse.data.token;
                
            }
            else{
                //[SVProgressHUD showErrorView:<#(NSString *)#>]
            }
        });
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



-(void)display:(UIButton*)sender{
   BOOL secureTextEntry =  self.passWordTextField.secureTextEntry = !self.passWordTextField.secureTextEntry;
    [sender setImage:secureTextEntry?FEImage(@"public_icon_bukejian"):FEImage(@"public_icon_kejian") forState:UIControlStateNormal];
    [sender setImage:secureTextEntry?FEImage(@"public_icon_bukejian"):FEImage(@"public_icon_kejian") forState:UIControlStateHighlighted];
    
}

-(void)textFieldChanage:(NSNotification*)notif{
    QXTextField *textField = notif.object;
    if (textField == self.phoneTextField) {
         self.phoneInvaild = [self __invaild86Phone:textField];
         NSLog(@"--- invaild is %d",self.phoneInvaild);
    }
    else if (textField == self.passWordTextField){
        if (self.passWordTextField.text.length>5&&self.phoneInvaild){
            self.loginButton.enabled = YES;
        }
        else{
            self.loginButton.enabled = NO;
        }
    }
   
}



-(BOOL)__invaild86Phone:(UITextField*)textField{
    BOOL invaild = NO;
    if (textField.text.length > self.index) {
        if (textField.text.length == 4 || textField.text.length == 9 ) {//输入
            NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
            [str insertString:@" " atIndex:(textField.text.length-1)];
            textField.text = str;
        }if (textField.text.length >= 13 ) {//输入完成
            textField.text = [textField.text substringToIndex:13];
            NSString *phone = [textField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
            if (phone.length >=11) {
                if([phone invailadatePhoneNumber]){
                    invaild = YES;
                    [self.passWordTextField becomeFirstResponder];
                }
                else{
                    [SVProgressHUD showErrorView:@"手机不合法"];
                }
            }
            
        }
        self.index = textField.text.length;
        
    }else if (textField.text.length < self.index){//删除
        invaild = NO;
        if (textField.text.length == 4 || textField.text.length == 9) {
            textField.text = [NSString stringWithFormat:@"%@",textField.text];
            textField.text = [textField.text substringToIndex:(textField.text.length-1)];
        }
        self.index = textField.text.length;
    }
    return invaild;
    
}


/*
 * lazy init layout
 *
 */
-(QXTextField*)phoneTextField{
    if (!_phoneTextField) {
        UIImage *image = FEImage(@"public_icon_phone");
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 16)];
        leftImageView.image = image;
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _phoneTextField = [[QXTextField alloc] initWithFrame:CGRectMake(40, 120, IPHONE_W-80, 32)];
        _phoneTextField.leftView = leftImageView;
        _phoneTextField.textColor = FEWordColor;
        _phoneTextField.textAlignment = NSTextAlignmentLeft;
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.placeholder = @"输入手机号码";
        _phoneTextField.font = FEFont(15);
        _phoneTextField.tintColor = FEWordColor;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _phoneTextField;
}

-(QXTextField*)passWordTextField{
    if (!_passWordTextField) {
        UIButton *passWordSecure_button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 18.5, 16)];
        [passWordSecure_button addTarget:self action:@selector(display:) forControlEvents:UIControlEventTouchUpInside];
        [passWordSecure_button setImage:FEImage(@"public_icon_bukejian") forState:UIControlStateNormal];
        [passWordSecure_button setImage:FEImage(@"public_icon_bukejian") forState:UIControlStateHighlighted];
        self.passWordSecure_button = passWordSecure_button;
        
        UIImage *image = FEImage(@"public_icon_mima");
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 16)];
        leftImageView.image = image;
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;

        _passWordTextField = [[QXTextField alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.phoneTextField.frame)+20, IPHONE_W-80, 32)];
        _passWordTextField.placeholder = @"密码";
        _passWordTextField.textColor = FEWordColor;
        _passWordTextField.textAlignment = NSTextAlignmentLeft;
        _passWordTextField.backgroundColor = [UIColor whiteColor];
        _passWordTextField.font = FEFont(15);
        _passWordTextField.secureTextEntry = YES;
        _passWordTextField.rightView = passWordSecure_button;
        _passWordTextField.rightViewMode = UITextFieldViewModeAlways;
        _passWordTextField.leftView = leftImageView;
        _passWordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passWordTextField.delegate = self;
        _passWordTextField.tintColor = FEWordColor;
    }
    return _passWordTextField;
}

-(UIButton*)forgetPassWord_button{
    if (!_forgetPassWord_button) {
        _forgetPassWord_button = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.passWordTextField.frame)+10, 80, 44)];

        _forgetPassWord_button.enabled = YES;
        [_forgetPassWord_button setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPassWord_button setTitle:@"忘记密码" forState:UIControlStateDisabled];
        [_forgetPassWord_button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_forgetPassWord_button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateHighlighted];
        [_forgetPassWord_button addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPassWord_button;
}


-(UIButton*)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.forgetPassWord_button.frame)+10, IPHONE_W-80, 44)];
        _loginButton.layer.cornerRadius = 4.0f;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setBackgroundImage:[UIImage imageWithColor:FEWordColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageWithColor:FERGBColor(154,181,221)] forState:UIControlStateDisabled];
        _loginButton.enabled = NO;
        _loginButton.titleLabel.font = FEFont(15);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateDisabled];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
}


-(UILabel*)agreementLabel{
    if (!_agreementLabel) {

        NSString *clickTitle = @"点击登录表示您同意";
        NSString *agreement = kAppName;
        NSString *agreementContent = [NSString stringWithFormat:@"%@%@",clickTitle,agreement];
        NSMutableAttributedString *agressAttri =  [[NSMutableAttributedString alloc] initWithString:agreementContent];
        [agressAttri addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, clickTitle.length)];
        [agressAttri addAttribute:NSFontAttributeName value:FEFont(12) range:NSMakeRange(0, clickTitle.length)];
        [agressAttri addAttribute:NSForegroundColorAttributeName value:FERGBColor(34, 206, 219) range:NSMakeRange(clickTitle.length, agreement.length)];
        [agressAttri addAttribute:NSFontAttributeName value:FEFont(12) range:NSMakeRange(clickTitle.length, agreement.length)];
        
        _agreementLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.loginButton.frame)+10, IPHONE_W-80, 15)];
        _agreementLabel.font = FEFont(12);
        _agreementLabel.textAlignment = NSTextAlignmentCenter;
        _agreementLabel.attributedText = agressAttri;
        _agreementLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreementGesture:)];
        [_agreementLabel addGestureRecognizer:selectTap];
        
    }
    return _agreementLabel;
}










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
