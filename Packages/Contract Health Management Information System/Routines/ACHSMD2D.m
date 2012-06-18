ACHSMD2D ; IHS/ITSC/PMF - PRINT DENIAL LISTING BY PROVIDER BY DATE OF SERVICE ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;    This is a new routine to accommodate new Denial/Deferred
 ;    Services data structure at Alpha sites.
 ;
A0 ;
 S (ACHSPGNO,ACHSLC,ACHSPTOT,ACHSGTOT,ACHSTFLG,ACHSPNOT,ACHSGNOT)=0
 ;
 ; Check for Hi-vol providers.
 I '$D(^ACHSF(DUZ(2),18,"B")) W !!,*7,?5,"No High Volume Providers have been Identified for this Facility" G CANREQ
 ;
 ; Ask user select hi-vol provider.
 S Y=$$HVP^ACHSMD0
 G CANREQ:$D(DUOUT)!($D(DTOUT))
 I +Y<1 W !!,*7,"No Vendors Selected" G CANREQ
 S ACHSVPTR=+$P(Y,U),ACHSHVAB=$P(Y,U,2)
A3 ;
 D HELP(10,ACHSVPTR)
 ;S ACHSRDAT=$$DIR^XBDIR("D","Enter Beginning Date ","","","","^D HELP^ACHSMD2D(99,ACHSVPTR)",1)
 S ACHSRDAT=$$DIR^XBDIR("D^::E","Enter Beginning Date ","","","","^D HELP^ACHSMD2D(99,ACHSVPTR)",1)
 G CANREQ:$D(DTOUT)!($D(DUOUT))
 I '$D(^ACHSDEN(DUZ(2),"D","ES",ACHSRDAT)) W !!,*7,?5,"No Documents (Orders)  Available to Print on this Date" G A3
 ;S ACHSEDAT=$$DIR^XBDIR("D","Enter Ending Date ","","","","^D HELP^ACHSMD2D(99,ACHSVPTR)",1)
 S ACHSEDAT=$$DIR^XBDIR("D^::E","Enter Ending Date ","","","","^D HELP^ACHSMD2D(99,ACHSVPTR)",1)
 G CANREQ:$D(DTOUT)!($D(DUOUT))
 I $$EBB^ACHS(ACHSRDAT,ACHSEDAT) G A3
 S ACHSJDAT=$E(ACHSRDAT,2,3)_$$JDT^ACHS(ACHSRDAT,1)
TXFILE ;
 S ACHSTXF=0
 S Y=$$DIR^XBDIR("Y","Do you want generate a TX FILE for this REPORT ","N")
 I $D(DUOUT)!($D(DTOUT)) G A3
 I Y=0 G A7
 S ACHSTXF=1,X="achsm2"_ACHSHVAB_"."_ACHSJDAT
 I '$D(^AFSTXLOG(DUZ(2),1,"B",X)) G A5
 U IO(0)
 S Y=$$DIR^XBDIR("Y","A TX FILE Already Exists for this Date - Continue (Y/N) ","","","","",1)
 I $D(DUOUT)!($D(DTOUT))!(+Y=0) G TXFILE
A5 ;
 I '$L($$AOP^ACHS(2,1)) D NODIR^ACHSMD0 G CANREQ
 S ACHSZFN="achsm2"_ACHSHVAB,ACHSZOPT=1,ACHSZDIR=$$AOP^ACHS(2,1)
 D ARCHLIST^ACHSARCH
 S ACHSZFN=$$AOP^ACHS(2,1)_"achsm2"_ACHSHVAB_"."_ACHSJDAT,ACHSZIN=0
 D OPENHFS^ACHSTCK1
 S ACHSHFS1=ACHSZDEV
A7 ;
 U IO(0)
 W !
 K %ZIS
 S %ZIS="NP",%ZIS("A")="Enter Printer Output Device: "
 D ^%ZIS
 K %ZIS
 I POP G CANREQ
 S ACHSPTRN=ION
 I IOM<132 W !!,*7,"Device Right Margin < 132 Char -- Select another Device" G A7
 S ACHSPTR=IO,ACHSRDT=$$HTE^XLFDT($H)
 D CHK16^ACHSPS16
 G A0:$D(DUOUT)
 I '$D(ACHS("PRINT","ERROR")) G A7A
 G A0:$$DIR^XBDIR("E","","","","","",1),CANREQ
A7A ;
 U IO(0)
 W !!?10,"Your Request is now being Processed",!
