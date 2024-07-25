#include "core/BuildConfiguration.hpp"
#if IS_EMBEDDED_BUILD()
namespace std
{
void __throw_bad_function_call()
{
}
} // namespace std
#endif