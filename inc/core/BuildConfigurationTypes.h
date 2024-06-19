#pragma once

#define BUILDTYPE_EMBEDDED 2
#define BUILDTYPE_TESTING 3

#ifndef BUILDTYPE
#error "BUILDTYPE not defined"
#endif

#if !((BUILDTYPE == BUILDTYPE_EMBEDDED) || (BUILDTYPE == BUILDTYPE_TESTING))
#error "Unknown BUILDTYPE"
#endif

// please don't use BUILDTYPE == ... by yourself but rather the following macros
// the preprocessor doesn't consider a missing BUILDTYPE in a comparison about BUILDTYPE an
// error..... so when you can use the following functions, you can be sure that BUILDTYPE existance
// and validity is checked
#define IS_EMBEDDED_BUILD() (BUILDTYPE == BUILDTYPE_EMBEDDED)
#define IS_TESTING_BUILD() (BUILDTYPE == BUILDTYPE_TESTING)