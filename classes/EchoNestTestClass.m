//
//  EchoNestTestClass.m
//  soundscapes 3D
//
//  Created by Kamel Makhloufi on 17/06/09.
//  Copyright 2009 melka. All rights reserved.
//

#import "EchoNestTestClass.h"
#import "MyView.h";

@implementation EchoNestTestClass

- (void)applicationDidFinishLaunching:(NSNotification *)not {
	NSLog(@"APPLICATION LAUNCHED");	
	/*
	 Here I used the Long Way
	 Each action (get_tatums, get_metadata, etc...) sends a notification.
	 You can either group all the notification to be sent to only one method.
	 -->	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackNotifications:) name:nil object:nil];
	 -->	then use :
	 -->	-(void)ENTrackNotifications:(NSNotification*)not {
	 -->		if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
	 -->			if ([[not name] isEqual:@"ENTrackBarsLoaded"]) {
	 -->				NSLog(@"ENTrackBarsLoaded");
	 -->				ACTION GOES HERE
	 -->			}
	 -->			if ([[not name] isEqual:@"ENTrackBeatsLoaded"]) {
	 -->				NSLog(@"ENTrackBeatsLoaded");
	 -->			}
	 -->			etc...
	 
	 Or as with the following notifications.
	 You should always keep the NEST notifications in separate methods, it will
	 be easier to deal with the HTTP data feeds for key validation and track upload.
	 This way you can be sure you're dealing with working data.
	*/
	
	// NEST NOTIFICATIONS
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENKeyValidated:) name:@"ENApiKeyIsValid" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENArtistFound:) name:@"ENArtistSearchFinished" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackUploadValidationFinished:) name:@"ENUploadValidationFinished" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackUploadStarted:) name:@"ENTrackUploadStarted" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackUploadFinished:) name:@"ENTrackUploadFinished" object:nil];
	// TRACK NOTIFICATIONS
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackBarsLoaded:) name:@"ENTrackBarsLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackBeatsLoaded:) name:@"ENTrackBeatsLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackDurationLoaded:) name:@"ENTrackDurationLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackEndOfFadeInLoaded:) name:@"ENTrackEndOfFadeInLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackKeyLoaded:) name:@"ENTrackKeyLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackLoudnessLoaded:) name:@"ENTrackLoudnessLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackMetadataLoaded:) name:@"ENTrackMetadataLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackModeLoaded:) name:@"ENTrackModeLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackSectionsLoaded:) name:@"ENTrackSectionsLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackSegmentsLoaded:) name:@"ENTrackSegmentsLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackStartOfFadeOutLoaded:) name:@"ENTrackStartOfFadeOutLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackTatumsLoaded:) name:@"ENTrackTatumsLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackTempoLoaded:) name:@"ENTrackTempoLoaded" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackTimeSignatureLoaded:) name:@"ENTrackTimeSignatureLoaded" object:nil];

	bars = NO;
	beats = NO;
	fades = NO;
	tatums = NO;
	sections = NO;	
	
#pragma mark Enter Your EchoNest API Key here
	APIKey = [NSString stringWithString:@"yourApiKey"];
	
	nest = [[EchoNest alloc] initWithAPIKey:APIKey];
	[loader startAnimation:nil];
}

#pragma mark Actions for Interface Builder buttons
// Action for the toolbar buttons
-(IBAction)loadBars:(id)sender {
	[loader startAnimation:nil];
	bars = YES;
	[track getBars];
}
-(IBAction)loadBeats:(id)sender {
	[loader startAnimation:nil];
	beats = YES;
	[track getBeats];
}
-(IBAction)loadDuration:(id)sender {
	[loader startAnimation:nil];
	[track getDuration];
}
-(IBAction)loadEndOfFadeIn:(id)sender {
	[loader startAnimation:nil];
	fades = YES;
	[track getEndOfFadeIn];
	[track getStartOfFadeOut];
}
-(IBAction)loadKey:(id)sender {
	[loader startAnimation:nil];
	[track getKey];
}
-(IBAction)loadLoudness:(id)sender {
	[loader startAnimation:nil];
	[track getLoudness];
}
-(IBAction)loadMetadata:(id)sender {
	[loader startAnimation:nil];
	[track getMetadata];
}
-(IBAction)loadMode:(id)sender {
	[loader startAnimation:nil];
	[track getMode];
}
-(IBAction)loadSections:(id)sender {
	[loader startAnimation:nil];
	sections = YES;
	[track getSections];
}
-(IBAction)loadSegments:(id)sender {
	[loader startAnimation:nil];
	[track getSegments];
}
-(IBAction)loadTatums:(id)sender {
	[loader startAnimation:nil];
	tatums = YES;
	[track getTatums];
}
-(IBAction)loadTempo:(id)sender {
	[loader startAnimation:nil];
	[track getTempo];
}
-(IBAction)loadTimeSignature:(id)sender {
	[loader startAnimation:nil];
	[track getTimeSignature];
}

