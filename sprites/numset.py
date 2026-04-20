from PIL import Image
import pathlib
from boundaries import boundaries

if __name__ == "__main__":
    parent_dir = pathlib.Path(__file__).parent
    filename = "spritesheet.png"

    image = Image.open(parent_dir / filename).convert("RGBA")

    case_str = "case (num)\n"

    numbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    # numbers = ["zero_small", "one_small", "two_small", "three_small", "four_small", "five_small", "six_small", "seven_small", "eight_small", "nine_small"]

    for i, name in enumerate(numbers):
        boundary = boundaries[name]

        rom_str = ""
        rom_size = 0

        left, top = boundary[0]
        right, bottom = boundary[1]

        enabled = ""
        bitmap = ""

        # row major order storage
        for y in range(top, bottom):
            for x in range(left, right):
                r, g, b, a = image.getpixel((x,y))

                # transparent bit
                enabled += str(int(a == 255))
                bitmap += str(int(r == 255 or g == 255 or b == 255))

        case_str += f"\t{i}: begin bitmap = {len(bitmap)}'b{bitmap}; enabled = {len(enabled)}'b{enabled}; end\n"

    case_str += f"\tdefault: begin bitmap = '0; enabled = '0; end\nendcase"

    with open(parent_dir / "numset.sv", 'w') as f:
        f.write(case_str)


