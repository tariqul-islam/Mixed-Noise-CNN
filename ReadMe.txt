The codes for removing mixed noise using small CNN. The codes are implementation of the paper:


Islam, M. T., Rahman, S. M., Ahmad, M. O., & Swamy, M. N. S. (2018). Mixed Gaussian-impulse noise reduction from images using convolutional neural network. Signal Processing: Image Communication.


In order to run the example you have to install numpy and tensorflow.

Instrucitons:

1. First run CAI.m to create Cai's method processed file.
2. Then run test_cnn.py to perform the denoising process.


Our followup Paper, which uses a variational step, that was used in this paper, as a general pre-processor for noise removal. The results can be seen in this paper: 

Islam, M. T., Saha, D., Rahman, S. M., Ahmad, M. O., & Swamy, M. N. S. (2018, December). A Variational Step for Reduction of Mixed Gaussian-Impulse Noise from Images. In 2018 10th International Conference on Electrical and Computer Engineering (ICECE) (pp. 97-100). IEEE.

And Corresponding Code: https://github.com/tariqul-islam/Variational-Step-for-Mixed-AWGN-IN-Removal-form-Images

Consider citing the papers if you find the codes useful.
