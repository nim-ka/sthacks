#ENTRY=0x80367460
ENTRY=0x80400000
FILE=main.s

echo "Preparing assets..."

for i in *.png; do
	bin="${i%.*}"
	tools/n64graphics -i "$bin" -g "$i" -f "${bin##*.}"
done

for i in *.aiff; do
	aiff="_$i"
	aifc="${i%.*}.aifc"
	bin="${i%.*}.bin"
	table="${i%.*}.table"

	ffmpeg -y -i "$i" -ar 16000 "$aiff"

	tools/aiff_extract_codebook "$aiff" > "$table"

	tools/vadpcm_enc -c "$table" "$aiff" "$aifc"
	dd if="$aifc" of="$bin" bs=192 skip=1

	dd if="$aifc" of=tmpa bs=112 skip=1; xxd tmpa | head -4 | xxd -r > "$table.bin"; rm tmpa

	rm "$aiff" "$aifc" "$table"
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

xxd -c 4 tmp.out | awk '{ print $2 $3 }' > tmp2.out
rm tmp.out

echo "Byteswapping..."

node -e 'console.log(fs.readFileSync("tmp2.out").toString().split`\n`.filter(e => e).map(e => e.match(/.{2}/g).reverse().join``).join`\n`)' > tmp3.out
rm tmp2.out

echo "Injecting..."

#node -e 'code = [].concat(...fs.readFileSync("tmp3.out").toString().split`\n`.filter(e => e).map(e => e.match(/.{2}/g).map(f => parseInt(f, 16)))); st = fs.readFileSync("tmp"); for (i = 0; i < code.length; i++) st[i + ('"$ENTRY"' - 0x80000000) + 0x1B0] = code[i]; fs.writeFileSync("tmp", st)'
node -e 'code = fs.readFileSync("tmp3.out").toString().split`\n`.filter(e => e).map(e => e.match(/.{2}/g).map(f => parseInt(f, 16))); st = fs.readFileSync("tmp"); for (i = 0; i < code.length; i++) for (j = 0; j < 4; j++) st[(i * 4 + j) + ('"$ENTRY"' - 0x80000000) + 0x1B0] = code[i][j]; fs.writeFileSync("tmp", st)'
rm tmp3.out

echo "Zipping..."

cp tmp current_unzipped_st
gzip tmp
mv tmp.gz "$2"

echo "Done!"

grep sDebug hacks.map
