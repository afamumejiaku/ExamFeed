library(image.darknet)
yolo_tiny_voc <-
  image_darknet_model(
    type = "detect",
    model = "tiny-yolo-voc.cfg",
    weights = system.file(package = "image.darknet", "models", "tiny-yolo-voc.weights"),
    labels = system.file(package = "image.darknet", "include", "darknet", "data",
                         "voc.names")
  )

x <-
  image_darknet_detect(
    file = paste(getwd(), "variance/dj.png", sep = "/"),
    object = yolo_tiny_voc,
    threshold = 0.19
  )


library(imager)
detected <- load.image("predictions.png")
blue_pred <- detected[, , , 3]
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

    # } else if(any(1 == blue_pred[i,])){
    # right < -1
    #
  }
}

print(left)
print(right)
