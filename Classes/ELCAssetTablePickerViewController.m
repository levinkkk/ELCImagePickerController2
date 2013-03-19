//
//  ELCAssetTablePickerViewController.m
//  ELCImagePickerDemo
//
//  Created by levin on 13-3-16.
//  Copyright (c) 2013年 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePickerViewController.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"

@interface ELCAssetTablePickerViewController ()

@end

@implementation ELCAssetTablePickerViewController


@synthesize parent;
@synthesize selectedAssetsLabel;
@synthesize assetGroup, elcAssets;
@synthesize tableView;
@synthesize selectedContainer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    
	[self.tableView setSeparatorColor:[UIColor clearColor]];
	[self.tableView setAllowsSelection:NO];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [tempArray release];
	elcSelectedAssets= [[NSMutableArray alloc] init];
    
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
	[self.navigationItem setRightBarButtonItem:doneButtonItem];
	[self.navigationItem setTitle:@"Loading..."];
    
	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    //    selectedContainer =[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-70, 320, 50)];
    //    [selectedContainer setBackgroundColor:[UIColor yellowColor]];
    //    [self.view  addSubview:selectedContainer];
    //    [self.tableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-70)];
    // Show partial while full list loads
    [selectedContainer setShowsHorizontalScrollIndicator:NO];
	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
}

-(void)preparePhotos {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	
    NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result == nil)
         {
             return;
         }
         
         ELCAsset *elcAsset = [[[ELCAsset alloc] initWithAsset:result] autorelease];
         [elcAsset setParent:self];
         [self.elcAssets addObject:elcAsset];
     }];
    NSLog(@"done enumerating photos");
	
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Pick Photos"];
    
    [pool release];
    
}

- (void) doneAction:(id)sender {
	
	NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
    
	for(ELCAsset *elcAsset in self.elcAssets)
    {
		if([elcAsset selected]) {
			
			[selectedAssetsImages addObject:[elcAsset asset]];
		}
	}
    
    [(ELCAlbumPickerController*)self.parent selectedAssets:selectedAssetsImages];
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([self.assetGroup numberOfAssets] / 4.0);
}

- (NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    
	if(maxIndex < [self.elcAssets count]) {
        
		return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
				[self.elcAssets objectAtIndex:index+1],
				[self.elcAssets objectAtIndex:index+2],
				[self.elcAssets objectAtIndex:index+3],
				nil];
	}
    
	else if(maxIndex-1 < [self.elcAssets count]) {
        
		return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
				[self.elcAssets objectAtIndex:index+1],
				[self.elcAssets objectAtIndex:index+2],
				nil];
	}
    
	else if(maxIndex-2 < [self.elcAssets count]) {
        
		return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
				[self.elcAssets objectAtIndex:index+1],
				nil];
	}
    
	else if(maxIndex-3 < [self.elcAssets count]) {
        
		return [NSArray arrayWithObject:[self.elcAssets objectAtIndex:index]];
	}
    
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ELCAssetCell *cell = (ELCAssetCell*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }
	else
    {
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

- (int)totalSelectedAssets {
    
//    int count = 0;
//    
//    for(ELCAsset *asset in self.elcAssets)
//    {
//		if([asset selected])
//        {
//            count++;
//		}
//	}
    
//    return count;
    return [elcSelectedAssets count];
}
-(IBAction)removeSelfSelectedAssets:(id)sender{
    ELCAsset *btn=(ELCAsset*)sender;
    [self removeSelectedAssetsByIndex:btn.tag];
    [self resetSelectPhoto];
}
-(void)addSelectedAssets:(ELCAsset*)asset{
    [elcSelectedAssets addObject:asset];
    
}
-(void)removeSelectedAssetsByIndex:(int)index{
    [elcSelectedAssets removeObjectAtIndex:index];
    
}
-(void)removeSelectedAssets:(ELCAsset*)asset{
    [elcSelectedAssets removeObject:asset];
    
}
-(void)resetSelectPhoto
{
    for (UIView *subview in selectedContainer.subviews) {
        if ([subview isKindOfClass:[ELCAsset class]]) {
            [subview removeFromSuperview];
        }
    }
    int count = 0;
    for(ELCAsset *asset in elcSelectedAssets)
    {
        // NSLog(@"00");
//		if([asset selected])
//        {
          //   NSLog(@"33");
            ELCAsset *assetImageView = [[ELCAsset alloc]initWithAsset2:asset.asset] ;
            [assetImageView setFrame:CGRectMake(count*80+3, 3, 80,80)];
            [assetImageView setSelected:YES];
            [assetImageView setTag:count];
            [assetImageView addTarget:self action:@selector(removeSelfSelectedAssets:) forControlEvents:UIControlEventTouchUpInside];
            [selectedContainer addSubview:assetImageView];
            [assetImageView release];
            count++;
//		}
	}
    [selectedContainer setContentSize:CGSizeMake(count*83, 80)];
    if (count>=5) {
        [selectedContainer setContentOffset:CGPointMake(80, 0) animated:YES];
    }
}
- (void)dealloc
{
    [elcSelectedAssets release];
    [elcAssets release];
    [selectedAssetsLabel release];
    [selectedContainer release];
    [tableView release];
    [super dealloc];
}


@end
