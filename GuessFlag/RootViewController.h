//
//  RootViewController.h
//  GuessFlag
//
//  Created by Lucas Torquato on 29/01/12.
//  Copyright 2012 T4 Desenvolvimento. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "ResultViewController.h"

@class RootTableViewCell;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, ResultViewDelegate>
{
    RootTableViewCell   *_rootTableViewCell;
    NSMutableArray      *players;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext     *managedObjectContext;

@property (nonatomic, retain) IBOutlet RootTableViewCell *rootTableViewCell;

- (void)startNewGame;
- (void)retrievePlayersFromDataBase;
- (void)orderPlayers:(NSMutableArray *)array;
- (void)configureCell:(RootTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configurationGame;

@end
