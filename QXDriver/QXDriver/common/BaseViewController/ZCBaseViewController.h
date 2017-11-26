//
//  ZCBaseViewController.h
//  Maroc
//
//  Created by zhangchun on 2016/11/29.
//  Copyright © 2016年 zhangchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCNavgtionbarOverlay.h"
//#import "ZCButton.h"
#import "ZCLabel.h"
//#import "UIView+NavigtionBar.h"
static const CGFloat navigtionHeight = 64;

/**
 *  @author zhangchun, 16-11-30 15:11:09
 *
 *  <#Description#>
 */
@protocol ZCBaseViewControllerDataSource <NSObject>
@optional
-(NSMutableArray<UIButton*>*)navigationBar_leftButtonItems;
-(NSMutableArray<UIButton*>*)navigationBar_rightButtonItems;
-(NSMutableArray<UIButton*>*)navigationBar_middleButtonItems;
-(NSMutableAttributedString*)navigtionTitle;
-(UIColor*)navigationBackgroundColor;
-(NSArray*)navigationBackgroundColors;
-(UIImage*)navigationImage;
-(UIColor*)navigationBarBottomLineColor;
-(UIView*)otherMiddleView;
-(BOOL)isHasMiddleButton;




//-(ZCButton*)navgtionBar_Leftbutton;
//-(ZCButton*)navgtionBar_Rightbutton;


@end

/**
 *  @author zhangchun, 16-11-30 15:11:16
 *
 *  <#Description#>
 */
@protocol ZCBaseViewControllerDelegate <NSObject>
@optional
-(void)navigationleftClick:(NSInteger)index;
-(void)navigationrightClick:(NSInteger)index;
-(void)navigationmiddleClick:(NSInteger)index;


@end


@interface ZCBaseViewController : UIViewController<ZCBaseViewControllerDataSource,ZCBaseViewControllerDelegate>
@property(nonatomic,strong,readonly)ZCNavgtionbarOverlay *overLayer;
@property(nonatomic,strong)ZCLabel *titLabel;
@property(nonatomic,strong)UIButton *leftbutton;
@property(nonatomic,strong)UIButton *middleButton;
@property(nonatomic,strong)UIButton *rightbutton;

-(void)upStatusBarHidden:(BOOL)hidden;

-(void)swithNavigationBarBottomLineColor:(UIColor*)color;
-(void)layoutNavigationViewBar;
-(void)removeColors;
-(void)removeBarView;
-(void)dismissNavigationBar:(dispatch_block_t) block;
-(void)showNavigationBar:(dispatch_block_t) block;



@end
