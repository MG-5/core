#pragma once
#include "core/BuildConfigurationTypes.h"

namespace core
{
/**
 * @brief Provides constexpr bools for usage in a bit more macro-free code
 * Using the bools and if constexpr () is a more modern way of splitting
 * code paths between the different builds.
 * Macros are provided via compiler -D command.
 * Multiple definitions are caught at compile time.
 *
 */
struct BuildConfiguration
{
#if OTTOCAR_IS_EMBEDDED_BUILD()
    static constexpr bool isEmbeddedBuild = true;
#else
    static constexpr bool isEmbeddedBuild = false;
#endif

#if OTTOCAR_IS_TESTING_BUILD()
    static constexpr bool isTestingBuild = true;
#else
    static constexpr bool isTestingBuild = false;
#endif

#if OTTOCAR_IS_FUZZING_BUILD()
    static constexpr bool isFuzzingBuild = true;
#else
    static constexpr bool isFuzzingBuild = false;
#endif

#if defined(OTTOCAR_BUILDCONFIG_DEBUG)
    static constexpr bool isDebugBuild = true;
#else
    static constexpr bool isDebugBuild = false;
#endif

#if defined(OTTOCAR_BUILDCONFIG_RELEASE)
    static constexpr bool isReleaseBuild = true;
#else
    static constexpr bool isReleaseBuild = false;
#endif

    static constexpr void checkBuild()
    {
        // sanity checks for macros
        static_assert(
            ((isEmbeddedBuild ? 1 : 0) + (isTestingBuild ? 1 : 0) + (isFuzzingBuild ? 1 : 0)) == 1);
        static_assert(((isDebugBuild ? 1 : 0) + (isReleaseBuild ? 1 : 0)) == 1);
    }
};

} // namespace core