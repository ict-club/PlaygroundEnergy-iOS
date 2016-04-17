/*	NSObjCRuntime.h
	Copyright (c) 1994-2015, Apple Inc. All rights reserved.
*/

#include <TargetConditionals.h>
#include <Availability.h>

#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)) || (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
#include <objc/NSObjCRuntime.h>
#include <stdarg.h>
#include <stdint.h>
#include <limits.h>
#include <AvailabilityMacros.h>
#endif

#if defined(__cplusplus)
#define FOUNDATION_EXTERN extern "C"
#else
#define FOUNDATION_EXTERN extern
#endif

#if TARGET_OS_WIN32

    #if defined(NSBUILDINGFOUNDATION)
        #define FOUNDATION_EXPORT FOUNDATION_EXTERN __declspec(dllexport)
    #else
        #define FOUNDATION_EXPORT FOUNDATION_EXTERN __declspec(dllimport)
    #endif

    #define FOUNDATION_IMPORT FOUNDATION_EXTERN __declspec(dllimport)

#else
    #define FOUNDATION_EXPORT  FOUNDATION_EXTERN
    #define FOUNDATION_IMPORT FOUNDATION_EXTERN
#endif

#if !defined(NS_INLINE)
    #if defined(__GNUC__)
        #define NS_INLINE static __inline__ __attribute__((always_inline))
    #elif defined(__MWERKS__) || defined(__cplusplus)
        #define NS_INLINE static inline
    #elif defined(_MSC_VER)
        #define NS_INLINE static __inline
    #elif TARGET_OS_WIN32
        #define NS_INLINE static __inline__
    #endif
#endif

#if !defined(FOUNDATION_STATIC_INLINE)
#define FOUNDATION_STATIC_INLINE static __inline__
#endif

#if !defined(FOUNDATION_EXTERN_INLINE)
#define FOUNDATION_EXTERN_INLINE extern __inline__
#endif

#if !defined(NS_REQUIRES_NIL_TERMINATION)
    #if TARGET_OS_WIN32
        #define NS_REQUIRES_NIL_TERMINATION
    #else
        #if defined(__APPLE_CC__) && (__APPLE_CC__ >= 5549)
            #define NS_REQUIRES_NIL_TERMINATION __attribute__((sentinel(0,1)))
        #else
            #define NS_REQUIRES_NIL_TERMINATION __attribute__((sentinel))
        #endif
    #endif
#endif

#if !defined(NS_BLOCKS_AVAILABLE)
    #if __BLOCKS__ && (MAC_OS_X_VERSION_10_6 <= MAC_OS_X_VERSION_MAX_ALLOWED || __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED)
        #define NS_BLOCKS_AVAILABLE 1
    #else
        #define NS_BLOCKS_AVAILABLE 0
    #endif
#endif

// Marks APIs whose iOS versions are nonatomic, that is cannot be set/get from multiple threads safely without additional synchronization
#if !defined(NS_NONATOMIC_IOSONLY)
    #if TARGET_OS_IPHONE
	#define NS_NONATOMIC_IOSONLY nonatomic
    #else
        #if __has_feature(objc_property_explicit_atomic)
            #define NS_NONATOMIC_IOSONLY atomic
        #else
            #define NS_NONATOMIC_IOSONLY
        #endif
    #endif
#endif

// Use NS_NONATOMIC_IOSONLY instead of this older macro
#if !defined(NS_NONATOMIC_IPHONEONLY)
#define NS_NONATOMIC_IPHONEONLY NS_NONATOMIC_IOSONLY
#endif

// Marks APIs which format strings by taking a format string and optional varargs as arguments
#if !defined(NS_FORMAT_FUNCTION)
    #if (__GNUC__*10+__GNUC_MINOR__ >= 42) && (TARGET_OS_MAC || TARGET_OS_EMBEDDED)
	#define NS_FORMAT_FUNCTION(F,A) __attribute__((format(__NSString__, F, A)))
    #else
	#define NS_FORMAT_FUNCTION(F,A)
    #endif
#endif

// Marks APIs which are often used to process (take and return) format strings, so they can be used in place of a constant format string parameter in APIs
#if !defined(NS_FORMAT_ARGUMENT)
    #if defined(__clang__)
	#define NS_FORMAT_ARGUMENT(A) __attribute__ ((format_arg(A)))
    #else
	#define NS_FORMAT_ARGUMENT(A)
    #endif
