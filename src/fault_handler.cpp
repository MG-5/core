#include "core/fault_handler.h"
#include "core/BuildConfiguration.hpp"
#include <cstdint>

#if IS_EMBEDDED_BUILD()

/* The fault handler implementation calls a function called
prvGetRegistersFromStack(). */
void __attribute__((aligned(4))) faultHandler(void)
{
#if (__ARM_ARCH == 7) // only for Cortex-M3, Cortex-M4 and Cortex-M7
    __asm volatile(" tst lr, #4                                                \n"
                   " ite eq                                                    \n"
                   " mrseq r0, msp                                             \n"
                   " mrsne r0, psp                                             \n"
                   " ldr r1, [r0, #24]                                         \n"
                   " ldr r2, handler2_address_const                            \n"
                   " bx r2                                                     \n"
                   " handler2_address_const: .word prvGetRegistersFromStack    \n");

#elif (__ARM_ARCH == 6) // only for Cortex-M0, Arm Cortex-M0+ and Arm Cortex-M1
    __asm volatile(" mrs r0, msp                                            \n"
                   " mov r1, lr                                             \n"
                   " mov r2, #4                                             \n"
                   " tst r1, r2                                             \n"
                   " beq prvGetRegistersFromStack                           \n"
                   " mrs r0, psp                                            \n"
                   " ldr r1, =prvGetRegistersFromStack                      \n"
                   " bx r1");
#endif
}

extern "C" [[noreturn]] void prvGetRegistersFromStack(uint32_t *pulFaultStackAddress)
{
    /* These are volatile to try and prevent the compiler/linker optimising them
    away as the variables never actually get used.  If the debugger won't show the
    values of the variables, make them global my moving their declaration outside
    of this function. */

    /* Debugging steps: Convert the content of 'pc' to hex and search for the
    address in the builds .list. That should get you at least somewhere.
    If the address doesn't exist, your firmware tried to access an illegal memory location.
    If the address only contains 0xA5, you ran into a FreeRTOS stack overflow. 0xA5 is the
    detection pattern it uses internally.*/
    volatile uint32_t r0;
    volatile uint32_t r1;
    volatile uint32_t r2;
    volatile uint32_t r3;
    volatile uint32_t r12;
    volatile uint32_t lr;  /* Link register. Function the firmware is executing */
    volatile uint32_t pc;  /* Program counter. Current line being executed */
    volatile uint32_t psr; /* Program status register. */

    r0 = pulFaultStackAddress[0];
    r1 = pulFaultStackAddress[1];
    r2 = pulFaultStackAddress[2];
    r3 = pulFaultStackAddress[3];

    r12 = pulFaultStackAddress[4];
    lr = pulFaultStackAddress[5];
    pc = pulFaultStackAddress[6];
    psr = pulFaultStackAddress[7];

    (void)r0;
    (void)r1;
    (void)r2;
    (void)r3;
    (void)r12;
    (void)lr;
    (void)pc;
    (void)psr;

    if constexpr (core::BuildConfiguration::IsDebugBuild)
    {
        __asm("bkpt");
    }

    for (;;)
        ;
}

#else

void faultHandler(void)
{
}

#endif