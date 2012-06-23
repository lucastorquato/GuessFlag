//
//  RootTableViewCell.h
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell
{
    UILabel *namePlayerLabel;
    UILabel *scorePlayerLabel;
    
    UILabel *placePlayerLabel;
}

@property(nonatomic, retain) IBOutlet UILabel *namePlayerLabel;
@property(nonatomic, retain) IBOutlet UILabel *scorePlayerLabel;
@property(nonatomic, retain) IBOutlet UILabel *placePlayerLabel;
@end
