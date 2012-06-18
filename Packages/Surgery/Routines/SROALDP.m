SROALDP ;B'HAM ISC/MAM - DISPLAY PREOP LABS ; [ 09/18/98  1:43 PM ]
 ;;3.0; Surgery ;**38,47,81**;24 Jun 93
 ;S SRPAGE="PAGE: 1 OF 2",SRHDR(.5)="PREOP LABORATORY RESULTS" D HDR^SROAUTL
 S SRPAGE="PAGE: 1 OF 2",SRHDR(.5)="LATEST PREOP LAB RESULTS IN 90 DAYS PRIOR TO SURGERY" D HDR^SROAUTL
 W !," 1. Serum Sodium: ",?30,$P(SRAO(1),"^"),?40,$P(SRAO(1),"^",2)
 W !," 2. BUN:",?30,$P(SRAO(2),"^"),?40,$P(SRAO(2),"^",2),!," 3. Serum Creatinine: ",?30,$P(SRAO(3),"^"),?40,$P(SRAO(3),"^",2)
 W !," 4. Serum Albumin:",?30,$P(SRAO(4),"^"),?40,$P(SRAO(4),"^",2),!," 5. Total Bilirubin:",?30,$P(SRAO(5),"^"),?40,$P(SRAO(5),"^",2)
 W !," 6. SGOT:",?30,$P(SRAO(6),"^"),?40,$P(SRAO(6),"^",2),!," 7. Alkaline Phosphatase:",?30,$P(SRAO(7),"^"),?40,$P(SRAO(7),"^",2)
 W !," 8. WBC:",?30,$P(SRAO(8),"^"),?40,$P(SRAO(8),"^",2),!," 9. Hematocrit:",?30,$P(SRAO(9),"^"),?40,$P(SRAO(9),"^",2),!,"10. Platelet Count:",?30,$P(SRAO(10),"^"),?40,$P(SRAO(10),"^",2)
 W !,"11. PTT: ",?30,$P(SRAO(11),"^"),?40,$P(SRAO(11),"^",2)
 W !,"12. PT: ",?30,$P(SRAO(12),"^"),?40,$P(SRAO(12),"^",2)
 W !! F MOE=1:1:80 W "-"
 Q
