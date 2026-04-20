import pathlib
import math


if __name__ == "__main__":
    parent_dir = pathlib.Path(__file__).parent
    file_name = "sine_lut.hex"

    lut = []
    for i in range(129):
        val = int(1023 * math.sin(i * 2 * math.pi / 512))
        val &= 0x7FF # clamp
        lut.append(f'{val:03X}')

    with open(parent_dir / file_name, 'w') as f:
        f.write('\n'.join(lut))
