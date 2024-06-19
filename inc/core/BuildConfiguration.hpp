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
#if IS_EMBEDDED_BUILD()
        static constexpr bool IsEmbeddedBuild = true;
#else
        static constexpr bool IsEmbeddedBuild = false;
#endif

#if IS_TESTING_BUILD()
        static constexpr bool IsTestingBuild = true;
#else
        static constexpr bool IsTestingBuild = false;
#endif

#if defined(DEBUG)
        static constexpr bool IsDebugBuild = true;
        static constexpr bool IsReleaseBuild = false;
#else
        static constexpr bool IsDebugBuild = false;
        static constexpr bool IsReleaseBuild = true;
#endif

        static constexpr void checkBuild()
        {
            // sanity checks for macros
            static_assert((IsEmbeddedBuild ^ IsTestingBuild) == 1);
            static_assert((IsDebugBuild ^ IsReleaseBuild) == 1);
        }
    };

} // namespace core