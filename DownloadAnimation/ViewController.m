//
//  ViewController.m
//  DownloadAnimation
//
//  Created by 谢鹏翔 on 16/8/12.
//  Copyright © 2016年 ime. All rights reserved.
//

#import "ViewController.h"
#import "MXDownloadButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    MXDownloadButton *button = [[MXDownloadButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
