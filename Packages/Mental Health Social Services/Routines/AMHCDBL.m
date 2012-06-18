AMHCDBL ; IHS/CMI/LAB - backload pcc visits ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;backfill BH with CDMIS Data
 ;
EP ;
 I '$D(^AMHTCOMP("B","PREVENTION")) D
 .S X="PREVENTION",DIC="^AMHTCOMP(",DIADD=1,DLAYGO=9002013.7,DIC(0)="L",DIC("DR")="1////PRV;2////B;3////Y;4////PREVENTION" D FILE^DICN
 .K DIADD,DLAYGO
 .D ^XBFMK
 .Q
START ;
 I $$VERSION^XPDUTL("ACD")<4.1 W !!,"CDMIS IS NOT UP TO VERSION 4.1, CANNOT CONTINUE" D XIT Q
 K ^TMP($J)
 S DIFGLINE=1
 W !!,"This routine is used to backload CDMIS data into the BH package."
 W !!,"This option should be only by those sites that have discontinued"
 W !,"the use of the CDMIS module.",!
 W !,"Only visits in a date range you specify will be transferred."
 W !,"You should decide ahead of time how far back you want to go"
 W !,"in backloading data.  It might be wise to just backload the past"
 W !,"1 or 2 years worth of data first and then decide if older data"
 W !,"should be moved.",!!
CONT ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I 'Y G XIT
D ;date range
 K AMHED,AMHBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date of CDMIS Visits to backload"
 D ^DIR S:Y<1 AMHQUIT=1 G:Y<1 START  S AMHBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Date of CDMIS Visits to backload"
 D ^DIR S:Y<1 AMHQUIT=1 G:Y<1 D  S AMHED=Y
 ;
 I AMHED<AMHBD D  G D
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 W !,"Please enter the location to be used as a default for Prevention Activities."
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("B")=$$VAL^XBDIQ1(9002013,DUZ(2),.28) D ^DIC
 K DIC,DA
 I Y=-1 D XIT Q
 S AMHDLOC=+Y
 W !,"Please enter the community to be used as a default for all records created."
 S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("B")=$$VAL^XBDIQ1(9002013,DUZ(2),.29) D ^DIC
 K DIC,DA
 I Y=-1 D XIT Q
 S AMHDCOM=+Y
PCC ;
 W !!,"These CDMIS visits do not need to pass to PCC because they are old visits."
 S AMHPCCL=0,AMHLPCC=0
 S DIR(0)="Y",DIR("A")="Should these visits also pass to PCC",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y S AMHPCCL=1,AMHLPCC=1
PROC ;
 W !!,"Please be patient while the conversion process takes place..."
 W !,"Moving CDMIS Prevention Activities"
 D CDPREV
 W !,"Moving CDMIS visits"
 D CDVISIT
 W !!,"all done"
 ;S DA=DUZ(2),DR="1501///1",DIE="^AMHSITE(" D ^DIE
 K ^TMP($J)
 D EN^XBVK("AMH")
 D ^XBFMK
 K DIFGLINE
 Q
CDVISIT ;
 D ^AMHLEIN
 S AMHBL=1,AMHCIN=0,AMHCRE=0,AMHCFU=0,AMHCIR=0,AMHCOT=0,AMHCTD=0
 S APCDOVRR=1,AMHCDVS=0
 S AMHIEN=0 F  S AMHIEN=$O(^ACDVIS(AMHIEN)) Q:AMHIEN'=+AMHIEN  D
 .S AMHR0=$G(^ACDVIS(AMHIEN,0))
 .Q:$D(^ACDVIS(AMHIEN,"BHCONV"))
 .S ^ACDVIS(AMHIEN,"BHCONV")=""
 .W "."
 .Q:AMHR0=""
 .S AMHDATE=$P(AMHR0,U,1)
 .Q:AMHDATE<AMHBD
 .Q:AMHDATE>AMHED
