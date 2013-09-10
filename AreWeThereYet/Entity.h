//
//  Entity.h
//  AreWeThereYet
//
//  Created by Xiaoyi Cai on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * laititude;
@property (nonatomic, retain) NSNumber * longititude;
@property (nonatomic, retain) NSNumber * proximity;

@end
