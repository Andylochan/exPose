//
//  UseClarifai.h
//  exPose
//
//  Created by Alice Gamarnik on 4/29/19.
//  Copyright © 2019 Andy Lochan. All rights reserved.
//

#ifndef UseClarifai_h
#define UseClarifai_h
#import <Foundation/Foundation.h>
#import "exPose-Bridging-Header.h"

#import "ClarifaiApp.h"

//@class ClarifaiObject;

@interface ClarifaiObject : NSObject
    
    //@property (strong, nonatomic) id someProperty;
    
- (void) SomeMethod:(UIImage * )img;
    
    @end

#endif /* UseClarifai_h */
