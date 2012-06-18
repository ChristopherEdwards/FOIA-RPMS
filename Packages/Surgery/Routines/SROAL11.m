SROAL11 ;B'HAM ISC/ADM - LOAD PREOP LAB DATA (CONTINUED) ; 5 MAR 1992  1:10 pm
 ;;3.0; Surgery ;**38,47,65,95**;24 Jun 93
STUFF ; Transfer test data from array to file 130
 W !!,"..Moving preoperative lab test data to Surgery Risk Assessment file...."
SRAT4 I $D(SRAT(4)) S X=SRAT(4),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^")=X S $P(^(202),"^")=$S(X'="":SRAD(4),1:"") ; Sodium
SRAT7 I $D(SRAT(7)) S X=SRAT(7),SRL=1,SRH=4 D INPUT S $P(^SRF(SRTN,201),"^",4)=X,$P(^(202),"^",4)=$S(X'="":SRAD(7),1:"") ; Creatinine
SRAT8 I $D(SRAT(8)) S X=SRAT(8),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^",5)=X,$P(^(202),"^",5)=$S(X'="":SRAD(8),1:"") ; BUN
SRAT11 I $D(SRAT(11)) S X=SRAT(11),SRL=1,SRH=4 D INPUT S $P(^SRF(SRTN,201),"^",8)=X,$P(^(202),"^",8)=$S(X'="":SRAD(11),1:"") ; Albumin
SRAT13 I $D(SRAT(13)) S X=SRAT(13),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^",11)=X,$P(^(202),"^",11)=$S(X'="":SRAD(13),1:"") ; SGOT
SRAT14 I $D(SRAT(14)) S X=SRAT(14),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^",9)=X,$P(^(202),"^",9)=$S(X'="":SRAD(14),1:"") ; Total Bilirubin
SRAT15 I $D(SRAT(15)) S X=SRAT(15),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^",12)=X,$P(^(202),"^",12)=$S(X'="":SRAD(15),1:"") ; Alkaline Phosphatase
SRAT16 I $D(SRAT(16)) S X=SRAT(16),SRL=1,SRH=4 D INPUT S $P(^SRF(SRTN,201),"^",13)=X,$P(^(202),"^",13)=$S(X'="":SRAD(16),1:"") ; White Blood Count
SRAT17 I $D(SRAT(17)) S X=SRAT(17),SRL=1,SRH=4 D INPUT S $P(^SRF(SRTN,201),"^",14)=X,$P(^(202),"^",14)=$S(X'="":SRAD(17),1:"") ; Hematocrit
SRAT18 I $D(SRAT(18)) S X=SRAT(18),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^",15)=X,$P(^(202),"^",15)=$S(X'="":SRAD(18),1:"") ; Platelet Count
SRAT19 I $D(SRAT(19)) S X=SRAT(19),SRL=1,SRH=4 D INPUT S $P(^SRF(SRTN,201),"^",17)=X,$P(^(202),"^",17)=$S(X'="":SRAD(19),1:"") ; PT
SRAT20 I $D(SRAT(20)) S X=SRAT(20),SRL=1,SRH=5 D INPUT S $P(^SRF(SRTN,201),"^",16)=X,$P(^(202),"^",16)=$S(X'="":SRAD(20),1:"") ; PTT
 Q
CARDIAC ; LOAD CARDIAC LAB DATA (CONTINUED)
 ;
21 I $D(SRAT(21)) S X=SRAT(21),SRL=1,SRH=6 D INPUT S $P(^SRF(SRTN,201),"^",21)=X,$P(^(202),"^",21)=$S(X'="":SRAD(21),1:"") ; HDL (CARDIAC)
22 I $D(SRAT(22)) S X=SRAT(22),SRL=1,SRH=6 D INPUT S $P(^SRF(SRTN,201),"^",22)=X,$P(^(202),"^",22)=$S(X'="":SRAD(22),1:"") ; TRIGLYCERIDE (CARDIAC)
23 I $D(SRAT(23)) S X=SRAT(23),SRL=1,SRH=6 D INPUT S $P(^SRF(SRTN,201),"^",23)=X,$P(^(202),"^",23)=$S(X'="":SRAD(23),1:"") ; POTASSIUM (CARDIAC)
24 I $D(SRAT(24)) S X=SRAT(24),SRL=1,SRH=6 D INPUT S $P(^SRF(SRTN,201),"^",24)=X,$P(^(202),"^",24)=$S(X'="":SRAD(24),1:"") ; BILIRUBIN (CARDIAC)
25 I $D(SRAT(25)) S X=SRAT(25),SRL=1,SRH=6 D INPUT S $P(^SRF(SRTN,201),"^",25)=X,$P(^(202),"^",25)=$S(X'="":SRAD(25),1:"") ; LDL (CARDIAC)
26 I $D(SRAT(26)) S X=SRAT(26),SRL=1,SRH=6 D INPUT S $P(^SRF(SRTN,201),"^",26)=X,$P(^(202),"^",26)=$S(X'="":SRAD(26),1:"") ; CHOLESTEROL (CARDIAC)
 Q
INPUT ; input checking
 I X="NS"!(X="") Q
 I $L(X)<SRL!($L(X)>SRH) S X="" Q
 S SRX=X S:"<>"[$E(X) SRX=$E(X,2,99)
 I +SRX'=SRX S X="" Q
 Q
