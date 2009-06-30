//
//  EchoNest.m
//  EchoNest
//
//  Created by Kamel Makhloufi on 17/06/09.
//  Copyright 2009 melka. All rights reserved.
//

#import "EchoNest.h"


// PRIVATE DECLARATIONS

@interface EchoNest (hidden)

-(BOOL) apiKeyIsValid;
-(void) setApiKeyIsValid:(BOOL)input;
@end

@implementation EchoNest (hidden)

-(BOOL) apiKeyIsValid {
	if (apiKeyIsValid == NO)
		NSLog(@"API KEY IS NOT VALID");
	return apiKeyIsValid;
}
-(void) setApiKeyIsValid:(BOOL)input {
	if (!input) {
		NSLog(@"WARNING");
		NSLog(@"API KEY IS NOT VALID");
	} else {
		NSLog(@"VALID API KEY");
	}
	apiKeyIsValid = input;
}

@end

// PUBLIC DECLARATIONS

@implementation EchoNest

@synthesize apiKey;
@synthesize artistId;
@synthesize trackMD5;
@synthesize baseUrl;
@synthesize filePath;

-(id) initWithAPIKey:(NSString*)APIKey andArtistID:(NSString*)artistID andTrackMD5:(NSString*)trackMd5 {
	self = [super init];
	if (self != nil) {
		[self setApiKey:APIKey];
		[self setArtistId:artistID];
		[self setTrackMD5:trackMd5];
		[self setBaseUrl:@"http://developer.echonest.com/api/"];
		req = [[NSMutableURLRequest alloc] init];
		[req setHTTPMethod:@"GET"];
		[req setValue:@"EchoNestCocoaFramework/Alpha1" forHTTPHeaderField:@"User-Agent"];
		if ([self apiKey]==nil) {
			NSLog(@"WARNING");
			NSLog(@"API KEY NOT SET");
			NSLog(@"YOU CANNOT DO ANYTHING WITHOUT THE KEY");
			NSLog(@"PLEASE GET SURE TO USE [<EchoNest> validateApiKey] AFTER SETTING IT");
		} else {
			[self validateApiKey];
		}
	}
	return self;
}
-(id) initWithAPIKey:(NSString*)APIKey andArtistID:(NSString*)artistID {
	return [self initWithAPIKey:APIKey andArtistID:artistID andTrackMD5:nil];
}
-(id) initWithAPIKey:(NSString*)APIKey {
	return [self initWithAPIKey:APIKey andArtistID:nil];
}
-(id) init {
	return [self initWithAPIKey:nil];
}


