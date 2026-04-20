from PIL import Image
import pathlib
from boundaries import boundaries

if __name__ == "__main__":
    parent_dir = pathlib.Path(__file__).parent
    sprites_dir = parent_dir / "sprites"
    filename = "spritesheet.png"

    sprites_dir.mkdir(exist_ok=True)

    image = Image.open(parent_dir / filename).convert("RGBA")

    package_str = "package constants_pkg;\n"

    for name, boundary in boundaries.items():
        rom_str = ""
        rom_size = 0

        left, top = boundary[0]
        right, bottom = boundary[1]

        # rom_str += f"// {name} start\n"

        sprite_size = 0

        # row major order storage
        for y in range(top, bottom):
            for x in range(left, right):

                r, g, b, a = image.getpixel((x,y))

                # transparent bit
                transparent = int(a != 255)

                # 12 bit rgb
                red = (r >> 4)
                green = (g >> 4)
                blue = (b >> 4)
                # final 13 bit storage
                final = transparent << 12 | red << 8 | green << 4 | blue

                # add the hex to the rom
                rom_str += f"{final:X}\n"
                sprite_size += 1

        address = rom_size
        width = right - left
        height = bottom - top

        package_str += f'\tlocalparam {name.upper()}_ROM = "sprites/{name.upper()}.hex";\n'
        package_str += f"\tlocalparam {name.upper()}_WIDTH = {width};\n"
        package_str += f"\tlocalparam {name.upper()}_HEIGHT = {height};\n\n"

        rom_size += sprite_size

        with open(sprites_dir / f'{name.upper()}.hex', 'w') as f:
            f.write(rom_str)

    package_str += f"\tenum {{{', '.join(map(str.upper, boundaries.keys()))}}} sprite_t;\n"
    package_str += "endpackage"


    with open(parent_dir / "rom.hex", 'w') as f:
        f.write(rom_str)

    with open(parent_dir / "constants.sv", 'w') as f:
        f.write(package_str)


