import cv2
import numpy as np

def adulteration_analysis(image):
   
   #Converts the image to grayscale, applies a blur to the image and compares the differences
   gray_scale_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
   blurred_image = cv2.GaussianBlur(gray_scale_image, (5, 5), 0)
   differences_in_image = cv2.absdiff(gray_scale_image, blurred_image)
   

   
   #analyzes whether there are significant differences
   
   #discrepancie_comparison = cv2.adaptiveThreshold(differences_in_image, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 11, 2)

   discrepancie_comparison = 80
   aux,image_dicrepancies = cv2.threshold(differences_in_image, discrepancie_comparison, 255, cv2.THRESH_BINARY)
  
   cv2.imshow('Differences', image_dicrepancies)
   cv2.waitKey(0)
   cv2.destroyAllWindows()   
   
   white_pixel_count = np.sum(image_dicrepancies == 255)
   print(white_pixel_count)
   
   if white_pixel_count > 0:
       return "\nPode háver adulterações"
   else:
       return "\nImagem parece autentica"
   
def main():
    path_image = input("Caminho do arquivo:")
    image = cv2.imread(path_image, cv2.IMREAD_COLOR)
    
    if image is None:
        print("Erro ao carregar a imagem.")
    else:
        print(adulteration_analysis(image))

main()