#endif

// Some compilers provide the capability to test if certain features are available. This macro provides a compatibility path for other compilers.
#ifndef __has_feature
#define __has_feature(x) 0
#endif

#ifndef __has_extension
#define __has_extension(x) 0
#endif

// Some compilers provide the capability to test if certain attributes are available. This macro provides a compatibility path for other compilers.
#ifndef __has_attribute
#define __has_attribute(x) 0
#endif

// Marks methods and functions which return an object that needs to be released by the caller but whose names are not consistent with Cocoa naming rules. The recommended fix to this is to rename the methods or functions, but this macro can be used to let the clang static analyzer know of any exceptions that cannot be fixed.
// This macro is ONLY to be used in exceptional circumstances, not to annotate functions which conform to the Cocoa naming rules.
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif

// Marks methods and functions which return an object that may need to be retained by the caller but whose names are not consistent with Cocoa naming rules. The recommended fix to this is to rename the methods or functions, but this macro can be used to let the clang static analyzer know of any exceptions that cannot be fixed.
// This macro is ONLY to be used in exceptional circumstances, not to annotate functions which conform to the Cocoa naming rules.
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif

#ifndef NS_RETURNS_INNER_POINTER
#if __has_attribute(objc_returns_inner_pointer)
#define NS_RETURNS_INNER_POINTER __attribute__((objc_returns_inner_pointer))
#else
#define NS_RETURNS_INNER_POINTER
#endif
#endif

// Marks methods and functions which cannot be used when compiling in automatic reference counting mode.
#if __has_feature(objc_arc)
#define NS_AUTOMATED_REFCOUNT_UNAVAILABLE __attribute__((unavailable("not available in automatic reference counting mode")))
#else
#define NS_AUTOMATED_REFCOUNT_UNAVAILABLE
#endif

// Marks classes which cannot participate in the ARC weak reference feature.
#if __has_attribute(objc_arc_weak_reference_unavailable)
#define NS_AUTOMATED_REFCOUNT_WEAK_UNAVAILABLE __attribute__((objc_arc_weak_reference_unavailable))
#else
#define NS_AUTOMATED_REFCOUNT_WEAK_UNAVAILABLE
#endif

// Marks classes that must specify @dynamic or @synthesize for properties in their @implementation (property getters & setters will not be synthesized unless the @synthesize directive is used)
#if __has_attribute(objc_requires_property_definitions)
#define NS_REQUIRES_PROPERTY_DEFINITIONS __attribute__((objc_requires_property_definitions)) 
#else
#define NS_REQUIRES_PROPERTY_DEFINITIONS
#endif

// Decorates methods in which the receiver may be replaced with the result of the method. 
#if __has_feature(attribute_ns_consumes_self)
#define NS_REPLACES_RECEIVER __attribute__((ns_consumes_self)) NS_RETURNS_RETAINED
#else
#define NS_REPLACES_RECEIVER
#endif

#if __has_feature(attribute_ns_consumed)
#define NS_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
#define NS_RELEASES_ARGUMENT
#endif

// Mark local variables of type 'id' or pointer-to-ObjC-object-type so that values stored into that local variable are not aggressively released by the compiler during optimization, but are held until either the variable is assigned to again, or the end of the scope (such as a compound statement, or method definition) of the local variable.
#ifndef NS_VALID_UNTIL_END_OF_SCOPE
#if __has_attribute(objc_precise_lifetime)
#define NS_VALID_UNTIL_END_OF_SCOPE __attribute__((objc_precise_lifetime))
#else
#define NS_VALID_UNTIL_END_OF_SCOPE
#endif
#endif

// Annotate classes which are root classes as really being root classes
#ifndef NS_ROOT_CLASS
#if __has_attribute(objc_root_class)
#define NS_ROOT_CLASS __attribute__((objc_root_class))
#else
#define NS_ROOT_CLASS
#endif
#endif

#ifndef NS_REQUIRES_SUPER
#if __has_attribute(objc_requires_super)
#define NS_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
#define NS_REQUIRES_SUPER
#endif
#endif

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

#ifndef NS_PROTOCOL_REQUIRES_EXPLICIT_IMPLEMENTATION
#if __has_attribute(objc_protocol_requires_explicit_implementation)
#define NS_PROTOCOL_REQUIRES_EXPLICIT_IMPLEMENTATION __attribute__((objc_protocol_requires_explicit_implementation))
#else
#define NS_PROTOCOL_REQUIRES_EXPLICIT_IMPLEMENTATION
#endif
#endif

