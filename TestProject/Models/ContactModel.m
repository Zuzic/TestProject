//
//  ContactModel.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

-(id) initContactModel{
    self = [super init];
    
    if(self){
        self.firstName = @"";
        self.lastName = @"";
        self.city = @"";
        self.email = @"test@test.com";
    }
    
    return self;
}

@end
