BDPPOST ; IHS/CMI/TMJ - Post Init to Populate File ;  
 ;;1.0;DESIGNATED PROVIDER MGT SYSTEM;;SEP 10, 2004
 ;
 ;This routine $O's through the Patient File, the MHSS Patient
 ;File, and the BW Patient File to pick up existing Desg. Providers
 ;for the new Desg. Provider Mgt System
 ;
START ;Begin Post Init
 S BDPCONV=""
 S BDPCONV=$O(^BDPPARM("B",DUZ(2),""))
 ;Q:BDPCONV=""
 ;S BDPCONV1=$P($G(^BDPPARM(BDPCONV,0)),U,2) ;Conversion Field
 I BDPCONV'="" W !!,"Conversion already ran - Quit ",!! Q  ;Converison Check
 ;
 D PCP ;Designated Primary Care Provider
 D MH ;Mental Health Primary Care Provider
 D SS ;Social Services Primary Care Provider
 D CD ;Chemical Dependency Primary Care Provider
 D WH ;Womens Health Case Manager
 D EOJ
 Q
 ;
PCP ;Populate DPCP
 S BDPPROV=0 F  S BDPPROV=$O(^AUPNPAT("AK",BDPPROV)) Q:BDPPROV'=+BDPPROV  D
 .S BDPDFN=0 F  S BDPDFN=$O(^AUPNPAT("AK",BDPPROV,BDPDFN)) Q:BDPDFN'=+BDPDFN  D
 .. Q:'$P(^AUPNPAT(BDPDFN,0),U,14)  ;Quit if no Record
 .. Q:BDPPROV=""
 .. S BDPTYPE=1 ;DPCP Category
 .. D ADD ;Populate DPCP
 ;
 Q
 ;
MH ;Populate MH Provider
 S BDPPROV=0 F  S BDPPROV=$O(^AMHPATR("AMH",BDPPROV)) Q:BDPPROV'=+BDPPROV  D
 .S BDPDFN=0 F  S BDPDFN=$O(^AMHPATR("AMH",BDPPROV,BDPDFN)) Q:BDPDFN'=+BDPDFN  D
 .. Q:'$P(^AMHPATR(BDPDFN,0),U,2)  ;Quit if no Current Provider
 .. Q:BDPPROV=""
 .. S BDPTYPE=2 ;DPCP Category
 .. D ADD ;Populate MH Provider
 ;
 Q
 ;
 ;
SS ;Populate the Social Service Provider
 S BDPPROV=0 F  S BDPPROV=$O(^AMHPATR("ASS",BDPPROV)) Q:BDPPROV'=+BDPPROV  D
 .S BDPDFN=0 F  S BDPDFN=$O(^AMHPATR("ASS",BDPPROV,BDPDFN)) Q:BDPDFN'=+BDPDFN  D
 .. Q:'$P(^AMHPATR(BDPDFN,0),U,3)  ;Quit if no Current Provider
 .. Q:BDPPROV=""
 .. S BDPTYPE=3 ;SS Category
 .. D ADD ;Populate SS Provider
 ;
 Q
 ;
 ;
CD ;Populate the Chemical Dependency Provider
 S BDPPROV=0 F  S BDPPROV=$O(^AMHPATR("AOT",BDPPROV)) Q:BDPPROV'=+BDPPROV  D
 .S BDPDFN=0 F  S BDPDFN=$O(^AMHPATR("AOT",BDPPROV,BDPDFN)) Q:BDPDFN'=+BDPDFN  D
 .. Q:'$P(^AMHPATR(BDPDFN,0),U,4)  ;Quit if no Current Provider
 .. Q:BDPPROV=""
 .. S BDPTYPE=4 ;CD Category
 .. D ADD ;Populate CD Provider
 ;
 Q
 ;
WH ;Populate Case Mgr from Women's Health
 S BDPPROV=0 F  S BDPPROV=$O(^BWP("C",BDPPROV)) Q:BDPPROV'=+BDPPROV  D
 .S BDPDFN=0 F  S BDPDFN=$O(^BWP("C",BDPPROV,BDPDFN)) Q:BDPDFN'=+BDPDFN  D
 .. Q:'$P(^BWP(BDPDFN,0),U,10)  ;Quit if no Current Provider
 .. Q:BDPPROV=""
 .. S BDPTYPE=8 ;WH Category
 .. D ADD ;Populate WOMENS HEALTH Provider
 ;
 Q
 ;
 ;
ADD ;Populate the BDP DESG PROV PACKAGE
 Q:'$D(BDPDFN)
 Q:'$D(BDPTYPE)
 Q:'$D(BDPPROV)
 ;
 S X=$$CREATE^BDPPASS(BDPDFN,BDPTYPE,BDPPROV) Q
 ;
 ;
EOJ ;End of Job
 ;
 ;D ^XBFMK S DIE="^BDPPARM(",DA=DUZ(2),DR=".01///"_DUZ(2);".02///"_1 D ^DIE,XBFMK
 D ^XBFMK K DIADD,DINUM
 S X=DUZ(2),DIC="^BDPPARM(",DIC(0)="L",DLAYGO=90360.4
 S DIC("DR")=".02///"_1
 D FILE^DICN D ^XBFMK K DIADD,DINUM
 W !!,"Finished adding the MH SS CD WH Case Managers",!,"to the  Desg Specialty Provider Package ",!!
 K BDPPROV,BDPPAT,BDPTYPE,BDPDFN,BDPCONV,BDPCONV1
 Q
