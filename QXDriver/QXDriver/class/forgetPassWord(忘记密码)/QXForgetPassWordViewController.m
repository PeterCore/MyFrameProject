//
//  QXForgetPassWordViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/14.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXForgetPassWordViewController.h"
#import "QXTextField.h"
#import "UIImage+Color.h"
#import "NSString+ZCHelper.h"
#import "QXVerifyUserHandle.h"
#import "QXVaildCodeViewController.h"
@interface QXForgetPassWordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)TPKeyboardAvoidingScrollView *avoidingScrollView;
@property(nonatomic,strong)QXTextField *phoneTextField;
@property(nonatomic,strong)QXTextField *identityCardTextField;
@property(nonatomic,strong)UIButton    *nextButton;
@property(nonatomic,assign)BOOL        phoneInvaild;


@property(nonatomic,assign)NSInteger index;
@end

@implementation QXForgetPassWordViewController


#pragma mark --- 初始化导航栏

-(NSMutableAttributedString*)navigtionTitle{
    return [NSMutableAttributedString attributedWithSubstring:@"忘记密码" textColor:FEWordColor font:18];
}


-(NSMutableArray<UIButton*>*)navigationBar_leftButtonItems
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 34, 34)];
    [left_button setImage:FEImage(@"nav_icon_back_gray") forState:UIControlStateNormal];
    [left_button setImage:FEImage(@"nav_icon_back_gray") forState:UIControlStateHighlighted];
    return [@[left_button] mutableCopy];
}


-(void)navigationleftClick:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- layout

-(void)__layoutView{
    if (!self.avoidingScrollView) {
        self.avoidingScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 64, IPHONE_W, IPHONE_H-64)];
        self.avoidingScrollView.scrollEnabled = YES;
        self.avoidingScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.avoidingScrollView];
    }
    
    [self.avoidingScrollView addSubview:self.phoneTextField];
    [self.avoidingScrollView addSubview:self.identityCardTextField];
    [self.avoidingScrollView addSubview:self.nextButton];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanage:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __layoutView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldChanage:(NSNotification*)notif{
    if (self.phoneTextField == notif.object) {
        self.phoneInvaild = [self __invaild86Phone:notif.object];
    }
    if (self.phoneTextField.text.length&&self.identityCardTextField.text.length&&self.phoneInvaild) {
        self.nextButton.enabled= YES;
    }
}

-(BOOL)__invaild86Phone:(UITextField*)textField{
    BOOL phoneInvaild = NO;
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
                    phoneInvaild = YES;
                    [self.identityCardTextField becomeFirstResponder];
                }
                else{
                    [SVProgressHUD showErrorView:@"手机不合法"];
                }
            }
            
        }
        self.index = textField.text.length;
        
    }else if (textField.text.length < self.index){//删除
        phoneInvaild = NO;
        if (textField.text.length == 4 || textField.text.length == 9) {
            textField.text = [NSString stringWithFormat:@"%@",textField.text];
            textField.text = [textField.text substringToIndex:(textField.text.length-1)];
        }
        self.index = textField.text.length;
    }
    return phoneInvaild;
    
}

/*
 * author zhangchun 2017-09-14
 *
 */
-(void)nextStep:(UIButton*)sender{
    
    QXVaildCodeViewController *vaildCodeVc = [[QXVaildCodeViewController alloc]init];
    vaildCodeVc.phone = self.phoneTextField.text;
    vaildCodeVc.idCard =self.identityCardTextField.text;
    [self.navigationController pushViewController:vaildCodeVc animated:YES];
    
    
   /* [SVProgressHUD show];
    NSString *phone = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    [QXVerifyUserHandle verifyWithidCard:self.identityCardTextField.text phone:phone priority:NetWorkManagerPriorityMedum progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            QXBaseResponse *baseResponse = [QXBaseResponse mj_objectWithKeyValues:responseObject];
            if (baseResponse.success == 1) {
                [SVProgressHUD dismiss];
            }
            else{
                [SVProgressHUD showErrorView:baseResponse.msg];
            }
        });
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];*/
}


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


-(QXTextField*)identityCardTextField{
    if (!_identityCardTextField) {
        UIImage *image = FEImage(@"public_icon_shenfenzheng");
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 16)];
        leftImageView.image = image;
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _identityCardTextField = [[QXTextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.phoneTextField.frame)+20, IPHONE_W-80, 32)];
        _identityCardTextField.leftView = leftImageView;
        _identityCardTextField.textColor = FEWordColor;
        _identityCardTextField.textAlignment = NSTextAlignmentLeft;
        _identityCardTextField.backgroundColor = [UIColor whiteColor];
        _identityCardTextField.leftViewMode = UITextFieldViewModeAlways;
        _identityCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _identityCardTextField.placeholder = @"输入身份证";
        _identityCardTextField.font = FEFont(15);
        _identityCardTextField.tintColor = FEWordColor;
        _identityCardTextField.delegate = self;
        _identityCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _identityCardTextField;
}

-(UIButton*)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.identityCardTextField.frame)+40, IPHONE_W-80, 44)];
        _nextButton.layer.cornerRadius = 4.0f;
        _nextButton.layer.masksToBounds = NO;
        [_nextButton setBackgroundImage:[UIImage imageWithColor:FEWordColor] forState:UIControlStateNormal];
        [_nextButton setBackgroundImage:[UIImage imageWithColor:FERGBColor(154,181,221)] forState:UIControlStateDisabled];
        _nextButton.enabled = NO;
        _nextButton.titleLabel.font = FEFont(15);
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateDisabled];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_nextButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _nextButton;
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
