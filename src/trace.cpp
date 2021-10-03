#include <core/trace.hpp>

#if OTTOCAR_IS_TRACEALYZER_SUPPORTED()
namespace bus_node_base
{
void Trace::print(const char *str)
{
    while (*str)
    {
        ITM_SendChar(*str);
        str++;
    }

    ITM_SendChar('\r');
    ITM_SendChar('\n');
}
} // namespace bus_node_base

#else 

namespace bus_node_base
{
void Trace::print(const char *str)
{
}
} // namespace bus_node_base

#endif