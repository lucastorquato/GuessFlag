//
//  RootTableViewCell.m
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell

@synthesize namePlayerLabel, scorePlayerLabel, placePlayerLabel;

-(void)dealloc
{
    [namePlayerLabel release];
    [scorePlayerLabel release];
    [placePlayerLabel release];
    [super dealloc];
}


@end
