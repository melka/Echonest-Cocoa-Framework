//
//  ENArtist.m
//  EchoNest
// 
// The Echo Nest API Objective-C library
// http://the.echonest.com/
// Copyright (C) 2009 melka - Kamel Makhloufi
// http://melka.one.free.fr/blog/

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


#import "ENArtist.h"


@implementation ENArtist

- (id) initWithArtistId:(NSString*)artistID {
	self = [super init];
	if (self != nil) {
		NSLog(@"%@",artistID);
	}
	return self;
}

@end