#if !__has_feature(objc_instancetype)
#undef instancetype
#define instancetype id
#endif

#if !defined(NS_UNAVAILABLE)
#define NS_UNAVAILABLE UNAVAILABLE_ATTRIBUTE
#endif

#if !defined(__unsafe_unretained)
#define __unsafe_unretained
#endif

#if TARGET_OS_WIN32
#import <objc/objc.h>
#include <stdarg.h>
#include <stdint.h>
#include <limits.h>
#endif

#include <CoreFoundation/CFAvailability.h>

#define NS_AVAILABLE(_mac, _ios) CF_AVAILABLE(_mac, _ios)
#define NS_AVAILABLE_MAC(_mac) CF_AVAILABLE_MAC(_mac)
#define NS_AVAILABLE_IOS(_ios) CF_AVAILABLE_IOS(_ios)

#define NS_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...) CF_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, __VA_ARGS__)
#define NS_DEPRECATED_MAC(_macIntro, _macDep, ...) CF_DEPRECATED_MAC(_macIntro, _macDep, __VA_ARGS__)
#define NS_DEPRECATED_IOS(_iosIntro, _iosDep, ...) CF_DEPRECATED_IOS(_iosIntro, _iosDep, __VA_ARGS__)

#define NS_ENUM_AVAILABLE(_mac, _ios) CF_ENUM_AVAILABLE(_mac, _ios)
#define NS_ENUM_AVAILABLE_MAC(_mac) CF_ENUM_AVAILABLE_MAC(_mac)
#define NS_ENUM_AVAILABLE_IOS(_ios) CF_ENUM_AVAILABLE_IOS(_ios)

#define NS_ENUM_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, ...) CF_ENUM_DEPRECATED(_macIntro, _macDep, _iosIntro, _iosDep, __VA_ARGS__)
#define NS_ENUM_DEPRECATED_MAC(_macIntro, _macDep, ...) CF_ENUM_DEPRECATED_MAC(_macIntro, _macDep, __VA_ARGS__)
#define NS_ENUM_DEPRECATED_IOS(_iosIntro, _iosDep, ...) CF_ENUM_DEPRECATED_IOS(_iosIntro, _iosDep, __VA_ARGS__)

#define NS_AVAILABLE_IPHONE(_ios) CF_AVAILABLE_IOS(_ios)
#define NS_DEPRECATED_IPHONE(_iosIntro, _iosDep) CF_DEPRECATED_IOS(_iosIntro, _iosDep)

/* NS_ENUM supports the use of one or two arguments. The first argument is always the integer type used for the values of the enum. The second argument is an optional type name for the macro. When specifying a type name, you must precede the macro with 'typedef' like so:
 
typedef NS_ENUM(NSInteger, NSComparisonResult) {
    ...
};
 
If you do not specify a type name, do not use 'typedef'. For example:
 
NS_ENUM(NSInteger) {
    ...
};
*/
#define NS_ENUM(...) CF_ENUM(__VA_ARGS__)
#define NS_OPTIONS(_type, _name) CF_OPTIONS(_type, _name)

// This macro is to be used by system frameworks to support the weak linking of classes. Weak linking is supported on iOS 3.1 and Mac OS X 10.6.8 or later.
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_6 || __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_1) && \
    ((__has_feature(objc_weak_class) || \
     (defined(__llvm__) && defined(__APPLE_CC__) && (__APPLE_CC__ >= 5658)) || \
     (defined(__APPLE_CC__) && (__APPLE_CC__ >= 5666))))
#define NS_CLASS_AVAILABLE(_mac, _ios) __attribute__((visibility("default"))) NS_AVAILABLE(_mac, _ios)
#define NS_CLASS_DEPRECATED(_mac, _macDep, _ios, _iosDep, ...) __attribute__((visibility("default"))) NS_DEPRECATED(_mac, _macDep, _ios, _iosDep, __VA_ARGS__)
#else
// class weak import is not supported
#define NS_CLASS_AVAILABLE(_mac, _ios)
#define NS_CLASS_DEPRECATED(_mac, _macDep, _ios, _iosDep, ...)
#endif

