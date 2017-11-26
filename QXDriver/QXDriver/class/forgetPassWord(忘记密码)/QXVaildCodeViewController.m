//
//  QXVaildCodeViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXVaildCodeViewController.h"
#import "VCTextField.h"
#import "QXVerifyUserHandle.h"
@interface QXVaildCodeViewController ()<VCTextFieldDelegate>
{
    NSMutableArray *_vaildCodes;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIView *vaildCodeTextFieldBoard;
@property(nonatomic,assign)NSInteger countDownNumber;
@property(nonatomic,strong)NSTimer *timer;

@end

static NSInteger countNumber = 10;

@implementation QXVaildCodeViewController

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

#pragma mark ---- fetchVailCode
-(void)__sendVaildCode{
    NSString *phone = [self.phone stringByReplacingOccurrencesOfString:@" "withString:@""];
    [QXVerifyUserHandle sendVaildCodeWithidPhone:[QXDataManager getEncodeAESStringWithContent:phone] priority:NetWorkManagerPriorityMedum progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];

}

-(void)__verifyAccountWithPhone:(NSString*)phone vaildCode:(NSString*)vaildCode{
    
    phone = [phone stringByReplacingOccurrencesOfString:@" "withString:@""];
    [QXVerifyUserHandle verifyAccountWithVaildCode:vaildCode phone:phone priority:NetWorkManagerPriorityLow progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            QXBaseResponse *response = [QXBaseResponse mj_objectWithKeyValues:responseObject];
            if (response.success == 1) {
                [SVProgressHUD dismiss];
            }
            else{
                [SVProgressHUD showErrorView:response.msg];
            }
            
            
        });
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
    
}


-(void)__layoutView{
    
    [self.view addSubview:self.titleLabel];
    [self __layoutVaildCodeTextField];
    [self.view layoutIfNeeded];
    [self.view addSubview:self.timeLabel];
}

-(void)__layoutVaildCodeTextField{
    
    self.vaildCodeTextFieldBoard = [[UIView alloc] init];
    [self.view addSubview:self.vaildCodeTextFieldBoard];
    [self.vaildCodeTextFieldBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@164);
        make.width.equalTo(@270);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    for (int tag  =  1; tag < 5; tag++) {
        VCTextField *textFieldVaildCode = [[VCTextField alloc]initWithFrame:CGRectMake(60*(tag-1)+10*(tag-1), 0, 60, 60)];
        textFieldVaildCode.tag = tag;
        textFieldVaildCode.font = FEFont(18);
        textFieldVaildCode.keyboardType = UIKeyboardTypeNumberPad;
        textFieldVaildCode.tintColor = FEWordColor;
        textFieldVaildCode.textAlignment = NSTextAlignmentCenter;
        textFieldVaildCode.backDelegate = self;
        textFieldVaildCode.textColor = FEWordColor;
        textFieldVaildCode.layer.borderColor = HEXCOLOR(0x99999).CGColor;
        textFieldVaildCode.layer.borderWidth = 0.5;
        [self.vaildCodeTextFieldBoard addSubview:textFieldVaildCode];
    }
    
}

-(NSString*)replacingOccurrencesSpace:(NSString*)inputText{
    inputText = [inputText stringByReplacingOccurrencesOfString:@" "withString:@""];
    return inputText;
}

-(void)textFieldChanage:(NSNotification*)notif
{
    VCTextField *textField = notif.object;
    NSInteger tag = textField.tag;
    if ([self isVialdCodeTextFieldBecomeFirstResponderWithTag:tag]
        && [self replacingOccurrencesSpace:[self withTag:tag].text].length >= 1) {
        NSString *vaildCode = [self withTag:tag].text;
        [self withTag:tag].text  = [vaildCode substringWithRange:NSMakeRange(vaildCode.length-1, 1)];
        if (tag<4) {
            [[self withTag:tag+1] becomeFirstResponder];
        }
        else {
            [[self withTag:tag] resignFirstResponder];
        }
    }

    NSString *vaildCode = textField.text;
    if (vaildCode.length) {
        [_vaildCodes replaceObjectAtIndex:tag-1 withObject:vaildCode];
    }
    NSString *_vaildCode = [_vaildCodes componentsJoinedByString:@" "];
    _vaildCode = [_vaildCode stringByReplacingOccurrencesOfString:@" "withString:@""];
    if (_vaildCode.length == 4) {
        [self.view endEditing:YES];
        [SVProgressHUD show];
        _vaildCode = [_vaildCodes componentsJoinedByString:@""];
        _vaildCode = [QXDataManager getEncodeAESStringWithContent:_vaildCode];
        NSString *phone = [self.phone stringByReplacingOccurrencesOfString:@" "withString:@""];
        phone = [QXDataManager getEncodeAESStringWithContent:phone];
        [self __verifyAccountWithPhone:phone vaildCode:_vaildCode];
    }
    
}

-(void)deleteBackWard:(VCTextField *)textField{
    if (textField.tag > 1) {
        [[self withTag:textField.tag-1] becomeFirstResponder];
        [_vaildCodes replaceObjectAtIndex:textField.tag-1 withObject:@" "];

    }
    
}

#pragma mark ---- 倒计时
- (void)starTimer{
    self.countDownNumber = countNumber;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCodeNumber) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)changeCodeNumber{
    if(self.countDownNumber < 1){
        self.timeLabel.text = @"重新发送";
        [self.timer invalidate];
        self.timer = nil;
    }
    else{
        self.timeLabel.text = [NSString stringWithFormat:@"%zd秒后可重发",self.countDownNumber];
        self.countDownNumber--;
        
    }
}

-(void)reSendCode:(UITapGestureRecognizer*)Ges{
    if (self.countDownNumber!= 0) {
        return;
    }
    [self starTimer];
    
}

-(BOOL)isVialdCodeTextFieldBecomeFirstResponderWithTag:(NSInteger)tag{
    
    VCTextField *textField = [self withTag:tag];
    return [textField canBecomeFirstResponder];
    
}

-(VCTextField*)withTag:(NSInteger)tag{
    
    VCTextField *textField = ((VCTextField*)([self.view viewWithTag:tag]));
    return textField;
    
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
    _vaildCodes = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        [_vaildCodes addObject:@" "];
    }
    self.countDownNumber = countNumber;
    [self __layoutView];
    //[self __sendVaildCode];
    [self starTimer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, IPHONE_W, 16)];
        _titleLabel.font = FEFont(15);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0x666666);
        _titleLabel.text = [NSString stringWithFormat:@"验证码正发送至%@",self.phone];
    }
    return _titleLabel;
}


-(UILabel*)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.vaildCodeTextFieldBoard.frame)+50, IPHONE_W, 34)];
        _timeLabel.font = FEFont(15);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = HEXCOLOR(0x666666);
        UITapGestureRecognizer *tapSelect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendCode:)];
        self.timeLabel.text = [NSString stringWithFormat:@"%zd秒后可重发",self.countDownNumber];
        _timeLabel.userInteractionEnabled = YES;
        [_timeLabel addGestureRecognizer:tapSelect];
    }
    return _timeLabel;
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
