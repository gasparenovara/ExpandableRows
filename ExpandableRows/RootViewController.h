//
//  RootViewController.m
//
//  Created by Gaspare Novara on 19/06/13.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	
}

@property (nonatomic, retain) NSArray *firstArray;
@property (nonatomic, retain) NSArray *secondArray;

@property (nonatomic, retain) NSMutableArray *firstForTable;
@property (nonatomic, retain) NSMutableArray *secondForTable;
@property (nonatomic, retain) NSMutableArray *rowsPerSection;

- (void)minimizeFirstsRows:(NSArray*)ar;
- (void)minimizeSecondsRows:(NSArray*)ar;

@end
