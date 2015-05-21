//
//  OAKTestHelper.h
//  Oak
//
//  Created by t-matsumura on 5/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#ifndef Oak_OAKTestHelper_h
#define Oak_OAKTestHelper_h

#define XCTAssertEqualDates(date1, date2, ...) \
        XCTAssertEqualWithAccuracy([date1 timeIntervalSinceReferenceDate], [date2 timeIntervalSinceReferenceDate], 0.001, __VA_ARGS__)

#define XCTAssertEqualArrays(array1, array2, ...) \
        XCTAssertEqual(array1.count, array2.count, __VA_ARGS__);\
        for(NSInteger i = 0; i < array1.count; i++) { \
            XCTAssertEqualObjects(array1[i], array2[i], __VA_ARGS__); \
        }

#endif
