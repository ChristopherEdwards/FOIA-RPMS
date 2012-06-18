SROALN3 ;BIR/MAM - LAB INFO ; [ 02/09/99  2:04 PM ]
 ;;3.0; Surgery ;**38,47,88**;24 Jun 93
 F SHEMP=203,204 S SRA(SHEMP)=$G(^SRF(SRTN,SHEMP))
 S SHEMP=$P(SRA(203),"^"),SRAO(1)=SHEMP_"^^274^305" S X=$P(SRA(204),"^") I X D DATE S SHEMP="("_Y_")",$P(SRAO(1),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",2),SRAO(2)=SHEMP_"^^405^407" S X=$P(SRA(204),"^",2) I X D DATE S SHEMP="("_Y_")",$P(SRAO(2),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",3),SRAO(3)=SHEMP_"^^275^306" S X=$P(SRA(204),"^",3) I X D DATE S SHEMP="("_Y_")",$P(SRAO(3),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",4),SRAO(4)=SHEMP_"^^406^408" S X=$P(SRA(204),"^",4) I X D DATE S SHEMP="("_Y_")",$P(SRAO(4),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",6),SRAO(5)=SHEMP_"^^277^308" S X=$P(SRA(204),"^",6) I X D DATE S SHEMP="("_Y_")",$P(SRAO(5),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",7),SRAO(6)=SHEMP_"^^278^309" S X=$P(SRA(204),"^",7) I X D DATE S SHEMP="("_Y_")",$P(SRAO(6),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",8),SRAO(7)=SHEMP_"^^279^310" S X=$P(SRA(204),"^",8) I X D DATE S SHEMP="("_Y_")",$P(SRAO(7),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",9),SRAO(8)=SHEMP_"^^280^311" S X=$P(SRA(204),"^",9) I X D DATE S SHEMP="("_Y_")",$P(SRAO(8),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",10),SRAO(9)=SHEMP_"^^281^312" S X=$P(SRA(204),"^",10) I X D DATE S SHEMP="("_Y_")",$P(SRAO(9),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",12),SRAO(10)=SHEMP_"^^283^314" S X=$P(SRA(204),"^",12) I X D DATE S SHEMP="("_Y_")",$P(SRAO(10),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",13),SRAO(11)=SHEMP_"^^455^455.1" S X=$P(SRA(204),"^",13) I X D DATE S SHEMP="("_Y_")",$P(SRAO(11),"^",2)=SHEMP
 S SHEMP=$P(SRA(203),"^",14),SRAO(12)=SHEMP_"^^456^456.1" S X=$P(SRA(204),"^",14) I X D DATE S SHEMP="("_Y_")",$P(SRAO(12),"^",2)=SHEMP
 S SRPAGE="PAGE: 2 OF 2",SRHDR(.5)="POSTOP LAB RESULTS WITHIN 30 DAYS AFTER SURGERY" D HDR^SROAUTL
 W !," 1. Highest Serum Sodium:",?35,$P(SRAO(1),"^"),?45,$P(SRAO(1),"^",2),!," 2. Lowest Serum Sodium:",?35,$P(SRAO(2),"^"),?45,$P(SRAO(2),"^",2)
 W !," 3. Highest Potassium:",?35,$P(SRAO(3),"^"),?45,$P(SRAO(3),"^",2),!," 4. Lowest Potassium:",?35,$P(SRAO(4),"^"),?45,$P(SRAO(4),"^",2)
 W !," 5. Highest Serum Creatinine: ",?35,$P(SRAO(5),"^"),?45,$P(SRAO(5),"^",2),!," 6. Highest CPK: ",?35,$P(SRAO(6),"^"),?45,$P(SRAO(6),"^",2),!," 7. Highest CPK-MB Band: ",?35,$P(SRAO(7),"^"),?45,$P(SRAO(7),"^",2)
 W !," 8. Highest Total Bilirubin: ",?35,$P(SRAO(8),"^"),?45,$P(SRAO(8),"^",2),!," 9. Highest WBC:",?35,$P(SRAO(9),"^"),?45,$P(SRAO(9),"^",2)
 W !,"10. Lowest Hematocrit:",?35,$P(SRAO(10),"^"),?45,$P(SRAO(10),"^",2)
 W !,"11. Highest Troponin I:",?35,$P(SRAO(11),"^"),?45,$P(SRAO(11),"^",2),!,"12. Highest Troponin T:",?35,$P(SRAO(12),"^"),?45,$P(SRAO(12),"^",2)
 W !! F MOE=1:1:80 W "-"
 Q
DATE S Y=X X ^DD("DD")
 Q
