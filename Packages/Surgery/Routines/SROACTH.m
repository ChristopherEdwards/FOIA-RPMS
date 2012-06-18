SROACTH ;B'HAM ISC/MAM - CARDIAC CATH INFO ; [ 09/07/00  1:25 PM ]
 ;;3.0; Surgery ;**38,95**;24 Jun 93
 S SRA(206)=$G(^SRF(SRTN,206))
 S SRAO(1)=$P(SRA(206),"^",24)_"^357",SRAO(2)=$P(SRA(206),"^",25)_"^358",SRAO(3)=$P(SRA(206),"^",26)_"^359",SRAO(4)=$P(SRA(206),"^",27)_"^360",SRAO(5)=$P(SRA(206),"^",28)_"^361",SRAO(6)=$P(SRA(206),"^",33)_"^362.1"
 S SRAO(7)=$P(SRA(206),"^",34)_"^362.2",SRAO(8)=$P(SRA(206),"^",35)_"^362.3",Y=$P(SRA(206),"^",9),C=$P(^DD(130,415,0),"^",2) D:Y'="" Y^DIQ S SRAO(10)=Y_"^415"
 S NYUK=$P(SRA(206),"^",30) D LV S SRAO(9)=SHEMP_"^363"
 S SRPAGE="PAGE: 1" D HDR^SROAUTL
 W !," 1. LVEDP:",?31,$P(SRAO(1),"^") I $P(SRAO(1),"^") W " mm Hg"
 W !," 2. Aortic Systolic Pressure: ",$J($P(SRAO(2),"^"),3) I $P(SRAO(2),"^") W " mm Hg"
 W !," 3. *PA Systolic Pressure:",?31,$P(SRAO(3),"^") I $P(SRAO(3),"^") W " mm Hg"
 W !," 4. *PAW Mean Pressure:",?31,$P(SRAO(4),"^") I $P(SRAO(4),"^") W " mm Hg"
 W !!," 5. Left Main Stenosis:",?30,$J($P(SRAO(5),"^"),3) I $P(SRAO(5),"^")?1.3N W "%"
 W !," 6. LAD Stenosis:",?30,$J($P(SRAO(6),"^"),3) I $P(SRAO(6),"^")?1.3N W "%"
 W !," 7. Right Coronary Stenosis:",?30,$J($P(SRAO(7),"^"),3) I $P(SRAO(7),"^")?1.3N W "%"
 W !," 8. Circumflex Stenosis:",?30,$J($P(SRAO(8),"^"),3) I $P(SRAO(8),"^")?1.3N W "%"
 W !!," 9. LV Contraction Grade  (from contrast ",!,"    or radionuclide angiogram or 2D echo): "_$P(SRAO(9),"^")
 W !!,"10. Mitral Regurgitation:",?30,$P(SRAO(10),"^")
 W !! F MOE=1:1:80 W "-"
 Q
LV S SHEMP=$S(NYUK="I":"I   > or = 0.55    NORMAL",NYUK="II":"II  0.45-0.54    MILD DYSFUNCTION",NYUK="III":"III  0.35-0.44  MODERATE DYSFUNCTION",NYUK="IIIa":"IIIa 0.40-0.44 MODERATE DYSFUNCTION A",1:NYUK)
 Q:SHEMP'=NYUK  S SHEMP=$S(NYUK="IIIb":"IIIb 0.35-0.39 MODERATE DYSFUNCTION B",NYUK="IV":"IV  0.25-0.34  SEVERE DYSFUNCTION",NYUK="V":"V  <0.25  VERY SEVERE DYSFUNCTION",NYUK="NS":"NO LV STUDY",1:"")
 Q
