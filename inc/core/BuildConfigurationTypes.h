#pragma once

#define OTTOCAR_BUILDTYPE_EMBEDDED 2
#define OTTOCAR_BUILDTYPE_TESTING 3
#define OTTOCAR_BUILDTYPE_FUZZING 4

#ifndef OTTOCAR_BUILDTYPE
#error "OTTOCAR_BUILDTYPE not defined"
#endif

#if !((OTTOCAR_BUILDTYPE == OTTOCAR_BUILDTYPE_EMBEDDED) || (OTTOCAR_BUILDTYPE == OTTOCAR_BUILDTYPE_TESTING) || (OTTOCAR_BUILDTYPE == OTTOCAR_BUILDTYPE_FUZZING))
#error "Unknown OTTOCAR_BUILDTYPE"
#endif


// please don't use OTTOCAR_BUILDTYPE == ... by yourself but rather the following macros
// the preprocessor doesn't consider a missing OTTOCAR_BUILDTYPE in a comparison about OTTOCAR_BUILDTYPE an error.....
// so when you can use the following functions, you can be sure that OTTOCAR_BUILDTYPE existance and validity is checked
#define OTTOCAR_IS_EMBEDDED_BUILD() (OTTOCAR_BUILDTYPE == OTTOCAR_BUILDTYPE_EMBEDDED)
#define OTTOCAR_IS_TESTING_BUILD() (OTTOCAR_BUILDTYPE == OTTOCAR_BUILDTYPE_TESTING)
#define OTTOCAR_IS_FUZZING_BUILD() (OTTOCAR_BUILDTYPE == OTTOCAR_BUILDTYPE_FUZZING)

