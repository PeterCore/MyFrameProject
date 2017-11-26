//
//  QXHomeViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/9/20.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "QXHomeViewController.h"
#import "QXReceiveOrderViewController.h"
#import "QXOrderListViewController.h"
#import "QXMineViewController.h"
#import "QXSliderBlock.h"

@interface QXHomeViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIButton *navigation_leftButton;
@property(nonatomic,strong)UIButton *navigation_middleButton;
@property(nonatomic,strong)UIButton *navigation_rightButton;
@property(nonatomic,strong)UIScrollView *boardViewScrollView;
@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)QXSliderBlock *sliderBlock;
@end

@implementation QXHomeViewController


#pragma mark --UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    NSUInteger index = scrollView.contentOffset.x / self.boardViewScrollView.frame.size.width;
    self.selectButton.enabled = YES;
    self.selectButton =  [self.overLayer viewWithTag:index+1];
    self.selectButton.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderBlock.frame = self.selectButton.frame;
    }];
    
    UIViewController *newsVc = self.childViewControllers[index];
    [newsVc didMoveToParentViewController:self];
    if (newsVc.view.superview) return;
    newsVc.view.frame = CGRectMake(scrollView.bounds.origin.x, 0, scrollView.bounds.size.width,self.view.bounds.size.height);
    [self.boardViewScrollView addSubview:newsVc.view];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / self.boardViewScrollView.frame.size.width;
    self.selectButton.enabled = YES;
    self.selectButton =  [self.overLayer viewWithTag:index+1];
    self.selectButton.enabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderBlock.frame = self.selectButton.frame;
    }];
    UIViewController *newsVc = self.childViewControllers[index];
    [newsVc didMoveToParentViewController:self];
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = CGRectMake(scrollView.bounds.origin.x, 0, scrollView.bounds.size.width,self.view.bounds.size.height);
    [self.boardViewScrollView addSubview:newsVc.view];
}


-(void)selectNavgationButton:(UIButton*)sender{
    
    sender.enabled = self.selectButton.enabled;
    self.selectButton.enabled = YES;
    NSInteger index = sender.tag-1;
    CGFloat offsetX = index * self.boardViewScrollView.frame.size.width;
    CGFloat offsetY = self.boardViewScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.boardViewScrollView setContentOffset:offset animated:YES];
    self.selectButton = sender;
    
    
}

/*
 *author zhangchun 2017-09-22
 *
 */
#pragma mark ---- layout 界面布局
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self __layoutNavigationButtons];
    [self __layoutView];
    [self selectNavgationButton:self.selectButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIColor*)navigationBackgroundColor{
    return NavigationBarColor;
}



-(void)__layoutView{
    
    [self.view addSubview:self.boardViewScrollView];
    QXMineViewController *mineVc = [[QXMineViewController alloc] init];
    QXReceiveOrderViewController *receiveVc = [[QXReceiveOrderViewController alloc] init];
    QXOrderListViewController *orderListVc = [[QXOrderListViewController alloc] init];
    [self addChildViewController:mineVc];
    [self addChildViewController:receiveVc];
    [self addChildViewController:orderListVc];
    mineVc.view.frame = self.boardViewScrollView.bounds;
    [self.boardViewScrollView addSubview:mineVc.view];
    
}


-(void)__layoutNavigationButtons{
    
    UIButton *navigation_leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 90, 44)];
    [navigation_leftButton setTitle:@"我的" forState:UIControlStateNormal];
    [navigation_leftButton setTitle:@"我的" forState:UIControlStateHighlighted];
    [navigation_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigation_leftButton setTitleColor:kselectNavtionBarButtonColor forState:UIControlStateDisabled];
    navigation_leftButton.titleLabel.font = FEFont(18);
    [navigation_leftButton addTarget:self action:@selector(selectNavgationButton:) forControlEvents:UIControlEventTouchUpInside];
    navigation_leftButton.tag = 1;
    [self.overLayer addSubview:navigation_leftButton];
    
    
    UIButton *navigation_middleButton = [[UIButton alloc] initWithFrame:CGRectMake((IPHONE_W-90)/2.0, 20, 90, 44)];
    [navigation_middleButton setImage:FEImage(@"nav_logo_gray") forState:UIControlStateNormal];
    [navigation_middleButton setImage:FEImage(@"nav_logo_light") forState:UIControlStateDisabled];
    [navigation_middleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigation_middleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigation_middleButton addTarget:self action:@selector(selectNavgationButton:) forControlEvents:UIControlEventTouchUpInside];
    navigation_middleButton.tag = 2;
    [self.overLayer addSubview:navigation_middleButton];
    
    
    UIButton *navigation_rightButton = [[UIButton alloc] initWithFrame:CGRectMake(IPHONE_W-90, 20, 90, 44)];
    [navigation_rightButton setTitle:@"订单" forState:UIControlStateNormal];
    [navigation_rightButton setTitle:@"订单" forState:UIControlStateHighlighted];
    [navigation_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigation_rightButton setTitleColor:kselectNavtionBarButtonColor forState:UIControlStateDisabled];
    navigation_rightButton.titleLabel.font = FEFont(18);
    [navigation_rightButton addTarget:self action:@selector(selectNavgationButton:) forControlEvents:UIControlEventTouchUpInside];
    navigation_rightButton.tag = 3;
    [self.overLayer addSubview:navigation_rightButton];
    
    self.navigation_leftButton = navigation_leftButton;
    self.navigation_middleButton = navigation_middleButton;
    self.navigation_rightButton = navigation_rightButton;
    self.selectButton = self.navigation_middleButton;
    self.selectButton.enabled = NO;
    [self.overLayer addSubview:self.sliderBlock];
   
}


-(QXSliderBlock*)sliderBlock{
    if (!_sliderBlock) {
        _sliderBlock = [[QXSliderBlock alloc] initWithFrame:self.selectButton.frame];
        _sliderBlock.backgroundColor = [UIColor clearColor];
    }
    return _sliderBlock;
}

-(UIScrollView*)boardViewScrollView{
    if (!_boardViewScrollView) {
        _boardViewScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, IPHONE_W, IPHONE_H)];
        _boardViewScrollView.showsHorizontalScrollIndicator = NO;
        _boardViewScrollView.showsVerticalScrollIndicator = NO;
        _boardViewScrollView.backgroundColor = [UIColor whiteColor];
        _boardViewScrollView.contentSize = CGSizeMake(IPHONE_W*3, 0);
        _boardViewScrollView.pagingEnabled = YES;
        
        _boardViewScrollView.delegate = self;
    }
    return _boardViewScrollView;
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