A7B ;
 S IOP=ACHSPTRN
 D ^%ZIS
 I POP>0 U IO(0) W !!,"Device Unavailable" G CANREQ
A7C ;
 I $D(ACHS("PRINT",16)) U ACHSPTR W @ACHS("PRINT",16)
 S ACHSIODV=ACHSPTR,ACHSPASS=1
 ;
 D HDR1,HDR2
 I ACHSTXF S ACHSIODV=ACHSHFS1,ACHSPASS=2 D HDR1,HDR2 S ACHSIODV=ACHSPTR,ACHSPASS=1
 S ACHSZR=ACHSRDAT-1
B0 ;
 S ACHSZR=$O(^ACHSDEN(DUZ(2),"D","ES",ACHSZR))
 G BEND:ACHSZR=""!(ACHSZR>ACHSEDAT)
 S ACHSZRR=""
B1 ; 
 S ACHSZRR=$O(^ACHSDEN(DUZ(2),"D","ES",ACHSZR,ACHSZRR))
 G B0:ACHSZRR=""
 S X=0
 S:$D(^ACHSDEN(DUZ(2),"D",ACHSZRR,100))#2 X=$P(^ACHSDEN(DUZ(2),"D",ACHSZRR,100),U,2)
 I X=0 G B1
 I X'=ACHSVPTR G B1
 S ACHSX=$G(^ACHSDEN(DUZ(2),"D",ACHSZRR,0))
 I $E(ACHSX)="#" G B1
 G B3
 ;
B2 ;
 S ACHSPASS=2,ACHSIODV=ACHSHFS1
B3 ;
 U ACHSIODV
 S DFN=$P(ACHSX,U,7),ACHSFAC=$P(ACHSX,U,8)
 S ACHSFAC=DUZ(2)
 I +DFN=0 G B5
 W $J($$HRN^ACHS(DFN,ACHSFAC),6),?7,$E($P($G(^DPT(DFN,0)),U),1,29)
 S X=$P($G(^DPT(DFN,0)),U,3)
 W ?38,$E(X,4,5),"-",$E(X,6,7),"-",1700+$E(X,1,3),?49,$P($G(^DPT(DFN,0)),U,2),?53,$P($G(^AUTTTRI($P($G(^AUPNPAT(DFN,11)),U,8),0)),U,2)
 G B10
 ;
B5 ;
 S ACHSY=$G(^ACHSDEN(DUZ(2),"D",ACHSZRR,10)),ACHSNAME=$P(ACHSY,U)_"  "_$P(ACHSY,U,2)_", "_$P(ACHSY,U,3)_", ",X=$P(ACHSY,U,4),Y=$P($G(^DIC(5,X,0)),U,2),ACHSNAME=ACHSNAME_Y_"  "_$P(ACHSY,U,5)
 W ?7,$E(ACHSNAME,1,50)
B10 ;
 S X=$P($G(^ACHSDEN(DUZ(2),"D",ACHSZRR,400)),U,2)
 S X=$P($G(^ACHSMPRI(X,0)),U)
 ;
 W ?58,$S($L(X):$E(X,1,4),1:"??")
XXX ;
 W ?63,$P($G(^ACHSDEN(DUZ(2),"D",ACHSZRR,100)),U,10)
 ;
B11 ;
 S X=$P(^ACHSDEN(DUZ(2),"D",ACHSZRR,250),U),Y=$P($G(^ACHSDENS(X,0)),U)
 W ?66,$E(Y,1,25),?93,$J($P(ACHSX,U),14)
 S X=+$P($G(^ACHSDEN(DUZ(2),"D",ACHSZRR,100)),U,8)
 S:ACHSPASS=1 ACHSPTOT=ACHSPTOT+X,ACHSGTOT=ACHSGTOT+X
 W ?109,$J(X,10,2)
 G B25:'$D(^ACHSDEN(DUZ(2),"D",ACHSZRR,950))
 S Y="",X=0,ACHS=0
 F ACHSF=1:1 S X=$O(^ACHSDEN(DUZ(2),"D",ACHSZRR,950,X)) Q:+X=0  S Y=$G(^ACHSDEN(DUZ(2),"D",ACHSZRR,950,X,0)) I Y?6N.N1" ".1E.1E S ACHS=$L(Y) Q
 I ACHS=0 G B25
 S X=$P(Y," ",1)
 W ?121,$E(X,1,7)
 S X=$P(Y," ",2)
 W ?129,$E(X,1,2)
