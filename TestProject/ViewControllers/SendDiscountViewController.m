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

#define kBottomTableViewConstraintValue 46

@interface SendDiscountViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewWithButton;
@property (strong, nonatomic) IBOutlet UIView *viewWithContact;
@property (strong, nonatomic) NSArray *contactArray;

//view with button property
@property (strong, nonatomic) IBOutlet UIView *viewWithText;

//view with contact property
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomTableViewConstraint;


@end

@implementation SendDiscountViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //add title
    [self setControllerTitle:@"SEND DISCOUNT"];
    
    
    //add tap to view with text
    UITapGestureRecognizer *showContactTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showContactListTap:)];
    [self.viewWithText addGestureRecognizer:showContactTap];
    
    //definition contact array
    self.contactArray = [NSArray new];
    
    // register table view cell xib
    [self.contactsTableView registerNib:[UINib nibWithNibName:@"ContactTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactTableViewCellIdentifier"];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.viewWithContact.hidden = YES;
    
}

#pragma mark - Utility methods
-(void)doneButtonWithHideState:(BOOL)isHide{
    self.doneButton.hidden = isHide;
    self.bottomTableViewConstraint.constant = isHide ? 0 : kBottomTableViewConstraintValue;
}

#pragma mark - Action methods
- (void)showContactListTap:(UITapGestureRecognizer *)recognizer {
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
            [self.contactsTableView reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }];
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
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}


@end