#define NS_CLASS_AVAILABLE_IOS(_ios) NS_CLASS_AVAILABLE(NA, _ios)
#define NS_CLASS_AVAILABLE_MAC(_mac) NS_CLASS_AVAILABLE(_mac, NA)
#define NS_CLASS_DEPRECATED_MAC(_macIntro, _macDep, ...) NS_CLASS_DEPRECATED(_macIntro, _macDep, NA, NA, __VA_ARGS__)
#define NS_CLASS_DEPRECATED_IOS(_iosIntro, _iosDep, ...) NS_CLASS_DEPRECATED(NA, NA, _iosIntro, _iosDep, __VA_ARGS__)

#define NS_EXTENSION_UNAVAILABLE(_msg)      __OS_EXTENSION_UNAVAILABLE(_msg)
#define NS_EXTENSION_UNAVAILABLE_MAC(_msg)  __OSX_EXTENSION_UNAVAILABLE(_msg)
#define NS_EXTENSION_UNAVAILABLE_IOS(_msg)  __IOS_EXTENSION_UNAVAILABLE(_msg)

#define NS_SWIFT_UNAVAILABLE(_msg) CF_SWIFT_UNAVAILABLE(_msg)

#define NS_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
#define NS_ASSUME_NONNULL_END   _Pragma("clang assume_nonnull end")

#define NS_REVISED_FOR_SWIFT CF_REVISED_FOR_SWIFT

#define NS_SWIFT_NAME(_name) CF_SWIFT_NAME(_name)

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT double NSFoundationVersionNumber;

#if TARGET_OS_MAC
#define NSFoundationVersionNumber10_0	397.40
#define NSFoundationVersionNumber10_1	425.00
#define NSFoundationVersionNumber10_1_1	425.00
#define NSFoundationVersionNumber10_1_2	425.00
#define NSFoundationVersionNumber10_1_3	425.00
#define NSFoundationVersionNumber10_1_4	425.00
#define NSFoundationVersionNumber10_2	462.00
#define NSFoundationVersionNumber10_2_1	462.00
#define NSFoundationVersionNumber10_2_2	462.00
#define NSFoundationVersionNumber10_2_3	462.00
#define NSFoundationVersionNumber10_2_4	462.00
#define NSFoundationVersionNumber10_2_5	462.00
#define NSFoundationVersionNumber10_2_6	462.00
#define NSFoundationVersionNumber10_2_7	462.70
#define NSFoundationVersionNumber10_2_8	462.70
#define NSFoundationVersionNumber10_3	500.00
#define NSFoundationVersionNumber10_3_1	500.00
#define NSFoundationVersionNumber10_3_2	500.30
#define NSFoundationVersionNumber10_3_3	500.54
#define NSFoundationVersionNumber10_3_4	500.56
#define NSFoundationVersionNumber10_3_5	500.56
#define NSFoundationVersionNumber10_3_6	500.56
#define NSFoundationVersionNumber10_3_7	500.56
#define NSFoundationVersionNumber10_3_8	500.56
#define NSFoundationVersionNumber10_3_9	500.58
#define NSFoundationVersionNumber10_4	567.00
#define NSFoundationVersionNumber10_4_1	567.00
#define NSFoundationVersionNumber10_4_2	567.12
#define NSFoundationVersionNumber10_4_3	567.21
#define NSFoundationVersionNumber10_4_4_Intel	567.23
#define NSFoundationVersionNumber10_4_4_PowerPC	567.21
#define NSFoundationVersionNumber10_4_5	567.25
#define NSFoundationVersionNumber10_4_6	567.26
#define NSFoundationVersionNumber10_4_7	567.27
#define NSFoundationVersionNumber10_4_8	567.28
#define NSFoundationVersionNumber10_4_9	567.29
#define NSFoundationVersionNumber10_4_10	567.29
#define NSFoundationVersionNumber10_4_11	567.36
#define NSFoundationVersionNumber10_5	677.00
#define NSFoundationVersionNumber10_5_1	677.10
#define NSFoundationVersionNumber10_5_2 677.15
#define NSFoundationVersionNumber10_5_3 677.19
#define NSFoundationVersionNumber10_5_4 677.19
#define NSFoundationVersionNumber10_5_5 677.21
#define NSFoundationVersionNumber10_5_6 677.22
#define NSFoundationVersionNumber10_5_7 677.24
#define NSFoundationVersionNumber10_5_8 677.26
#define NSFoundationVersionNumber10_6 751.00
#define NSFoundationVersionNumber10_6_1 751.00
#define NSFoundationVersionNumber10_6_2 751.14
#define NSFoundationVersionNumber10_6_3 751.21
#define NSFoundationVersionNumber10_6_4 751.29
#define NSFoundationVersionNumber10_6_5 751.42
#define NSFoundationVersionNumber10_6_6 751.53
#define NSFoundationVersionNumber10_6_7 751.53
#define NSFoundationVersionNumber10_6_8 751.62
#define NSFoundationVersionNumber10_7 833.10
#define NSFoundationVersionNumber10_7_1 833.10
#define NSFoundationVersionNumber10_7_2 833.20
#define NSFoundationVersionNumber10_7_3 833.24
#define NSFoundationVersionNumber10_7_4 833.25
#define NSFoundationVersionNumber10_8 945.00
#define NSFoundationVersionNumber10_8_1 945.00
#define NSFoundationVersionNumber10_8_2 945.11
#define NSFoundationVersionNumber10_8_3 945.16
#define NSFoundationVersionNumber10_8_4 945.18
#define NSFoundationVersionNumber10_9 1056
#define NSFoundationVersionNumber10_9_1 1056
#define NSFoundationVersionNumber10_9_2 1056.13
#endif

