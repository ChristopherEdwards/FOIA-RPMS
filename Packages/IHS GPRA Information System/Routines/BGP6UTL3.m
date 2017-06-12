BGP6UTL3 ; IHS/CMI/LAB - 27 Apr 2009 11:01 PM 30 Aug 2009 10:16 AM 30 Jun 2010 4:58 PM 05 Aug 2016 11:40 AM 26 Mar 2016 2:40 PM ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
ONN4 ;EP
 K BGPEXCT
 S Y=$$OPEN^%ZISH(BGPUF,BGPFONN4,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 S BGPP=0,BGPY=$O(^BGPCTRL("B","2016",0)),BGPX="",BGPEC=$P(^BGPCTRL(BGPY,0),U,25)
 F  S BGPP=$O(^BGPCTRL(BGPY,86,BGPP)) Q:BGPP'=+BGPP  D
 .S BGPPP1=$P(^BGPCTRL(BGPY,86,BGPP,0),U,1)
 .S BGPZ=$P(^BGPCTRL(BGPY,86,BGPP,0),U,2)
 .S $P(BGPX,U,BGPPP1)=BGPZ
 W BGPX,!
 K BGPX
 S BGPX="" S P=11 F  S $P(BGPX,U,P)="Current",P=P+9 Q:P>(BGPEC-8)
 S P=14 F  S $P(BGPX,U,P)="Previous",P=P+9 Q:P>(BGPEC-5)
 S P=17 F  S $P(BGPX,U,P)="Baseline",P=P+9 Q:P>(BGPEC+1)
 W BGPX,!
 K BGPX
 D SETHDR^BGP6UTL
 S P=11 F  S $P(BGPX,U,P)="Num",P=P+3 Q:P>(BGPEC-2)
 S P=12 F  S $P(BGPX,U,P)="Den",P=P+3 Q:P>(BGPEC-1)
 S P=13 F  S $P(BGPX,U,P)="%",P=P+3 Q:P>BGPEC
 W BGPX,!
 S BGPX=0 F  S BGPX=$O(BGPONN4(BGPX)) Q:BGPX'=+BGPX  W BGPONN4(BGPX),!
 K BGPONN4
 D ^%ZISC
 Q
ONN5 ;
 K BGPEXCT
 S Y=$$OPEN^%ZISH(BGPUF,BGPFONN5,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 S BGPP=0,BGPY=$O(^BGPCTRL("B","2016",0)),BGPX="",BGPEC=$P(^BGPCTRL(BGPY,0),U,26)
 F  S BGPP=$O(^BGPCTRL(BGPY,87,BGPP)) Q:BGPP'=+BGPP  D
 .S BGPPP1=$P(^BGPCTRL(BGPY,87,BGPP,0),U,1)
 .S BGPZ=$P(^BGPCTRL(BGPY,87,BGPP,0),U,2)
 .S $P(BGPX,U,BGPPP1)=BGPZ
 W BGPX,!
 K BGPX
 S BGPX="" S P=11 F  S $P(BGPX,U,P)="Current",P=P+9 Q:P>(BGPEC-8)
 S P=14 F  S $P(BGPX,U,P)="Previous",P=P+9 Q:P>(BGPEC-5)
 S P=17 F  S $P(BGPX,U,P)="Baseline",P=P+9 Q:P>(BGPEC+1)
 W BGPX,!
 K BGPX
 D SETHDR^BGP6UTL
 S P=11 F  S $P(BGPX,U,P)="Num",P=P+3 Q:P>(BGPEC-2)
 S P=12 F  S $P(BGPX,U,P)="Den",P=P+3 Q:P>(BGPEC-1)
 S P=13 F  S $P(BGPX,U,P)="%",P=P+3 Q:P>BGPEC
 W BGPX,!
 S BGPX=0 F  S BGPX=$O(BGPONN5(BGPX)) Q:BGPX'=+BGPX  W BGPONN5(BGPX),!
 K BGPONN5
ONNC D ^%ZISC  ;close host file
 Q
AGEDATE(BIAGRG,BISVDT,BIBEGDT,BIENDDT,BIERR) ;EP
 ;---> Given an Age Range in months or years and a Survey Date,
 ;---> return the beginning and ending dates in Fileman format.
 ;---> Use to search patients by DOB.
 ;---> Parameters:
 ;     1 - BIAGRG  (req) Age Range^Mth/Yr (e.g.,50-64^1)
 ;                    (See description at linelable AGERNG above.)
 ;     2 - BISVDT  (req) Survey/Forecast Date (date from which to
 ;                       calculate age).
 ;     3 - BIBEGDT (ret) Beginning Date.
 ;     4 - BIENDDT (ret) Ending Date.
 ;     5 - BIERR   (ret) Error.
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 I "ALL"[$G(BIAGRG) S BIBEGDT=0,BIENDDT=9999999 Q
 I '$G(BISVDT) S BISVDT=$G(DT)
 ;I '$G(BISVDT) S BIBEGDT=0,BIENDDT=9999999 Q
 ;S:BISVDT>DT BISVDT=DT
 ;
 ;---> If X=one age only, set it in the form X-X and quit.
 ;---> If Age Range is passed in years, convert to months.
 D
 .N Y S Y=$P(BIAGRG,U)
 .;---> If Y=one age only, set it in the form Y-Y.
 .I Y?1N.N S Y=Y_"-"_Y
 .I '$P(BIAGRG,U,2) S BIAGRG=Y Q
 .S BIAGRG=(12*$P(Y,"-"))_"-"_(12*$P(Y,"-",2)+11)
 ;
 N BIAGRG1,BIAGRG2
 S BIAGRG1=+$P(BIAGRG,"-",1),BIAGRG2=+$P(BIAGRG,"-",2)
 ;I (BIAGRG1'?1N.N)!(BIAGRG2'?1N.N) D ERRCD^BIUTL2(676,.BIERR) Q
 ;
 ;D PASTMTH(BISVDT,($P(BIAGRG,"-",2)+1),.BIBEGDT)
 D PASTMTH(BISVDT,(BIAGRG2+1),.BIBEGDT)
 ;
 ;---> Now, set Beginning Day to be one day AFTER the patient would
 ;---> be too old and out of the selected Age Range.
 ;---> In other words, come forward one day to include only patients
 ;---> whose age is ONE DAY LESS THAN a month (or year) after the
 ;---> maximum limit of the selected Age Range.
 ;---> For example, Age Range=24-36 includes patients whose age
 ;---> is between [24months] and [37months-1day].
 N X,X1,X2 S X1=BIBEGDT,X2=1 D C^%DTC S BIBEGDT=X
 ;
 ;D PASTMTH(BISVDT,$P(BIAGRG,"-",1),.BIENDDT)
 D PASTMTH(BISVDT,BIAGRG1,.BIENDDT)
 Q
 ;
 ;
 ;----------
PASTMTH(BIDTI,BIMTHS,BIDTO,BIYR) ;EP
 ;---> Return the date BIMTHS months/years prior the input date.
 ;---> Parameters:
 ;     1 - BIDTI  (req) Date in.
 ;     2 - BIMTHS (req) Number of months in the past to calculate.
 ;     3 - BIDTO  (ret) Date out (BIMTHS prior to BIDTI).
 ;     4 - BIYR   (opt) If BIYR=1, input is in years; multiply BIMTHSx12.
 ;
 Q:'$G(BIDTI)
 I '$G(BIMTHS) S BIDTO=BIDTI Q
 I $G(BIYR)=1 S BIMTHS=(BIMTHS*12)
 N YYY,MM,DD
 S YYY=$E(BIDTI,1,3),MM=+$E(BIDTI,4,5),DD=+$E(BIDTI,6,7)
 D
 .I MM>BIMTHS S MM=MM-BIMTHS Q
 .N I,Q S Q=0
 .F I=12:12 D  Q:Q
 ..I BIMTHS-MM<I S MM=I-(BIMTHS-MM),YYY=YYY-(I/12),Q=1
 ;
 S:MM<10 MM="0"_MM
 S:DD<10 DD="0"_DD
 S BIDTO=YYY_MM_DD
 Q
 ;
