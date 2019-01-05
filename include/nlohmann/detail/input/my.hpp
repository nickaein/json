#pragma once
#include <cstdint>

uint64_t my_atoi(const char* b, const char* e);

uint64_t my_atoi(const char* b, const char* e)
{
    static constexpr uint64_t pow10[20] = {
        10000000000000000000UL,
        1000000000000000000UL,
        100000000000000000UL,
        10000000000000000UL,
        1000000000000000UL,
        100000000000000UL,
        10000000000000UL,
        1000000000000UL,
        100000000000UL,
        10000000000UL,
        1000000000UL,
        100000000UL,
        10000000UL,
        1000000UL,
        100000UL,
        10000UL,
        1000UL,
        100UL,
        10UL,
    	1UL,
    };

    assert(b < e);

    uint64_t result = 0;
    auto i = sizeof(pow10) / sizeof(*pow10) - static_cast<unsigned>(e - b);

    for(; b!=e ; ++b) 
    {
        // assert(*b>='0' && *b<='9');

        result += pow10[i++] * (static_cast<unsigned>(*b - '0'));
    }

    return result;
}
