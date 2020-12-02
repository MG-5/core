#include "chip.h"
#include <bus-node-base/trace.hpp>

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
