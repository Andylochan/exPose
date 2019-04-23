//
//  ClarifaiModel.m
//  exPose
//
//  Created by Alice Gamarnik on 4/17/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "exPose-Bridging-Header.h"
#import "ClarifaiApp.h"

@implementation ClarifaiModels : NSObject

- (void) someMethod {
    NSLog(@"SomeMethod Ran");

    ClarifaiApp *app = [[ClarifaiApp alloc] initWithApiKey:@"da75f627006347d0b9edd26fbf73babf"];
    
    //color model
    ClarifaiImage *image = [[ClarifaiImage alloc] initWithURL:@"https://samples.clarifai.com/metro-north.jpg"];
    [app getModelByName:@"color" completion:^(ClarifaiModels *model, NSError *error) {
        [model predictOnImages:@[image]
                    completion:^(NSArray<ClarifaiSearchResult *> *outputs, NSError *error) {
                        NSLog(@"outputs: %@", outputs);
                    }];
    }];
    
    //focus model
    //ClarifaiImage *image = [[ClarifaiImage alloc] initWithURL:@"https://samples.clarifai.com/focus.jpg"];
    [app getModelByID:@"c2cf7cecd8a6427da375b9f35fcd2381" completion:^(ClarifaiModels *model, NSError *error) {
        [model predictOnImages:@[image]
                    completion:^(NSArray<ClarifaiSearchResult *> *outputs, NSError *error) {
                        // Cast each output to be ClarifaiOutputFocus type. Each detected region will have cooresponding focus density.
                        if ([outputs[0] isKindOfClass:[ClarifaiOutputFocus class]]) {
                            NSLog(@"Focus density: %f", ((ClarifaiOutputFocus *)outputs[0]).focusDensity);
                            for (ClarifaiOutputRegion *box in ((ClarifaiOutputFocus *)outputs[0]).focusRegions) {
                                NSLog(@"boundingBox: %f, %f, %f, %f", box.top, box.left, box.bottom, box.right);
                                NSLog(@"focus density of region: %f", box.focusDensity);
                            }
                        }
                    }];
    }];

}

@end
