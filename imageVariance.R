library(imager)
library(geometry)

img1 <- grayscale(load.image("variance/image1crop.jpg"))
img2 <- grayscale(load.image("variance/image2crop.jpg"))

#img1 <- resize(img1, round(width(img1) / 4), round(height(img1) / 4))
#img2 <- resize(img2, round(width(img2) / 4), round(height(img2) / 4))

getVariance <- function(img1, img2) {
  img1Cropped <- data.matrix(img1[img1 != 0 & img2 != 0])
  img2Cropped <- data.matrix(img2[img1 != 0 & img2 != 0])
  
  return(dot(img1Cropped, img2Cropped) / (norm(img1Cropped, "F") * norm(img2Cropped, "F")))
}


getVariance(img1, img2)
