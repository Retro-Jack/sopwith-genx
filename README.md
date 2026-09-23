# sopwith-genx

Sopwith for DOS, with the cursor keys added to its flight controls.

This is David L. Clark's Sopwith 2 — the 1984 original, reverse-engineered by
Andrew Jenner and released by Clark — with **twelve lines changed** so the plane
can be flown from the arrow keys. It exists because
[GenX-DOS](https://genx-dos.fun/) serves the game in a browser, where reaching
for `,` `/` `.` is not what anyone's hands expect.

The first commit is the source exactly as released. Everything since is visible
as a diff.

## What changed

| Key | Does | Original key, still works |
|---|---|---|
| <kbd>&uarr;</kbd> | Climb | `,` |
| <kbd>&darr;</kbd> | Descend | `/` |
| <kbd>&larr;</kbd> | Decelerate | `Z` |
| <kbd>&rarr;</kbd> | Accelerate | `X` |

Nothing was taken away — the original keys are untouched, so the game's own
manual is still correct. The change is in `keybint()`, the keyboard interrupt
handler, which is the path an IBM-compatible keyboard takes; `def.h` gains the
four scancodes. The handler masks the scancode with `0x7f`, so the `0xe0`
prefix that the extended arrow keys send falls through to `default` and does
nothing, which is why both the arrow block and the numeric keypad work.

The flip stays on `.` — there are three flight controls and four arrows, and
putting the throttle on the horizontal pair uses them better than doubling up.

## Building

The build wants a DOS toolchain, and the easiest place to find one is DOS. What
worked here, under DOSBox:

- **Turbo C 2.01** — `TCC.EXE`, small model (`C0S.OBJ`, `CS.LIB`). Borland
  released 2.01 as free "antique software".
- **A86** — Eric Isaacson's assembler. `sopasm.asm` is written for it: bare
  labels and `PUBLIC`s with no `SEGMENT` or `.MODEL` directives, which MASM and
  TASM will not take as they stand.
- **TLINK** — Turbo C's own linker, standing in for the `otlink` the original
  makefile calls, which is not obtainable. It takes the same shape of input.

Lay the tools out as `C:\PROG`, put the source at `C:\`, and run `BUILD.BAT`:

```bat
A86 +o +c SOPASM.ASM
TCC -v -y -IC:\PROG\INCLUDE -LC:\PROG\LIB -c -w SOPWITH2.C
TLINK /m /v /c C:\PROG\LIB\C0S.OBJ+SOPWITH2.OBJ+SOPASM.OBJ,SOPWITH2.EXE,SOPWITH2.MAP,C:\PROG\LIB\CS.LIB
```

Out comes `SOPWITH2.EXE`.

### Running it

`SOPWITH2.EXE -s -i -k` goes straight into a single-player game on the IBM
keyboard path — which is the path this change lives in. Without those it asks
for the game mode and the keyboard type first. `-q` starts with the sound off;
without it the sound is on, which is the source's own default and not something
changed here.

## Licence

GNU General Public License, version 2 — see [COPYING](COPYING).

Sopwith is copyright © 1984–2000 David L. Clark, and the reverse-engineered
source is © 1999–2000 Andrew Jenner. Clark originally released it under his own
terms and **subsequently relicensed it under the GPL**; his files in
[fragglet/sdl-sopwith](https://github.com/fragglet/sdl-sopwith) carry the GPL
grant beside his copyright, and the DOS sources sat in that tree under `COPYING`
until they were retired in 2003. `license.txt`, his original terms, is kept here
as part of the historical record rather than as the licence in force.

The modified files carry notices saying what changed and when, as the licence
requires.
