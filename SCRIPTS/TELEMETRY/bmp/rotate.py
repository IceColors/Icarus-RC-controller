from PIL import Image
import bitmap

img = Image.open("./motor.bmp")

for i in range(-90, 91):
    rotated = img.rotate(i)
    rotated.save("motor_{}.bmp".format(i))

for i in range(-90, 91):
    img = bitmap.open()