// The bottom right button open a file dialog to
// upload a mp3 file
-(IBAction)uploadTrack:(id)sender {
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	NSArray* fileTypes = [NSArray arrayWithObjects:@"mp3",nil];
	[openDlg setPrompt:@"Load"];
	[openDlg setTitle:@"Select mp3 file"];
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	if ( [openDlg runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton )
	{
		NSArray* files = [openDlg filenames];
		int i;
		for( i = 0; i < [files count]; i++ )
		{
			fileName = [files objectAtIndex:i];
			// Sends the filename to the EchoNest object
			// it will upload the file to the server
			// and sends a notification when done
			[nest uploadFile:fileName];
			// Sends the file to the "drawing view"
			// That's were the loading and playing is done
			[drawingView initSound:fileName];
		}
	}
}

#pragma mark EchoNest notifications

// ECHONEST GENERAL NOTIFICATIONS
-(void)ENKeyValidated:(NSNotification*)not {
	// Test if your api key is valid	
	if ([[not object] boolValue]) {
		[labelInfos setTitleWithMnemonic:@"EchoNest API Key valid"];
		[loader startAnimation:nil];
	} else {
		[labelInfos setTitleWithMnemonic:@"Invalid API Key"];
	}
}
-(void)ENArtistFound:(NSNotification*)not {
	if ([[not object] boolValue]) {

	}
}
-(void)ENTrackUploadValidationFinished:(NSNotification*)not {
	// Sent if the file's MD5 hash was found on the
	// EchoNest server. Basically the same thing as 
	// ENTrackUploadFinished if the file was already
	// analyzed at some time.
	
	if ([[not object] boolValue]) {		
		// RETRIEVE THE TRACK OBJECT
		track = [nest track];
		// RETRIEVE INFOS FROM TRACK
		[track getMetadata];
		[track getSections];
		if (bars) {
			[track getBars];
		}
		if (beats) {
			[track getBeats];
		}
		if (fades) {
			[track getEndOfFadeIn];
			[track getStartOfFadeOut];
		}
		if (tatums) {
			[track getTatums];
		}
	}
}
-(void)ENTrackUploadStarted:(NSNotification*)not {
	[loader startAnimation:nil];
	[labelInfos setTextColor:[NSColor blackColor]];
	[labelInfos setTitleWithMnemonic:@"MP3 UPLOAD STARTED"];
}

-(void)ENTrackUploadFinished:(NSNotification*)not {
	if ([[not object] boolValue]) {		
		[labelInfos setTextColor:[NSColor blackColor]];
		[labelInfos setTitleWithMnemonic:@"MP3 UPLOAD FINISHED"];		
		// RETRIEVE THE TRACK OBJECT
		track = [nest track];
		// RETRIEVE INFOS FROM TRACK
		[track getMetadata];
		[track getSections];
		if (bars) {
			[track getBars];
		}
		if (beats) {
			[track getBeats];
		}
		if (fades) {
			[track getEndOfFadeIn];
			[track getStartOfFadeOut];
		}
		if (tatums) {
			[track getTatums];
		}
	}
	[loader stopAnimation:nil];
}
// ECHONEST TRACK NOTIFICATIONS
-(void)ENTrackBarsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object]  forType:@"bars"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackBeatsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object]  forType:@"beats"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackDurationLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[labelInfos setTextColor:[NSColor blackColor]];
		[labelInfos setTitleWithMnemonic:[NSString stringWithFormat:@"Duration : %@ seconds",[[[not object] objectAtIndex:0] stringValue]]];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackEndOfFadeInLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object]  forType:@"fadeIn"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackKeyLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[[[[not object] objectAtIndex:0] attributeForName:@"confidence"] stringValue] floatValue];
		NSColor* c = [NSColor colorWithCalibratedHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		[labelInfos setTitleWithMnemonic:[NSString stringWithFormat:@"Key : %@",[[[not object] objectAtIndex:0] stringValue]]];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackLoudnessLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[labelInfos setTextColor:[NSColor blackColor]];
		[labelInfos setTitleWithMnemonic:[NSString stringWithFormat:@"Loudness : %@dB",[[[not object] objectAtIndex:0] stringValue]]];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackMetadataLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		NSString* m = [NSString stringWithFormat:@"%@ - %@ : %@",[[[not object] objectAtIndex:3] stringValue], [[[not object] objectAtIndex:4] stringValue], [[[not object] objectAtIndex:5] stringValue]];
		[labelInfos setTextColor:[NSColor blackColor]];
		[labelInfos setTitleWithMnemonic:m];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackModeLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[[[[not object] objectAtIndex:0] attributeForName:@"confidence"] stringValue] floatValue];
		NSColor* c = [NSColor colorWithCalibratedHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		NSString* mode;
		if ([[[[not object] objectAtIndex:0] stringValue] intValue] == 1) {
			mode = @"Major";
		} else {
			mode = @"Minor";
		}
		[labelInfos setTitleWithMnemonic:[NSString stringWithFormat:@"Mode : %@",mode] ];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackSectionsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object] forType:@"sections"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackSegmentsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object] forType:@"segments"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackStartOfFadeOutLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object]  forType:@"fadeOut"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackTatumsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object] forType:@"tatums"];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackTempoLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[[[[not object] objectAtIndex:0] attributeForName:@"confidence"] stringValue] floatValue];
		NSColor* c = [NSColor colorWithCalibratedHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		[labelInfos setTitleWithMnemonic:[NSString stringWithFormat:@"Tempo : %@ BPM",[[[not object] objectAtIndex:0] stringValue]]];
	}
	[loader stopAnimation:nil];
}
-(void)ENTrackTimeSignatureLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[[[[not object] objectAtIndex:0] attributeForName:@"confidence"] stringValue] floatValue];
		NSColor* c = [NSColor colorWithCalibratedHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		[labelInfos setTitleWithMnemonic:[NSString stringWithFormat:@"Time Signature : %@",[[[not object] objectAtIndex:0] stringValue]]];
	}
	[loader stopAnimation:nil];
}

@end
