#!/bin/bash
export LC_ALL=C
set -e
CC="${TEST_CC:-cc}"
CXX="${TEST_CXX:-c++}"
GCC="${TEST_GCC:-gcc}"
GXX="${TEST_GXX:-g++}"
OBJDUMP="${OBJDUMP:-objdump}"
MACHINE="${MACHINE:-$(uname -m)}"
testname=$(basename "$0" .sh)
echo -n "Testing $testname ... "
t=out/test/macho/$testname
mkdir -p $t

cat <<EOF | $CC -o $t/a.o -c -xc -
#include <stdio.h>
void hello() {
  printf("Hello world\n");
}
EOF

! clang --ld-path=./ld64 -shared -o $t/b.dylib $t/a.o -Wl,-pagezero_size,0x1000 >& $t/log
fgrep -q ' -pagezero_size option can only be used when linking a main executable' $t/log

echo OK
