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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Utility methods
-(void) setControllerTitle:(NSString*) title{
    self.title = title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
}


#pragma mark - Cancel button logic
-(void) addCancelButton{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 60, 40)];
    [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

-(void) hideCancelButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.leftBarButtonItem;
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.hidden = YES;
}

-(void) showCancelButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.leftBarButtonItem;
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.hidden = NO;
}

#pragma mark - Done button logic
-(void) addDoneButton{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 60, 40)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    UIBarButtonItem *barDoneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneButton addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barDoneButtonItem;
}

-(void) disableDoneButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.alpha = 0.3f;
    customBtn.enabled = NO;
}

-(void) enableDoneButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.alpha = 1.0f;
    customBtn.enabled = YES;
}

#pragma mark - Terms button logic
-(void) addTermsButton{//cross
    UIButton *termsButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 60, 40)];
    [termsButton setTitle:@"Terms" forState:UIControlStateNormal];
    [termsButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    UIBarButtonItem *bartermsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:termsButton];
    [termsButton addTarget:self action:@selector(termsClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = bartermsButtonItem;
}

-(void) hideTermsButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.hidden = YES;
}

-(void) showTermsButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.hidden = NO;
}

#pragma mark - Cross button logic
-(void) addCrossButton{
    UIButton *crossButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 20, 20)];
    [crossButton setImage:[UIImage imageNamed:@"crossImage"] forState:UIControlStateNormal];
    [crossButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    UIBarButtonItem *barCrossButtonItem = [[UIBarButtonItem alloc] initWithCustomView:crossButton];
    [crossButton addTarget:self action:@selector(crossClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barCrossButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
}

-(void) hideCrossButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.hidden = YES;
}

-(void) showCrossButton{
    UIBarButtonItem *item = (UIBarButtonItem *)self.navigationItem.rightBarButtonItem;
    
    UIButton *customBtn = (UIButton *)item.customView;
    customBtn.hidden = NO;
}

#pragma mark - Close Controller logic
-(void) popToRootController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action Methods
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) doneClick{
    NSLog(@"Done click");
}

-(void) termsClick{
    NSLog(@"Terms click");
}

-(void) crossClick{
     NSLog(@"Cross click");
}



@end
