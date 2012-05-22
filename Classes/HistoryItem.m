//
//  HistoryItem.m
//  Hermes
//
//  Created by Alex Crichton on 10/10/11.
//

#import "HistoryItem.h"
#import "Song.h"
#import "Pandora.h"

@implementation HistoryItem

- (Pandora*) pandora {
  return [[NSApp delegate] pandora];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction) like:(id)sender {
  Song* s = [self representedObject];
  [[self pandora] rateSong:s as:YES];
  [like setEnabled:NO];
  [dislike setEnabled:YES];
}

- (IBAction) dislike:(id)sender {
  Song* s = [self representedObject];
  [[self pandora] rateSong:s as:NO];
  [like setEnabled:YES];
  [dislike setEnabled:NO];
}

- (IBAction)gotoTitle:(id)sender {
  NSURL *url = [NSURL URLWithString:[[self representedObject] titleUrl]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)gotoArtist:(id)sender {
  NSURL *url = [NSURL URLWithString:[[self representedObject] artistUrl]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)gotoAlbum:(id)sender {
  NSURL *url = [NSURL URLWithString:[[self representedObject] albumUrl]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void) imageLoaded: (NSNotification*) not {
  if ([not object] != loader) {
    return;
  }
  NSImage *image = [[NSImage alloc] initWithData: [loader data]];
  [art setImage:image];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateUI {
  if (art == nil || [self representedObject] == nil) {
    return;
  }

  Song *s = [self representedObject];
  NSString *a = [s art];
  if (a && ![a isEqual:@""]) {
    if (loader != nil) {
      [[NSNotificationCenter defaultCenter]
       removeObserver:self name:@"image-loaded" object:loader];
      loader = nil;
    }
    loader = [[ImageLoader alloc] init];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(imageLoaded:)
     name:@"image-loaded"
     object:loader];
    [loader loadImageURL:a];
  }

  [like setEnabled:YES];
  [dislike setEnabled:YES];
  if ([[s nrating] intValue] == 1) {
    [like setEnabled:NO];
  } else if ([[s nrating] intValue] == -1) {
    [dislike setEnabled:NO];
  }
}

- (void) trySetFromView {
  NSView *view = [self view];
  if (view == nil) {
    return;
  }

  loader = nil;

  art = nil;
  like = dislike = nil;
  for (NSView *view in [[self view] subviews]) {
    if ([view isKindOfClass:[NSButton class]]) {
      NSButton *button = (NSButton*) view;
      if ([[button alternateTitle] isEqual:@"Like"]) {
        like = button;
      } else if ([[button alternateTitle] isEqual:@"Dislike"]) {
        dislike = button;
      } else if ([[button alternateTitle] isEqual:@"Album"]) {
        art = button;
      }
    }
  }
  assert(art);
  assert(like);
  assert(dislike);
}

- (void) setView:(NSView *)view {
  [super setView:view];
  [self trySetFromView];
}

- (void) setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
  [self trySetFromView];
  [self updateUI];
}

@end