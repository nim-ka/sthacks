mips-linux-gnu-gcc -S -I $HOME/sm64/include -I $HOME/sm64/src -I $HOME/sm64/actors -DTARGET_N64 -D__sgi -DNON_MATCHING -DAVOID_UB model.c &&
mips-linux-gnu-gcc -S -I $HOME/sm64/include -I $HOME/sm64/src -I $HOME/sm64/actors -DTARGET_N64 -D__sgi -DNON_MATCHING -DAVOID_UB geo.c
