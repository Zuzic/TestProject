//
//  BaseViewController.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id rootVC = [[self.navigationController viewControllers] objectAtIndex:0];
    
    if(self != rootVC){
        [self changeBackToCancelButton];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Utility methods
-(void) setControllerTitle:(NSString*) title{
    self.title = title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
}

-(void) changeBackToCancelButton{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 60, 40)];
    [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - Action Methods
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
