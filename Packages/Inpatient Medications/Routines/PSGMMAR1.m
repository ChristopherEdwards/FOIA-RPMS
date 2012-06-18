PSGMMAR1 ;BIR/CML3-PRINTS MD MAR ;12 Mar 98 / 9:33 AM
 ;;5.0; INPATIENT MEDICATIONS ;**3,8,92**;16 DEC 97
 ;
 ;
SP ; start print
 U IO S WG=$S($D(^TMP($J))#2:+^($J),1:0),WGN=$S('$D(^PS(57.5,WG,0)):WG,$P(^(0),"^")]"":$P(^(0),"^"),1:WG),(LN1,LN2,PSGOP,PN,RB,WDN,TM)="",PSGLSTOP=1,$P(LN1,"-",133)="",$P(LN2,"-",126)=""
 S MOS="JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",(LN3,LN14,QQ)=""
 F Q=0:0 S Q=$O(PSGD(Q)) Q:'Q  S LN3=LN3_" "_$E("  ",1,PSGMARDF=7+1)_$S(PSGMARDF=7:$P(PSGD(Q),"^"),1:$E(Q,6,7))_$E("  ",1,PSGMARDF=7+1) S:PSGMARDF=7 QQ=Q I PSGMARDF=14 S LN14=LN14_"  "_$S($E(Q,4,5)'=$E(QQ,4,5):$P(MOS,"^",+PSGD(Q)),1:"   "),QQ=Q
 S (LN4,LN7)="|" F Q=1:1:PSGMARDF S LN4=LN4_$E("_________",1,$S(PSGMARDF=7:9,1:4))_"|",LN7=LN7_$E("         ",1,$S(PSGMARDF=7:9,1:4))_"|"
 S LN5="|-------|-------|----------------------|------|----------------------|------|",LN6="  DATE    TIME          REASON           INIT         RESULT           INIT"
 S LN31="|--------|--------|-----------------------------------------|------|-----------------------|-----------------------|--------|------|"
 S LN32="|        |        |                                       |       |                      |                      |        |       |"
 K BLN S BLN(1)=$E(LN1,1,36),BLN(2)="   Indicate RIGHT (R) or LEFT (L)",BLN(3)="",BLN(4)="   (IM)                   (SUB Q)",BLN(5)="1. DELTOID             6. UPPER ARM",BLN(6)="2. VENTRAL GLUTEAL     7. ABDOMEN"
 S BLN(7)="3. GLUTEUS MEDIUS      8. THIGH",BLN(8)="4. MID(ANTERIOR) THIGH 9. BUTTOCK",BLN(9)="5. VASTUS LATERALIS   10. UPPER BACK",BLN(10)=" PRN: E=Effective   N=Not Effective"
 S ASTERS=$E("*********",1,PSGMARDF=7*5+4),EXPIRE=$S(PSGMARDF=14:"****",1:"*********"),SPACES=$E("         ",1,PSGMARDF=7*5+4) F X="PSGMARSD","PSGMARFD" S @($E(X,1,7)_"P")=$P($$ENDTC2^PSGMI(@X)," ")
 I PSGSS="P" F  S PN=$O(^TMP($J,PN)) Q:PN=""  D
 .; naked ref below is from line above ^TMP($J,PN)
 . S PPN=^(PN),PWDN=$P(PPN,U,13),PRB=$P(PPN,U,14),PTM="zz"
 . D PI
 . I PSGMARS'=2 D ^PSGMMAR2
 . I PSGMARS'=1 D:(PSGMARS=2&(PSGMARB'=2)) BLANK^PSGMMAR3 D ^PSGMMAR3
 F  S (PTM,TM)=$O(^TMP($J,TM)) Q:TM=""  F  S (PWDN,WDN)=$O(^TMP($J,TM,WDN)) Q:WDN=""  D
 . I PSGRBPPN="P" F  S PN=$O(^TMP($J,TM,WDN,PN)) Q:PN=""  F  S (PRB,RB)=$O(^TMP($J,TM,WDN,PN,RB)) Q:RB=""  S PPN=^(RB) D PI,^PSGMMAR2:PSGMARS'=2,BLANK^PSGMMAR3:(PSGMARS=2&(PSGMARB'=2)),^PSGMMAR3:PSGMARS'=1
 . I PSGRBPPN="R" F  S (PRB,RB)=$O(^TMP($J,TM,WDN,RB)) Q:RB=""  F  S PN=$O(^TMP($J,TM,WDN,RB,PN)) Q:PN=""  S PPN=^(PN) D PI,^PSGMMAR2:PSGMARS'=2,BLANK^PSGMMAR3:(PSGMARS=2&(PSGMARB'=2)),^PSGMMAR3:PSGMARS'=1
 Q
 ;
PI ;
 K PSGMPG,PSGMPGN
 S:PTM="zz" PTM="NOT FOUND" S:PWDN="zz" PWDN="NOT FOUND" S:PRB="zz" PRB="NOT FOUND"
 S (PSGOP,PSGP)=+$P(PN,U,2),PSGP(0)=$P(PN,U),BD=$P(PPN,U,2),PSSN=$P(PPN,U,3),DX=$P(PPN,U,4),WT=$P(PPN,U,5)_" "_$P(PPN,U,6)
 S HT=$P(PPN,U,7)_" "_$P(PPN,U,8),AD=$P(PPN,U,9)
 S TD=$P(PPN,U,10),PSEX=$P(PPN,U,11),PSGLWD=$P(PPN,U,12),PPN=$P(PPN,U),PAGE=$P(BD,";",2),BD=$P(BD,";"),DFN=PSGP
 D ATS^PSJMUTL(115,117,1)
 Q
