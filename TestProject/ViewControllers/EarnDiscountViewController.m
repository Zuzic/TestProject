//
//  EarnDiscountViewController.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "EarnDiscountViewController.h"

#define SHARE_CODE_BUTTON_TEXT @"Share the code"
#define SEND_TO_FRIENDS_BUTTON_TEXT @"Send to eligible friends"
#define ENTER_CODE_BUTTON_TEXT @"Enter code from a friend"

@interface EarnDiscountViewController ()
@property (strong, nonatomic) IBOutlet UIButton *shareCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *sendToFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *enterCodeButton;

@end

@implementation EarnDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTermsButton];
    [self addCrossButton];
    
    [self.shareCodeButton setTitle:SHARE_CODE_BUTTON_TEXT forState:UIControlStateNormal];
    [self.sendToFriendsButton setTitle:SEND_TO_FRIENDS_BUTTON_TEXT forState:UIControlStateNormal];
    [self.enterCodeButton setTitle:ENTER_CODE_BUTTON_TEXT forState:UIControlStateNormal];
    
    [self setControllerTitle:@"EARN DISCOUNT"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action methods
-(void) crossClick{
    [super crossClick];
    [[[UIAlertView alloc] initWithTitle:@"Hey" message:@"Cross button click" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void) termsClick{
    [super termsClick];
    [self performSegueWithIdentifier:@"termsPush" sender:nil];
}

- (IBAction)shareCodeButtonClicked:(id)sender {
    NSArray * activityItems = @[[NSString stringWithFormat:@"Some initial text."], [NSURL URLWithString:@"http://www.google.com"]];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];

    [self.navigationController presentViewController:activityViewController
                                       animated:YES
                                     completion: nil];
    
   
}


@end
