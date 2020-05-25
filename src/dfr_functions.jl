


function combinepoints(Points)
    allpoints = Points[1]
    numsets  = size(Points,1)
    for i=2:numsets
        allpoints = [allpoints Points[i]]
    end
    return allpoints
end

"""
Map high dimensional points to lower dimension using classicalMDS
    get_low_dim_points(Points, dim)
    :param Points: [d,n,numsets] array of sets of points
    :param dim: the dimension to be mapped to
"""
function get_low_dim_points(Points, dim)
    allpoints = combinepoints(Points)
    dXX = calc_vec_dist(allpoints)
    lowdimpoints = transform(fit(MDS,dXX,maxoutdim=dim, distances=true))
    allpoints = combinepoints(Points)
    dXX = calc_vec_dist(allpoints)
    lowdimpoints = transform(fit(MDS,dXX,maxoutdim=dim, distances=true))
    numsets = size(Points,1)
    numpoints = size(Points[1],2)
    dimpoints = size(lowdimpoints,1)
    newpoints = zeros(dimpoints, numpoints , numsets)
    newpoints = assignpoints!(lowdimpoints, newpoints)

    return newpoints
end


function assignpoints!(lowdimpoints,newpoints)
    numsets = size(newpoints,3)
    numpoints = size(newpoints,2)
    for i=1:numsets
        newpoints[:,:,i] = lowdimpoints[:,1:numpoints]
        lowdimpoints = lowdimpoints[:,numpoints+1:end]
    end
    return newpoints
end

#bootstrap sampling from points
function bootstrapsamples(points)
    n = size(points)
    r = rand(1:n[2],n[2])
    samplepoints = zeros(n[1],n[2])
    for i=1:n[2]
        samplepoints[:,i] = points[:,r[i]]
    end
    return samplepoints
end

"""
Perform two-sample hypothesis testing
    dfr_hypothesistest(Points, dim)
    :param Points: (d,n) array of points
    :param dim: the dimension to be mapped to
"""
function fisherraotest(pdf1, pdf2, n1, n2, dFR)
    numsamples=200
    dfr_samples = ones(numsamples)
    r = rand(numsamples) #use this to select which distribution to sample from
    for i=1:numsamples
        if (r[i] > 0.5)
            sample_points1, ind = sample(pdf1,n1) #sample points from the pdf
            sample_points2, ind = sample(pdf1,n1) #sample points from the pdf
            sample_pdf1 = kde!(sample_points1) #estimate a pdf from the sample points
            sample_pdf2 = kde!(sample_points2) #estimate a pdf from the sample points
            sample_pdf1 = kde!(sample_points1)
            sample_pdf2 = kde!(sample_points2)
            #samplepoints1 = bootstrapsamples(newpoints1)
            #samplepoints2 = bootstrapsamples(newpoints1)
            dfr_samples[i] = fisherraodistance(sample_pdf1, sample_pdf2, sample_points1, sample_points2)
        else
            #samplepoints1 = bootstrapsamples(newpoints2)
            #samplepoints2 = bootstrapsamples(newpoints2)
            sample_points1, ind = sample(pdf2,n2) #sample points from the pdf
            sample_points2, ind = sample(pdf2,n2) #sample points from the pdf
            sample_pdf1 = kde!(sample_points1) #estimate a pdf from the sample points
            sample_pdf2 = kde!(sample_points2) #estimate a pdf from the sample points
            sample_pdf1 = kde!(sample_points1)
            sample_pdf2 = kde!(sample_points2)
            sample_pdf1 = kde!(sample_points1)
            sample_pdf2 = kde!(sample_points2)
            dfr_samples[i] = fisherraodistance(sample_pdf1, sample_pdf2, sample_points1, sample_points2)
        end
    end
    pvalue = length(dfr_samples[dfr_samples.>dFR]) / numsamples
    return [pvalue, dfr_samples]
end

"""
Calculate Euclidean pairwise distances between a set of points
     calc_vec_dist(allpoints)
    :param allpoints: (d,n) array of points
"""
function calc_vec_dist(allpoints)
    N = size(allpoints, 2)
    dXX = zeros(N,N)
    for i = 1:N
        v1 = allpoints[:,i]
        for j=1:N
            v2 = allpoints[:,j]
            dXX[i,j] = sqrt((sum(v1-v2).^2))
        end
    end
    return dXX
end

"""
Estimates the Fisher-Rao Distance between two densities
     fisherraodistance(pdf1, pdf2, points1, points2)
    :params pdf1, pdf2: Ball Density estimates returned from kde!
    :params points1, points2: two [d,n] sets of points being compared
"""
function fisherraodistance(pdf1, pdf2, points1, points2)
    n1 = size(points1,2)
    likelihood_points1_pdf1 = evaluateDualTree(pdf1, points1)
    likelihood_points1_pdf2 = evaluateDualTree(pdf2, points1)
    IP = sum( sqrt.(likelihood_points1_pdf2 ./ likelihood_points1_pdf1) )/n1
    IP = IP > 1 ? 1 : IP
    dfr1 = acos( IP )

    n2 = size(points2,2)
    likelihood_points2_pdf2 = evaluateDualTree(pdf2, points2)
    likelihood_points2_pdf1 = evaluateDualTree(pdf1, points2)
    IP = sum( sqrt.(likelihood_points2_pdf1 ./ likelihood_points2_pdf2) )/n2
    IP = IP > 1 ? 1 : IP
    dfr2 = acos( IP)

    return fisherRaoDistance = (dfr1 + dfr2)/2
end
