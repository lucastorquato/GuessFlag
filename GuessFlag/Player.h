//
//  Jogador.h
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright (c) 2012 T4 Desenvolvimento. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * name;

@end
