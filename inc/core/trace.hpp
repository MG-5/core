#pragma once

#ifndef OTTOCAR_TRACEALYZER_SUPPORT
#error "Please specify OTTOCAR_TRACEALYZER_SUPPORT either 0 or 1"
#endif

#if !((OTTOCAR_TRACEALYZER_SUPPORT == 0) || (OTTOCAR_TRACEALYZER_SUPPORT == 1))
#error "Please specify OTTOCAR_TRACEALYZER_SUPPORT either 0 or 1"
#endif

#define OTTOCAR_IS_TRACEALYZER_SUPPORTED() (OTTOCAR_TRACEALYZER_SUPPORT == 1)

namespace bus_node_base
{
/**
 * @brief Provides basic tracing utilities
 */
class Trace
{
public:
    /**
     * @brief Prints a debug string via ARM Cortex-M's Instrumentation Trace Macrocell.
     */
    static void print(const char *str);
};
} // namespace bus_node_base
