//
//  ELCAssetTablePickerViewController.h
//  ELCImagePickerDemo
//
//  Created by levin on 13-3-16.
//  Copyright (c) 2013年 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class ELCAsset;
@interface ELCAssetTablePickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
	ALAssetsGroup *assetGroup;
	
	NSMutableArray *elcAssets;
    NSMutableArray *elcSelectedAssets;
	int selectedAssets;
	
	id parent;
	
	NSOperationQueue *queue;
    IBOutlet UIScrollView *selectedContainer;
    IBOutlet UITableView *tableView;
}
@property (retain, nonatomic) IBOutlet UIScrollView *selectedContainer;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id parent;
@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;

-(int)totalSelectedAssets;
-(void)preparePhotos;
-(void)resetSelectPhoto;
-(void)addSelectedAssets:(ELCAsset*)asset;
-(void)removeSelectedAssets:(ELCAsset*)asset;
-(void)doneAction:(id)sender;


@end
