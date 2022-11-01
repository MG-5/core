#include "chip.h"
#include <core/trace.hpp>

#if OTTOCAR_IS_EMBEDDED_BUILD()
#include <chip.h>
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
#endif
