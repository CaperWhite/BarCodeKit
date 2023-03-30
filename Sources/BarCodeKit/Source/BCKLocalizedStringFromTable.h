//
//  BCKLocalizedStringFromTable.h
//  BarCodeKit
//
//  Created by Daniel Muhra on 30/03/23.
//  Copyright (c) 2023 Daniel Muhra. All rights reserved.
//

#if SWIFT_PACKAGE

#define BCKLocalizedStringFromTable(key, tbl, comment) \
        [SWIFTPM_MODULE_BUNDLE localizedStringForKey:(key) value:@"" table:(tbl)]
#else

#define BCKLocalizedStringFromTable(key, tbl, comment) \
        [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:(tbl)]

#endif
