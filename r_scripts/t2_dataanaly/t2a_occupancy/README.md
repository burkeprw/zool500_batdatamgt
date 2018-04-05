# Patrick Burke ZOOL500 Directed Studies Project
Date created: ___2017-Nov-11___   
Last modified: ___2017-Nov-27___   
***Code for this task can be found [here](https://github.com/burkeprw/rsh_zool500_bats/blob/master/r_scripts/t2_occupancy/ghd02_occupancy_subset.md).*** 

### Task2: Occupancy Analysis

Here I assess occupancy status for the bat species that occur in the Lower Mainland of BC. This information will provide valualable baseline conditions prior to population impacts from WNS.  

## Methods
I will use `unmarked` to estimate species occupancy.  

1. **Observation covariates:**  
    + ___wind___: Maximum wind gust speed standardized using `standardize:scale()`; EnvCan stations averaged over 4d    
    + ___temp___: Temperature standardized using `standardize:scale()`; EnvCan stations averaged over 4d   
    + ___precip___: Precipitation standardized using `standardize:scale()`; EnvCan stations averaged over 4d    
    + ___date___: Date standardized as a Julian day using `lubridate:yday()` and `standardize:scale()`  
2. **Site covariates:**   
    + ___GLA.x___: canopy gap light measured by a camera lens and Gap Light Analyzer software and standardized using `standardize:scale()`   
    + ___LAI.4___: leaf area index measured by a camera lens and Gap Light Analyzer software and standardized using `standardize:scale()`  
    + ___LAI.5___: leaf area index measured by a camera lens and Gap Light Analyzer software and standardized using `standardize:scale()`    
    + ___elev___: Elevation above sea level standardized using `standardize:scale()`     
    + ___mic_ht___: Microphone height above the ground standardized using `standardize:scale()`   
    + ___mic_type___: Ulreasonic microphone type (three types used  
    + ___det_model___: Bioacoustic detector model name (three types used)     


**Table 2-1:** Bat Species List for BC

Species|Code|Provincial<br>Status|Federal<br>Status|WNS<br>Impacts              
-----------------------------|----|------------|----------------|----------   
Big Brown Bat	               |EPFU|Not At Risk |      	         |Low          
Silver-haired Bat            |LANO|Not At Risk |      	         |Low          
Hoary Bat	                   |LACI|Not At Risk |                |Very Low     
California Myotis            |MYCA|Not At Risk |                |**High**     
Long-eared Myotis	(Keen's)   |MYEV|Not At Risk |Endangered      |**Severe**   
Little Brown Myotis	         |MYLU|Not At Risk |      	         |**Severe**   
Long-legged Myotis	         |MYVO|Not At Risk |      	         |**High**     
Yuma Myotis                  |MYYU|Not At Risk |      	         |**Severe**   
Western Small-footed Myotis  |MYCI|Blue        |                |**Severe**   
Fringed Myotis	             |MYTH|Blue        |Data Deficient  |Unknown        
Northern Myotis       	     |MYSE|Blue	      |Endangered      |**Severe** 
Eastern Red Bat	             |LABO|Unknown     |          	     |Low	       
Townsend's Big-eared Bat	   |COTO|Blue        |          	     |Unknown    
Pallid Bat            	     |ANPA|Red         |Threatened	     |Unknown    
Spotted Bat           	     |EUMA|Blue        |Special Concern |Unknown     

\* WNS Impacts are unknown for all species in the West. However, these qualitative impact categories have been assigned given the magnitude of population response for similar species in the east, species with similar physiology, expert opinion, and disease modeling.


## Model Results

I first modeled occupancy for MYLU, the endangered little brown myotis. In the coming weeks, I will add covariates to the model and estimate occupancy for additional species.   



**Table 2-2:** Preliminary model selection for MYLU

Model|nPars|AIC|delta|AICwt|CumltvWt              
----------------------------------------|-|------|-----|-------|---------  
psi(.)p(mic height)         |3| 165.78| 0.000| 0.3437|     0.34|
psi(.)p(mic type)           |5| 165.81| 0.025| 0.3395|     0.68|
psi(.)p(detector model)     |4| 167.40| 1.620| 0.1529|     0.84|
psi(.)p(detector + mic)     |7| 168.00| 2.211| 0.1138|     0.95|
psi(.)p(precipitation)      |3| 170.92| 5.132 |0.0264|     0.98|
psi(.)p(.)                  |2| 172.29| 6.502| 0.0133|     0.99|
psi(elevation)p(.)          |3| 174.03| 8.248| 0.0056|     1.00|
psi(.)p(date)               |3| 174.28| 8.496| 0.0049|     1.00|

## Top model results MYLU:

**Call:**
Call:
occu(formula = ~mic_ht ~ 1, data = MyluUMF)


**Occupancy:**  

Estimate |SE   |z  |P(>z)   
---------|------|-----|---------  
1.96| 0.589| 3.33| 0.00088  

**Detection:**  

covariate|Estimate|SE|z|P(>z)  
------------|------------|--------|-------|--------  
(Intercept)|    0.987| 0.270|  3.65| 0.000262
mic_ht|        -0.577| 0.215| -2.68| 0.007264

**AIC:** 165.7846 


