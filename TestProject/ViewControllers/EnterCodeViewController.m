//
//  EnterCodeViewController.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "EnterCodeViewController.h"
#import "ConfirmCodeViewController.h"

@interface EnterCodeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;

@property (strong, nonatomic) NSString *codeText;


@end

@implementation EnterCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setControllerTitle:@"ENTER CODE"];
    [self addDoneButton];
    [self addCancelButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self disableDoneButton];
    
    self.codeText = [self randomStringWithLength:6];
    
    self.codeLabel.text = [NSString stringWithFormat:@"Generate code is %@", self.codeText];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.codeTextField.text.length == 0){
        [self disableDoneButton];
    }
    else{
        [self enableDoneButton];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"confirmCodePush"]) {
        BOOL isEquals = [self.codeTextField.text isEqualToString:self.codeText];
        ConfirmCodeViewController *confContr = (ConfirmCodeViewController *)segue.destinationViewController;
        [confContr setControllerState:isEquals];
    }
}

#pragma mark - Action methods
-(void) doneClick{
    [super doneClick];
    [self performSegueWithIdentifier:@"confirmCodePush" sender:nil];
}

#pragma mark - UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self doneClick];
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *result = textField.text;
    result= [result stringByReplacingCharactersInRange:range withString:string];
    
    if(result.length == 0){
        [self disableDoneButton];
    }
    else{
        [self enableDoneButton];
    }
    return YES;
}


#pragma mark - Generate fake code
-(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}



@end
