//
//  Asset.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ELCAsset : UIButton {
	ALAsset *asset;
	UIImageView *overlayView;
	BOOL selected;
	id parent;
}

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id parent;

-(id)initWithAsset:(ALAsset*)_asset;
-(id)initWithAsset2:(ALAsset*)_asset;
-(void)setSelected:(BOOL)_selected;
-(BOOL)selected;

@end