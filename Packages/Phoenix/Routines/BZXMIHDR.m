BZXMIHDR ;IHS/PIMC/JLG- HEALTH DEPARTMENT REPORT ; 12/2/03
 ;;5.1;LAB;;04/11/91 11:06
 ;;;IHS/PIMC/JLG  - 12/2/03  Restructuring and revision without commenting at each place.
 ;SLC/CJS,BA- HEALTH DEPARTMENT REPORT ;2/19/91 
 ;MODIFIED BY WALZ
 ;;;IHS/PIMC/vjm - 7/24/01 added INTROTXT sub-rtn
 ;
 Q:$D(BZX("QUIT"))    ; var will be set if '^' out of the Gila River
 ;                    ; intro text DIR response - option:  BZXX DWMIHDR1
 K ^UTILITY("MI",$J)
 ;
 ; start - vjm 4/14/2000 - setting subscript variable
 S BZXSBSCR="MI"
 ; end - vjm 4/14/2000
 ;
 I '$D(DT) W !,"VARIABLE DT NOT DEFINED ABORTING" Q
 ;Begin modified code IHS/PIMC/JLG  12/6/00
BEGIN S LREND=0,LREDT="T-1"
 D ^LRWU3
 I 'LREND D
 .S ZTRTN="DQ^BZXMIHDR"
 .S ZTSAVE("BZX*")=""
 .D IO^LRWU
 ;End modified code  12/6/00
END K %DT,A,AGE,D0,DA,DFN,DIC,DL,DOB,DR,DX,I,LRACC,LRBUG,LROCCU,LRDFN,LRDPF,LRDT,LREDT,LREND,LRHC,LRIDT,LRMARST,DWSAMP,LRPHONE,LRRACE,LRSAMP,LRSDT,LRSPEC,LRWRD,POP,PNM,S,SEX,SSN,HRCN,X,Y,Z0,DWLOC  ;IHS/ANMC/CLS 10/03/92 HRCN
 K DWPROV,DWPROVN,DWCOLDT,PEDT,PSDT,DWCITY,DWSTR,DWSTATE,DWPROV,DWBUG,DWCMPLDT,DWCOL,DWCPL,DWSTATN,DWZIP,FOOTFLG,II,III,LI,PG,PGM,PLG,PP,RACC,RPNM,J
 ;
 ; start - vjm 4/14/2000 - killing BZX variables
 K BZXCOMM,BZX,BZXSBSCR
 ; end - vjm 4/14/2000
 ;
 K:$D(ZTSK) ^%ZTSK(ZTSK),ZTSK D ^%ZISC
 Q
DQ K ^UTILITY("MI",$J) 
 S FOOTFLG=0,PEDT=$E(LREDT,4,5)_"/"_$E(LREDT,6,7)_"/"_$E(LREDT,2,3),PSDT=$E(LRSDT,4,5)_"/"_$E(LRSDT,6,7)_"/"_$E(LRSDT,2,3)
 D:$D(ZTSK) KILL^%ZTLOAD K ZTSK U IO
 S LRDT=LREDT-.0001 F I=0:0 S LRDT=$O(^LR("AD",LRDT)) Q:LRDT<1!(LRDT>LRSDT)  D DATE Q:LREND
 D PREPORT
 Q
DATE ;S DR=.11 
 S LRBUG=0 F I=0:0 S LRBUG=$O(^LR("AD",LRDT,LRBUG)) Q:LRBUG<1  D LIST Q:LREND
 Q
LIST ;
 S LRACC="" F I=0:0 S LRACC=$O(^LR("AD",LRDT,LRBUG,LRACC)) Q:LRACC=""  S LRDFN=^(LRACC) D SPEC,PAT,SETNODE 
 Q