#if TARGET_OS_IPHONE
#define NSFoundationVersionNumber_iPhoneOS_2_0	678.24
#define NSFoundationVersionNumber_iPhoneOS_2_1  678.26
#define NSFoundationVersionNumber_iPhoneOS_2_2  678.29
#define NSFoundationVersionNumber_iPhoneOS_3_0  678.47
#define NSFoundationVersionNumber_iPhoneOS_3_1  678.51
#define NSFoundationVersionNumber_iPhoneOS_3_2  678.60
#define NSFoundationVersionNumber_iOS_4_0  751.32
#define NSFoundationVersionNumber_iOS_4_1  751.37
#define NSFoundationVersionNumber_iOS_4_2  751.49
#define NSFoundationVersionNumber_iOS_4_3  751.49
#define NSFoundationVersionNumber_iOS_5_0  881.00
#define NSFoundationVersionNumber_iOS_5_1  890.10
#define NSFoundationVersionNumber_iOS_6_0  992.00
#define NSFoundationVersionNumber_iOS_6_1  993.00
#define NSFoundationVersionNumber_iOS_7_0 1047.20
#define NSFoundationVersionNumber_iOS_7_1 1047.25
#define NSFoundationVersionNumber_iOS_8_0 1140.11
#define NSFoundationVersionNumber_iOS_8_1 1141.1
#endif

#if TARGET_OS_WIN32
typedef long NSInteger;
typedef unsigned long NSUInteger;

#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX

#define NSINTEGER_DEFINED 1
#endif

@class NSString, Protocol;

FOUNDATION_EXPORT NSString *NSStringFromSelector(SEL aSelector);
FOUNDATION_EXPORT SEL NSSelectorFromString(NSString *aSelectorName);

FOUNDATION_EXPORT NSString *NSStringFromClass(Class aClass);
FOUNDATION_EXPORT Class __nullable NSClassFromString(NSString *aClassName);

FOUNDATION_EXPORT NSString *NSStringFromProtocol(Protocol *proto) NS_AVAILABLE(10_5, 2_0);
FOUNDATION_EXPORT Protocol * __nullable NSProtocolFromString(NSString *namestr) NS_AVAILABLE(10_5, 2_0);

FOUNDATION_EXPORT const char *NSGetSizeAndAlignment(const char *typePtr, NSUInteger * __nullable sizep, NSUInteger * __nullable alignp);

FOUNDATION_EXPORT void NSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
FOUNDATION_EXPORT void NSLogv(NSString *format, va_list args) NS_FORMAT_FUNCTION(1,0);

typedef NS_ENUM(NSInteger, NSComparisonResult) {NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending};

#if NS_BLOCKS_AVAILABLE
typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);
#endif

typedef NS_OPTIONS(NSUInteger, NSEnumerationOptions) {
    NSEnumerationConcurrent = (1UL << 0),
    NSEnumerationReverse = (1UL << 1),
};

typedef NS_OPTIONS(NSUInteger, NSSortOptions) {
    NSSortConcurrent = (1UL << 0),
    NSSortStable = (1UL << 4),
};

