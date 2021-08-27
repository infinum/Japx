//
//  EncoderTester.m
//  Japx_Tests
//
//  Created by Nikola Majcen on 29/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Japx_Tests-Swift.h"
@import Japx;

@interface EncoderTester : XCTestCase

@end

@implementation EncoderTester

- (void)testJsonToJsonAPITransformationWithSimpleEncoding
{
    BOOL correctlyParsed = [AdditionalFunctions doesWithJsonFromFileNamed:@"SimpleEncoding-Json"
                                                   containsEverethingFrom:@"SimpleEncoding-JsonApi"
                                                        afterParsingBlock:^id _Nonnull(NSData * _Nonnull data) {
                                                            return [JAPXEncoder encodeWithData:data additionalParams:nil options:[JAPXEncodingOptions new] error:nil];
                                                        }];
    XCTAssertTrue(correctlyParsed);
}

- (void)testJsonToJsonAPITransformationWithRecursiveRelationships
{
    BOOL correctlyParsed = [AdditionalFunctions doesWithJsonFromFileNamed:@"RecursivRelationships-Json"
                                                   containsEverethingFrom:@"RecursivRelationships-JsonApi"
                                                        afterParsingBlock:^id _Nonnull(NSData * _Nonnull data) {
                                                            return [JAPXEncoder encodeWithData:data additionalParams:nil options:[JAPXEncodingOptions new] error:nil];
                                                        }];
    XCTAssertTrue(correctlyParsed);
}

- (void)testJsonToJsonAPITransformationWithExtraParams
{
    NSDictionary *extraParams = @{
                                  @"links": @{ @"self": @"http://example.com/articles" }
                                  };
    BOOL correctlyParsed = [AdditionalFunctions doesWithJsonFromFileNamed:@"ExtraParams-Json"
                                                   containsEverethingFrom:@"ExtraParams-JsonApi"
                                                        afterParsingBlock:^id _Nonnull(NSData * _Nonnull data) {
                                                            return [JAPXEncoder encodeWithData:data additionalParams:extraParams options:[JAPXEncodingOptions new] error:nil];
                                                        }];
    XCTAssertTrue(correctlyParsed);
}

@end
