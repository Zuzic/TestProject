//
//  ContactManager.h
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef void(^ArrayRetrieveCallback)(NSArray *items, NSString* errorText);

@interface ContactManager : NSObject
-(void) authorizationAddressBookCallback:(ArrayRetrieveCallback) callback;

+ (ContactManager *)sharedInstance;
@end