-(void) validateApiKey {
	NSLog(@"VALIDATING API KEY");
	apiKeyValidationData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_duration?api_key=%@",[self baseUrl],[self apiKey]]];
	[req setURL:url];
	apiKeyValidationConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void) searchArtistWithString:(NSString*)input {
	if ([self apiKeyIsValid]) {
		NSLog(@"SEARCHING ARTIST : %@",[self urlencode:input]);
		artistSearchData = [[NSMutableData alloc] init];
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@search_artists?api_key=%@&query=%@&version=3",[self baseUrl],[self apiKey], [self urlencode:input]]];
		[req setURL:url];
		artistSearchConnection = [NSURLConnection connectionWithRequest:req delegate:self];
	};
}
-(void) searchTracksWithString:(NSString*)input {
	if ([self apiKeyIsValid]) {
		NSLog(@"SEARCHING TRACK : %@",[self urlencode:input]);
		trackSearchData = [[NSMutableData alloc] init];
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@search_tracks?api_key=%@&query=%@&version=3",[self baseUrl],[self apiKey], [self urlencode:input]]];
		[req setURL:url];
		trackSearchConnection = [NSURLConnection connectionWithRequest:req delegate:self];
	};
}
-(void) initializeArtist {
	artist = [[ENArtist alloc] initWithArtistId:artistId];
}
-(void) initializeTrack {
	NSLog(@"INIT TRACK");
	track = [[ENTrack alloc] initWithApiKey:[self apiKey] andTrackMD5:[self trackMD5]];
}
-(void) uploadFile:(NSString*)path {
	[self setFilePath:path];
	trackUploadData = [NSData dataWithContentsOfFile:path];
	unsigned char* digest = MD5([trackUploadData bytes], [trackUploadData length], NULL);
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						digest[0], digest[1], 
						digest[2], digest[3],
						digest[4], digest[5],
						digest[6], digest[7],
						digest[8], digest[9],
						digest[10], digest[11],
						digest[12], digest[13],
						digest[14], digest[15]];
	[self setTrackMD5:s];
	trackUploadValidationData = [[NSMutableData alloc] init];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_key?api_key=%@&md5=%@&version=3",[self baseUrl],[self apiKey],s]];
	[req setURL:url];
	trackUploadValidationConnection = [NSURLConnection connectionWithRequest:req delegate:self];
}
-(void) uploadData {
	
	trackUploadResponseData = [[NSMutableData alloc] init];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@upload",[self baseUrl]]];
	
	NSMutableURLRequest* up = [NSMutableURLRequest requestWithURL:url];
	NSString* boundary = @"------------------------xHtMlBoUnDaRy4CoCoAFraMewOrk";
	[up setHTTPMethod:@"POST"];
	[up setValue:@"EchoNestCocoaFramework/Alpha1" forHTTPHeaderField:@"User-Agent"];
	[up addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	// ADDING API KEY
	[postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"api_key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:apiKey] dataUsingEncoding:NSUTF8StringEncoding]];
	// VERSION 3
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"version\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"3"] dataUsingEncoding:NSUTF8StringEncoding]];
	// WAIT FOR ANALYSIS TO COMPLETE
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"wait\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Y"] dataUsingEncoding:NSUTF8StringEncoding]];
	// ADDING FILE INFOS
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", [filePath lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Type: audio/mpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	// ADDING FILE DATA
	[postBody appendData:[NSData dataWithContentsOfFile:filePath]];
	// CLOSING THE HTTP BODY
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[up setHTTPBody:postBody];
	trackUploadConnection = [NSURLConnection connectionWithRequest:up delegate:self];
	NSNotification* not = [NSNotification notificationWithName:@"ENTrackUploadStarted" object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:not];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response{
	if ([connection isEqual:apiKeyValidationConnection]) {
		NSLog(@"URLCONNECTION TYPE : VALIDATION");
	}
	if ([connection isEqual:artistSearchConnection]) {
		NSLog(@"URLCONNECTION TYPE : ARTIST SEARCH");
	}
	if ([connection isEqual:trackUploadConnection]) {
		NSLog(@"URLCONNECTION TYPE : TRACK UPLOAD");
	}
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog(@"URL DATA%@",data);
	if ([connection isEqual:apiKeyValidationConnection]) {
		[apiKeyValidationData appendData:data];
	}
	if ([connection isEqual:artistSearchConnection]) {
		[artistSearchData appendData:data];
	}
	if ([connection isEqual:trackUploadValidationConnection]) {
		[trackUploadValidationData appendData:data];
	}
	if ([connection isEqual:trackUploadConnection]) {
		[trackUploadResponseData appendData:data];
	}
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSNotification* not;
	NSNumber* success;
	if ([connection isEqual:apiKeyValidationConnection]) {
		NSXMLDocument* xml = [[NSXMLDocument alloc] initWithData:apiKeyValidationData options:NSXMLDocumentTidyXML error:nil];
		NSArray* valid = [xml objectsForXQuery:@"for $p in .//response/status/message\nwhere $p/text()=\"Invalid API key\"return $p" error:nil];
		if ([valid count] == 1) {
			[self setApiKeyIsValid:NO];
			success = [NSNumber numberWithBool:NO];
		} else {
			[self setApiKeyIsValid:YES];
			success = [NSNumber numberWithBool:YES];
		}
		not = [NSNotification notificationWithName:@"ENApiKeyIsValid" object:success];
	}
	if ([connection isEqual:artistSearchConnection]) {
		NSXMLDocument* xml = [[NSXMLDocument alloc] initWithData:artistSearchData options:NSXMLDocumentTidyXML error:nil];
		NSArray* ids = [xml objectsForXQuery:@"for $p in .//response/artists/artist/id/text()\nreturn $p" error:nil];
		NSArray* names = [xml objectsForXQuery:@"for $p in .//response/artists/artist/name/text()\nreturn $p" error:nil];
		NSDictionary* xmlValues = [NSDictionary dictionaryWithObjects:ids forKeys:names];
		if ([names count] >= 1) {
			success = [NSNumber numberWithBool:YES];
		} else {
			success = [NSNumber numberWithBool:NO];
		}
		not = [NSNotification notificationWithName:@"ENArtistSearchFinished" object:success userInfo:xmlValues];
	}
	if ([connection isEqual:trackUploadValidationConnection]) {
		NSXMLDocument* xml = [[NSXMLDocument alloc] initWithData:trackUploadValidationData options:NSXMLDocumentTidyXML error:nil];
		NSArray* valid = [xml objectsForXQuery:@"for $p in .//response/status/message\nwhere $p/text()=\"Success\"return $p" error:nil];
		if ([valid count] == 1) {
			success = [NSNumber numberWithBool:YES];
			[self initializeTrack];
		} else {
			success = [NSNumber numberWithBool:NO];
			[self uploadData];
		}
		not = [NSNotification notificationWithName:@"ENUploadValidationFinished" object:success];
	}
	if ([connection isEqual:trackUploadConnection]) {
		NSXMLDocument* xml = [[NSXMLDocument alloc] initWithData:trackUploadResponseData options:NSXMLDocumentTidyXML error:nil];
		NSArray* valid = [xml objectsForXQuery:@"for $p in .//response/status/message\nwhere $p/text()=\"Success\"return $p" error:nil];
		if ([valid count] == 1) {
			success = [NSNumber numberWithBool:YES];
			[self initializeTrack];
		} else {
			success = [NSNumber numberWithBool:NO];
		}
		not = [NSNotification notificationWithName:@"ENTrackUploadFinished" object:success];
	}
	[[NSNotificationCenter defaultCenter] postNotification:not];
}

