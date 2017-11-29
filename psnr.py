import numpy

def psnr(dataset1, dataset2, maximumDataValue, ignore=None):
   """
   title::
      psnr

   description::
      This method will compute the peak-signal-to-noise ratio (PSNR) between
      two provided data sets.  The PSNR will be computed for the ensemble
      data.  If the PSNR is desired for a particular slice of the provided
      data, then the data sets provided should represent those slices.

   attributes::
      dataset1
         An array-like object containing the first data set.
      dataset2
         An array-like object containing the second data set.
      maximumDataValue
         The maximum value that might be contained in the data set (this
         is not necessaryily the the maximum value in the data set, but 
         rather it is the largest value that any member of the data set 
         might take on).
      ignore
         A scalar value that will be ignored in the data sets.  This can
         be used to mask data in the provided data set from being
         included in the analysis. This value will be looked for in both
         of the provided data sets, and only an intersection of positions
         in the two data sets will be included in the computation. [default 
         is None]

   author::
      Carl Salvaggio

   copyright::
      Copyright (C) 2015, Rochester Institute of Technology

   license::
      GPL

   version::
      1.0.0

   disclaimer::
      This source code is provided "as is" and without warranties as to 
      performance or merchantability. The author and/or distributors of 
      this source code may have made statements about this source code. 
      Any such statements do not constitute warranties and shall not be 
      relied on by the user in deciding whether to use this source code.
      
      This source code is provided without any express or implied warranties 
      whatsoever. Because of the diversity of conditions and hardware under 
      which this source code may be used, no warranty of fitness for a 
      particular purpose is offered. The user is advised to test the source 
      code thoroughly before relying on it. The user must assume the entire 
      risk of using the source code.
   """

   # Make sure that the provided data sets are numpy ndarrays, if not
   # convert them and flatten te data sets for analysis
   #print dataset1.shape
   #print dataset2.shape
   if type(dataset1).__module__ != numpy.__name__:
      d1 = numpy.asarray(dataset1).flatten()
   else:
      d1 = dataset1.flatten()

   if type(dataset2).__module__ != numpy.__name__:
      d2 = numpy.asarray(dataset2).flatten()
   else:
      d2 = dataset2.flatten()

   # Make sure that the provided data sets are the same size
   if d1.size != d2.size:
      raise ValueError('Provided datasets must have the same size/shape')

   # Check if the provided data sets are identical, and if so, return an
   # infinite peak-signal-to-noise ratio
   if numpy.array_equal(d1, d2):
      return float('inf')

   # If specified, remove the values to ignore from the analysis and compute
   # the element-wise difference between the data sets
   if ignore is not None:
      index = numpy.intersect1d(numpy.where(d1 != ignore)[0], 
                                numpy.where(d2 != ignore)[0])
      error = d1[index].astype(numpy.float64) - d2[index].astype(numpy.float64)
   else:
      error = d1.astype(numpy.float64)-d2.astype(numpy.float64)

   # Compute the mean-squared error
   meanSquaredError = numpy.sum(error**2) / error.size

   # Return the peak-signal-to-noise ratio
   return 10.0 * numpy.log10(maximumDataValue**2 / meanSquaredError)
