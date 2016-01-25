/*
 +--------------------------------------------------------------------------
 |
 | WARNING: REMOVING THIS COPYRIGHT HEADER IS EXPRESSLY FORBIDDEN
 |
 | CLAYTON APPLICATION
 | ========================================
 | by ENCLAVE, INC.
 | (c) 2012-2013 ENCLAVEIT.COM - All right reserved
 | Website: http://www.enclave.vn [^]
 | Email : engineering@enclave.vn
 | ========================================
 |
 | WARNING //--------------------------
 |
 | Selling the code for this program without prior written consent is expressly
 |forbidden.
 | This computer program is protected by copyright law.
 | Unauthorized reproduction or distribution of this program, or any portion of
 | if, may result in severe civil and criminal penalties and will be prosecuted
 |to the maximum extent possible under the law.
 +--------------------------------------------------------------------------
 */

//
//  Log.h
//  Clayton
//
//  Created by Quoc (Quinn) H. NGUYEN on 11/16/15.
//  Copyright © 2015 Quoc (Quinn) H. NGUYEN. All rights reserved.
//

#ifndef Log_h
#define Log_h

#ifdef DEBUG
#define DLOG(format, ...)  NSLog(@"" format, ##__VA_ARGS__)
#define DETAIL_LOG(format, ...)	 NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define POINT_LOG(name, point)  NSLog(@"%@ : %@", name, NSStringFromCGPoint(point))
#define SIZE_LOG(name, size)  NSLog(@"%@ : %@", name, NSStringFromCGSize(size))
#define RECT_LOG(name, rect)  NSLog(@"%@ : %@", name, NSStringFromCGRect(rect))
#define TRACE(format, ...)  NSLog((@"%@.%@: " format), [self class], NSStringFromSelector(_cmd), ##__VA_ARGS__)
#else
#define DLOG(format, ...)
#define DETAIL_LOG(format, ...)
#define POINT_LOG(name, point)
#define SIZE_LOG(name, size)
#define RECT_LOG(name, rect)
#define TRACE(format, ...)
#endif


#endif /* Log_h */
