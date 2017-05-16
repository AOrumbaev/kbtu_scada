#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KRMLPActivation.h"
#import "KRMLP.h"
#import "KRMLPHiddenLayer.h"
#import "KRMLPInputLayer.h"
#import "KRMLPLayer.h"
#import "KRMLPCost.h"
#import "KRMLPOutputLayer.h"
#import "KRMLPHiddenNet.h"
#import "KRMLPNet.h"
#import "KRMLPOutputNet.h"
#import "KRMLPInertia.h"
#import "KRMLPOptimization.h"
#import "KRMLPNetworkOutput.h"
#import "KRMLPResult.h"
#import "KRMLPTrainingOutput.h"
#import "KRMLPPattern.h"
#import "KRMLPFetcher.h"
#import "KRMLPPassed.h"
#import "KRMathLib.h"

FOUNDATION_EXPORT double KRMLPVersionNumber;
FOUNDATION_EXPORT const unsigned char KRMLPVersionString[];

