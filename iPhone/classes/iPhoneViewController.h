//
//  iPhoneViewController.h
//  iPhone
//
//  Created by Kamel Makhloufi on 11/07/09.
//  Copyright melka 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EchoNest.h"
#import "ENTrack.h"

#import "MyUIView.h"

@interface iPhoneViewController : UIViewController {
	NSString* APIKey;
	EchoNest* nest;
	ENTrack* track;
	NSString* mp3url;
	NSString* localMP3;
	NSString* trackMd5;
	IBOutlet id loader;
	IBOutlet id labelInfos;
	IBOutlet id drawingView;
	IBOutlet id infosView;
	IBOutlet id progressBar;
}

@end

