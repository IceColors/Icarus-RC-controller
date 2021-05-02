from PIL import Image
from PIL import ImageOps
import bitmap


img = Image.open(".\sdrone.bmp")



im2 = img.convert('RGBA')
im2 = ImageOps.pad(im2, (32, 32))

for i in range(-90, 91):
    rotated = im2.rotate(i)
    fff = Image.new('RGBA', rotated.size, (255,)*4)

    out = Image.composite(rotated, fff, rotated)
    out.convert(img.mode).save("drone_{}.bmp".format(i))


    