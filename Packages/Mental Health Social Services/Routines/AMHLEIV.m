AMHLEIV ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 16-JAN-1997 14 Sep 2009 12:21 PM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;; ;
 ;
EP1(AMHR,P) ;EP - CALLED FROM PROTOCOL FROM THE OTHER INFORMATION MENU AFTER VISIT ENTRY
 I '$G(AMHR) D FULL^VALM1 W !!,"You must first select a visit." D PAUSE^AMHLEA Q
 NEW AMHBROW,AMHD,AMHDA,AMHFILE,AMHINTK,AMHL,AMHLINE,AMHNODE,AMHPC,AMHPCNT,AMHPRNM,AMHPRNT,AMHQUIT,AMHR1,AMHRCNT,AMHINTI,AMHPROGT,AMHFIRST
 NEW AMHV,AMHX,D,D0,DA,DD,DIADD,DIC,DIE,DIK,DIR,DIRUT,DLAYGO,DO,DR,AMHPAT,DFN
 S (DFN,AMHPAT)=P
 S AMHPROGT=$P(^AMHREC(AMHR,0),U,2)
 D EN
 D FULL^VALM1
 K VALMHDR
 Q
EP ;EP CALLED FROM DATA ENTRY
 Q:'$G(AMHR)
 NEW DFN,AMHPAT,AMHPROGT
 S (DFN,AMHPAT)=$P(^AMHREC(AMHR,0),U,8)
 S Y=AMHPAT D ^AUPNPAT
 S AMHPROGT=$P(^AMHREC(AMHR,0),U,2)
 D EN
 Q
EN ; -- main entry point for AMH UPDATE PATIENT CASE DATA
 NEW AMHX,AMHINTK,AMHD,AMHRCNT,AMHLINE
 D EN^VALM("AMH VISIT INTAKE")
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)=$$EXTSET^XBFUNC(9002011,.02,AMHPROGT)_" INTAKE DOCUMENTS        *unsigned document"
 S VALMHDR(2)="Patient Name: "_IORVON_$P(^DPT(DFN,0),U)_IOINORM_"   DOB: "_$$FTIME^VALM1($P(^DPT(DFN,0),U,3))_"   Sex: "_$P(^DPT(DFN,0),U,2)_"   HRN: "_$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),1:"????")
 S X="",$E(X,4)="",$E(X,24)="INITIAL",$E(X,44)="",$E(X,53)="UPDATE"
 S VALMHDR(3)=X
 S X="",$E(X,1)="#",$E(X,4)="INITIATED",$E(X,15)="PROGRAM",$E(X,24)="PROVIDER",$E(X,44)="UPDATED",$E(X,53)="PROVIDER"
 S VALMHDR(4)=X
 ;S X="",$E(X,44)="UPDATED",$E(X,53)="PROVIDER"
 ;S VALMHDR(5)=X
 Q
 ;
INIT ; -- init variables and list array
 S VALMSG="?? for more actions  + next screen  - prev screen"
 D GATHER ;gather up all records for display
 S VALMCNT=AMHLINE
 Q
 ;
