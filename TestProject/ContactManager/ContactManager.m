//
//  ContactManager.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "ContactManager.h"
#import "ContactModel.h"

@implementation ContactManager

-(void) authorizationAddressBookCallback:(ArrayRetrieveCallback) callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSArray *contactArray = [self getAddressBookValues];
                    if(callback)
                        dispatch_async(dispatch_get_main_queue(), ^{
                           callback(contactArray, @"");
                        });
                        
                    
                } else {
                    if(callback){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(nil, @"Authorization error");
                        });
                    }
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            NSArray *contactArray = [self getAddressBookValues];
            if(callback)
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(contactArray, @"");
                });
        }
        else {
            if(callback){
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil, @"Please allow the Test project to use your contacts in the iPhone settings.");
                });
            }
        }
    });
}

-(NSArray*) getAddressBookValues{
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    NSMutableArray *contactsArray = [NSMutableArray new];
    
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        
        ContactModel * contactModel = [[ContactModel alloc] initContactModel];
        
        contactModel.firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        if(!contactModel.firstName){
            contactModel.firstName = @"";
        }
        
        contactModel.lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        if(!contactModel.lastName){
            contactModel.lastName = @"";
        }
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        if(emails){
            CFStringRef currentEmailsValue = ABMultiValueCopyValueAtIndex(emails, 0);
            contactModel.email = (__bridge NSString *)currentEmailsValue;
            if(currentEmailsValue) CFRelease(currentEmailsValue);
        }
        CFRelease(emails);
        
        ABMultiValueRef addresses = ABRecordCopyValue(person, kABPersonAddressProperty);

        if(addresses){
            for (CFIndex i = 0; i < ABMultiValueGetCount(addresses); i++) {
                CFStringRef currentAddressLabel = ABMultiValueCopyLabelAtIndex(addresses, i);
                CFDictionaryRef currentAddressValue = ABMultiValueCopyValueAtIndex(addresses, i);
                
                
                if(currentAddressLabel){
                    NSDictionary * addressDict = (__bridge NSDictionary *)currentAddressValue;
                    
                    if (CFStringCompare(currentAddressLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
                        //NSLog(@"work address %@", addressDict);
                    }
                    else  if (CFStringCompare(currentAddressLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                        //NSLog(@"home address %@", addressDict);
                    }
                    else {
                        //NSLog(@"other address %@", addressDict);
                    }
                    
                    contactModel.city = addressDict[@"City"] ? addressDict[@"City"] : @"";
                }
                
                if(currentAddressLabel) CFRelease(currentAddressLabel);
                if(currentAddressValue) CFRelease(currentAddressValue);
            }
            
            CFRelease(addresses);
        }
        [contactsArray addObject:contactModel];
    }
    
    return contactsArray;
}

#pragma mark - singleton
+ (ContactManager *)sharedInstance
{
    static ContactManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ContactManager alloc] init];
    });
    return sharedInstance;
}

@end