/* The following Quality of Service (QoS) classifications are used to indicate to the system the nature and importance of work.  They are used by the system to manage a variety of resources.  Higher QoS classes receive more resources than lower ones during resource contention. */
typedef NS_ENUM(NSInteger, NSQualityOfService) {
    /* UserInteractive QoS is used for work directly involved in providing an interactive UI such as processing events or drawing to the screen. */
    NSQualityOfServiceUserInteractive = 0x21,
    
    /* UserInitiated QoS is used for performing work that has been explicitly requested by the user and for which results must be immediately presented in order to allow for further user interaction.  For example, loading an email after a user has selected it in a message list. */
    NSQualityOfServiceUserInitiated = 0x19,
    
    /* Utility QoS is used for performing work which the user is unlikely to be immediately waiting for the results.  This work may have been requested by the user or initiated automatically, does not prevent the user from further interaction, often operates at user-visible timescales and may have its progress indicated to the user by a non-modal progress indicator.  This work will run in an energy-efficient manner, in deference to higher QoS work when resources are constrained.  For example, periodic content updates or bulk file operations such as media import. */
    NSQualityOfServiceUtility = 0x11,
    
    /* Background QoS is used for work that is not user initiated or visible.  In general, a user is unaware that this work is even happening and it will run in the most efficient manner while giving the most deference to higher QoS work.  For example, pre-fetching content, search indexing, backups, and syncing of data with external systems. */
    NSQualityOfServiceBackground = 0x09,

    /* Default QoS indicates the absence of QoS information.  Whenever possible QoS information will be inferred from other sources.  If such inference is not possible, a QoS between UserInitiated and Utility will be used. */
    NSQualityOfServiceDefault = -1
} NS_ENUM_AVAILABLE(10_10, 8_0);

static const NSInteger NSNotFound = NSIntegerMax;

NS_ASSUME_NONNULL_END

#if !defined(YES)
    #define YES	(BOOL)1
#endif

#if !defined(NO)
    #define NO	(BOOL)0
#endif

#if !defined(NS_SUPPRESS_MIN_MAX_ABS)

#if (defined(__GNUC__) || defined(__clang__)) && !defined(__STRICT_ANSI__)

#if __clang__

#define __NSX_PASTE__(A,B) A##B

#if !defined(MIN)
    #define __NSMIN_IMPL__(A,B,L) ({ __typeof__(A) __NSX_PASTE__(__a,L) = (A); __typeof__(B) __NSX_PASTE__(__b,L) = (B); (__NSX_PASTE__(__a,L) < __NSX_PASTE__(__b,L)) ? __NSX_PASTE__(__a,L) : __NSX_PASTE__(__b,L); })
    #define MIN(A,B) __NSMIN_IMPL__(A,B,__COUNTER__)
#endif

#if !defined(MAX)
    #define __NSMAX_IMPL__(A,B,L) ({ __typeof__(A) __NSX_PASTE__(__a,L) = (A); __typeof__(B) __NSX_PASTE__(__b,L) = (B); (__NSX_PASTE__(__a,L) < __NSX_PASTE__(__b,L)) ? __NSX_PASTE__(__b,L) : __NSX_PASTE__(__a,L); })
    #define MAX(A,B) __NSMAX_IMPL__(A,B,__COUNTER__)
#endif

#if !defined(ABS)
    #define __NSABS_IMPL__(A,L) ({ __typeof__(A) __NSX_PASTE__(__a,L) = (A); (__NSX_PASTE__(__a,L) < 0) ? - __NSX_PASTE__(__a,L) : __NSX_PASTE__(__a,L); })
    #define ABS(A) __NSABS_IMPL__(A,__COUNTER__)
#endif

#else

#if !defined(MIN)
    #define MIN(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __a : __b; })
#endif

#if !defined(MAX)
    #define MAX(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; })
#endif

#if !defined(ABS)
    #define ABS(A)	({ __typeof__(A) __a = (A); __a < 0 ? -__a : __a; })
#endif

#endif

#else

#if !defined(MIN)
    #define MIN(A,B)	((A) < (B) ? (A) : (B))
#endif

#if !defined(MAX)
    #define MAX(A,B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(ABS)
    #define ABS(A)	((A) < 0 ? (-(A)) : (A))
#endif

#endif

#endif

