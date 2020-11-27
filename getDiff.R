library(geometry)

getDiff <- function(image1, image2){
  img1 <- grayscale(load.image(image1))
  img2 <- grayscale(load.image(image2))
  img1cropped <- data.matrix(img1 [img1 != 0 & img2 != 0])
  img2cropped <- data.matrix(img2[img1 != 0 & img2 != 0])
  dotProd <- dot(img1cropped, img2cropped)
  magImg1 <- norm(img1cropped, type = "F")
  magImg2 <- norm(img2cropped, type = "F")
  cosSim <- dotProd/(magImg1 * magImg2)
  return (cosSim)
  
}


getDiff("variance/image4.jpg", "variance/image2crop.jpg")