DE .;
 .S AMHCOMP=$$VAL^XBDIQ1(9002172.1,AMHIEN,1),AMHCOMPI=$P(AMHR0,U,2)
 .S AMHCOMPB=$O(^AMHTCOMP("B",AMHCOMP,0)) I AMHCOMPB="" W !,"Cannot map component: ",AMHCOMP," ",AMHIEN," Using Other" S AMHCOMP="OTHER",AMHCOMPB=$O(^AMHTCOMP("B","OTHER",0))
 .S AMHCOMT=$$VAL^XBDIQ1(9002172.1,AMHIEN,5),AMHCOMTI=$P(AMHR0,U,7)
 .S AMHPROV=$P(AMHR0,U,3)
 .S AMHTC=$P(AMHR0,U,4)
 .S AMHPAT=$P(AMHR0,U,5)
 .;Q:AMHPAT=""
 .S AMHLOC=$G(^ACDVIS(AMHIEN,"BWP")) I AMHLOC="" S AMHLOC=DUZ(2)
 .I AMHTC="IN" S AMHACT=12 D IN S AMHCIN=AMHCIN+1 Q
 .I AMHTC="RE" S AMHACT=12 D IN S AMHCRE=AMHCRE+1 Q
 .I AMHTC="FU" S AMHACT=21 D IN S AMHCFU=AMHCFU+1 Q
 .I AMHTC="IR" S AMHACT=25 D IN S AMHCIR=AMHCIR+1
 .I AMHTC="OT" S AMHACT=48 D IN S AMHCOT=AMHCOT+1 Q
 .I AMHTC="TD" S AMHACT=19 D TD^AMHCDBL1 S AMHCTD=AMHCTD+1 Q
 .;I AMHTC="CS" S AMHACT="" D CS^AMHCDBL2
 W !,"moved ",AMHCDVS," cdmis visits"
 W !,AMHCIN," initial"
 W !,AMHCRE," reopen"
 W !,AMHCFU," follow up"
 W !,AMHCIR," info/referral"
 W !,AMHCOT," other"
 W !,AMHCTD," trans/disc"
 Q
IN ;
 D IN^AMHCDBL1
 Q
CDPREV ;
 ;move all entries from ACDPD using month/yr from .01 field and then date from .01 of multiple
 ;
 S AMHCDPRC=0
 S AMHIEN=0 F  S AMHIEN=$O(^ACDPD(AMHIEN)) Q:AMHIEN'=+AMHIEN  D
 .W "."
 .S AMHR0=$G(^ACDPD(AMHIEN,0))
 .Q:AMHR0=""
 .S AMHMY=$E($P(AMHR0,U),1,5)
 .S AMHCOMP=$$VAL^XBDIQ1(9002170.7,AMHIEN,1)
 .I AMHCOMP="" S AMHCOMP="OTHER",AMHCOMPB=$O(^AMHTCOMP("B","OTHER",0)) G C1
 .S AMHCOMPB=$O(^AMHTCOMP("B",AMHCOMP,0)) I AMHCOMPB="" W !,"Cannot map component: ",AMHCOMP," ",AMHIEN," Using Other" S AMHCOMP="OTHER",AMHCOMPB=$O(^AMHTCOMP("B","OTHER",0))
