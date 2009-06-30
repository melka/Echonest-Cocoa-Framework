//
//  EchoNestTestClass.h
//  soundscapes 3D
//
//  Created by Kamel Makhloufi on 17/06/09.
//  Copyright 2009 melka. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EchoNest.h"

@interface EchoNestTestClass : NSObject {
	// ECHONEST
	EchoNest*		nest;
	ENTrack*			track;
	
	// XML LOADING
	NSString*		APIKey;
	
	// HOLDS THE NAME OF THE MP3
	// WE WANT TO ANALYZE
	NSString*		fileName;
	
	// VISUALISATIONS ELEMENTS
	// I USE THESE BOOLEANS TO
	// REDRAW ONLY THE SELECTED
	// ELEMENTS WHEN CHANGING TRACKS
	BOOL				bars;
	BOOL				beats;
	BOOL				fades;
	BOOL				tatums;
	BOOL				sections;
	
	// INTERFACE BUILDER CONNECTIONS
	IBOutlet id		drawingView;
	IBOutlet id		labelInfos;
	IBOutlet id		loader;
}

-(IBAction)loadBars:(id)sender;
-(IBAction)loadBeats:(id)sender;
-(IBAction)loadDuration:(id)sender;
-(IBAction)loadEndOfFadeIn:(id)sender;
-(IBAction)loadKey:(id)sender;
-(IBAction)loadLoudness:(id)sender;
-(IBAction)loadMetadata:(id)sender;
-(IBAction)loadMode:(id)sender;
-(IBAction)loadSections:(id)sender;
-(IBAction)loadSegments:(id)sender;
-(IBAction)loadTatums:(id)sender;
-(IBAction)loadTempo:(id)sender;
-(IBAction)loadTimeSignature:(id)sender;
-(IBAction)uploadTrack:(id)sender;

@end
