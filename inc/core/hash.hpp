#pragma once

#include <cstdint>
#include <string_view>

namespace core::hash
{
static constexpr uint64_t HASH_SEED = 0xcbf29ce484222325;
static constexpr uint64_t MagicPrime = 0x00000100000001b3;

uint64_t fnvWithSeed(uint64_t hash, const uint8_t *data, const uint8_t *const dataEnd);

constexpr uint64_t fnvStringview(const std::string_view &str)
{
    uint64_t hash = HASH_SEED;
    for (char c : str)
    {
        hash = (hash ^ c) * MagicPrime;
    }

    return hash;
}

static constexpr uint64_t FirmwareHashTestingValue{0xDEADBEEFC0FFEE};
uint64_t computeFirmwareHash();
} // namespace core::hash