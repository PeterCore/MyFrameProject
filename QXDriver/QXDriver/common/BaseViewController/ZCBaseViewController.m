//
//  ZCBaseViewController.m
//  Maroc
//
//  Created by zhangchun on 2016/11/29.
//  Copyright © 2016年 zhangchun. All rights reserved.
//

#import "ZCBaseViewController.h"
//#import "ZCLabel+Language.h"
@interface ZCBaseViewController ()
@property(nonatomic,strong)ZCNavgtionbarOverlay *overLayer;
@property(nonatomic,assign)BOOL statusHidden;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@property(nonatomic,strong)UIImageView *navigationBarView;
@end

@implementation ZCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self layoutNavigtionBar];
    [self layoutLeftButtons];
    [self layoutRightButtons];
    
    if([self respondsToSelector:@selector(otherMiddleView)]){
        UIView *view = [self otherMiddleView];
        [self.overLayer addSubview:view];
    }
    else{
        if ([self respondsToSelector:@selector(isHasMiddleButton)]) [self layoutMiddleButton];
        else [self layoutTitle];
    }

    
    
   
}


-(void)dismissNavigationBar:(dispatch_block_t) block{
    
    if (self.overLayer) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.overLayer setFrame:CGRectMake(0, -64, IPHONE_W, 64)];
            if (block) {
                block();
            }
        }];
    }
    
}


-(void)showNavigationBar:(dispatch_block_t) block{
    
    if (self.overLayer) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.overLayer setFrame:CGRectMake(0, 0, IPHONE_W, navigtionHeight)];
            if (block) {
                block();
            }
        }];
    }
    
}

-(void)reloadView{
    if (self.titLabel) {
//        [self.titLabel setFrame:CGRectMake(self.leftbutton?CGRectGetMaxX(self.leftbutton.frame)+10:10, 20, IPHONE_W-(self.leftbutton?CGRectGetMaxX(self.leftbutton.frame)+10:10)-(self.rightbutton?(IPHONE_W-CGRectGetMinX(self.rightbutton.frame)):10), 44)];
        [self.titLabel setFrame:CGRectMake(60, 20, IPHONE_W-120, 44)];

    }
}

-(void)layoutMiddleButton{
    if ([self respondsToSelector:@selector(navigationBar_middleButtonItems)]) {
        NSArray *middleItems = [self navigationBar_middleButtonItems];
        if (middleItems.count == 1) {
            UIButton *middleButton = (UIButton*)middleItems[0];
            self.middleButton = middleButton;
            [self.overLayer addSubview:middleButton];
            [middleButton addTarget:self action:@selector(middleClick:) forControlEvents:UIControlEventTouchUpInside];
        }

    }
}


-(void)middleClick:(UIButton*)sender{
    if ([self respondsToSelector:@selector(navigationmiddleClick:)]) {
        [self navigationmiddleClick:0];
    }
    
}

/**
 *  @author zhangchun, 16-11-30 22:11:36
 *
 *  layout title
 */
-(void)layoutTitle{
    if ([self respondsToSelector:@selector(navigtionTitle)]) {
        NSMutableAttributedString *muttitle = [self navigtionTitle];
        if (muttitle) {
            //[self.titLabel setFrame:CGRectMake(IPHONE_W-60, 20, 120, 44)];
//            self.titLabel = [[ZCLabel alloc]initWithFrame:CGRectMake(self.leftbutton?CGRectGetMaxX(self.leftbutton.frame)+10:10, 20, IPHONE_W-(self.leftbutton?CGRectGetMaxX(self.leftbutton.frame)+10:10)-(self.rightbutton?(IPHONE_W-CGRectGetMinX(self.rightbutton.frame)):10), 44)];
            self.titLabel = [[ZCLabel alloc]initWithFrame:CGRectMake(60, 20, IPHONE_W-120, 44)];
            [self.overLayer addSubview:self.titLabel];
            self.titLabel.attributedText = muttitle;
        }
    }
}

/**
 *  @author zhangchun, 16-11-30 22:11:53
 *
 *  layout navigationrightItems
 */
