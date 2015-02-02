//
//  NSArray+Filter.h
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ArrayFilterCallback)(NSArray *correctCity, NSArray *otherCity);

@interface NSArray (Filter)
+(NSArray*) searchByText:(NSString*)searchText array:(NSArray*)array;

-(void) filterArrayByCity:(NSString*)cityName contactArray:(NSArray*)contactArray callback:(ArrayFilterCallback) callback;
-(void) filterArrayCurrentCityWithArray:(NSArray*)contactArray callback:(ArrayFilterCallback) callback;

@end