B25 ;
 W !
 I ACHSPASS=2 G B26
 S ACHSPNOT=ACHSPNOT+1,ACHSGNOT=ACHSGNOT+1,ACHSLC=ACHSLC+1
B26 ;
 I ACHSLC#45=0 D FTR1,FTR1A,HDR1,HDR2
 I ACHSPASS=2 S ACHSIODV=ACHSPTR G B1
 I 'ACHSTXF G B1
 S ACHSIODV=ACHSHFS1
 G B2
 ;
BEND ;
 U ACHSPTR
 D FTR1
 I ACHSTXF U ACHSHFS1 D FTR1
 S ACHSTFLG=ACHSTFLG+1
 U ACHSPTR
 D FTR1,FTR1A
 W !!
 I ACHSTXF U ACHSHFS1 D FTR1,FTR1A W !!
 I $D(ACHS("PRINT",16)) U ACHSPTR D 10^ACHSPS16
 S IO=ACHSPTR
 D ^%ZISC
 I 'ACHSTXF G EXIT
 S IO=ACHSHFS1
 D ^%ZISC
 S ACHSEXFS="achsm2"_ACHSHVAB_"."_ACHSJDAT
 D TXLOGADD^ACHSTXUT
 G EXIT:ACHSY>0
 U IO(0)
 W *7,!,"Entry NOT Successfully Posted to Data Tranmission Log - Notify Supervisor",!
 I $$DIR^XBDIR("E","Enter <RETURN> to Continue ")
 G EXIT
 ;
CANREQ ;
 W !!?20,"Request Cancelled"
 D RTRN^ACHS
EXIT ;
 D EN^XBVK("ACHS"),^ACHSVAR
 K DIR,DIC,DFN
 Q
 ;
HDR1 ; Print header.
 S:ACHSPASS=1 ACHSPGNO=ACHSPGNO+1,ACHSPTOT=0,ACHSPNOT=0
 U ACHSIODV
 W @IOF,$$C^XBFUNC("HIGH VOLUME PROVIDER DENIAL LISTING FOR: "_$$LOC^ACHS,132)
 S X="FOR PATIENTS TREATED BY: "_$P(^AUTTVNDR(ACHSVPTR,0),U)
 W !?2,ACHSRDT,?132-$L(X)/2,X,?122,"Page ",ACHSPGNO,!,$$C^XBFUNC("DATE OF SERVICE: "_$$FMTE^XLFDT(ACHSRDAT),132),!!
 Q
 ;
HDR2 ;
 U ACHSIODV
 W "IHS #",?16,"PATIENT NAME",?40,"DOB",?48,"SEX",?53,"TRB",?58,"MP",?62,"TS",?66,"REASON  FOR  DENIAL",?93,"DENIAL NUMB",?109,"EST. COST",?121,"ACCT NO",?129,"FC",!
 W "------",?7,"----------------------------",?38,"--------",?48,"---",?53,"---",?58,"--",?62,"--",?66,"-------------------------",?93,"--------------",?109,"----------",?121,"-------",?129,"--",!
 Q
 ;
FTR1 ;
 I ACHSTFLG=0 W !?40,"NO ITEMS (THIS PAGE): ",$J(ACHSPNOT,3),?69,"SUB-TOTAL (THIS PAGE) ",?104,$J(ACHSPTOT,15,2)
 I ACHSTFLG>0 W !?7,"TOTAL PAGES IN REPORT: ",$J(ACHSPGNO,3),?40,"NUMBER OF ITEMS (ALL PAGES): ",$J(ACHSGNOT,5),?77,"GRAND TOTAL (ALL PAGES) ",?104,$J(ACHSGTOT,15,2)
 Q
 ;
FTR1A ;
 W !!," Date: _____________",?25,"Authorized Facility Signature:",?60,"______________________________",!!
 ;W " Date: _____________",?25,"Ordering Official Signature:",?60,"______________________________",!!
 ;W " Date: _____________",?25,"Vendor Services Received:",?60,"______________________________",!!
 Q
 ;
HELP(Z,V) ;EP - From DIR.  Z = Number of dates to display. V = Vendor.
 N X,Y
 S X=3991231,Y=0
 W !!,"Recent MDEL dates:"
 F  S X=$O(^ACHSDEN(DUZ(2),"D","ES",X),-1) Q:'X  S Y=Y+1 Q:Y>Z  W !?20,$$FMTE^XLFDT(X) I 'Y#10 D RTRN^ACHS Q:$G(ACHSQUIT)  ; The reverse $ORDER lists as error to %INDEX.
 K ACHSQUIT
 Q
 ;
