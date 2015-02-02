//
//  BaseViewController.h
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(void) setControllerTitle:(NSString*) title;

-(void) addCancelButton;
-(void) hideCancelButton;
-(void) showCancelButton;

-(void) addDoneButton;
-(void) disableDoneButton;
-(void) enableDoneButton;
-(void) doneClick;

-(void) addTermsButton;
-(void) hideTermsButton;
-(void) showTermsButton;
-(void) termsClick;

-(void) addCrossButton;
-(void) hideCrossButton;
-(void) showCrossButton;
-(void) crossClick;

-(void) popToRootController;
-(void) popViewController;
@end