-(ENTrack*)track{	return track; }
-(ENArtist*)artist {	return artist; }

-(void) dealloc {
	[apiKey release];
	[artistId release];
	[trackMD5 release];
	[super dealloc];
}

///////////////////////
// UTILITY FUNCTIONS //
///////////////////////

//simple API that encodes reserved characters according to:
//RFC 3986
//http://tools.ietf.org/html/rfc3986
//http://mesh.typepad.com/blog/2007/10/url-encoding-wi.html
-(NSString *) urlencode: (NSString *) url {
	NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
									@"@" , @"&" , @"=" , @"+" ,
									@"$" , @"," , @"[" , @"]",
									@"#", @"!", @"'", @"(", 
									@")", @"*", @" ", nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
									 @"%3A" , @"%40" , @"%26" ,
									 @"%3D" , @"%2B" , @"%24" ,
									 @"%2C" , @"%5B" , @"%5D", 
									 @"%23", @"%21", @"%27",
									 @"%28", @"%29", @"%2A", @"%20", nil];
	
	int len = [escapeChars count];
	
	NSMutableString *temp = [url mutableCopy];
	
	int i;
	for(i = 0; i < len; i++)
	{
		
		[temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
									 withString:[replaceChars objectAtIndex:i]
										 options:NSLiteralSearch
											range:NSMakeRange(0, [temp length])];
	}
	
	NSString *out = [NSString stringWithString: temp];
	
	return out;
}

@end