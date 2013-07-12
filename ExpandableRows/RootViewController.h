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

-(void)miniMizeFirstsRows:(NSArray*)ar;
-(void)miniMizeSecondsRows:(NSArray*)ar;

@end
