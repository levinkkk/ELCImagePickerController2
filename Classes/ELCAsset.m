//
//  Asset.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"
#import "ELCAssetTablePickerViewController.h"
@implementation ELCAsset

@synthesize asset;
@synthesize parent;
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		self.asset = _asset;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;	
}
-(id)initWithAsset2:(ALAsset*)_asset {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		self.asset = _asset;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay2.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;
}
//-(void) removeSelectedAssets{
//    ELCAssetTablePickerViewController *parentView=(ELCAssetTablePickerViewController*)self.parent;
//   // [parentView.elcAssets removeObject:self];
//    [parentView resetSelectPhoto:self];
//}
-(void)toggleSelection {
    
	overlayView.hidden = !overlayView.hidden;
    
    ELCAssetTablePickerViewController *parentView=(ELCAssetTablePickerViewController*)self.parent;
    
    if([parentView totalSelectedAssets] >=5) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum Reached" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alert show];
		[alert release];	
        overlayView.hidden = !overlayView.hidden;
        //[(ELCAssetTablePicker*)self.parent doneAction:nil];
    }
    else{
        if (overlayView.hidden==NO) {
             [parentView addSelectedAssets:self];
        }else{
            [parentView removeSelectedAssets:self];
        }
        
        [parentView resetSelectPhoto];
    }
}

-(BOOL)selected {
	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[overlayView setHidden:!_selected];
}

- (void)dealloc 
{    
    self.asset = nil;
	[overlayView release];
    [super dealloc];
}

@end

