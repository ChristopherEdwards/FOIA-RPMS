APCLADX ; IHS/CMI/LAB - AGE BUCKET/DIAGNOSIS REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 W !!?15,"*****  FREQUENCY OF DIAGNOSES BY AGE REPORT  *****",!!
 D EXIT
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EXIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
FILT ;
 S APCLQUIT=""
 K APCLSEX,APCLDOB1,APCLDOB2,APCLFAC,APCLPROV,APCLCLN,APCLSC,APCLSCP,APCLTYPE,APCLTYPP
 W !!,"When I search the database, I can ""screen"" POVs according to any one of the",!,"following attributes:"
 W !?15,"PATIENT SEX",!?15,"FACILITY OF ENCOUNTER",!?15,"PRIMARY PROVIDER",!?15,"CLINIC TYPE"
 W !?15,"SERVICE CATEGORY (Hospitalizations, Ambulatory, Chart Reviews",!?33," Nursing Home, etc.)",!?15,"VISIT TYPE (IHS, Contract, Tribal, 638, Other, VA)",!
 S DIR(0)="YO",DIR("A")="Want to use one or more of these 'screens'",DIR("B")="NO",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 G:$D(DIRUT) ED
 G:Y=0 POV
 D ^APCLADX0
 G:$D(DIRUT) FILT
 I APCLQUIT S APCLQUIT="" G FILT
POV ;
 K APCLPRIM,APCLALL
 S DIR(0)="SO^P:Primary Purpose of Visit;A:All Purpose of Visits (Primary and Secondary)",DIR("A")="Report should include"
 S DIR("?")="If you wish to count only the primary purpose of visit enter a 'P'.  To include ALL purpose of visits enter an 'A'.  For outpatient visits (non-H service category) the primary pov is the first one entered." D ^DIR K DIR
 I $D(DIRUT) G FILT
 I Y="A" S APCLALL=""
 I Y="P" S APCLPRIM=""
 ;
BIN D SETBIN
 W !,"The Age Groups to be used are currently defined as:",! D LIST
 S DIR(0)="YO",DIR("A")="Do you wish to modify these age groups" D ^DIR K DIR
 I $D(DIRUT) G POV
 I Y=0 G ZIS
RUN ;
 K APCLQUIT S APCLY="",APCLA=-1 W ! F  D AGE Q:APCLX=""  I $D(APCLQUIT) G BIN
 D CLOSE I $D(APCLQUIT) G BIN
 D LIST
 G ZIS
 ;
AGE ;
 S APCLX=""
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the starting age of the "_$S(APCLY="":"first",1:"next")_" age group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S APCLQUIT="" Q
 S APCLX=Y
 I Y="" Q
 I APCLX?1.3N,APCLX>APCLA D SET Q
 W $C(7) W !,"Make sure the age is higher the beginning age of the previous group.",! G RUN
 ;
SET S APCLA=APCLX
 I APCLY="" S APCLY=APCLX Q
 S APCLY=APCLY_"-"_(APCLX-1)_";"_APCLX
 Q
 ;
CLOSE I APCLY="" Q
GC ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the highest age for the last group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S APCLQUIT="" Q
 S APCLX=Y I Y="" S APCLX=199
 I APCLX?1.3N,APCLX'<APCLA S APCLY=APCLY_"-"_APCLX,APCLBIN=APCLY Q
 W "  ??",$C(7) G CLOSE
 Q
 ;
 ;
LIST ;
 S %=APCLBIN
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,"-")," - ",$P(X,"-",2)
 W !
 Q
 ;
SETBIN ;
 S APCLBIN="0-0;1-4;5-14;15-19;20-24;25-44;45-64;65-125"
 Q
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 D EXIT Q
 W !!,$C(7),$C(7),"THIS REPORT SHOULD BE PRINTED ON 132 COLUMN PAPER OR ON A PRINTER THAT IS",!,"SET UP FOR CONDENSED PRINT!!!",!,"IF YOU DO NOT HAVE SUCH A PRINTER AVAILABLE - SEE YOUR SITE MANAGER.",!
 S XBRC="^APCLADX1",XBRP="^APCLADXP",XBNS="APCL",XBRX="EXIT^APCLADX"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;
 K APCLBD,APCLED,APCLSEX,A,B,C,X,Y,Z,%,APCLFAC,APCLJOB,E,F,G,ZTQUEUED,APCLCLN,APCLTYPE,APCLSC,APCLC,APCLPREC,APCLSD,APCLCATP,APCLCLNP,APCLLOCP,APCLNARR,DIC,DIR,J,K,M,S
 K APCLQUIT,APCLPOV,APCLVSIT,APCLTOT,APCLPROV,APCLVTOT,APCLLINO,L,I,APCLPOVN,APCLV,APCLTYPP,APCLSCP,APCLPRIM,APCLALL
 K APCL132,APCLA,APCLBDD,APCLBIN,APCLCODE,APCLDOB,APCLDOBS,APCLEDD,APCLF2,APCLFACP,APCLFOUN,APCLNN,APCLODAT,APCLPG,APCLPRVP,APCLSEXP,APCLTAB,APCLVDFN,APCLZ
 K APCLBT,APCLGRAN
 Q
 ;
 ;
 ;
 ;
