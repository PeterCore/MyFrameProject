//
//  MapTestViewController.m
//  QXDriver
//
//  Created by zhangchun on 2017/11/17.
//  Copyright © 2017年 千夏. All rights reserved.
//

#import "MapTestViewController.h"
#import "QXAMapView.h"
@interface MapTestViewController ()

@end

@implementation MapTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    QXAMapView *mapView = [[QXAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
}

-(void)navigationleftClick:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
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
