1

   Abaqus 6.14-1                                  Date 23-Jun-2018   Time 20:42:29
   For use at CARDIFF UNIVERSITY under license from Dassault Systemes or its subsidiary.

                                                                                 
                                                                                 
 STEP    1     INCREMENT     1     STEP TIME    0.00    
 


                        S T E P       1     M A T R I X   G E N E R A T E
 
  THE FOLLOWING GLOBAL MATRICES WILL BE GENERATED AND WRITTEN TO l9h2SingleIncI0S1_X1.sim

   STIFFNESS
   MASS
 
  IF MULTY-POINT CONSTRAINTS ARE SPECIFIED IN THE MODEL, THEY WILL BE APPLIED
 
  THE FOLLOWING GLOBAL MATRICES WILL BE WRITTEN TO THE FOLLOWING TEXT FILES

   STIFFNESS          TO l9h2SingleIncI0S1_STIF1.mtx
   MASS               TO l9h2SingleIncI0S1_MASS1.mtx
   MATRIX OUTPUT FORMAT - MATRIX INPUT
1

   Abaqus 6.14-1                                  Date 23-Jun-2018   Time 20:42:29
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


 AVERAGE FORCE                      6.014E-06   TIME AVG. FORCE       6.014E-06
 LARGEST RESIDUAL FORCE            -8.674E-18   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -4.511E-03   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -4.511E-03   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -1.660E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      9.470E-02   TIME AVG. FORCE       4.735E-02
 LARGEST RESIDUAL FORCE            -6.525E-54   AT NODE        481   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -3.927E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -2.573E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -7.810E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      0.288       TIME AVG. FORCE       0.128    
 LARGEST RESIDUAL FORCE            -2.776E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.173       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.374E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -0.193     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      0.500       TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -4.996E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.492       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -0.110       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS  -0.212     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  4.040E-02
 STEP TIME COMPLETED       0.400    ,  TOTAL TIME COMPLETED        0.400    


  INCREMENT     5 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      0.500       TIME AVG. FORCE       0.277    
 LARGEST RESIDUAL FORCE             4.996E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.        -0.977       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -5.762E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   2.554E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      0.288       TIME AVG. FORCE       0.278    
 LARGEST RESIDUAL FORCE            -5.829E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.46       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        5.762E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   0.212     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  6.061E-02
 STEP TIME COMPLETED       0.600    ,  TOTAL TIME COMPLETED        0.600    


  INCREMENT     7 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      9.470E-02   TIME AVG. FORCE       0.252    
 LARGEST RESIDUAL FORCE            -1.082E-15   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.78       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        0.110       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   0.193     AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  7.071E-02
 STEP TIME COMPLETED       0.700    ,  TOTAL TIME COMPLETED        0.700    


  INCREMENT     8 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      6.014E-06   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -3.990E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.92       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.374E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THE FORCE     EQUILIBRIUM RESPONSE WAS LINEAR IN THIS INCREMENT

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   7.810E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      5.070E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.598E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        2.573E-02   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   1.660E-02 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        4.511E-03   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.121    
 STEP TIME COMPLETED        1.20    ,  TOTAL TIME COMPLETED         1.20    


  INCREMENT    13 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.141    
 STEP TIME COMPLETED        1.40    ,  TOTAL TIME COMPLETED         1.40    


  INCREMENT    15 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.202    
 STEP TIME COMPLETED        2.00    ,  TOTAL TIME COMPLETED         2.00    


  INCREMENT    21 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.242    
 STEP TIME COMPLETED        2.40    ,  TOTAL TIME COMPLETED         2.40    


  INCREMENT    25 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.263    
 STEP TIME COMPLETED        2.60    ,  TOTAL TIME COMPLETED         2.60    


  INCREMENT    27 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.323    
 STEP TIME COMPLETED        3.20    ,  TOTAL TIME COMPLETED         3.20    


  INCREMENT    33 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =  1.00000E-02
       ELAPSED TOTAL CPU TIME (SEC) =  2.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.333    
 STEP TIME COMPLETED        3.30    ,  TOTAL TIME COMPLETED         3.30    


  INCREMENT    34 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.424    
 STEP TIME COMPLETED        4.20    ,  TOTAL TIME COMPLETED         4.20    


  INCREMENT    43 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =  1.00000E-02
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.444    
 STEP TIME COMPLETED        4.40    ,  TOTAL TIME COMPLETED         4.40    


  INCREMENT    45 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.465    
 STEP TIME COMPLETED        4.60    ,  TOTAL TIME COMPLETED         4.60    


  INCREMENT    47 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.485    
 STEP TIME COMPLETED        4.80    ,  TOTAL TIME COMPLETED         4.80    


  INCREMENT    49 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.495    
 STEP TIME COMPLETED        4.90    ,  TOTAL TIME COMPLETED         4.90    


  INCREMENT    50 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.515    
 STEP TIME COMPLETED        5.10    ,  TOTAL TIME COMPLETED         5.10    


  INCREMENT    52 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.535    
 STEP TIME COMPLETED        5.30    ,  TOTAL TIME COMPLETED         5.30    


  INCREMENT    54 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =  1.00000E-02
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.556    
 STEP TIME COMPLETED        5.50    ,  TOTAL TIME COMPLETED         5.50    


  INCREMENT    56 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.596    
 STEP TIME COMPLETED        5.90    ,  TOTAL TIME COMPLETED         5.90    


  INCREMENT    60 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.616    
 STEP TIME COMPLETED        6.10    ,  TOTAL TIME COMPLETED         6.10    


  INCREMENT    62 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.636    
 STEP TIME COMPLETED        6.30    ,  TOTAL TIME COMPLETED         6.30    


  INCREMENT    64 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.657    
 STEP TIME COMPLETED        6.50    ,  TOTAL TIME COMPLETED         6.50    


  INCREMENT    66 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.667    
 STEP TIME COMPLETED        6.60    ,  TOTAL TIME COMPLETED         6.60    


  INCREMENT    67 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.677    
 STEP TIME COMPLETED        6.70    ,  TOTAL TIME COMPLETED         6.70    


  INCREMENT    68 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.687    
 STEP TIME COMPLETED        6.80    ,  TOTAL TIME COMPLETED         6.80    


  INCREMENT    69 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.707    
 STEP TIME COMPLETED        7.00    ,  TOTAL TIME COMPLETED         7.00    


  INCREMENT    71 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.727    
 STEP TIME COMPLETED        7.20    ,  TOTAL TIME COMPLETED         7.20    


  INCREMENT    73 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.747    
 STEP TIME COMPLETED        7.40    ,  TOTAL TIME COMPLETED         7.40    


  INCREMENT    75 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.788    
 STEP TIME COMPLETED        7.80    ,  TOTAL TIME COMPLETED         7.80    


  INCREMENT    79 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.838    
 STEP TIME COMPLETED        8.30    ,  TOTAL TIME COMPLETED         8.30    


  INCREMENT    84 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.889    
 STEP TIME COMPLETED        8.80    ,  TOTAL TIME COMPLETED         8.80    


  INCREMENT    89 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =   0.0000    
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.899    
 STEP TIME COMPLETED        8.90    ,  TOTAL TIME COMPLETED         8.90    


  INCREMENT    90 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =   0.0000    
       ELAPSED SYSTEM TIME (SEC)    =  1.00000E-02
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.919    
 STEP TIME COMPLETED        9.10    ,  TOTAL TIME COMPLETED         9.10    


  INCREMENT    92 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.929    
 STEP TIME COMPLETED        9.20    ,  TOTAL TIME COMPLETED         9.20    


  INCREMENT    93 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

 ITERATION SUMMARY FOR THE INCREMENT:   1 TOTAL ITERATIONS, OF WHICH
   0 ARE SEVERE DISCONTINUITY ITERATIONS AND  1 ARE EQUILIBRIUM ITERATIONS.

 TIME INCREMENT COMPLETED  0.100    ,  FRACTION OF STEP COMPLETED  0.939    
 STEP TIME COMPLETED        9.30    ,  TOTAL TIME COMPLETED         9.30    


  INCREMENT    94 STARTS. ATTEMPT NUMBER  1, TIME INCREMENT  0.100    

  NUMBER OF EQUATIONS =     1034     NUMBER OF FLOATING PT. OPERATIONS =  9.26E+05

     CHECK POINT   START OF SOLVER    

     CHECK POINT  END OF SOLVER       

       ELAPSED USER TIME (SEC)      =  1.00000E-02
       ELAPSED SYSTEM TIME (SEC)    =   0.0000    
       ELAPSED TOTAL CPU TIME (SEC) =  1.00000E-02
       ELAPSED WALLCLOCK TIME (SEC) =          0

               CONVERGENCE CHECKS FOR EQUILIBRIUM ITERATION     1


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE             5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.        7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   4.707E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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


 AVERAGE FORCE                      4.737E-20   TIME AVG. FORCE       0.221    
 LARGEST RESIDUAL FORCE            -5.230E-16   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST INCREMENT OF DISP.         -1.95       AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
 LARGEST CORRECTION TO DISP.       -7.105E-17   AT NODE          9   DOF  2
   INSTANCE: BEAM-1                                                                          
          THERE IS ZERO FORCE     EVERYWHERE

  MAXIMUM HALF-INCREMENT FORCE RESIDUAL IS   3.661E-15 AND OCCURS AT NODE          9 INSTANCE BEAM-1                                                                          

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
       USER TIME (SEC)      =   8.6200    
       SYSTEM TIME (SEC)    =  0.19000    
       TOTAL CPU TIME (SEC) =   8.8100    
       WALLCLOCK TIME (SEC) =          9
