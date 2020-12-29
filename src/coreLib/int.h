
/** 
 * @file int.h 
 * @author James T Oswald
 * This header library defines standard interger sizes with short names.
 * */ 

#ifndef int_header
#define int_header

#include<stdint.h>

typedef uint8_t u8;   //!< one unsigned byte
typedef uint16_t u16; //!< one unsigned word
typedef uint32_t u32; //!< one unsigned double word
typedef uint64_t u64; //!< one unsigned quad word

typedef int8_t i8;    //!< one signed byte
typedef int16_t i16;  //!< one signed word
typedef int32_t i32;  //!< one signed word
typedef int64_t i64;  //!< one signed word

typedef float f32;    //!< 32 bit float (single precision)
typedef double f64;   //!< 64 bit float (double precision)

#endif