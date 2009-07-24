//
//  iPhoneViewController.m
//  iPhone
//
//  Created by Kamel Makhloufi on 11/07/09.
//  Copyright melka 2009. All rights reserved.
//

#import "iPhoneViewController.h"

@implementation iPhoneViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ENTrackUploadProgress:) name:@"ENTrackUploadProgress" object:nil];
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
#pragma mark Enter Your EchoNest API Key here
	APIKey = [NSString stringWithString:@"yourAPIKey"];
	nest = [[EchoNest alloc] initWithAPIKey:APIKey];
	[drawingView setFrame:[[self view] frame]];
	[infosView setFrame:[[self view] frame]];
	[infosView setBackgroundColor:[UIColor clearColor]];
	[[self view] addSubview:infosView];
	
	[progressBar setHidden:YES];
}

#pragma mark EchoNest notifications

// ECHONEST GENERAL NOTIFICATIONS
-(void)ENKeyValidated:(NSNotification*)not {
	// Test if your api key is valid
	if ([[not object] boolValue]) {
		[labelInfos setText:@"EchoNest API Key valid"];
		[loader startAnimating];
		
		// 3 methods to get an analysis
		int method = 3;
		switch (method) {
			case 1 :
				// 1 - Uploading local MP3 file
				localMP3 = @"NAME OF THE FILE IN YOUR BUNDLE";
				[nest uploadFile:[[NSBundle mainBundle]  pathForResource:localMP3 ofType:@"mp3"]];
				[drawingView loadLocalMP3:[[NSBundle mainBundle] pathForResource:localMP3 ofType:@"mp3"]];
				break;
			case 2 :
				// 2 - Using a file on a server
				mp3url = @"URL OF THE FILE ON THE SERVER ex:http://www.melkaone.net/audio.mp3";
				[nest uploadURL:mp3url];
				[drawingView loadDistantMP3:mp3url];
				break;
			case 3 :
				// 3 - Using an already existing analysis
				// You must know the md5 hash of the file.
				trackMd5 = [NSString stringWithString:@"dc9f3021cd4cff17a7da2b73280eb998"]; // M.I.A. - Arular - Banana Skit
				[nest setTrackMD5:trackMd5];
				[nest initializeTrack];
				track = [nest track];
				[labelInfos setText:@"Track Initialized"];
				[track getDuration];
				break;
			default :
				break;
		}		
	} else {
		[labelInfos setText:@"Invalid API Key"];
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
		[labelInfos setText:@"Track Initialized"];
		[nest initializeTrack];
		track = [nest track];
		[track getDuration];
	}
}

-(void)ENTrackUploadStarted:(NSNotification*)not {
	// Beginning the upload of a local MP3 file
	[loader startAnimating];
	[labelInfos setTextColor:[UIColor blackColor]];
	[labelInfos setText:@"MP3 UPLOAD STARTED"];
	[progressBar setHidden:NO];
	[progressBar setProgress:0];
}
-(void)ENTrackUploadProgress:(NSNotification*)not {
	// Progress of the upload
	// [not object] is an NSNumber (float) between 0 and 1
	[progressBar setProgress:[[not object] floatValue]];
	if ([[not object] floatValue] == 1) {
		[labelInfos setText:@"Waiting for analysis"];
	}
}
-(void)ENTrackUploadFinished:(NSNotification*)not {
	// Called when the file has finished uploading
	// and the analysis is complete
	if ([[not object] boolValue]) {	
		[labelInfos setTextColor:[UIColor blackColor]];
		[labelInfos setText:@"MP3 UPLOAD FINISHED"];		
		// RETRIEVE THE TRACK OBJECT
		[nest initializeTrack];
		track = [nest track];
		[track getDuration];
		[labelInfos setText:@"Track Initialized"];
	}
	[progressBar setHidden:YES];
	[loader stopAnimating];
}
// ECHONEST TRACK NOTIFICATIONS
-(void)ENTrackBarsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object]  forType:@"bars"];
		[track getBeats];
	}
	[loader stopAnimating];
}
-(void)ENTrackBeatsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object]  forType:@"beats"];
		[track getTatums];
	}
	[loader stopAnimating];
}
-(void)ENTrackDurationLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[labelInfos setTextColor:[UIColor blackColor]];
		[labelInfos setText:[NSString stringWithFormat:@"Duration : %f seconds",[[not object] time]]];
		[drawingView setDuration:[[not object] time]];
		[track getMetadata];
	}
	[loader stopAnimating];
}
-(void)ENTrackEndOfFadeInLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setFadeInData:[not object]];
		[drawingView drawGraphics];
	}
	[loader stopAnimating];
}
-(void)ENTrackStartOfFadeOutLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setFadeOutData:[not object]];
		[drawingView drawGraphics];
		[track getSections];
	}
	[loader stopAnimating];
}
-(void)ENTrackKeyLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[not object] confidence];
		UIColor* c = [UIColor colorWithHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		[labelInfos setText:[NSString stringWithFormat:@"Key : %i",[[not object] key]]];
	}
	[loader stopAnimating];
}
-(void)ENTrackLoudnessLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[labelInfos setTextColor:[UIColor blackColor]];
		[labelInfos setText:[NSString stringWithFormat:@"Loudness : %fdB",[[not object] loudness]]];
	}
	[loader stopAnimating];
}
-(void)ENTrackMetadataLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		NSString* m = [NSString stringWithFormat:@"%@ - %@ : %@ : %@",[[not object] status], [[not object] artist],[[not object] album],[[not object] title]];
		[labelInfos setTextColor:[UIColor blackColor]];
		[labelInfos setText:m];
		[track getEndOfFadeIn];
		[track getStartOfFadeOut];
	}
	[loader stopAnimating];
}
-(void)ENTrackModeLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[not object] confidence];
		UIColor* c = [UIColor colorWithHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		NSString* mode;
		if ([[not object] mode] == 1) {
			mode = @"Major";
		} else {
			mode = @"Minor";
		}
		[labelInfos setText:[NSString stringWithFormat:@"Mode : %@",mode] ];
	}
	[loader stopAnimating];
}
-(void)ENTrackSectionsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object] forType:@"sections"];
		[track getBars];
	}
	[loader stopAnimating];
}
-(void)ENTrackSegmentsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object] forType:@"segments"];
	}
	[loader stopAnimating];
}
-(void)ENTrackTatumsLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		[drawingView setXmlData:[not object] forType:@"tatums"];
	}
	[loader stopAnimating];
}
-(void)ENTrackTempoLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[not object] confidence];
		UIColor* c = [UIColor colorWithHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		[labelInfos setText:[NSString stringWithFormat:@"Tempo : %f BPM",[[not object] tempo]]];
	}
	[loader stopAnimating];
}
-(void)ENTrackTimeSignatureLoaded:(NSNotification*)not {
	if ([[[not userInfo] valueForKey:@"success"] boolValue]) {
		float confidence = [[not object] confidence];
		UIColor* c = [UIColor colorWithHue:confidence/4 saturation:.8 brightness:1 alpha:1]; 
		[labelInfos setTextColor:c];
		[labelInfos setText:[NSString stringWithFormat:@"Time Signature : %f",[[not object] signature]]];
	}
	[loader stopAnimating];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	CGRect r = [[self view] frame];
	if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
		[drawingView setFrame:CGRectMake(0, 0, r.size.height, r.size.width)];
		//[infosView setFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
	} else if((self.interfaceOrientation == UIDeviceOrientationPortrait) || (self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)){
		[drawingView setFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
		//[infosView setFrame:CGRectMake(0, 0, r.size.width, r.size.height)];
	}
	[drawingView drawGraphics];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