-(void)layoutRightButtons{
    if ([self respondsToSelector:@selector(navigationBar_rightButtonItems)]) {
        NSArray *rightItems = [self navigationBar_rightButtonItems];
        if (rightItems.count) {
            NSInteger index = 0;
            for (UIButton *button in rightItems) {
                [self.overLayer addSubview:button];
                [button setFrame:CGRectMake(self.rightbutton?IPHONE_W-CGRectGetMinX(self.rightbutton.frame):IPHONE_W-5-button.frame.size.width, 20, button.frame.size.width, button.frame.size.height)];
                [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag =index;
                self.rightbutton = button;
                index ++;
            }
        }
        [self reloadView];
    }
    
   
}

-(void)rightClick:(UIButton*)sender{
    if ([self respondsToSelector:@selector(navigationrightClick:)]) {
        [self navigationrightClick:sender.tag];
    }
    
}

/**
 *  @author zhangchun, 16-11-30 22:11:43
 *
 *  layout navigationLeftItems
 */

-(void)layoutLeftButtons{
    if ([self respondsToSelector:@selector(navigationBar_leftButtonItems)]) {
        NSArray *leftItems = [self navigationBar_leftButtonItems];
        if (leftItems.count) {
            NSInteger index = 0;
            for (UIButton *button in leftItems) {
                [self.overLayer addSubview:button];

                [button setFrame:CGRectMake(self.leftbutton?CGRectGetMaxX(self.leftbutton.frame):5, 20, button.frame.size.width, button.frame.size.height)];
                [button addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag =index;
                self.leftbutton = button;
                index ++;
            }
        }
        [self reloadView];
        
    }
}

-(void)leftClick:(UIButton*)sender{
    if ([self respondsToSelector:@selector(navigationleftClick:)]) {
        [self navigationleftClick:sender.tag];
    }
   
    
}

-(void)swithNavigationBarBottomLineColor:(UIColor*)color
{
    if (self.overLayer) {
        
    }
}


/**
 *  @author zhangchun, 16-11-30 21:11:47
 *
 *  layout navigtionBar
 */
-(void)layoutNavigtionBar{
    if (!self.overLayer) {
        self.overLayer = [[ZCNavgtionbarOverlay alloc]initWithFrame:CGRectMake(0, 0, IPHONE_W, navigtionHeight) bottomLineColor:^UIColor *(UIColor *color) {
            if ([self respondsToSelector:@selector(navigationBarBottomLineColor)]) {
                color = [self navigationBarBottomLineColor];
            }
            else{
                color = [UIColor clearColor];
            }
            return color;
            
        }];
        self.overLayer.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.overLayer];
        self.overLayer.backgroundColor = [UIColor whiteColor];
        if ([self respondsToSelector:@selector(navigationBackgroundColor)]) {
            UIColor *background = [self navigationBackgroundColor];
            self.overLayer.backgroundColor = background;
        }
    }
    [self layoutNavigationViewBar];

  

}

-(void)removeColors{
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
}

-(void)layoutNavigationViewBar{
    [self removeBarView];

    if ([self respondsToSelector:@selector(navigationImage)]) {
        UIImage *image = [self navigationImage];
        self.navigationBarView = [[UIImageView alloc]initWithFrame:self.overLayer.bounds];
        self.navigationBarView.image = image;
        [self.overLayer insertSubview:self.navigationBarView atIndex:0];
    }
    
}

-(void)removeBarView
{
    [self.navigationBarView removeFromSuperview];
    self.navigationBarView = nil;
}


-(void)layoutColors{
    [self removeColors];
    if ([self respondsToSelector:@selector(navigationBackgroundColors)]) {
        NSArray *colors = [self navigationBackgroundColors];
        if (colors.count) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = [colors copy];
            NSInteger counts = colors.count;
            CGFloat offset = 1.0/counts;
            NSMutableArray *colosList = [NSMutableArray array];
            for (NSInteger i = 0; i < counts; i++) {
                [colosList addObject:@(i*offset)];
            }
            gradientLayer.locations = colosList;
            gradientLayer.startPoint = CGPointMake(0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.0, 1);
            gradientLayer.frame = self.overLayer.bounds;
            [self.overLayer.layer addSublayer:gradientLayer];
            self.gradientLayer  = gradientLayer;
        }
    }
}


-(void)upStatusBarHidden:(BOOL)hidden{
    self.statusHidden = hidden;
     [[UIApplication sharedApplication] setStatusBarHidden:self.statusHidden withAnimation:UIStatusBarAnimationSlide];
    //[self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setNeedsStatusBarAppearanceUpdate];
    if ([self.overLayer.backgroundColor isEqual:NavigationBarBackground]) {
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
    }
    else{
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
