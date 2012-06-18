AZHZCLI ;DSD/PDW - Clean IHS Patient files ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;;
S ;WORKS ON DFN
IHSPAT ;start edits for fields in IHS patient file
 S (AZHZODR,AZHZDR)="",AZHZGL="AUPNPAT("
 D ELIG,HRN
 Q  ;-----
 ;--------------------------------------------------------
ELIG ;perform checks and edits on eligibility/beneficiary/tribe data 
 D ACTIVE
 I '$D(^AUPNPAT(DFN,11)) U IO D AZHZPG W:('AZHZHIT&AZHZAAP) !,DFN,?10,AZHZ("B"),?45," NO ELIGIBILITY INFORMATION" Q  ;-----
 S AZHZ11=^AUPNPAT(DFN,11),AZHZB=$P(AZHZ11,U,11),AZHZTP=$P(AZHZ11,U,8),AZHZQT=$P(AZHZ11,U,9),AZHZQI=$P(AZHZ11,U,10),AZHZL=$P(AZHZ11,U,12)
 S AZHZQTS=$S(+AZHZQT>0:1,AZHZQT["UNS":1,AZHZQT["FUL":1,1:0),AZHZQIS=$S(+AZHZQI>0:1,AZHZQI["UNS":1,AZHZQI["FUL":1,1:0)
 S AZHZLS=$S("I"[AZHZL:0,"PCD"[AZHZL:1,1:0)
 S AZHZTS=0 I AZHZTP]"",$D(^AUTTTRI(AZHZTP,0)) S AZHZT=+$P(^(0),U,2)
 E  U IO D AZHZPG W:('AZHZHIT&AZHZAAP) !,DFN,?10,AZHZ("B"),?45," NO TRIBE !" Q  ;-----
 S AZHZQTF=$S($P(^AGFAC(AZHZSITE,0),U,2)="Y":1,1:0)
 I AZHZT=999,+AZHZB=1 S AZHZTS=1 G CONT ;-----
 I AZHZT=999 F AZHZBZ=6,8,18,32,33 I AZHZBZ=+AZHZB S AZHZTS=0 G CONT ;-----
 I AZHZT=999 Q  ;----- UNDETERMINED
 I AZHZT>0,AZHZT'=970,AZHZT<999 S AZHZTS=1
CONT I 'AZHZTS G NONI ;-----
 I AZHZT=998 U IO D AZHZPG W:('AZHZHIT&AZHZAAP) !,DFN,?10,AZHZ("B"),?45," OLD TRIBE USED " Q  ;-----
 I $P(^AUTTTRI(AZHZTP,0),U,4)="Y" U IO D AZHZPG W:('AZHZHIT&AZHZAAP) !,DFN,?10,AZHZ("B"),?45," OLD TRIBE USED " Q  ;-----
IND I 'AZHZLS S ^AZHZTEMP(DFN,"I",1112,"O")=AZHZL,^("N")="P"
 I 'AZHZQIS S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="UNSPECIFIED"
 I AZHZQI["/0" S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="UNSPECIFIED"
 I AZHZQI=0 S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="UNSPECIFIED"
 I 'AZHZQIS,AZHZQTS S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")=AZHZQT
 I AZHZQTF,'AZHZQTS S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="UNSPECIFIED"
 I AZHZQTF,AZHZQTS["/0" S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="UNSPECIFIED"
 I AZHZQTF,AZHZQTS=0 S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="UNSPECIFIED"
 Q  ;-----
 ;---------------------------------------------------------------------
NONI ; NON-INDIAN CHECK
 I AZHZQIS S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="NONE"
 I AZHZQI="" S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="NONE"
 I AZHZQI["/0" S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="NONE"
 I AZHZQI=0 S ^AZHZTEMP(DFN,"I",1110,"O")=AZHZQI,^("N")="NONE"
 Q:'AZHZQTF
 I AZHZQT="" S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="NONE"
 I AZHZQT["/0" S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="NONE"
 I AZHZQT=0 S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="NONE"
 I AZHZQTS S ^AZHZTEMP(DFN,"I",1109,"O")=AZHZQT,^("N")="NONE"
 Q  ;-----
 ;---------------------------------------------------------------------
HRN ; edit 41 node - hard sets not collected in AZHTEMP
 Q:$D(^AZHZSAV)  ;-----   quit if the scan phase has been completed
 S (AZHZFAC,AZHZFACC,AZHZLFAC)=0
 K ^AUPNPAT(DFN,41,"B") F  S AZHZFAC=$O(^AUPNPAT(DFN,41,AZHZFAC)) Q:(DFOUT!DUOUT)  Q:'AZHZFAC  S AZHZFACC=AZHZFACC+1,AZHZLFAC=AZHZFAC D 
 .I ($D(^AUPNPAT(DFN,41,AZHZFAC))#2) S AZHZDAT=(^(AZHZFAC,0)) W "  ",AZHZGL,"=",AZHZDAT K ^AUPNPAT(DFN,41,AZHZFAC) S ^AUPNPAT(DFN,41,AZHZFAC,0)=AZHZDAT
 ;kills upper node if it exists when it should not ie (DFN,41,2345) itself exists
 .I $P(^AUPNPAT(DFN,41,AZHZFAC,0),"^")="" S $P(^(0),U)=AZHZFAC ; inset ist peice if it doesn't exist
EHRN I $D(^AUPNPAT(DFN,41,0)),$P(^AUPNPAT(DFN,41,0),U,3)="" S ^AUPNPAT(DFN,41,0)="^9000001.41IP^"_AZHZLFAC_"^"_AZHZFACC ; reset counters if not set
 Q  ;-----
 ;---------------------------------------------------------------------
AZHZPG ;ENTRY POINT page controller
 S:'$D(DUOUT) DUOUT=0 S:'$D(DFOUT) DFOUT=0
 Q:($Y<(IOSL-4))!(DUOUT!DFOUT)  S:'$D(AZHZPG) AZHZPG=0 S AZHZPG=AZHZPG+1 I $E(IOST)="C" R !,"^ to quit ",AZHZX:DTIME I $E(AZHZX)="^" S DUOUT=1,DFOUT=1 Q
AZHZHDR ; Header controller
 W !,@IOF Q:'$D(AZHZHDR)  S:'$D(AZHZLINE) $P(AZHZLINE,"-",IOM-2)="" S:'$D(AZHZPG) AZHZPG=1 I '$D(AZHZDT) D DT^DICRW S Y=DT D DD^%DT S AZHZDT=Y
 U IO W ?(IOM-20-$L(AZHZHDR)/2),AZHZHDR,?(IOM-25),AZHZDT,?(IOM-10),"PAGE: ",AZHZPG,!,AZHZLINE
EAZHZPG Q  ;-----
 ;---------------------------------------------------------------------
ACTIVE ;ENTRY POINT for testing to see if patient is active
 ;SETS AZHZAAP=1 if patient has any active HRN records
 S AZHZAAP=0 I $D(^AUPNPAT(DFN,41,0)),+$O(^(0)) S AZHZAS=0 F  S AZHZAS=$O(^AUPNPAT(DFN,41,AZHZAS)) Q:'+AZHZAS  S:$P(^(AZHZAS,0),U,3)="" AZHZAAP=1
EACT K AZHZAS Q  ;----
 ;---------------------------------------------------------------------