SPEC S (LRIDT,LRSPEC,LRSAMP)=0 F I=0:0 S LRIDT=$O(^LR(LRDFN,"MI",LRIDT)) Q:LRIDT<1  D  Q:LRSPEC
 .I $D(^LR(LRDFN,"MI",LRIDT,0)),$E(LRACC,1,$L(LRACC)-1)=$P(^LR(LRDFN,"MI",LRIDT,0),U,6) D
 ..S LRSPEC=+$P(^LR(LRDFN,"MI",LRIDT,0),U,5),LRSAMP=+$P(^(0),U,11),DWPROVN=+$P(^(0),U,7),DWCOLDT=+$P(^(0),U,1) 
 ..S DWCMPLDT=$S($D(^LR(LRDFN,"MI",LRIDT,1)):+$P(^(1),U,1),$D(^(11)):+$P(^(11),U,1),$D(^(5)):+$P(^(5),U,1),$D(^(8)):+$P(^(8),U,1),$D(^(16)):+$P(^(16),U,1),1:"")
 ..S DWLOC=$P(^LR(LRDFN,"MI",LRIDT,0),U,8)
 S DWPROV="" S:DWPROVN>0&($D(^VA(200,DWPROVN,0))) DWPROV=$P(^VA(200,DWPROVN,0),U,1)
 S DWSAMP="" I LRSAMP,$D(^LAB(62,LRSAMP,0)) S DWSAMP=$P(^(0),U)
 Q
PAT S LRDPF=$P(^LR(LRDFN,0),U,2) Q:LRDPF=67.1  ;quit if research entry from file 67.1
 ;
 ; start - vjm 5/11/2000
 S DFN=$P(^LR(LRDFN,0),U,3)   
 I LRDPF=2 D BZXGR^BZXLRGR                 ;To print all communities, only defined for file 2
 S DIC=^DIC(+LRDPF,0,"GL")
 D PT^LRX
 ; end - vjm 5/11/2000
 ;
 S X=DIC_DFN_",.13)"
 S LRPHONE=$S($D(@X):$P(^(.13),U),1:""),LRRACE=$P(DIC_DFN_",0)",U,6),LRMARST=$P(^(0),U,5),LROCCU=$P(^(0),U,7)
 S (DWSTR,DWCITY,DWSTATN,DWZIP,DWSTATE)=""
 ;Begin mods to fix missing state  IHS/PIMC/JLG  12/1/03
 ;I $D(^DPT(DFN,.11)) S DWSTR=$P(^DPT(DFN,.11),"^",1),DWCITY=$P(^(.11),"^",4),DWSTATN=+$P(^(.11),"^",5),DWZIP=$P(^(.11),"^",6),DWSTATE=$P(^DIC(5,DWSTATN,0),"^",1)
 I $D(^DPT(DFN,.11)) D
 .S DWSTR=$P(^DPT(DFN,.11),"^",1),DWCITY=$P(^(.11),"^",4),DWSTATN=+$P(^(.11),"^",5),DWZIP=$P(^(.11),"^",6)
 .I DWSTATN S DWSTATE=$P(^DIC(5,DWSTATN,0),"^",1)
 .E  S DWSTATE="No state"
 ;End changes
 Q
SETNODE ;
 ; start - vjm 5/11/2000 adding comm to the ^UTILITY temp gbl
 D MICOMM^BZXLRGR         ;IHS/PIMC/JLG  12/6/00
 Q                        ;IHS/PIMC/JLG  12/6/00
 ; end - vjm 5/11/2000
 
 ;
PREPORT ;
 ; start - vjm 5/17/2000 - do Do block if no data to report
 I '$D(^UTILITY("MI",$J)) D  Q
 .  S PG=1
 .  D RHEAD
 .  K PG
 .  W !?35,"**** NO DATA TO REPORT **** "
 .  W @IOF
 .  Q
 ; end - vjm 5/17/2000
 ;
 S PG=1,DWBUG="" F I=0:0 S DWBUG=$O(^UTILITY("MI",$J,DWBUG))  Q:DWBUG=""  D RLOOP1
 D FOOTER W @IOF
 K ^UTILITY("MI",$J)
 Q
RLOOP1 D:FOOTFLG=1 FOOTER
 W @IOF D RHEAD  ;W !,"Reporting Organism: "_DWBUG,!
 S RPNM="" F II=0:0 S RPNM=$O(^UTILITY("MI",$J,DWBUG,RPNM))  Q:RPNM=""  D RLOOP2
 Q
RLOOP2 S RACC="" F III=0:0 S RACC=$O(^UTILITY("MI",$J,DWBUG,RPNM,RACC))  Q:RACC=""  D PRTIT
 Q
