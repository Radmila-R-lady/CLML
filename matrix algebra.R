#######################Applied Machine Learning Days by EPFL##############################
#########################Crash course in R for machine learning###################
#########################Radmila VELICHKOVICH#####################################
#########################27.1.2019, Lausanne, Switzerland#########################


# Introduction to matrix algebra for ML -----------------------------------

#Understanding the basic notion of matrix algebra for ML
#requires getting familiar with terms like vector, matrix, tensor
#then operations we can perform 
#and its application to machine learning and mathematical operations behind it


# TYPE OF TENSORS ---------------------------------------------------------

#vector

vector_2dim<-c(1,2)
vector_2dim
vector_7dim<-c(1,2,5,7,5,5,2)
vector_7dim

#matrix 

matrix_3by2 = matrix( 
    c(2, 4, 3, 1, 5, 7), 
    nrow=3, 
    ncol=2) 
matrix_3by2

#in order to work with tensor use package tensorr
#nice intro can be found at: 
#https://cloud.r-project.org/web/packages/tensorr/vignettes/introduction.html#tensor-times-matrix

###special types of matrices

# identity matrix
#
diag(4)
View(diag(4))

#squared matrix

#diagonal matrix


#MATRIX OPERATIONS -------------------------------------------------------
#matrix transposition

t(matrix_3by2)

#matrix multiplication
#Let´s define matrix A and B and then multiply them

A=matrix( 
  c(2, 4, 3, 1, 5, 7), 
  nrow=3, 
  ncol=2) 

B= matrix( 
  c(2, 4, 3, 1, 5, 7), 
  nrow=2, 
  ncol=3) 
A
B
A%*%B

#idempotent matrix

C=matrix(c(4,-1,12,-3),
         nrow = 2,
         ncol=2, byrow=T)
C
C%*%C

#inverse matrix

inv.matrix<-matrix(c(-5,0,2,1,-2,3,6,-2,1),
                   nrow=3,
                   ncol=3, byrow=T)

inv.matrix
solve(inv.matrix)

# Take the inverse of the 2 by 2 identity matrix
solve(diag(4))


#eigenvector and eigenvalues

eigen()
