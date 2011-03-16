//
//  Song.h
//  Pithos
//
//  Created by Alex Crichton on 3/12/11.
//  Copyright 2011 Carnegie Mellon University. All rights reserved.
//

@interface Song : NSObject {

}

@property (retain) NSString *artist;
@property (retain) NSString *title;
@property (retain) NSString *art;
@property (retain) NSString *url;
@property (retain) NSString *stationId;
@property (retain) NSString *musicId;
@property (retain) NSString *userSeed;
@property (retain) NSString *rating;
@property (retain) NSString *songType;
@property (retain) NSString *albumUrl;
@property (retain) NSString *artistUrl;
@property (retain) NSString *titleUrl;

+ (NSString*) decryptURL: (NSString*) url;

@end