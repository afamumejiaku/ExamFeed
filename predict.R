# library(image.darknet)
# yolo_tiny_voc <-
#   image_darknet_model(
#     type = "detect",
#     model = "tiny-yolo-voc.cfg",
#     weights = system.file(package = "image.darknet", "models", "tiny-yolo-voc.weights"),
#     labels = system.file(package = "image.darknet", "include", "darknet", "data",
#                          "voc.names")
#   )
# 
# x <-
#   image_darknet_detect(
#     file = paste(getwd(), "variance/image4.jpg", sep = "/"),
#     object = yolo_tiny_voc,
#     threshold = 0.19
#   )
# 
# 
library(imager)
detected <- load.image("predictions.png")
blue_pred <- detected[, , , 2]
top <- -1
bot <- -1
left <- -1
right <- -1

for (i in 1:dim(blue_pred)[1]) {
  
  if (any(1 == blue_pred[i, ]) & left == -1) {
    left <- i - 1
    
  } else if (all(1 != blue_pred[i, ]) & left != -1 & right == -1) {
    right <- i
    print(i)
  }
}

if(left != -1 & right == -1) {
  right <- dim(blue_pred)[1]
}


for (i in 1:dim(blue_pred)[2]) {
  
  if (any(1 == blue_pred[,i]) & top == -1) {
    top <- i - 1
    
  } else if (all(1 != blue_pred[,i]) & top != -1 & bot == -1) {
    bot <- i
  }
}

if(top != -1 & bot == -1) {
  bot <- dim(blue_pred)[2]
}

display("predictions.png")
print(left)
print(right)
print(top)
print(bot)

new_img <- grayscale(detected)
overlay <- matrix(1, nrow = dim(blue_pred)[1], ncol = dim(blue_pred)[2])
overlay[left:right, top:bot] = 0

new_img <- as.matrix(new_img)

croppedImage <- new_img * overlay

croppedImage <- as.cimg(croppedImage)
display(croppedImage)