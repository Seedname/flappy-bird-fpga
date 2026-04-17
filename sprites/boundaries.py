background = ((0, 0), (144, 256), "background")
floor = ((146, 0), (300, 56), "floor")
scoreboard = ((146, 58), (259, 116), "scoreboard")

bird1 = ((264, 64), (281, 76), "bird1")
bird2 = ((264, 90), (281, 102), "bird2")
bird3 = ((223, 124), (240, 136), "bird3")

start = ((242, 213), (282, 227), "start")
score = ((244, 173), (284, 187), "score")

ok = ((246, 134), (286, 148), "ok")

new = ((146, 245), (162, 252), "new")

flappy_bird = ((146, 173), (242, 195), "flappy_bird")
game_over = ((146, 199), (240, 218), "game_over")
get_ready = ((146, 221), (233, 243), "get_ready")

pipe_top = ((302, 0), (328, 135), "pipe_top")
pipe_bottom = ((330, 0), (356, 121), "pipe_bottom")

tap = ((172, 122), (211, 171), "tap")

bronze = ((302, 137), (324, 159), "bronze")
silver = ((266, 229), (288, 251), "silver")
gold = ((242, 229), (264, 251), "gold")
platinum = ((220, 144), (242, 166), "platinum")

zero = ((288, 100), (295, 110), "zero")
one = ((289, 118), (296, 128), "one")
two = ((289, 134), (296, 144), "two")
three = ((289, 150), (296, 160), "three")
four = ((287, 173), (294, 183), "four")
five = ((287, 185), (294, 195), "five")
six = ((165, 245), (172, 255), "six")
seven = ((175, 245), (182, 255), "seven")
eight = ((185, 245), (192, 255), "eight")
nine = ((195, 245), (202, 255), "nine")

zero_small = ((287, 74), (293, 81), "zero_small")
one_small = ((288, 162), (294, 169), "one_small")
two_small = ((204, 245), (210, 252), "two_small")
three_small = ((212, 245), (218, 252), "three_small")
four_small = ((220, 245), (226, 252), "four_small")
five_small = ((228, 245), (234, 252), "five_small")
six_small = ((284, 197), (290, 204), "six_small")
seven_small = ((292, 197), (298, 204), "seven_small")
eight_small = ((284, 213), (290, 220), "eight_small")
nine_small = ((292, 213), (298, 220), "nine_small")

boundary_list = [background,floor,scoreboard,bird1,bird2,bird3,start,score,ok,new,flappy_bird,game_over,get_ready,pipe_top,pipe_bottom,tap,bronze,silver,gold,platinum,zero,one,two,three,four,five,six,seven,eight,nine,zero_small,one_small,two_small,three_small,four_small,five_small,six_small,seven_small,eight_small,nine_small]

boundaries = {name: (top_left, bottom_right) for top_left, bottom_right, name in boundary_list}