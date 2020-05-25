# FisherRaoDistance

[![Build Status](https://travis-ci.com/wadehenning/FisherRaoDistance.jl.svg?branch=master)](https://travis-ci.com/wadehenning/FisherRaoDistance.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/wadehenning/FisherRaoDistance.jl?svg=true)](https://ci.appveyor.com/project/wadehenning/FisherRaoDistance-jl)
[![Codecov](https://codecov.io/gh/wadehenning/FisherRaoDistance.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/wadehenning/FisherRaoDistance.jl)
[![Coveralls](https://coveralls.io/repos/github/wadehenning/FisherRaoDistance.jl/badge.svg?branch=master)](https://coveralls.io/github/wadehenning/FisherRaoDistance.jl?branch=master)


This is a repository for calculating the Fisher-Rao Distance between densities and performing hypothesis testing.

##Overview
The key advantages of using the Fisher-Rao Distance for comparing sets of data are that it can be used:
 * parametrically and non-parametrically
 * for multi-dimensional data
 * in various domains (i.e.  **R<sup>n</sup>** or **S<sup>n</sup>**  ) by simply changing the form of the density


###Basic Function Usage
For this example we simply generate and compare three data sets generated from a Normal Distribution.

```
using FisherRaoDistance
using KernelDensityEstimatePlotting

#note that the Fisher-Rao distance does not require the sets to have the same number of points.
points1 = randn(1, 500)
points2 = randn(1, 500) + ones(1, 500) * 0.25
points3 = randn(1, 500) + ones(1, 500) * 0.5

pdf1 = FisherRaoDistance.kde!(points1)
pdf2 = FisherRaoDistance.kde!(points2)
pdf3 = FisherRaoDistance.kde!(points3)  

plot([pdf1; pdf2; pdf3], c = ["red"; "green"; "blue"])




```



<img src ="images/DoesItWork.png" width="300"/>
