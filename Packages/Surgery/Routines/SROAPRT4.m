SROAPRT4 ;B'HAM ISC/MAM - PRINT ASSESSMENT (CONT.) ; 18 MAR 1992 10:30 am
 ;;3.0; Surgery ;**38**;24 Jun 93
 K SRA S SRA(201)=$G(^SRF(SRTN,201)),SRA(202)=$G(^SRF(SRTN,202))
 W !,?20,"PREOPERATIVE LABORATORY TEST RESULTS"
 W !!,$J("Serum Sodium: ",38) S X=$P(SRA(201),"^") W X S X=$P(SRA(202),"^") I X D DATE W ?50,"("_Y_")"
 W !,$J("Serum Creatinine: ",38) S X=$P(SRA(201),"^",4) W X S X=$P(SRA(202),"^",4) I X D DATE W ?50,"("_Y_")"
 W !,$J("BUN: ",38) S X=$P(SRA(201),"^",5) W X I X S X=$P(SRA(202),"^",5) I X D DATE W ?50,"("_Y_")"
 W !,$J("Serum Albumin: ",38) S X=$P(SRA(201),"^",8) W X I X S X=$P(SRA(202),"^",8) I X D DATE W ?50,"("_Y_")"
 W !,$J("Total Bilirubin: ",38) S X=$P(SRA(201),"^",9) W X S X=$P(SRA(202),"^",9) I X D DATE W ?50,"("_Y_")"
 W !,$J("SGOT: ",38) S X=$P(SRA(201),"^",11) W X I X S X=$P(SRA(202),"^",11) I X D DATE W ?50,"("_Y_")"
 W !,$J("Alkaline Phosphatase: ",38) S X=$P(SRA(201),"^",12) W X I X S X=$P(SRA(202),"^",12) I X D DATE W ?50,"("_Y_")"
 W !,$J("White Blood Count: ",38) S X=$P(SRA(201),"^",13) W X S X=$P(SRA(202),"^",13) I X D DATE W ?50,"("_Y_")"
 W !,$J("Hematocrit: ",38) S X=$P(SRA(201),"^",14) W X I X S X=$P(SRA(202),"^",14) I X D DATE W ?50,"("_Y_")"
 W !,$J("Platelet Count: ",38) S X=$P(SRA(201),"^",15) W X S X=$P(SRA(202),"^",15) I X D DATE W ?50,"("_Y_")"
 W !,$J("PTT: ",38) S X=$P(SRA(201),"^",16) W X S X=$P(SRA(202),"^",16) I X D DATE W ?50,"("_Y_")"
 W !,$J("PT: ",38) S X=$P(SRA(201),"^",17) W X I X S X=$P(SRA(202),"^",17) I X D DATE W ?50,"("_Y_")"
 I $E(IOST)="P" W !!
 Q
DATE S Y=X X ^DD("DD")
 Q
