//
//  SendDiscountViewController.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "SendDiscountViewController.h"
#import "MBProgressHUD.h"
#import "ContactManager.h"
#import "ContactTableViewCell.h"
#import "ContactModel.h"
#import "NSArray+Filter.h"
#import <MessageUI/MFMailComposeViewController.h>

#define kBottomTableViewConstraintValue 46

@interface SendDiscountViewController ()<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewWithButton;
@property (strong, nonatomic) IBOutlet UIView *viewWithContact;
@property (strong, nonatomic) NSArray *contactArray;
@property (strong, nonatomic) NSArray *contactCopyArray;\

//view with button property
@property (strong, nonatomic) IBOutlet UIView *viewWithText;

//view with contact property
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomTableViewConstraint;

@property (strong, nonatomic) MFMailComposeViewController *compose_mail;

@end

@implementation SendDiscountViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //add title
    [self setControllerTitle:@"SEND DISCOUNT"];
    [self addDoneButton];
    [self addCancelButton];
    //add tap to view with text
    UITapGestureRecognizer *showContactTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showContactListTap:)];
    [self.viewWithText addGestureRecognizer:showContactTap];
    
    //definition contact array
    self.contactArray = @[[NSArray new], [NSArray new]];
    self.contactCopyArray = @[[NSArray new], [NSArray new]];
    
    // register table view cell xib
    [self.contactsTableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactTableViewCellIdentifier"];
    self.contactsTableView.allowsMultipleSelection = YES;
    
    if ([self.contactsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.contactsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //IOS8 separator fix
    if ([self.contactsTableView respondsToSelector:@selector(layoutMargins)]) {
        self.contactsTableView.layoutMargins = UIEdgeInsetsZero;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self disableDoneButton];
    self.viewWithContact.hidden = YES;
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self disableDoneButton];
}

#pragma mark - Utility methods
-(void)doneButtonWithHideState:(BOOL)isHide{
    if(isHide){
         [self disableDoneButton];
    }
    else{
        [self enableDoneButton];
    }
    self.doneButton.hidden = isHide;
    self.bottomTableViewConstraint.constant = isHide ? 0 : kBottomTableViewConstraintValue;
}

-(void) loadContactData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[ContactManager sharedInstance] authorizationAddressBookCallback:^(NSArray *items, NSString *errorText) {
        if(!items){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        
        self.viewWithButton.hidden = YES;
        self.viewWithContact.hidden = NO;
        
        [self doneButtonWithHideState:YES];
        
        [items filterArrayCurrentCityWithArray:items callback:^(NSArray *correctCity, NSArray *otherCity) {
            self.contactArray = @[correctCity, otherCity];
            self.contactCopyArray = self.contactArray;
            [self.contactsTableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }];
}

#pragma mark - Action methods
- (void)showContactListTap:(UITapGestureRecognizer *)recognizer {
    [self loadContactData];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self createEmail];
}

-(void) doneClick{
    [super doneClick];
    [self createEmail];
}

#pragma mark - UITextfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length == 0){
        self.contactArray = self.contactCopyArray;
    }
    else{
        self.contactArray = [NSArray searchByText:textField.text array:self.contactArray];
    }
    
    [self.contactsTableView reloadData];
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *result = textField.text;
    result= [result stringByReplacingCharactersInRange:range withString:string];
    
    if(result.length == 0){
        self.contactArray = self.contactCopyArray;
    }
    else{
        self.contactArray = [NSArray searchByText:result array:self.contactCopyArray];
    }
    
    [self.contactsTableView reloadData];
    
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.contactArray.count == 2) ? 2 : 1 ;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.contactArray.count == 0){
        return 0;
    }
    
    NSArray *sectionsArray = [self.contactArray objectAtIndex:section];
    return sectionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContactTableViewCellIdentifier";
    
    ContactTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[ContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    __weak ContactTableViewCell *weakCell = cell;
    
    ContactModel *currentContact = [[self.contactArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    weakCell.contactFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", currentContact.firstName, currentContact.lastName];
    
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self doneButtonWithHideState:NO];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *selectedCells = [self.contactsTableView indexPathsForSelectedRows];
    if(selectedCells.count==0){
        [self doneButtonWithHideState:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sectionArray = [self.contactArray objectAtIndex:section];
    if(section == 0 && sectionArray.count>0){
        return @"CONTACTS FROM SAN FRANCISCO";
    }
    else if(section == 1 && sectionArray.count>0){
        return @"OTHER CITIES";
    }
    else{
        return @"";
    }
}

#pragma mark - send mail
- (void)createEmail {
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
    [emailBody appendString:@"<p>Hey, I just want to send you this $5 off for this new food delivery service Fasibite, that now works in San Francisco</p>"];
    UIImage *emailImage = [UIImage imageNamed:@"saleOffer"];
    NSString *base64String = [self base64String:emailImage];
    [emailBody appendString:[NSString stringWithFormat:@"<p><b><img src='data:image/png;base64,%@'></b></p>",base64String]];
    [emailBody appendString:@"</body></html>"];
    
    //Create the mail composer window
    MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];
    emailDialog.mailComposeDelegate = self;
    
    NSMutableArray *recipients = [NSMutableArray new];
    NSArray *selectedArray = [self.contactsTableView indexPathsForSelectedRows];
    
    for(NSIndexPath *contactPath in selectedArray){
        ContactModel *contact = [[self.contactArray objectAtIndex:contactPath.section] objectAtIndex:contactPath.row];
        
        [recipients addObject:[NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName]];
    }
    
    [emailDialog setToRecipients:recipients];
    [emailDialog setSubject:@"SEND DISCOUNT"];
    [emailDialog setMessageBody:emailBody isHTML:YES];
    
    [self.navigationController presentViewController:emailDialog animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (![self.presentedViewController isBeingDismissed])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [self loadContactData];
        }];
    }
}

#pragma mark - coding image
- (NSString *)base64String:(UIImage*) image {
    NSData * data = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[data bytes]];
}

@end
