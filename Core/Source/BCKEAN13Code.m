//
//  BCKEAN13Code.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "BCKEAN13Code.h"
#import "BCKEANCodeCharacter.h"
#import "NSError+BCKCode.h"

// the variant pattern to use based on the first digit
static char *variant_patterns[10] = {"LLLLLLRRRRRR",  // 0
	"LLGLGGRRRRRR",  // 1
	"LLGGLGRRRRRR",  // 2
	"LLGGGLRRRRRR",  // 3
	"LGLLGGRRRRRR",  // 4
	"LGGLLGRRRRRR",  // 5
	"LGGGLLRRRRRR",  // 6
	"LGLGLGRRRRRR",  // 7
	"LGLGGLRRRRRR",  // 8
	"LGGLGLRRRRRR"   // 9
};

@implementation BCKEAN13Code

#pragma mark - Helper Methods

- (NSUInteger)_digitAtIndex:(NSUInteger)index
{
	NSString *digitStr = [self.content substringWithRange:NSMakeRange(index, 1)];
	return [digitStr integerValue];
}

- (NSUInteger)_codeVariantIndexForDigitAtIndex:(NSUInteger)index withVariantPattern:(char *)variantPattern
{
	NSAssert(index>0 && index<13, @"Index must be from 1 to 12");
	
	char variantForDigit = variantPattern[index-1];
	NSUInteger variantIndex = BCKEANCodeCharacterEncoding_L;
	
	if (variantForDigit == 'G')
	{
		variantIndex = BCKEANCodeCharacterEncoding_G;
	}
	else if (variantForDigit == 'R')
	{
		variantIndex = BCKEANCodeCharacterEncoding_R;
	}
	
	return variantIndex;
}

#pragma mark - Subclassing Methods

+ (BOOL)canEncodeContent:(NSString *)content error:(NSError *__autoreleasing *)error
{
	NSUInteger length = [content length];
	
	if (length != 13)
	{
		if (error)
		{
			NSString *message = [NSString stringWithFormat:@"%@ requires content to be 13 digits", NSStringFromClass([self class])];
			*error = [NSError BCKCodeErrorWithMessage:message];
		}
		
		return NO;
	}
	
	for (NSUInteger index=0; index<[content length]; index++)
	{
		NSString *character = [content substringWithRange:NSMakeRange(index, 1)];
		char c = [character UTF8String][0];
		
		if (!(c>='0' && c<='9'))
		{
			if (error)
			{
				NSString *message = [NSString stringWithFormat:@"%@ cannot encode '%@' at index %d", NSStringFromClass([self class]), character, index];
				*error = [NSError BCKCodeErrorWithMessage:message];
			}
			
			return NO;
		}
	}
	
	return YES;
}

+ (NSString *)barcodeStandard
{
	return @"International standard ISO/IEC 15420";
}

+ (NSString *)barcodeDescription
{
	return @"EAN-13";
}

- (NSUInteger)horizontalQuietZoneWidth
{
	return 7;
}

- (NSArray *)codeCharacters
{
	// If the array was created earlier just return it
	if (_codeCharacters)
	{
		return _codeCharacters;
	}
   
	NSMutableArray *tmpArray = [NSMutableArray array];
	
	// variant pattern derives from first digit
	NSUInteger firstDigit = [self _digitAtIndex:0];
	char *variant_pattern = variant_patterns[firstDigit];
	
	// start marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	for (NSUInteger index = 1; index < 13; index ++)
	{
		NSUInteger digit = [self _digitAtIndex:index];
		BCKEANCodeCharacterEncoding encoding = [self _codeVariantIndexForDigitAtIndex:index withVariantPattern:variant_pattern];
		
		[tmpArray addObject:[BCKEANCodeCharacter codeCharacterForDigit:digit encoding:encoding]];
		
		if (index == 6)
		{
			// middle marker
			[tmpArray addObject:[BCKEANCodeCharacter middleMarkerCodeCharacter]];
		}
	}
	
	// end marker
	[tmpArray addObject:[BCKEANCodeCharacter endMarkerCodeCharacter]];
	
	_codeCharacters = [tmpArray copy];
	return _codeCharacters;
}

- (NSString *)captionTextForZone:(BCKCodeDrawingCaption)captionZone
{
	if (captionZone == BCKCodeDrawingCaptionLeftQuietZone)
	{
		return [self.content substringToIndex:1];
	}
	
	return nil;
}

- (NSString *)defaultCaptionFontName
{
	return @"OCRB";
}

- (CGFloat)aspectRatio
{
	return 39.29 / 25.91;
}

- (BOOL)markerBarsCanOverlapBottomCaption
{
	return YES;
}

- (BOOL)allowsFillingOfEmptyQuietZones
{
	return YES;
}

@end
