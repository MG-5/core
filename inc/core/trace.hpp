#pragma once

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