PRTIT ; print patient data
 W !!,$E(RPNM,1,28) ;NAME
 W ?30,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",6) ;HRN
 W ?40,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",7) ;DOB
 W ?54,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",8) ;SEX
 W ?58,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",4) ;ACCN
 W ?70,$E($P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",1),1,12) ;SPEC
 S DWCOL=$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",3) W ?84,$E(DWCOL,4,5)_"/"_$E(DWCOL,6,7)_"/"_$E(DWCOL,2,3) ;COL DT
 S DWCPL=$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",5) W ?94,$E(DWCPL,4,5)_"/"_$E(DWCPL,6,7)_"/"_$E(DWCPL,2,3) ;CPL DT
 W ?106,$E($P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",2),1,25) ;PROV
 W !,?5,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",9) ;PHONE
 W ?30,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",10) ;STREET
 W ?64,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",11) ;CITY
 W ?84,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",12) ;STATE
 W ?98,$P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",13) ;ZIP
 W ?106,$E($P(^UTILITY("MI",$J,DWBUG,RPNM,RACC),"^",14),1,25) ;LOC
 ;
 ; start - vjm 5/15/2000 - adding comm to these write statements
 D COMM^BZXLRGR    ;IHS/PIMC/JLG   12/6/00
 ; end - vjm
 ;
 I $Y>50 D FOOTER W @IOF D RHEAD
 Q
RHEAD W "AZ HEALTH DEPARTMENT REPORT",?51,"Phoenix Indian Medical Center",!,?46,"4212 N. 16th St., Phoenix, AZ  85016",!,"From "_PEDT_" to "_PSDT,?53,"****** CONFIDENTIAL ******",?98,"Printed: "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),?120,"Page: "_PG,!
 W !,"Name",?30,"ID#",?40,"DOB",?54,"Sex",?58,"Lab #",?70,"Sample",?84,"Col Dt",?94,"Cpl Dt",?106,"Provider",!,?5,"Phone #",?30,"Address",?106,"Location"
 ;
 ; start - vjm 5/15/2000
 ;Modified to print current community on all reports
 W !?5,"Current Community"               ;IHS/PIMC/JLG  12/6/00
 ; end - vjm
 ;
 W ! F LI=0:1:IOM-1 W ?LI,"-"
 W ! S PG=PG+1,FOOTFLG=1
 W !,"Reporting Organism: "_DWBUG,!
 Q
FOOTER S PLG=56-$Y F PP=1:1:PLG W !
 W "________________________________________            _______________"
 W !,"   Medical Technologist                                   Date"
 Q
 ;
 ;====================================================================
INTROTXT ; introduction text of this Local Health Department [Gila River] report
 ;
 W !!!
 W "This report prints Arizona Health Department organisms which have",!
 W "been identified during the date interval selected.  The report",!
 W "is for patients residing only in selected Gila River communities.",!!
 W "NOTE:  This report requires a COMPRESSED (132 characters/line) printer!",!!
 K DIRUT
 S DIR(0)="E",DIR("A")="Press <Return> to continue or '^' to quit"
 D ^DIR K DIR,DA
 S:$D(DIRUT) BZX("QUIT")=1
 Q:$D(BZX("QUIT"))
 W:$D(IOF) @IOF
 Q
 ;
 ;
BZXGR ; processing for Gila River Community pts
 ; ^BZXGRHD --> BZX DWMIHDR1 GILA RIVER HLTH RPT COMMUNITIES file
 ;
 S BZX("COMM IEN")=0
 S BZX("COMM IEN")=$$COMMRES^AUPNPAT(DFN,"I")
 ;
 ; do this IF the ptr value for CURRENT COMMUNITY does not exist
 I '+BZX("COMM IEN") D
 .  S BZX("COMM NAME")=$P(^AUPNPAT(DFN,11),U,18)
 .  S BZX("COMM IEN")=$O(^AUTTCOM("B",BZX("COMM NAME"),0))
 .  Q
 ;
 ; get IEN of the local BZX gila river community list
 S BZX("IEN")=$O(^BZXGRHR("B",BZX("COMM IEN"),0))
 ;
 I '+BZX("IEN") D BZXKVARS Q      ; QUIT if no entry in local file
 S BZXCOMM=$$COMMRES^AUPNPAT(DFN,"E")
 D BZXKVARS
 Q
BZXKVARS ; clean up the BZX vars
 K BZX
 Q
 ; end of routine
