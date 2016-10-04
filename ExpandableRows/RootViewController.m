//
//  RootViewController.m
//
//  Created by Gaspare Novara on 19/06/13.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize firstArray,secondArray;
@synthesize firstForTable,secondForTable;
@synthesize rowsPerSection;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSDictionary *dTmp1 = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"first" ofType:@"plist"]];
    NSDictionary *dTmp2 = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"second" ofType:@"plist"]];
    
	self.firstArray = [dTmp1 valueForKey:@"Objects"];
    self.secondArray = [dTmp2 valueForKey:@"Objects"];
	
	self.rowsPerSection = [[NSMutableArray alloc] init];
	self.firstForTable = [[NSMutableArray alloc] init] ;
	[self.firstForTable addObjectsFromArray:self.firstArray];
    
    self.secondForTable = [[NSMutableArray alloc] init] ;
	[self.secondForTable addObjectsFromArray:self.secondArray];
    
    
	self.title = @"Sugartin.info";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case 0:
            rows = [self.firstForTable count];
            [self.rowsPerSection addObject:[NSNumber numberWithInteger:rows]];
			break;
        case 1:
            rows = [self.secondForTable count];
            [self.rowsPerSection addObject:[NSNumber numberWithInteger:rows]];
            break;
    }
    
    return rows;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionLabel;
    switch (section) {
        case 0:
            sectionLabel = @"First Section";
            break;
        case 1:
            sectionLabel = @"Second Section";
            break;
            
    }
    
    return sectionLabel;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
	
    if (indexPath.section == 0) {
        cell.textLabel.text = [[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell setIndentationLevel:[[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    } else {
        cell.textLabel.text = [[self.secondForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell setIndentationLevel:[[[self.secondForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    if (indexPath.section == 0) {
        
        NSInteger totalRows = [self.firstForTable count];
        NSDictionary *d = [self.firstForTable objectAtIndex:indexPath.row];
		
        if ([d valueForKey:@"Objects"]) {
            NSArray *ar = [d valueForKey:@"Objects"];
            
            BOOL isAlreadyInserted = NO;
            
            for (NSDictionary *dInner in ar) {
                NSInteger index=[self.firstForTable indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted = (index > 0 && index != NSIntegerMax);
				if (isAlreadyInserted) {
					break;
				}
            }
            
            if (isAlreadyInserted) {
                [self minimizeFirstsRows:ar];
            } else {
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells = [NSMutableArray array];
                for (NSDictionary *dInner in ar) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [self.firstForTable insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        } else {
            NSLog(@"Leave Element:::%@ %@|", [d valueForKey:@"name"], [d valueForKey:@"book"]);
        }
        
        if (indexPath.row == 0 && [self.firstForTable count] > [[self.rowsPerSection objectAtIndex:indexPath.section] integerValue]) {
            NSDictionary *d_ = [self.firstForTable objectAtIndex:3];
            NSArray *ar_ = [d_ valueForKey:@"Objects"];
            [self minimizeFirstsRows:ar_];
        } else if (indexPath.row + 1 == totalRows) {
            NSDictionary *d_ = [self.firstForTable objectAtIndex:0];
            NSArray *ar_ = [d_ valueForKey:@"Objects"];
            [self minimizeFirstsRows:ar_];
        }
        
        for (int i = 0; i < [[self.rowsPerSection objectAtIndex:indexPath.section] integerValue]; i++) {
            NSDictionary *d_ = [self.secondForTable objectAtIndex:i];
            NSArray *ar_ = [d_ valueForKey:@"Objects"];
            [self minimizeSecondsRows:ar_];
        }
    }
    
    if (indexPath.section == 1) {
        
        
        NSInteger totalRows = [self.secondForTable count];
        NSDictionary *d = [self.secondForTable objectAtIndex:indexPath.row];
		
        if ([d valueForKey:@"Objects"]) {
            NSArray *ar = [d valueForKey:@"Objects"];
            BOOL isAlreadyInserted = NO;
            
            for (NSDictionary *dInner in ar) {
                NSInteger index = [self.secondForTable indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted = (index > 0 && index != NSIntegerMax);
				if(isAlreadyInserted) {
					break;
				}
            }
            
            if (isAlreadyInserted) {
                [self minimizeSecondsRows:ar];
            } else {
                NSUInteger count = indexPath.row+1;
                NSMutableArray *arCells = [NSMutableArray array];
				
                for (NSDictionary *dInner in ar) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:1]];
                    [self.secondForTable insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        } else {
            NSLog(@"Leave Element:::%@ %@|", [d valueForKey:@"name"], [d valueForKey:@"book"]);
        }
        
        if (indexPath.row == 0 && [self.secondForTable count] > [[self.rowsPerSection objectAtIndex:indexPath.section] integerValue]) {
            NSDictionary *d_ = [self.secondForTable objectAtIndex:3];
            NSArray *ar_ = [d_ valueForKey:@"Objects"];
            [self minimizeSecondsRows:ar_];
        } else if (indexPath.row + 1 == totalRows) {
            NSDictionary *d_ = [self.secondForTable objectAtIndex:0];
            NSArray *ar_ = [d_ valueForKey:@"Objects"];
            [self minimizeSecondsRows:ar_];
        }
        
        for (int i = 0; i < [[self.rowsPerSection objectAtIndex:indexPath.section] integerValue]; i++) {
            NSDictionary *d_ = [self.firstForTable objectAtIndex:i];
            NSArray *ar_ = [d_ valueForKey:@"Objects"];
            [self minimizeFirstsRows:ar_];
        }
    }
}

- (void)minimizeFirstsRows:(NSArray*)ar
{
	for (NSDictionary *dInner in ar) {
		NSUInteger indexToRemove = [self.firstForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner = [dInner valueForKey:@"Objects"];
		if (arInner && [arInner count] > 0) {
			[self minimizeFirstsRows:arInner];
		}
		
		if ([self.firstForTable indexOfObjectIdenticalTo:dInner] != NSNotFound) {
			[self.firstForTable removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]]
								  withRowAnimation:UITableViewRowAnimationFade];
		}
	}
}


- (void)minimizeSecondsRows:(NSArray*)ar
{
	for (NSDictionary *dInner in ar) {
		NSUInteger indexToRemove = [self.secondForTable indexOfObjectIdenticalTo:dInner];
		NSArray *arInner = [dInner valueForKey:@"Objects"];
		if (arInner && [arInner count] > 0) {
			[self minimizeSecondsRows:arInner];
		}
		
		if ([self.secondForTable indexOfObjectIdenticalTo:dInner] != NSNotFound) {
			[self.secondForTable removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:1]]
                                  withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}



@end