D(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
GATHER ;EP
 S AMHRCNT=0,AMHLINE=0
 K AMHV
 S AMHX=0 F  S AMHX=$O(^AMHRINTK("AC",AMHPAT,AMHX)) Q:AMHX'=+AMHX  D
 .;S AMHINTR=$P(^AMHRINTK(AMHX,0),U,3)
 .;Q:'AMHINTR
 .Q:'$$ALLOWINT(DUZ,AMHX)
 .I $P(^AMHRINTK(AMHX,0),U,5)]"" Q:$P(^AMHRINTK(AMHX,0),U,5)'=AMHPROGT
 .Q:$P(^AMHRINTK(AMHX,0),U,9)'="I"  ;only initial intakes
 .S AMHV(9999999-$P(^AMHRINTK(AMHX,0),U),AMHX)=""
 S D=0,AMHLINE=0,AMHRCNT=0
 F  S D=$O(AMHV(D)) Q:D'=+D  D
 .S AMHX=0 F  S AMHX=$O(AMHV(D,AMHX)) Q:AMHX'=+AMHX  D
 ..S AMHL="",AMHRCNT=AMHRCNT+1,AMHL=$S('$P(^AMHRINTK(AMHX,0),U,11):"*",1:""),AMHL=AMHL_AMHRCNT,$E(AMHL,5)=$$D($P(^AMHRINTK(AMHX,0),U))
 ..S $E(AMHL,15)=$E($$VAL^XBDIQ1(9002011.13,AMHX,.05),1,8)
 ..S $E(AMHL,24)=$E($$VAL^XBDIQ1(9002011.13,AMHX,.04),1,19)
 ..S AMHLINE=AMHLINE+1,AMHINTK(AMHLINE,0)=AMHL,AMHINTK("IDX",AMHLINE,AMHRCNT)=AMHX
 ..S AMHY=0 F  S AMHY=$O(^AMHRINTK("AI",AMHX,AMHY)) Q:AMHY'=+AMHY  D
 ...S AMHL=""
 ...S $E(AMHL,43)=$S('$P(^AMHRINTK(AMHY,0),U,11):"*",1:"")
 ...S $E(AMHL,44)=$$D($P($P(^AMHRINTK(AMHY,0),U),"."))
 ...S $E(AMHL,53)=$$VAL^XBDIQ1(9002011.13,AMHY,.04)
 ...S AMHLINE=AMHLINE+1,AMHINTK(AMHLINE,0)=AMHL,AMHINTK("IDX",AMHLINE,AMHRCNT)=AMHX
 Q
ADD ;
 ;add a new intake document
 D FULL^VALM1
 S AMHIDAT=""
 I $G(AMHR) S AMHIDAT=$P($P(^AMHREC(AMHR,0),U),".")
 I AMHIDAT="" S AMHIDAT=$P($G(AMHDATE),".",1)
 I AMHIDAT="" S AMHIDAT=DT
 NEW X,Y,Z
 S Y=0
 ;S X=0 F  S X=$O(^AMHRINTK("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRINTK(X,0),U,9)="I" S Y=1
 ;I Y=1 W !!,"There is already an Initial Intake on this visit.",! D PAUSE^AMHLEA,EXIT Q
 W !,"Adding Intake for ",$$VAL^XBDIQ1(2,AMHPAT,.01)  ;," with a date of ",$$FMTE^XLFDT(AMHIDAT),"."
 S DIR(0)="Y",DIR("A")="Do you wish to continue and add the Initial Intake document",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE^AMHLEA,EXIT Q
 I 'Y D PAUSE^AMHLEA,EXIT Q
 ;create and update
 S X=AMHIDAT,DIC(0)="L",DIC="^AMHRINTK(",DLAYGO=9002011.13,DIADD=1,DIC("DR")=".02////"_AMHPAT_";.05///"_AMHPROGT_";.07////"_DT_";.09///I;.13////"_DUZ
 K DD,D0,DO
 D FILE^DICN
 K DIC,DLAYGO,DIADD
 I Y=-1 W !!,"error creating Initial Intake document...." D PAUSE^AMHLEA,EXIT Q
 S AMHRINTI=+Y
 ;update 11 multiple and .07
 S AMHPROVN=$S($G(AMHR):$$PRIMPROV^AMHUTIL(AMHR,"N"),1:$P(^VA(200,DUZ,0),U,1))
 S DA=AMHRINTI,DIE="^AMHRINTK(",DR=".01;.05;.04//"_AMHPROVN_";.07;4100",DIE("NO^")="" D ^DIE K DIE,DA
 S DA=AMHRINTI,DIE="^AMHRINTK(",DR=".06////"_DUZ_";.13////"_DUZ,DIE("NO^")="" D ^DIE K DA,DIE,DR
 W !!,"Initial Intake document created..." D SIGNINT(AMHRINTI)
 D PAUSE^AMHLEA
 D EXIT
 Q
SIGNINT(AMHRX) ;sign intake
SIGNINT1 K AMHXX
 S AMHXX=$$ESIGINT^AMHESIG(AMHRX)
 I '$G(AMHXX) D  I $P(AMHXX,U,4),AMHANS G SIGNINT1
 .W !!,$P(AMHXX,U,3),!
 .I '$P(AMHXX,U,4) Q
 .S DIR(0)="Y",DIR("A")="Do you wish to enter an Intake Narrative",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .S AMHANS=Y Q:'Y
 .S DIE="^AMHRINTK(",DR=4100,DA=AMHRX D ^DIE K DA,DIE,DR
 I AMHXX D ESIGGFII^AMHESIG(AMHRX)
 Q
 ;
ALLOWINT(P,I) ;EP
 ;P - DUZ, user internal entry number
 ;I - intake ien
 I '$G(P) Q 0
 I '$G(I) Q 0
 NEW R,G
 I $D(^AMHSITE(DUZ(2),16,P)) Q 1  ;allow all with access
 I $P(^AMHRINTK(I,0),U,4)=P Q 1
 I $P(^AMHRINTK(I,0),U,6)=P Q 1
 I $P(^AMHRINTK(I,0),U,13)=P Q 1
 I $P(^AMHRINTK(I,0),U,4)="" Q 1
 S R=0,G=0 F  S R=$O(^AMHRINTK("AI",I,R)) Q:R'=+R  D
 .I $P(^AMHRINTK(R,0),U,4)=P S G=1
 .I $P(^AMHRINTK(R,0),U,6)=P S G=1
 .I $P(^AMHRINTK(R,0),U,13)=P S G=1
 Q G
EDIT ;
 S AMHRINTI=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S AMHR1=$O(VALMY(0)) I 'AMHR1 K AMHR1,VALMY,XQORNOD W !,"No record selected." G EXIT
 S (X,Y)=0 F  S X=$O(AMHINTK("IDX",X)) Q:X'=+X!(AMHRINTI)  I $O(AMHINTK("IDX",X,0))=AMHR1 S Y=$O(AMHINTK("IDX",X,0)),AMHRINTI=AMHINTK("IDX",X,Y)
 I '$D(^AMHRINTK(AMHRINTI,0)) W !,"Not a valid BH INTAKE." D PAUSE^AMHLEA D EXIT Q
 I $P(^AMHRINTK(AMHRINTI,0),U,9)'="I" W !!,"This is not an Initial Intake.  Use option U to edit an Update to",!,"an Intake document." D PAUSE^AMHLEA,EXIT Q
 D FULL^VALM1
 I $P(^AMHRINTK(AMHRINTI,0),U,11) W !!,"This Initial Intake document has been signed.  You cannot edit it." D PAUSE^AMHLEA,EXIT Q
 ;I $P(^AMHRINTK(AMHRINTI,0),U,3)'=AMHR D  Q
 ;.W !!,"This Intake is not associated with the visit your are currently processing.",!,"To edit this Intake document you must use Edit Visit and edit the visit",!,"on "_$$VAL^XBDIQ1(9002011.13,AMHRINTI,.03),"." D PAUSE^AMHLEA,EXIT Q
 I $$VALI^XBDIQ1(9002011.13,AMHRINTI,.04)'=DUZ&(DUZ'=$$VALI^XBDIQ1(9002011.13,AMHRINTI,.13))&(DUZ'=$$VALI^XBDIQ1(9002011.13,AMHRINTI,.06)) D  D PAUSE^AMHLEA,EXIT Q
 .W !,"You are not the original provider or the person who entered or ",!,"modified this document.  You cannot edit it."
 S DA=AMHRINTI,DIE="^AMHRINTK(",DR=".01"_$S('$O(^AMHRINTK("AI",AMHRINTI,0)):";.05",1:"")_";.04;.06////^S X=DUZ;.07//^S X=DT"_";4100" D ^DIE K DIE,DR,DA
 ;I '$O(^AMHRINTK("AI",AMHRINTI,0)) S DIE="^AMHRINTK(",DA=AMHRINTI,DR=".05" D ^DIE K DIE,DA,DR
 ;S DIE="^AMHRINTK(",DA=AMHRINTI,DR=".04;.06////^S X=DUZ;.07//^S X=DT"_";4100" D ^DIE K DIE,DR,DA
 ;set visit multiple, .07
 ;S DA=AMHRINTI,DIE="^AMHRINTK(",DR=".07////"_DT,DIE("NO^")="" D ^DIE K DIE,DA,DR
 ;S DA=AMHRINTI,DIE="^AMHRINTK(",DR=4100,DIE("NO^")="" D ^DIE
 W !!,"Initial Intake document updated...." D SIGNINT(AMHRINTI),PAUSE^AMHLEA
 D EXIT
 Q
PRINT ;
 S AMHRINTI=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S AMHR1=$O(VALMY(0)) I 'AMHR1 K AMHR1,VALMY,XQORNOD W !,"No record selected." G EXIT
 S (X,Y)=0 F  S X=$O(AMHINTK("IDX",X)) Q:X'=+X!(AMHRINTI)  I $O(AMHINTK("IDX",X,0))=AMHR1 S Y=$O(AMHINTK("IDX",X,0)),AMHRINTI=AMHINTK("IDX",X,Y)
 I '$D(^AMHRINTK(AMHRINTI,0)) W !,"Not a valid BH INTAKE." D PAUSE^AMHLEA D EXIT Q
 D FULL^VALM1
 D PRINT^AMHLEIV3
 D PAUSE^AMHLEA
 D EXIT
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP -- exit code
 K AMHX,AMHINTK,AMHPC,AMHR1
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=AMHLINE
 D HDR
 K X,Y,Z,I
 Q
 ;
EXPND ; -- expand code
 Q
 ;
DEL ;EP - called from protocol entry
 NEW AMHY,AMHRINTI,AMHX,AMHZ,AMHC,AMHC1,AMHRINT,AMHRIU
 D FULL^VALM1
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)),'$D(^AMHSITE(DUZ(2),21,"B",DUZ)) W !!,"You do not have the security access to delete an Intake document.",!,"Please see your supervisor or program manager.",! D PAUSE^AMHLEA,EXIT Q
 S AMHRINTI=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S AMHR1=$O(VALMY(0)) I 'AMHR1 K AMHR1,VALMY,XQORNOD W !,"No record selected." G EXIT
 S (X,Y)=0 F  S X=$O(AMHINTK("IDX",X)) Q:X'=+X!(AMHRINTI)  I $O(AMHINTK("IDX",X,0))=AMHR1 S Y=$O(AMHINTK("IDX",X,0)),AMHRINTI=AMHINTK("IDX",X,Y)
 I '$D(^AMHRINTK(AMHRINTI,0)) W !,"Not a valid BH INTAKE." D PAUSE^AMHLEA D EXIT Q
DEL1 ;are you sure??
 K AMHY
 I '$D(^AMHRINTK(AMHRINTI)) D EXIT Q
 S AMHY(1)=AMHRINTI,AMHC=1
 S AMHX=0 F  S AMHX=$O(^AMHRINTK("AI",AMHRINTI,AMHX)) Q:AMHX'=+AMHX  S AMHC=AMHC+1,AMHY(AMHC)=AMHX
 W !!,"You can now select which Intake or Update document to delete.  Initial Intake ",!,"documents that have Updates associated with them cannot be deleted.",!
 W !?5,"0",?10,"Quit/Exit"
 S X=0,AMHC=0 F  S AMHC=$O(AMHY(AMHC)) Q:AMHC'=+AMHC  S AMHX=AMHY(AMHC) D
 .S AMHINTR=$P(^AMHRINTK(AMHX,0),U,3)
 .S AMHC1=AMHC W !?5,AMHC,?10,"Date: ",$$D($$VALI^XBDIQ1(9002011.13,AMHX,.01)),"  Provider: ",$E($$VAL^XBDIQ1(9002011.13,AMHX,.04),1,15),?51,$E($$VAL^XBDIQ1(9002011.13,AMHX,.05),1,13),?65,$$VAL^XBDIQ1(9002011.13,AMHX,.09)
 W !
 S DIR(0)="N^0:"_AMHC1_":0",DIR("A")="Select Action",DIR("B")="0" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y=0 D EXIT Q
 S AMHRINT=AMHY(Y)
 S AMHRIU=$P(^AMHRINTK(AMHRINT,0),U,9)
 I $D(^AMHSITE(DUZ(2),21,"B",DUZ)) G DISP
 I $P(^AMHRINTK(AMHRINT,0),U,4)'=DUZ&(DUZ'=$P(^AMHRINTK(AMHRINT,0),U,13))&(DUZ'=$P(^AMHRINTK(AMHRINT,0),U,6)) D  D PAUSE^AMHLEA G DEL1
 .W !!,"You are not the provider or the person who entered this "_$S(AMHRIU="I":"Initial Intake",1:"Update"),!,"document, you cannot delete it."
 I $P(^AMHRINTK(AMHRINT,0),U,11),'$D(^XUSEC("AMHZ DELETE SIGNED NOTE",DUZ)) D  G DEL1
 .W !!,"You cannot delete this "_$S(AMHRIU="I":"Initial Intake",1:"Update")_" document, it has been electronically signed.",!,"Please see your supervisor or program manager." D PAUSE^AMHLEA Q
DISP ;
 I $P(^AMHRINTK(AMHRINT,0),U,9)="I",$D(^AMHRINTK("AI",AMHRINT)) W !!,"This Initial Intake has Updates associated with it, it cannot be deleted." D PAUSE^AMHLEA G DEL1
 S DA=AMHRINT,DIC="^AMHRINTK(" D EN^DIQ
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this "_$S(AMHRIU="I":"Initial Intake",1:"Update")_" document",DIR("B")="N" KILL DA D ^DIR KILL DIR  ;LORI
 I 'Y W !!,$S(AMHRIU="I":"Initial Intake",1:"Update")_" document not deleted." D PAUSE^AMHLEA G DEL1
 S DA=AMHRINT,DIK="^AMHRINTK(" D ^DIK
 K DA,DIK
 ;
 W !!,$S(AMHRIU="I":"Initial Intake",1:"Update")_" document deleted." D PAUSE^AMHLEA
 G DEL1
 Q
UPD ;
 NEW AMHR1,X,AMHRINTI,AMHX,AMHY,AMHC,AMHA,AMHRINTU
 S AMHRINTI=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G EXIT
 S AMHR1=$O(VALMY(0)) I 'AMHR1 K AMHR1,VALMY,XQORNOD W !,"No record selected." G EXIT
 S (X,Y)=0 F  S X=$O(AMHINTK("IDX",X)) Q:X'=+X!(AMHRINTI)  I $O(AMHINTK("IDX",X,0))=AMHR1 S Y=$O(AMHINTK("IDX",X,0)),AMHRINTI=AMHINTK("IDX",X,Y)
 I '$D(^AMHRINTK(AMHRINTI,0)) W !,"Not a valid BH INTAKE." D PAUSE^AMHLEA D EXIT Q
 ;I $P(^AMHRINTK(AMHRINTI,0),U,9)'="I" W !!,"This is not an Initial Intake.  Use option U to edit an update to",!,"an intake document." D PAUSE^AMHLEA,EXIT Q
 D FULL^VALM1
 ;I $P(^AMHRINTK(AMHRINTI,0),U,11) W !!,"This intake document has been signed.  You cannot edit it." D PAUSE^AMHLEA,EXIT Q
 ;display all updates for this initial intake
UPD1 ;
 K AMHY
 S AMHC=0,AMHX=0 F  S AMHX=$O(^AMHRINTK("AI",AMHRINTI,AMHX)) Q:AMHX'=+AMHX  S AMHC=AMHC+1,AMHY(AMHC)=AMHX
 S AMHA=AMHC+1
 W !!,"You can either add a new Update to this Intake document or edit an "
 W !,"existing, unsigned one on which you are the provider.  Please select an Update"
 W !,"to edit or choose ",AMHA," to add a new one or 0 to quit.",!
 W !?5,"0",?10,"Quit/Exit Update"
 S X=0,AMHC=0 F  S AMHC=$O(AMHY(AMHC)) Q:AMHC'=+AMHC  S AMHX=AMHY(AMHC) D
 .;S AMHINTR=$P(^AMHRINTK(AMHX,0),U,3)
 .W !?5,AMHC,?10,"Date Updated: ",$$D($$VALI^XBDIQ1(9002011.13,AMHX,.01)),"   Provider: ",$E($$VAL^XBDIQ1(9002011.13,AMHX,.04),1,20),?66,$E($$VAL^XBDIQ1(9002011.13,AMHX,.05),1,13)
 W !?5,AMHA,?10,"Add new Update document",!
 S DIR(0)="N^0:"_AMHA_":0",DIR("A")="Select Action",DIR("B")="0" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I Y=AMHA D ADDUPD,PAUSE^AMHLEA G UPD1
 I Y=0 D EXIT Q
 S AMHRINTU=AMHY(Y)
UPDE ;
 I $P(^AMHRINTK(AMHRINTU,0),U,11) W !!,"This Intake Update document has been signed.  You cannot edit it." D PAUSE^AMHLEA G UPD1
 ;I $P(^AMHRINTK(AMHRINTI,0),U,3)'=AMHR D  Q
 ;.W !!,"This Update document is not associated with the visit your are currently processing.",!,"To edit this Update document you must use Edit Visit and edit the visit",!,"on "_$$VAL^XBDIQ1(9002011.13,AMHRINTI,.03),"." D PAUSE^AMHLEA,EXIT Q
 I $$VALI^XBDIQ1(9002011.13,AMHRINTU,.04)'=DUZ&(DUZ'=$P(^AMHRINTK(AMHRINTU,0),U,13))&(DUZ'=$$VALI^XBDIQ1(9002011.13,AMHRINTU,.06)) D  D PAUSE^AMHLEA G UPD1
 .W !,"You are not the original provider or the person who entered/edited this   ",!,"document. You cannot edit it."
 S DA=AMHRINTU,DIE="^AMHRINTK(",DR=".01;.04;.06////^S X=DUZ;.07////"_DT_";.07;4100" D ^DIE K DIE,DR,DA
 ;set visit multiple, .07
 ;S DA=AMHRINTI,DIE="^AMHRINTK(",DR=".07////"_DT,DIE("NO^")="" D ^DIE K DIE,DA,DR
 ;S DA=AMHRINTI,DIE="^AMHRINTK(",DR=4100,DIE("NO^")="" D ^DIE
 W !!,"Intake Update document updated...." D SIGNINT(AMHRINTU),PAUSE^AMHLEA G UPD1
 Q
ADDUPD ;
 D FULL^VALM1
 S AMHIDAT=""
 I $G(AMHR) S AMHIDAT=$P($P(^AMHREC(AMHR,0),U),".")
 I AMHIDAT="" S AMHIDAT=$P($G(AMHDATE),".",1)
 I AMHIDAT="" S AMHIDAT=DT
 W !,"Adding Intake Update for ",$$VAL^XBDIQ1(2,AMHPAT,.01)  ;," with a date of ",$$FMTE^XLFDT(AMHIDAT),"."
 S DIR(0)="Y",DIR("A")="Do you wish to continue on to add the Intake Update",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE^AMHLEA,EXIT Q
 I 'Y D PAUSE^AMHLEA,EXIT Q
 ;create and update
 S X=AMHIDAT,DIC(0)="L",DIC="^AMHRINTK(",DLAYGO=9002011.13,DIADD=1,DIC("DR")=".02////"_AMHPAT_";.05///"_$$VAL^XBDIQ1(9002011.13,AMHRINTI,.05)_";.07////"_DT_";.09///U;.13////"_DUZ_";.1////"_AMHRINTI
 K DD,D0,DO
 D FILE^DICN
 K DIC,DLAYGO,DIADD
 I Y=-1 W !!,"Error creating Update to the Intake document...." Q
 S AMHRINTU=+Y
 ;update 11 multiple and .07
 S AMHPROVN=$S($G(AMHR):$$PRIMPROV^AMHUTIL(AMHR,"N"),1:$P(^VA(200,DUZ,0),U,1))
 S DA=AMHRINTU,DIE="^AMHRINTK(",DR=".01;.04//"_AMHPROVN_";.07;4100",DIE("NO^")="" D ^DIE K DIE,DA
 S DA=AMHRINTU,DIE="^AMHRINTK(",DR=".06////"_DUZ,DIE("NO^")="" D ^DIE K DA,DIE,DR
 W !!,"Intake Update document created..." D SIGNINT(AMHRINTU)
 Q
