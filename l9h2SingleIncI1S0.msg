1

   Abaqus 6.14-1                                  Date 23-Jun-2018   Time 20:43:51
   For use at CARDIFF UNIVERSITY under license from Dassault Systemes or its subsidiary.

                                                                                 
                                                                                 
 STEP    1     INCREMENT     1     STEP TIME    0.00    
 


                        S T E P       1     M A T R I X   G E N E R A T E
 
  THE FOLLOWING GLOBAL MATRICES WILL BE GENERATED AND WRITTEN TO l9h2SingleIncI1S0_X1.sim

   STIFFNESS
   MASS
 
  IF MULTY-POINT CONSTRAINTS ARE SPECIFIED IN THE MODEL, THEY WILL BE APPLIED
 
  THE FOLLOWING GLOBAL MATRICES WILL BE WRITTEN TO THE FOLLOWING TEXT FILES

   STIFFNESS          TO l9h2SingleIncI1S0_STIF1.mtx
   MASS               TO l9h2SingleIncI1S0_MASS1.mtx
   MATRIX OUTPUT FORMAT - MATRIX INPUT
1

   Abaqus 6.14-1                                  Date 23-Jun-2018   Time 20:43:52
   For use at CARDIFF UNIVERSITY under license from Dassault Systemes or its subsidiary.

                                                                                 
                                                                                 
 STEP    2     INCREMENT     1     STEP TIME    0.00    


                        S T E P       2     D Y N A M I C   A N A L Y S I S - I M P L I C I T  I N T E G R A T I O N


                                                                                          

          DYNAMIC APPLICATION PACKED SCHEME IS                 TRANSIENT FIDELITY  
          HILBER-HUGHES-TAYLOR (HHT) TIME INTEGRATOR IS USED

          FIXED TIME INCREMENTS
          TIME INCREMENT IS                                    0.100    
          TIME PERIOD IS                                        9.90    

          HILBER-HUGHES-TAYLOR METHOD PARAMETERS:  ALPHA   IS    0.00000    
                                                   BETA    IS   0.250000    
                                                   GAMMA   IS   0.500000    
          SINGULAR MASS TREATMENT TYPE IS                     ERROR
          CONSERVATIVE TIME INCREMENTATION IS USED
          STEP AMPLITUDE IS                                    STEP

 CONVERGENCE TOLERANCE PARAMETERS FOR FORCE    
     CRITERION FOR RESIDUAL FORCE     FOR A NONLINEAR PROBLEM          5.000E-03
     CRITERION FOR DISP.    CORRECTION IN A NONLINEAR PROBLEM          1.000E-02
     INIT. VALUE OF TIME AVG. FORCE     IS TIME AVG. FORCE     IN PREVIOUS STEP
     AVERAGE FORCE     IS TIME AVERAGE FORCE    
     ALTERNATE CRIT. FOR RESIDUAL FORCE     FOR A NONLINEAR PROBLEM    2.000E-02
     CRITERION FOR ZERO FORCE     RELATIVE TO TIME AVRG. FORCE         1.000E-05
     CRITERION FOR RESIDUAL FORCE     WHEN THERE IS ZERO FLUX          1.000E-05
     CRITERION FOR DISP.    CORRECTION WHEN THERE IS ZERO FLUX         1.000E-03
     CRITERION FOR RESIDUAL FORCE     FOR A LINEAR INCREMENT           1.000E-08
     FIELD CONVERSION RATIO                                             1.00    
     CRITERION FOR ZERO FORCE     REL. TO TIME AVRG. MAX. FORCE        1.000E-05
     CRITERION FOR ZERO DISP.    RELATIVE TO CHARACTERISTIC LENGTH     1.000E-08

     VOLUMETRIC STRAIN COMPATIBILITY TOLERANCE FOR HYBRID SOLIDS       1.000E-05
     AXIAL STRAIN COMPATIBILITY TOLERANCE FOR HYBRID BEAMS             1.000E-05
     TRANS. SHEAR STRAIN COMPATIBILITY TOLERANCE FOR HYBRID BEAMS      1.000E-05
     SOFT CONTACT CONSTRAINT COMPATIBILITY TOLERANCE FOR P>P0          5.000E-03
     SOFT CONTACT CONSTRAINT COMPATIBILITY TOLERANCE FOR P=0.0         0.100    
     CONTACT FORCE ERROR TOLERANCE FOR CONVERT SDI=YES                 1.00    
     DISPLACEMENT COMPATIBILITY TOLERANCE FOR DCOUP ELEMENTS           1.000E-05
     ROTATION COMPATIBILITY TOLERANCE FOR DCOUP ELEMENTS               1.000E-05

 EQUILIBRIUM WILL BE CHECKED FOR SEVERE DISCONTINUITY ITERATIONS

 ITERATION CONTROL PARAMETERS:
     FIRST EQUILIBRIUM ITERATION FOR CONSECUTIVE DIVERGENCE CHECK              4
     EQUILIBRIUM ITERATION AFTER WHICH ALTERNATE RESIDUAL IS USED              9
     MAXIMUM EQUILIBRIUM ITERATIONS ALLOWED                                   16
     MAXIMUM ITERATIONS FOR SEVERE DISCONTINUITIES                            12
     GLOBAL STABILIZATION CONTROL IS NOT USED

          PRINT OF INCREMENT NUMBER, TIME, ETC., EVERY    1  INCREMENTS

     THE MAXIMUM NUMBER OF INCREMENTS IN THIS STEP IS                   10000

     VELOCITY-BASED PARABOLIC EXTRAPOLATION WILL BE USED

     CHARACTERISTIC ELEMENT LENGTH      2.40    

     DETAILS REGARDING ACTUAL SOLUTION WAVEFRONT REQUESTED

     DETAILED OUTPUT OF DIAGNOSTICS TO DATABASE REQUESTED

     PRINT OF INCREMENT NUMBER, TIME, ETC., TO THE MESSAGE FILE EVERY     1  INCREMENTS

     COLLECTING MODEL CONSTRAINT INFORMATION FOR OVERCONSTRAINT CHECKS

     COLLECTING STEP CONSTRAINT INFORMATION FOR OVERCONSTRAINT CHECKS

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =  1.00000E-02
       ELAPSED TOTAL CPU TIME (SEC) =  2.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0


  INCREMENT     1 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      8.004E-06   TIME AVG. FORCE       8.004E-06
 LARGEST RESIDUAL FORCE            -8.674E-18   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -3.819E-03   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.819E-03   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -1.851E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  1.010E-02
 STEP TIME COMPLETED       0.100    ,  TOTAL TIME COMPLETED        0.100    


  INCREMENT     2 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      8.665E-04   TIME AVG. FORCE       4.372E-04
 LARGEST RESIDUAL FORCE             1.388E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -3.103E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -1.958E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -8.809E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  2.020E-02
 STEP TIME COMPLETED       0.200    ,  TOTAL TIME COMPLETED        0.200    


  INCREMENT     3 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      2.661E-03   TIME AVG. FORCE       1.178E-03
 LARGEST RESIDUAL FORCE            -2.220E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.125       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.709E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -0.219     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  3.030E-02
 STEP TIME COMPLETED       0.300    ,  TOTAL TIME COMPLETED        0.300    


  INCREMENT     4 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.882E-03   TIME AVG. FORCE       2.104E-03
 LARGEST RESIDUAL FORCE             1.110E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.306       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.020E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -0.241     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  4.040E-02
 STEP TIME COMPLETED       0.400    ,  TOTAL TIME COMPLETED        0.400    


  INCREMENT     5 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      6.775E-03   TIME AVG. FORCE       3.038E-03
 LARGEST RESIDUAL FORCE             5.551E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.470       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        5.705E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.666E-02 AND OCCURS AT NODE        481 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  5.051E-02
 STEP TIME COMPLETED       0.500    ,  TOTAL TIME COMPLETED        0.500    


  INCREMENT     6 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      8.548E-03   TIME AVG. FORCE       3.957E-03
 LARGEST RESIDUAL FORCE             7.772E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.416       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        0.162       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   0.280     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  6.061E-02
 STEP TIME COMPLETED       0.600    ,  TOTAL TIME COMPLETED        0.600    


  INCREMENT     7 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      9.327E-03   TIME AVG. FORCE       4.724E-03
 LARGEST RESIDUAL FORCE             3.886E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.262       AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        0.116       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   0.267     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  7.071E-02
 STEP TIME COMPLETED       0.700    ,  TOTAL TIME COMPLETED        0.700    


  INCREMENT     8 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      9.100E-03   TIME AVG. FORCE       5.271E-03
 LARGEST RESIDUAL FORCE            -4.163E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.316       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        6.920E-02   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   9.352E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  8.081E-02
 STEP TIME COMPLETED       0.800    ,  TOTAL TIME COMPLETED        0.800    


  INCREMENT     9 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      9.429E-03   TIME AVG. FORCE       5.733E-03
 LARGEST RESIDUAL FORCE            -4.580E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.507       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -0.159       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   8.189E-02 AND OCCURS AT NODE        481 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  9.091E-02
 STEP TIME COMPLETED       0.900    ,  TOTAL TIME COMPLETED        0.900    


  INCREMENT    10 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.035E-02   TIME AVG. FORCE       6.195E-03
 LARGEST RESIDUAL FORCE             4.857E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.410       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -0.129       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -6.209E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.101    
 STEP TIME COMPLETED        1.00    ,  TOTAL TIME COMPLETED         1.00    


  INCREMENT    11 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.078E-02   TIME AVG. FORCE       6.612E-03
 LARGEST RESIDUAL FORCE             7.633E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.293       AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.308E-02   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -4.745E-02 AND OCCURS AT NODE        481 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.111    
 STEP TIME COMPLETED        1.10    ,  TOTAL TIME COMPLETED         1.10    


  INCREMENT    12 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.074E-02   TIME AVG. FORCE       6.956E-03
 LARGEST RESIDUAL FORCE             1.235E-15   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.258       AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.698E-02   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -6.006E-02 AND OCCURS AT NODE        481 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.121    
 STEP TIME COMPLETED        1.20    ,  TOTAL TIME COMPLETED         1.20    


  INCREMENT    13 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.128E-02   TIME AVG. FORCE       7.288E-03
 LARGEST RESIDUAL FORCE            -3.469E-16   AT NODE        480   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.166       AT NODE        118   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.734E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -5.357E-02 AND OCCURS AT NODE        481 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.131    
 STEP TIME COMPLETED        1.30    ,  TOTAL TIME COMPLETED         1.30    


  INCREMENT    14 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.193E-02   TIME AVG. FORCE       7.620E-03
 LARGEST RESIDUAL FORCE            -5.759E-16   AT NODE        471   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.176       AT NODE        118   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -6.587E-02   AT NODE          9   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.470E-02 AND OCCURS AT NODE        481 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.141    
 STEP TIME COMPLETED        1.40    ,  TOTAL TIME COMPLETED         1.40    


  INCREMENT    15 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.245E-02   TIME AVG. FORCE       7.942E-03
 LARGEST RESIDUAL FORCE            -3.053E-16   AT NODE        471   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.183       AT NODE        471   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        5.115E-02   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.250E-02 AND OCCURS AT NODE        499 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.152    
 STEP TIME COMPLETED        1.50    ,  TOTAL TIME COMPLETED         1.50    


  INCREMENT    16 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.336E-02   TIME AVG. FORCE       8.280E-03
 LARGEST RESIDUAL FORCE            -6.731E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.144       AT NODE        470   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.967E-02   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -4.247E-02 AND OCCURS AT NODE        471 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.162    
 STEP TIME COMPLETED        1.60    ,  TOTAL TIME COMPLETED         1.60    


  INCREMENT    17 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.429E-02   TIME AVG. FORCE       8.634E-03
 LARGEST RESIDUAL FORCE            -2.359E-16   AT NODE        470   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.155       AT NODE        470   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        5.321E-02   AT NODE          9   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.143E-02 AND OCCURS AT NODE        499 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.172    
 STEP TIME COMPLETED        1.70    ,  TOTAL TIME COMPLETED         1.70    


  INCREMENT    18 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.469E-02   TIME AVG. FORCE       8.971E-03
 LARGEST RESIDUAL FORCE            -4.233E-16   AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.146       AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.800E-02   AT NODE        117   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -4.423E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.182    
 STEP TIME COMPLETED        1.80    ,  TOTAL TIME COMPLETED         1.80    


  INCREMENT    19 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.475E-02   TIME AVG. FORCE       9.275E-03
 LARGEST RESIDUAL FORCE             6.245E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.172       AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.534E-02   AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.606E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.192    
 STEP TIME COMPLETED        1.90    ,  TOTAL TIME COMPLETED         1.90    


  INCREMENT    20 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.505E-02   TIME AVG. FORCE       9.563E-03
 LARGEST RESIDUAL FORCE             3.192E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.132       AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.242E-02   AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -4.617E-02 AND OCCURS AT NODE        499 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.202    
 STEP TIME COMPLETED        2.00    ,  TOTAL TIME COMPLETED         2.00    


  INCREMENT    21 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.575E-02   TIME AVG. FORCE       9.858E-03
 LARGEST RESIDUAL FORCE             2.359E-16   AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.140       AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.697E-02   AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.268E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.212    
 STEP TIME COMPLETED        2.10    ,  TOTAL TIME COMPLETED         2.10    


  INCREMENT    22 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.544E-02   TIME AVG. FORCE       1.011E-02
 LARGEST RESIDUAL FORCE            -2.151E-16   AT NODE        459   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.103       AT NODE        459   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.767E-02   AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.321E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.222    
 STEP TIME COMPLETED        2.20    ,  TOTAL TIME COMPLETED         2.20    


  INCREMENT    23 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.519E-02   TIME AVG. FORCE       1.033E-02
 LARGEST RESIDUAL FORCE            -2.914E-16   AT NODE         17   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.132       AT NODE        507   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.273E-02   AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.777E-02 AND OCCURS AT NODE        498 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.232    
 STEP TIME COMPLETED        2.30    ,  TOTAL TIME COMPLETED         2.30    


  INCREMENT    24 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.488E-02   TIME AVG. FORCE       1.052E-02
 LARGEST RESIDUAL FORCE            -2.394E-16   AT NODE         17   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.124       AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.357E-02   AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.106E-02 AND OCCURS AT NODE        499 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.242    
 STEP TIME COMPLETED        2.40    ,  TOTAL TIME COMPLETED         2.40    


  INCREMENT    25 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.587E-02   TIME AVG. FORCE       1.074E-02
 LARGEST RESIDUAL FORCE             5.586E-16   AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.144       AT NODE          2   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.155E-02   AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.390E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.253    
 STEP TIME COMPLETED        2.50    ,  TOTAL TIME COMPLETED         2.50    


  INCREMENT    26 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.617E-02   TIME AVG. FORCE       1.094E-02
 LARGEST RESIDUAL FORCE             2.429E-16   AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.153       AT NODE          2   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.201E-02   AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.116E-02 AND OCCURS AT NODE        480 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.263    
 STEP TIME COMPLETED        2.60    ,  TOTAL TIME COMPLETED         2.60    


  INCREMENT    27 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.685E-02   TIME AVG. FORCE       1.116E-02
 LARGEST RESIDUAL FORCE            -2.394E-16   AT NODE        499   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.128       AT NODE          2   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.337E-02   AT NODE        479   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.633E-02 AND OCCURS AT NODE        479 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.273    
 STEP TIME COMPLETED        2.70    ,  TOTAL TIME COMPLETED         2.70    


  INCREMENT    28 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.738E-02   TIME AVG. FORCE       1.139E-02
 LARGEST RESIDUAL FORCE            -3.816E-16   AT NODE         67   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.106       AT NODE          5   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.500E-02   AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.208E-02 AND OCCURS AT NODE        479 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.283    
 STEP TIME COMPLETED        2.80    ,  TOTAL TIME COMPLETED         2.80    


  INCREMENT    29 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.696E-02   TIME AVG. FORCE       1.158E-02
 LARGEST RESIDUAL FORCE            -3.435E-16   AT NODE        506   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.111       AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.886E-02   AT NODE        498   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.050E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.293    
 STEP TIME COMPLETED        2.90    ,  TOTAL TIME COMPLETED         2.90    


  INCREMENT    30 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.591E-02   TIME AVG. FORCE       1.172E-02
 LARGEST RESIDUAL FORCE            -2.793E-16   AT NODE        479   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.110       AT NODE        469   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.868E-02   AT NODE        479   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.862E-02 AND OCCURS AT NODE        515 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.303    
 STEP TIME COMPLETED        3.00    ,  TOTAL TIME COMPLETED         3.00    


  INCREMENT    31 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.581E-02   TIME AVG. FORCE       1.185E-02
 LARGEST RESIDUAL FORCE            -1.804E-16   AT NODE         15   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.120       AT NODE        448   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.209E-02   AT NODE        469   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.527E-02 AND OCCURS AT NODE        479 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.313    
 STEP TIME COMPLETED        3.10    ,  TOTAL TIME COMPLETED         3.10    


  INCREMENT    32 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.615E-02   TIME AVG. FORCE       1.199E-02
 LARGEST RESIDUAL FORCE            -2.047E-16   AT NODE        445   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.133       AT NODE        468   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.016E-02   AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.329E-02 AND OCCURS AT NODE        489 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.323    
 STEP TIME COMPLETED        3.20    ,  TOTAL TIME COMPLETED         3.20    


  INCREMENT    33 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.614E-02   TIME AVG. FORCE       1.211E-02
 LARGEST RESIDUAL FORCE             3.053E-16   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.114       AT NODE        468   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.134E-02   AT NODE        468   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.109E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.333    
 STEP TIME COMPLETED        3.30    ,  TOTAL TIME COMPLETED         3.30    


  INCREMENT    34 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.648E-02   TIME AVG. FORCE       1.224E-02
 LARGEST RESIDUAL FORCE            -2.359E-16   AT NODE         16   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.133       AT NODE        467   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.374E-02   AT NODE        489   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.769E-02 AND OCCURS AT NODE        516 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.343    
 STEP TIME COMPLETED        3.40    ,  TOTAL TIME COMPLETED         3.40    


  INCREMENT    35 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.659E-02   TIME AVG. FORCE       1.237E-02
 LARGEST RESIDUAL FORCE             3.296E-16   AT NODE        467   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.101       AT NODE        467   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.654E-02   AT NODE        117   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.328E-02 AND OCCURS AT NODE        489 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.354    
 STEP TIME COMPLETED        3.50    ,  TOTAL TIME COMPLETED         3.50    


  INCREMENT    36 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.720E-02   TIME AVG. FORCE       1.250E-02
 LARGEST RESIDUAL FORCE             2.151E-16   AT NODE        448   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.123       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.681E-02   AT NODE        516   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.065E-02 AND OCCURS AT NODE        490 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.364    
 STEP TIME COMPLETED        3.60    ,  TOTAL TIME COMPLETED         3.60    


  INCREMENT    37 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.657E-02   TIME AVG. FORCE       1.261E-02
 LARGEST RESIDUAL FORCE             2.220E-16   AT NODE        515   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.152       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.887E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.562E-02 AND OCCURS AT NODE        444 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.374    
 STEP TIME COMPLETED        3.70    ,  TOTAL TIME COMPLETED         3.70    


  INCREMENT    38 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.641E-02   TIME AVG. FORCE       1.271E-02
 LARGEST RESIDUAL FORCE             2.810E-16   AT NODE        467   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.136       AT NODE         16   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.519E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.532E-02 AND OCCURS AT NODE        478 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.384    
 STEP TIME COMPLETED        3.80    ,  TOTAL TIME COMPLETED         3.80    


  INCREMENT    39 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.666E-02   TIME AVG. FORCE       1.281E-02
 LARGEST RESIDUAL FORCE             3.053E-16   AT NODE        505   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.112       AT NODE         15   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.715E-02   AT NODE        117   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.005E-02 AND OCCURS AT NODE        515 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.394    
 STEP TIME COMPLETED        3.90    ,  TOTAL TIME COMPLETED         3.90    


  INCREMENT    40 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.690E-02   TIME AVG. FORCE       1.291E-02
 LARGEST RESIDUAL FORCE            -2.940E-16   AT NODE        464   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.145       AT NODE         15   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.199E-02   AT NODE        478   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.637E-02 AND OCCURS AT NODE        505 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.404    
 STEP TIME COMPLETED        4.00    ,  TOTAL TIME COMPLETED         4.00    


  INCREMENT    41 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.595E-02   TIME AVG. FORCE       1.299E-02
 LARGEST RESIDUAL FORCE             3.140E-16   AT NODE        447   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.165       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.258E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.113E-02 AND OCCURS AT NODE        478 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.414    
 STEP TIME COMPLETED        4.10    ,  TOTAL TIME COMPLETED         4.10    


  INCREMENT    42 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.673E-02   TIME AVG. FORCE       1.308E-02
 LARGEST RESIDUAL FORCE             2.914E-16   AT NODE        476   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.163       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.601E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.555E-02 AND OCCURS AT NODE        504 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.424    
 STEP TIME COMPLETED        4.20    ,  TOTAL TIME COMPLETED         4.20    


  INCREMENT    43 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.677E-02   TIME AVG. FORCE       1.316E-02
 LARGEST RESIDUAL FORCE            -4.302E-16   AT NODE        477   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.130       AT NODE        130   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.400E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.107E-02 AND OCCURS AT NODE        477 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.434    
 STEP TIME COMPLETED        4.30    ,  TOTAL TIME COMPLETED         4.30    


  INCREMENT    44 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.691E-02   TIME AVG. FORCE       1.325E-02
 LARGEST RESIDUAL FORCE            -3.712E-16   AT NODE        439   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.112       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.584E-02   AT NODE        123   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.519E-02 AND OCCURS AT NODE        478 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.444    
 STEP TIME COMPLETED        4.40    ,  TOTAL TIME COMPLETED         4.40    


  INCREMENT    45 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.709E-02   TIME AVG. FORCE       1.333E-02
 LARGEST RESIDUAL FORCE             2.290E-16   AT NODE        513   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.126       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.168E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.989E-02 AND OCCURS AT NODE        450 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.455    
 STEP TIME COMPLETED        4.50    ,  TOTAL TIME COMPLETED         4.50    


  INCREMENT    46 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.747E-02   TIME AVG. FORCE       1.342E-02
 LARGEST RESIDUAL FORCE            -2.290E-16   AT NODE        490   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.137       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.541E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.671E-02 AND OCCURS AT NODE        506 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.465    
 STEP TIME COMPLETED        4.60    ,  TOTAL TIME COMPLETED         4.60    


  INCREMENT    47 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.691E-02   TIME AVG. FORCE       1.350E-02
 LARGEST RESIDUAL FORCE            -2.012E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.111       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.083E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.815E-02 AND OCCURS AT NODE        457 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.475    
 STEP TIME COMPLETED        4.70    ,  TOTAL TIME COMPLETED         4.70    


  INCREMENT    48 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.610E-02   TIME AVG. FORCE       1.355E-02
 LARGEST RESIDUAL FORCE            -5.551E-16   AT NODE        506   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         9.983E-02   AT NODE        126   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.113E-02   AT NODE        506   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.823E-02 AND OCCURS AT NODE        450 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.485    
 STEP TIME COMPLETED        4.80    ,  TOTAL TIME COMPLETED         4.80    


  INCREMENT    49 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.694E-02   TIME AVG. FORCE       1.362E-02
 LARGEST RESIDUAL FORCE             2.741E-16   AT NODE        452   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.119       AT NODE        457   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.232E-02   AT NODE        457   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.047E-02 AND OCCURS AT NODE        506 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.495    
 STEP TIME COMPLETED        4.90    ,  TOTAL TIME COMPLETED         4.90    


  INCREMENT    50 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.730E-02   TIME AVG. FORCE       1.370E-02
 LARGEST RESIDUAL FORCE             2.984E-16   AT NODE        483   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         9.813E-02   AT NODE        127   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.906E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.791E-02 AND OCCURS AT NODE        457 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.505    
 STEP TIME COMPLETED        5.00    ,  TOTAL TIME COMPLETED         5.00    


  INCREMENT    51 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.643E-02   TIME AVG. FORCE       1.375E-02
 LARGEST RESIDUAL FORCE            -3.678E-16   AT NODE        502   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.121       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.528E-02   AT NODE        506   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.571E-02 AND OCCURS AT NODE        457 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.515    
 STEP TIME COMPLETED        5.10    ,  TOTAL TIME COMPLETED         5.10    


  INCREMENT    52 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.610E-02   TIME AVG. FORCE       1.379E-02
 LARGEST RESIDUAL FORCE            -2.949E-16   AT NODE        447   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.161       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.519E-02   AT NODE        456   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.524E-02 AND OCCURS AT NODE        495 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.525    
 STEP TIME COMPLETED        5.20    ,  TOTAL TIME COMPLETED         5.20    


  INCREMENT    53 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.634E-02   TIME AVG. FORCE       1.384E-02
 LARGEST RESIDUAL FORCE             3.608E-16   AT NODE        457   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.157       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.660E-02   AT NODE        457   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.887E-02 AND OCCURS AT NODE        456 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.535    
 STEP TIME COMPLETED        5.30    ,  TOTAL TIME COMPLETED         5.30    


  INCREMENT    54 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.683E-02   TIME AVG. FORCE       1.390E-02
 LARGEST RESIDUAL FORCE             2.082E-16   AT NODE        461   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.116       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.852E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.133E-02 AND OCCURS AT NODE        457 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.545    
 STEP TIME COMPLETED        5.40    ,  TOTAL TIME COMPLETED         5.40    


  INCREMENT    55 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.699E-02   TIME AVG. FORCE       1.395E-02
 LARGEST RESIDUAL FORCE             1.874E-16   AT NODE        449   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.128       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.823E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.061E-02 AND OCCURS AT NODE        495 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.556    
 STEP TIME COMPLETED        5.50    ,  TOTAL TIME COMPLETED         5.50    


  INCREMENT    56 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.620E-02   TIME AVG. FORCE       1.399E-02
 LARGEST RESIDUAL FORCE             2.637E-16   AT NODE        449   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.121       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.908E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.997E-02 AND OCCURS AT NODE        456 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.566    
 STEP TIME COMPLETED        5.60    ,  TOTAL TIME COMPLETED         5.60    


  INCREMENT    57 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.527E-02   TIME AVG. FORCE       1.402E-02
 LARGEST RESIDUAL FORCE            -2.602E-16   AT NODE        505   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.149       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.530E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.451E-02 AND OCCURS AT NODE        494 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.576    
 STEP TIME COMPLETED        5.70    ,  TOTAL TIME COMPLETED         5.70    


  INCREMENT    58 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.617E-02   TIME AVG. FORCE       1.405E-02
 LARGEST RESIDUAL FORCE             3.365E-16   AT NODE        495   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.147       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.348E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.849E-02 AND OCCURS AT NODE        447 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.586    
 STEP TIME COMPLETED        5.80    ,  TOTAL TIME COMPLETED         5.80    


  INCREMENT    59 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.695E-02   TIME AVG. FORCE       1.410E-02
 LARGEST RESIDUAL FORCE            -3.296E-16   AT NODE        494   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.158       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        5.294E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.065E-02 AND OCCURS AT NODE        493 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.596    
 STEP TIME COMPLETED        5.90    ,  TOTAL TIME COMPLETED         5.90    


  INCREMENT    60 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.704E-02   TIME AVG. FORCE       1.415E-02
 LARGEST RESIDUAL FORCE             2.758E-16   AT NODE         69   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.128       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.984E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.454E-02 AND OCCURS AT NODE        494 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.606    
 STEP TIME COMPLETED        6.00    ,  TOTAL TIME COMPLETED         6.00    


  INCREMENT    61 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.725E-02   TIME AVG. FORCE       1.420E-02
 LARGEST RESIDUAL FORCE             4.094E-16   AT NODE        461   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.147       AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        5.101E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.051E-02 AND OCCURS AT NODE        498 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.616    
 STEP TIME COMPLETED        6.10    ,  TOTAL TIME COMPLETED         6.10    


  INCREMENT    62 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.630E-02   TIME AVG. FORCE       1.424E-02
 LARGEST RESIDUAL FORCE             2.255E-16   AT NODE         10   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.132       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.770E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.054E-02 AND OCCURS AT NODE        493 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.626    
 STEP TIME COMPLETED        6.20    ,  TOTAL TIME COMPLETED         6.20    


  INCREMENT    63 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.656E-02   TIME AVG. FORCE       1.427E-02
 LARGEST RESIDUAL FORCE            -4.441E-16   AT NODE         11   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.132       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.924E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.588E-02 AND OCCURS AT NODE        493 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.636    
 STEP TIME COMPLETED        6.30    ,  TOTAL TIME COMPLETED         6.30    


  INCREMENT    64 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.752E-02   TIME AVG. FORCE       1.432E-02
 LARGEST RESIDUAL FORCE            -2.047E-16   AT NODE        493   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.117       AT NODE        493   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.429E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.443E-02 AND OCCURS AT NODE        498 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.646    
 STEP TIME COMPLETED        6.40    ,  TOTAL TIME COMPLETED         6.40    


  INCREMENT    65 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.821E-02   TIME AVG. FORCE       1.438E-02
 LARGEST RESIDUAL FORCE             1.891E-16   AT NODE        437   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.127       AT NODE        493   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.014E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.613E-02 AND OCCURS AT NODE        498 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.657    
 STEP TIME COMPLETED        6.50    ,  TOTAL TIME COMPLETED         6.50    


  INCREMENT    66 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.693E-02   TIME AVG. FORCE       1.442E-02
 LARGEST RESIDUAL FORCE            -3.053E-16   AT NODE        474   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.146       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.765E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.371E-02 AND OCCURS AT NODE        438 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.667    
 STEP TIME COMPLETED        6.60    ,  TOTAL TIME COMPLETED         6.60    


  INCREMENT    67 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.535E-02   TIME AVG. FORCE       1.444E-02
 LARGEST RESIDUAL FORCE             2.914E-16   AT NODE         69   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.166       AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.664E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.578E-02 AND OCCURS AT NODE        498 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.677    
 STEP TIME COMPLETED        6.70    ,  TOTAL TIME COMPLETED         6.70    


  INCREMENT    68 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.480E-02   TIME AVG. FORCE       1.444E-02
 LARGEST RESIDUAL FORCE            -2.359E-16   AT NODE         69   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.172       AT NODE         69   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.104E-02   AT NODE         69   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.518E-02 AND OCCURS AT NODE        498 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.687    
 STEP TIME COMPLETED        6.80    ,  TOTAL TIME COMPLETED         6.80    


  INCREMENT    69 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.605E-02   TIME AVG. FORCE       1.446E-02
 LARGEST RESIDUAL FORCE             3.053E-16   AT NODE         10   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.127       AT NODE         69   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.753E-02   AT NODE        130   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.777E-02 AND OCCURS AT NODE        438 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.697    
 STEP TIME COMPLETED        6.90    ,  TOTAL TIME COMPLETED         6.90    


  INCREMENT    70 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.701E-02   TIME AVG. FORCE       1.450E-02
 LARGEST RESIDUAL FORCE            -2.776E-16   AT NODE        453   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.112       AT NODE        126   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.102E-02   AT NODE        126   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.300E-02 AND OCCURS AT NODE        449 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.707    
 STEP TIME COMPLETED        7.00    ,  TOTAL TIME COMPLETED         7.00    


  INCREMENT    71 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.763E-02   TIME AVG. FORCE       1.454E-02
 LARGEST RESIDUAL FORCE             4.718E-16   AT NODE        513   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.124       AT NODE        123   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.217E-02   AT NODE        126   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.558E-02 AND OCCURS AT NODE        449 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.717    
 STEP TIME COMPLETED        7.10    ,  TOTAL TIME COMPLETED         7.10    


  INCREMENT    72 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.659E-02   TIME AVG. FORCE       1.457E-02
 LARGEST RESIDUAL FORCE            -2.845E-16   AT NODE        501   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.165       AT NODE        123   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.667E-02   AT NODE        130   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.634E-02 AND OCCURS AT NODE        438 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.727    
 STEP TIME COMPLETED        7.20    ,  TOTAL TIME COMPLETED         7.20    


  INCREMENT    73 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.667E-02   TIME AVG. FORCE       1.460E-02
 LARGEST RESIDUAL FORCE            -3.868E-16   AT NODE        503   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.140       AT NODE        123   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.286E-02   AT NODE        123   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.179E-02 AND OCCURS AT NODE        504 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.737    
 STEP TIME COMPLETED        7.30    ,  TOTAL TIME COMPLETED         7.30    


  INCREMENT    74 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.728E-02   TIME AVG. FORCE       1.464E-02
 LARGEST RESIDUAL FORCE            -2.290E-16   AT NODE        514   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.122       AT NODE        126   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.495E-02   AT NODE        130   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.012E-02 AND OCCURS AT NODE        439 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.747    
 STEP TIME COMPLETED        7.40    ,  TOTAL TIME COMPLETED         7.40    


  INCREMENT    75 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.736E-02   TIME AVG. FORCE       1.467E-02
 LARGEST RESIDUAL FORCE            -2.186E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.121       AT NODE        126   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.044E-02   AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.429E-02 AND OCCURS AT NODE        438 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.758    
 STEP TIME COMPLETED        7.50    ,  TOTAL TIME COMPLETED         7.50    


  INCREMENT    76 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.584E-02   TIME AVG. FORCE       1.469E-02
 LARGEST RESIDUAL FORCE            -1.769E-16   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.125       AT NODE         12   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.608E-02   AT NODE        115   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.595E-02 AND OCCURS AT NODE        504 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.768    
 STEP TIME COMPLETED        7.60    ,  TOTAL TIME COMPLETED         7.60    


  INCREMENT    77 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.520E-02   TIME AVG. FORCE       1.470E-02
 LARGEST RESIDUAL FORCE            -3.018E-16   AT NODE        447   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.135       AT NODE         12   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.140E-02   AT NODE        130   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.529E-02 AND OCCURS AT NODE        514 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.778    
 STEP TIME COMPLETED        7.70    ,  TOTAL TIME COMPLETED         7.70    


  INCREMENT    78 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.647E-02   TIME AVG. FORCE       1.472E-02
 LARGEST RESIDUAL FORCE            -2.012E-16   AT NODE         16   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.131       AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.838E-02   AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.807E-02 AND OCCURS AT NODE        447 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.788    
 STEP TIME COMPLETED        7.80    ,  TOTAL TIME COMPLETED         7.80    


  INCREMENT    79 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.756E-02   TIME AVG. FORCE       1.476E-02
 LARGEST RESIDUAL FORCE             3.123E-16   AT NODE        464   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.133       AT NODE        127   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.038E-02   AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.395E-02 AND OCCURS AT NODE        456 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.798    
 STEP TIME COMPLETED        7.90    ,  TOTAL TIME COMPLETED         7.90    


  INCREMENT    80 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.666E-02   TIME AVG. FORCE       1.478E-02
 LARGEST RESIDUAL FORCE            -1.665E-16   AT NODE        503   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.104       AT NODE        124   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.010E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -3.202E-02 AND OCCURS AT NODE        514 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.808    
 STEP TIME COMPLETED        8.00    ,  TOTAL TIME COMPLETED         8.00    


  INCREMENT    81 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.619E-02   TIME AVG. FORCE       1.480E-02
 LARGEST RESIDUAL FORCE             3.192E-16   AT NODE         70   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.129       AT NODE          1   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.613E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.036E-02 AND OCCURS AT NODE        437 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.818    
 STEP TIME COMPLETED        8.10    ,  TOTAL TIME COMPLETED         8.10    


  INCREMENT    82 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.765E-02   TIME AVG. FORCE       1.483E-02
 LARGEST RESIDUAL FORCE            -2.498E-16   AT NODE         70   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.140       AT NODE          1   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.264E-02   AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.170E-02 AND OCCURS AT NODE        513 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.828    
 STEP TIME COMPLETED        8.20    ,  TOTAL TIME COMPLETED         8.20    


  INCREMENT    83 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.801E-02   TIME AVG. FORCE       1.487E-02
 LARGEST RESIDUAL FORCE             1.457E-16   AT NODE        457   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.125       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.092E-02   AT NODE        127   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.693E-02 AND OCCURS AT NODE        514 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.838    
 STEP TIME COMPLETED        8.30    ,  TOTAL TIME COMPLETED         8.30    


  INCREMENT    84 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.685E-02   TIME AVG. FORCE       1.489E-02
 LARGEST RESIDUAL FORCE            -2.047E-16   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.141       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.503E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.781E-02 AND OCCURS AT NODE        486 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.848    
 STEP TIME COMPLETED        8.40    ,  TOTAL TIME COMPLETED         8.40    


  INCREMENT    85 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.573E-02   TIME AVG. FORCE       1.490E-02
 LARGEST RESIDUAL FORCE             3.487E-16   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.124       AT NODE          6   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -3.137E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.060E-02 AND OCCURS AT NODE        125 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.859    
 STEP TIME COMPLETED        8.50    ,  TOTAL TIME COMPLETED         8.50    


  INCREMENT    86 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.686E-02   TIME AVG. FORCE       1.493E-02
 LARGEST RESIDUAL FORCE            -3.365E-16   AT NODE        468   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.122       AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.768E-02   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.715E-02 AND OCCURS AT NODE        503 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.869    
 STEP TIME COMPLETED        8.60    ,  TOTAL TIME COMPLETED         8.60    


  INCREMENT    87 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.795E-02   TIME AVG. FORCE       1.496E-02
 LARGEST RESIDUAL FORCE             2.637E-16   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.108       AT NODE        125   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.142E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.581E-02 AND OCCURS AT NODE        517 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.879    
 STEP TIME COMPLETED        8.70    ,  TOTAL TIME COMPLETED         8.70    


  INCREMENT    88 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.683E-02   TIME AVG. FORCE       1.498E-02
 LARGEST RESIDUAL FORCE            -2.567E-16   AT NODE        503   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.117       AT NODE        473   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.654E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.723E-02 AND OCCURS AT NODE        486 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.889    
 STEP TIME COMPLETED        8.80    ,  TOTAL TIME COMPLETED         8.80    


  INCREMENT    89 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.564E-02   TIME AVG. FORCE       1.499E-02
 LARGEST RESIDUAL FORCE            -3.608E-16   AT NODE        513   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.104       AT NODE        473   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.568E-02   AT NODE        517   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.690E-02 AND OCCURS AT NODE        503 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.899    
 STEP TIME COMPLETED        8.90    ,  TOTAL TIME COMPLETED         8.90    


  INCREMENT    90 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.649E-02   TIME AVG. FORCE       1.501E-02
 LARGEST RESIDUAL FORCE            -4.441E-16   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.101       AT NODE        493   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.776E-02   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.186E-02 AND OCCURS AT NODE        517 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.909    
 STEP TIME COMPLETED        9.00    ,  TOTAL TIME COMPLETED         9.00    


  INCREMENT    91 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.822E-02   TIME AVG. FORCE       1.504E-02
 LARGEST RESIDUAL FORCE            -2.914E-16   AT NODE        486   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.109       AT NODE         17   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.495E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.530E-02 AND OCCURS AT NODE        476 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.919    
 STEP TIME COMPLETED        9.10    ,  TOTAL TIME COMPLETED         9.10    


  INCREMENT    92 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.743E-02   TIME AVG. FORCE       1.507E-02
 LARGEST RESIDUAL FORCE             2.151E-16   AT NODE        461   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.124       AT NODE         14   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.986E-02   AT NODE        125   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.370E-02 AND OCCURS AT NODE        475 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.929    
 STEP TIME COMPLETED        9.20    ,  TOTAL TIME COMPLETED         9.20    


  INCREMENT    93 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.616E-02   TIME AVG. FORCE       1.508E-02
 LARGEST RESIDUAL FORCE             2.706E-16   AT NODE        503   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.126       AT NODE         14   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.197E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.040E-02 AND OCCURS AT NODE        449 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.939    
 STEP TIME COMPLETED        9.30    ,  TOTAL TIME COMPLETED         9.30    


  INCREMENT    94 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.724E-02   TIME AVG. FORCE       1.510E-02
 LARGEST RESIDUAL FORCE             3.608E-16   AT NODE         14   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         0.101       AT NODE          2   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.368E-02   AT NODE        129   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.618E-02 AND OCCURS AT NODE        503 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.949    
 STEP TIME COMPLETED        9.40    ,  TOTAL TIME COMPLETED         9.40    


  INCREMENT    95 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.729E-02   TIME AVG. FORCE       1.512E-02
 LARGEST RESIDUAL FORCE             2.914E-16   AT NODE        504   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.122       AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.463E-02   AT NODE        128   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -1.887E-02 AND OCCURS AT NODE        502 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.960    
 STEP TIME COMPLETED        9.50    ,  TOTAL TIME COMPLETED         9.50    


  INCREMENT    96 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.605E-02   TIME AVG. FORCE       1.513E-02
 LARGEST RESIDUAL FORCE            -2.758E-16   AT NODE         13   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.118       AT NODE        504   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.853E-02   AT NODE        122   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.658E-02 AND OCCURS AT NODE        493 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.970    
 STEP TIME COMPLETED        9.60    ,  TOTAL TIME COMPLETED         9.60    


  INCREMENT    97 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.690E-02   TIME AVG. FORCE       1.515E-02
 LARGEST RESIDUAL FORCE             4.788E-16   AT NODE        504   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.126       AT NODE        464   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.660E-02   AT NODE        504   DOF  1
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -2.467E-02 AND OCCURS AT NODE        493 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.980    
 STEP TIME COMPLETED        9.70    ,  TOTAL TIME COMPLETED         9.70    


  INCREMENT    98 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.811E-02   TIME AVG. FORCE       1.518E-02
 LARGEST RESIDUAL FORCE            -2.082E-16   AT NODE         15   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.145       AT NODE        464   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        3.238E-02   AT NODE        464   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.544E-02 AND OCCURS AT NODE        485 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.990    
 STEP TIME COMPLETED        9.80    ,  TOTAL TIME COMPLETED         9.80    


  INCREMENT    99 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      1.772E-02   TIME AVG. FORCE       1.521E-02
 LARGEST RESIDUAL FORCE             1.839E-16   AT NODE        467   DOF  1
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.102       AT NODE        127   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.902E-02   AT NODE        464   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.134E-02 AND OCCURS AT NODE        464 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED   1.00    
 STEP TIME COMPLETED        9.90    ,  TOTAL TIME COMPLETED         9.90    


          THE ANALYSIS HAS BEEN COMPLETED



     ANALYSIS SUMMARY:
     TOTAL OF        100  INCREMENTS
                       0  CUTBACKS IN AUTOMATIC INCREMENTATION
                      99  ITERATIONS INCLUDING CONTACT ITERATIONS IF PRESENT
                     101  PASSES THROUGH THE EQUATION SOLVER OF WHICH 
                       3  INVOLVE MATRIX DECOMPOSITION, INCLUDING
                       2  DECOMPOSITION(S) OF THE MASS MATRIX
                       1  REORDERING OF EQUATIONS TO MINIMIZE WAVEFRONT
                       0  ADDITIONAL RESIDUAL EVALUATIONS FOR LINE SEARCHES
                       0  ADDITIONAL OPERATOR EVALUATIONS FOR LINE SEARCHES
                       2  WARNING MESSAGES DURING USER INPUT PROCESSING
                       0  WARNING MESSAGES DURING ANALYSIS
                       0  ANALYSIS WARNINGS ARE NUMERICAL PROBLEM MESSAGES
                       0  ANALYSIS WARNINGS ARE NEGATIVE EIGENVALUE MESSAGES
                       0  ERROR MESSAGES



     JOB TIME SUMMARY
       USER TIME (SEC)      =   8.7100    
       SYSTEM TIME (SEC)    =  0.18000    
       TOTAL CPU TIME (SEC) =   8.8900    
       WALLCLOCK TIME (SEC) =          9
