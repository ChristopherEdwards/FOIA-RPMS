ACHSDAR3 ; IHS/ITSC/PMF - APPEAL TO ALTERNATE RESOURCE (1/3) ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
PAT ;
 S ACHDOCT="appeal to alternate resource"
 D ^ACHSDLK                      ;STANDARD PATIENT LOOKUP
 G END^ACHSDAR4:$D(ACHDLKER)
P4 ;
 ;IF 'OTHER RESOURCES' ARE DOCUMENTED
 I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,0)),U,4) G P5
 W !!!,*7,*7,?10,"No Alternate Resources For This Patient. ",!
 G ENTER:$$DIR^ACHS("Y","          Do You Wish To Enter One Now ","NO","Enter 'YES' to enter an Alternate Resource for this patient","",2)
 S ACHDLKER=""
 D END^ACHSDAR4 Q
 ;
P5 ;
 I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,0)),U,4)=1 S ACHDALRS=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,0)),U,3) G DENDT
 ;
 W !!?10,"Alternate Resources Available For This Patient.",!!
 S (ACHD,ACHDX)=0
 F  S ACHD=$O(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHD)) Q:'ACHD  D
 .S ACHDX=ACHDX+1
 .W ?13,ACHDX,". ",$P($G(^AUTNINS($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHD,0)),U),0)),U),!
 ;
 S %=$$DIR^ACHS("N^1:"_ACHDX,"           Select Alternate Resource","","","",1)
 I $D(DUOUT)!$D(DTOUT)!('%) G PAT
 S ACHDALRS=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,+%,0)),U)
 ;
DENDT ; --- Date Of Alternate Resource Denial"
 W !!
 S ACHDDAT=$$FMTE^XLFDT($P($G(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,0)),U,5))
 ;
 S %=$$DIR^ACHS("D","Enter Date Of Alternate Resource Denial",$S($D(ACHDDAT):ACHDDAT,1:""),"","",1)
 I $D(DUOUT)!$D(DTOUT) G PAT
 I +%<0 G OPTION
 S DA=ACHDALRS
 S DA(1)=ACHSA
 S DA(2)=DUZ(2)
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",800,"
 S DR="8////"_+%
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA,800,ACHDALRS)","+") S DUOUT="" Q
 D ^DIE
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA,800,ACHDALRS)","-") S DUOUT="" Q
 ;
OPTION ; --- Appeal Options
 W !!!?10,"Appeal Options",!
 ;
 S (ACHD,ACHDX)=0
 F  S ACHDX=$O(^ACHSDENR(DUZ(2),13,ACHDX)) Q:+ACHDX=0  D
 .S ACHD=ACHD+1 W !?10,ACHD_". ",$P($G(^ACHSDENR(DUZ(2),13,ACHDX,0)),U)
 ;
 I ACHD=0 W !,"No Appeal options found for this facility!" G ALRCMT
 ;
 S %=$$DIR^ACHS("NO^1:"_ACHD,"          Enter Number Of Option Or <RETURN> To Continue","","","",1)
 ;
 G ALRCMT:%=""
 I $D(DUOUT)!$D(DTOUT) D END^ACHSDAR4 Q
 ;
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,4,0)) S ^ACHSDEN(DUZ(2),"D",ACHSA,800,ACHDALRS,4,0)=$$ZEROTH^ACHS(9002071,1,800,9)
 ;
 I %=ACHD S DIC="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",800,"_ACHDALRS_",4,",DA(3)=DUZ(2),DA(2)=ACHSA,DA(1)=ACHDALRS D EN^DIWE G OPTION
 ;
 S X=%
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",800,"_ACHDALRS_",4,"
 S DA(3)=DUZ(2)
 S DA(2)=ACHSA
 S DA(1)=ACHDALRS
 S DIC(0)="QEMZ"
 ;
 K DD,DO
 D FILE^DICN    ;
 G OPTION
 ;
ALRCMT ; --- Comments Concerning Alternate Resource Appeal
 W !!,"Enter Pertinent Comments Concerning Alternate Resource Appeal",!,"Or <RETURN> to Skip: ",!!
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",800,"_ACHDALRS_",5,"
 S DA(3)=DUZ(2)
 S DA(2)=ACHSA
 S DA(1)=ACHDALRS
 D EN^DIWE
 I X[U S ACHDLKER=""
DEV ;
 W !!
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D HOME^%ZIS D END^ACHSDAR4 Q
 G:'$D(IO("Q")) START^ACHSDAR4
 K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 S ZTRTN="START^ACHSDAR4",ZTDESC="CHS APPEAL TO ALTERNATE RESOURCE LETTER"
 F %="ACHSA","ACHDALRS" S ZTSAVE(%)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV
 Q
 ;
ENTER ;
 W !!
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,800,0)) S ^ACHSDEN(DUZ(2),"D",ACHSA,800,0)=$$ZEROTH^ACHS(9002071,1,800)
 S DA(2)=DUZ(2)
 S DA(1)=ACHSA
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",800,"
 S DIC(0)="AQELM"
 D ^DIC
 G:Y<1 P4
 W !!
 S DA(2)=DUZ(2)
 S DA(1)=ACHSA
 S DIE=DIC
 S DR="2;5"
 D ^DIE
 G P4
 ;
