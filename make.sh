#ENTRY=0x80367460
ENTRY=0x80400000
FILE=main.s

echo "Preparing..."

for i in *.png; do
	bin="${i%.*}"
	n64graphics -i "$bin" -g "$i" -f "${bin##*.}"
done

echo "Unzipping..."

cp "$1" tmp.gz
gunzip tmp.gz

echo "Injecting hook..."

node -e 'addr = '"$ENTRY"' / 4; st = fs.readFileSync("tmp"); st[0x248826] = addr >> 16 & 0xFF; st[0x248825] = addr >> 8 & 0xFF; st[0x248824] = addr & 0xFF; fs.writeFileSync("tmp", st)'

echo "Disassembling..."

mips-linux-gnu-as -march=vr4300 -EB -G 0 "$FILE" -o "$FILE.o" || exit
mips-linux-gnu-ld -A vr4300 -EB -Ttext="$ENTRY" -Map hacks.map "$FILE.o"
DISASM="$(mips-linux-gnu-objdump -Dr a.out)"
rm "$FILE.o"

printf "%s" "$DISASM" > a.out.s

mips-linux-gnu-objcopy -O binary --only-section=.text a.out tmp.out
rm a.out

echo "Byteswapping..."

BYTESWAP="$(node -e 'console.log(`'"$(xxd -c 4 tmp.out | awk '{ print $2 $3 }')"'`.split`\n`.map(e => e.match(/.{2}/g).reverse().join``).join`\n`)')"
rm tmp.out
#printf "$BYTESWAP"

echo "Injecting..."

node -e 'code = `'"$BYTESWAP"'`.split`\n`.map(e => e.match(/.{2}/g).map(f => parseInt(f, 16))).reduce((a, b) => [...a, ...b]); fs = require("fs"); st = fs.readFileSync("tmp"); for (i = 0; i < code.length; i++) st[i + ('"$ENTRY"' - 0x80000000) + 0x1B0] = code[i]; fs.writeFileSync("tmp", st)'

echo "Zipping..."

cp tmp current_unzipped_st
gzip tmp
mv tmp.gz "$2"

echo "Done!"

grep sDebug hacks.map
