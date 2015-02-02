//
//  ConfirmCodeViewController.m
//  TestProject
//
//  Created by Yury Zenko on 02.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "ConfirmCodeViewController.h"
@interface ConfirmCodeViewController()
@property (strong, nonatomic) IBOutlet UIImageView *stateImageView;
@property (assign) BOOL isEqualsCode;
@end


@implementation ConfirmCodeViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    
    //add title
    [self setControllerTitle:@"EARN $200!"];
    //add tap to view with text
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideCancelButton];
    [self showCurrentState];
}

-(void) setControllerState:(BOOL)isEquals{
    self.isEqualsCode = isEquals;
}

#pragma mark - Utility methods
-(void) showCurrentState{
    self.stateImageView.image = self.isEqualsCode ? [UIImage imageNamed:@"acceptedImage"] : [UIImage imageNamed:@"rejectedImage"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(self.isEqualsCode){
            [self popToRootController];
        }
        else{
            [self popViewController];
        }
    });
    
    
}

@end
