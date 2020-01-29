mips-linux-gnu-as -march=vr4300 -EB -G 0 "$1" -o "$1.o"
mips-linux-gnu-ld -A vr4300 -EB -Ttext="$2" -Map hacks.map "$1.o"
mips-linux-gnu-objdump -Dr a.out
rm "$1.o" a.out
