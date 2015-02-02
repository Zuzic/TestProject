//
//  TermsViewController.m
//  TestProject
//
//  Created by Yury Zenko on 03.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "TermsViewController.h"

@implementation TermsViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    
    //add title
    [self setControllerTitle:@"TERMS"];
    [self addCrossButton];
    //add tap to view with text
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Action Methods
-(void) crossClick{
    [super crossClick];
    [self popViewController];
}
@end
