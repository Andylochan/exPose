//
//  UseClarifai.m
//  exPose
//
//  Created by Alice Gamarnik on 4/22/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "exPose-Bridging-Header.h"

#import "ClarifaiApp.h"

@implementation ClarifaiObject

- (void) SomeMethod: (UIImage * )img{
    NSLog(@"ClarifaiModels Ran");
    
    ClarifaiApp *app = [[ClarifaiApp alloc] initWithApiKey:@"da75f627006347d0b9edd26fbf73babf"];
    
    ClarifaiImage *image = [[ClarifaiImage alloc] initWithImage:img];
    
    //general model
    [app getModelByName:@"general-v1.3" completion:^(ClarifaiModel *model, NSError *error) {
        [model predictOnImages:@[image] completion:^(NSArray<ClarifaiOutput *> *outputs, NSError *error) {
                        NSLog(@"outputs: %@", outputs);
                        for (ClarifaiConcept *concept in outputs[0].concepts) {
                            NSLog(@"tag: %@", concept.conceptName);
                            NSLog(@"probability: %f", concept.score);
                        }
                        /*
                        if (!error) {
                            ClarifaiOutput *output = outputs[0];
                            
                            // Loop through predicted concepts (tags), and display them on the screen.
                            NSMutableArray *tags = [NSMutableArray array];
                            for (ClarifaiConcept *concept in output.concepts) {
                                [tags addObject:concept.conceptName];
                            }
                        } else {
                            NSLog(@"Error: %@", error.description);
                        }
                         */
                    }];
    }];
    
    //color model
    [app getModelByID:@"eeed0b6733a644cea07cf4c60f87ebb7" completion:^(ClarifaiModel *model, NSError *error) {
        [model predictOnImages:@[image] completion:^(NSArray<ClarifaiOutput *> *outputs, NSError *error) {
                        NSLog(@"outputs: %@", outputs);
                        for (ClarifaiConcept *concept in outputs[0].concepts) {
                            NSLog(@"tag: %@", concept.conceptName);
                            NSLog(@"probability: %f", concept.score);
                        }
                    }];
    }];
    
    //landscape quality model
    [app getModelByID:@"bec14810deb94c40a05f1f0eb3c91403" completion:^(ClarifaiModel *model, NSError *error) {
        [model predictOnImages:@[image] completion:^(NSArray<ClarifaiOutput *> *outputs, NSError *error) {
                        NSLog(@"outputs: %@", outputs);
                        for (ClarifaiConcept *concept in outputs[0].concepts) {
                            NSLog(@"tag: %@", concept.conceptName);
                            NSLog(@"probability: %f", concept.score);
                        }
                    }];
    }];
    
    //focus model
    //ClarifaiImage *image = [[ClarifaiImage alloc] initWithURL:@"https://samples.clarifai.com/focus.jpg"];
    [app getModelByID:@"c2cf7cecd8a6427da375b9f35fcd2381" completion:^(ClarifaiModel *model, NSError *error) {
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