C1 .S AMHCOMT=$$VAL^XBDIQ1(9002170.7,AMHIEN,2)
 .S AMHLOC=$P(AMHR0,U,4)
 .S AMHMIEN=0 F  S AMHMIEN=$O(^ACDPD(AMHIEN,1,AMHMIEN)) Q:AMHMIEN'=+AMHMIEN  D
 ..I $D(^ACDPD(AMHIEN,1,AMHMIEN,"BHCONV")) Q  ;already moved
 ..S AMHMR0=^ACDPD(AMHIEN,1,AMHMIEN,0)
 ..S AMHDAY=$P(AMHMR0,U) I $L(AMHDAY)=1 S AMHDAY="0"_AMHDAY
 ..S AMHDATE=AMHMY_AMHDAY S X=AMHDATE,%DT="" D ^%DT I Y=-1 Q  ;W !,"invalid date: ",AMHDATE," ien: ",AMHIEN," ",AMHMIEN Q
 ..I AMHDATE<AMHBD!(AMHDATE>AMHED) Q
 ..S AMHPRA=$P(AMHMR0,U,2) I AMHPRA="" W !,"NO prevention activity, skipping" Q
 ..S AMHPRA=$P(^ACDPREV(9002170.9,AMHPRA,0),U)
 .. S X=AMHPRA,DIC(0)="M",DIC="^AMHTPA(" D ^DIC S AMHPRAB=+Y I AMHPRAB="" W !,"Could not map prevention activity: ",AMHPRA Q
 .. K DIC D ^XBFMK
 ..S AMHTAR=$P(AMHMR0,U,4)
 ..S AMHNS=$P(AMHMR0,U,5)
 ..S AMHCAT=$P(AMHMR0,U,7) I AMHCAT S AMHCAT=$O(^ACDLOT(AMHCAT,0),U)
 ..S AMHCAT=$$TOC(AMHCAT)
 ..S AMHTIME=$P(AMHMR0,U,8) I AMHTIME="" W !,"no time on prevention.. skipping ",AMHIEN," ",AMHMIEN Q
 ..S AMHTIME=AMHTIME*60
 ..;create MHSS record
 ..K DIC S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")=".02///C;.03///^S X=DT;.19////"_DUZ_";.33////R;.28////"_DUZ_";.22///A;.21///^S X=DT"
 ..K DD,DO,D0 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 ..I Y=-1 W !!,$C(7),$C(7),"Error creating Behavioral Health Record!!  Deleting Record.",! Q
 ..S AMHR=+Y,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 ..S DA=AMHR,DR=".04////"_AMHLOC_";.05////"_AMHDCOM_";.06///37;.07///"_AMHCAT_";.09///"_AMHNS_";.12///"_AMHTIME_";.32///PR;1101///"_AMHCOMP_";1105///"_AMHCOMT_";1106///"_AMHTAR,DIE="^AMHREC(" D ^DIE
 ..I $D(Y) W !!,"error editing MHSS Record entry ",AMHIEN," ",AMHMIEN
 ..;now create provider
 ..S AMHIENP=0,AMHC=0 F  S AMHIENP=$O(^ACDPD(AMHIEN,1,AMHMIEN,"PRV",AMHIENP)) Q:AMHIENP'=+AMHIENP  D
 ...S Y=$P(^ACDPD(AMHIEN,1,AMHMIEN,"PRV",AMHIENP,0),U)
 ...S AMHC=AMHC+1
 ...S AMHPS=$S(AMHC=1:"P",1:"S")
 ...S X=+Y,DIC("DR")=".03////"_AMHR_";.04///"_AMHPS,DIC="^AMHRPROV(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.02 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 ...I Y=-1 W !!,"Creating Primary Provider entry failed!!!",$C(7),$C(7) H 2
 ...D ^XBFMK
 ..;now create POV
 ..S Y=$O(^AMHPROB("B",99,0))
 ..S X=+Y,DIC("DR")=".03////"_AMHR_";.04///PREVENTION ACTIVITY: "_AMHPRA,DIC="^AMHRPRO(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.01 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 ..I Y=-1 W !!,"Creating POV entry failed!!!",$C(7),$C(7) H 2
 ..D ^XBFMK
 ..;now create prevention activity
 ..S X=AMHPRAB,DIC("DR")=".03////"_AMHR,DIC="^AMHRPA(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.09 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 ..I Y=-1 W !!,"Creating PREVENTION ACTIVITY entry failed!!!",$C(7),$C(7) H 2
 ..D ^XBFMK
 ..S ^ACDPD(AMHIEN,1,AMHMIEN,"BHCONV")=""
 ..S AMHCDPRC=AMHCDPRC+1
 W !!,"A total of ",AMHCDPRC," CDMIS prevention activities moved to BH."
 Q
XIT ;
 W !!,"ALL DONE",!
 D EN^XBVK("AMH")
 D ^XBFMK
 Q
TOC(X) ;
 I X="" Q 4
 I X="SCHOOL" Q 6
 I X="COMMUNITY FACILITY" Q 4
 I X="CONTRACT PROGRAM" Q 4
 I X="HOME" Q 5
 I X="JAIL/COURTS" Q 14
 I X="MEDICAL FACILITY" Q 3
 I X="OTHER" Q 4
 I X="OUTDOORS" Q 4
 I X="PROGRAM FACILITY" Q 2
 I X="REGIONAL TRTMNT CTR" Q 11
 Q 4
PROBCONV ;
 ;S X=0 F  S X=$O(AMHPROB(X)) Q:X'=+X  S %=$$PCONV($P(AMHPROB(X),U,3)),$P(AMHPROB(X),U,4)=%,$P(AMHPROB(X),U,5)=$O(^AMHPROB("B",%,0))
 Q
PCCLINK ;EP
 Q:AMHPAT=""
 S AMHPTYPE="C"
 Q:'$P(^AMHTACT($P(^AMHREC(AMHR,0),U,6),0),U,4)
 S DFN=AMHPAT
 S AMHACTN=1
 ;check for pcc visit on this date
 Q:$$VIS(AMHPAT,AMHDATE)  ;quit if already an alcohol clinic visit on this date
 D PCCLINK^AMHLE2
 S V=$P(^AMHREC(AMHR,0),U,16)
 I V K ^AUPNVSIT("ABILL",DT,V),^AUPNVSIT("ADWO",DT,V)
 Q
VIS(P,D) ;
 NEW X,Y,G
 S G=0
 S X=9999999-AMHDATE,Y=0 F  S X=$O(^AUPNVSIT("AA",P,X)) Q:$P(X,".")>AMHDATE!(X="")  D
 .S Y=0 F  S Y=$O(^AUPNVSIT("AA",P,X,Y)) Q:Y'=+Y  I $$CLINIC^APCLV(Y,"C")=43 S G=1
 .Q
 Q G
