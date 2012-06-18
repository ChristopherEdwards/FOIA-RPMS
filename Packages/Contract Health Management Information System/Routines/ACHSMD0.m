ACHSMD0 ; IHS/ITSC/PMF - PRINT MASTER DELIVERY ORDER LIST (1/2) ;   [ 02/19/2004  10:38 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6,8**;JUNE 11, 2001
 ;
 ; IHS/ASDST/GTH 09/08/99 Modified at the request of the Navajo Area
 ;  CHS officer to accommodate the 2-line MDOL report.
 ;ACHS*3.1*6  4/7/03 IHS/SET/FCJ CHANGED B1 TO A DO LOOP AND ADDED
 ;            SORT FOR DOS
 ;ACHS*3.1*6  6/19/03 IHS/SET/FCJ ADDED REQUEST TO PRINT BY ISSUE DATE
 ;            MODIFICATION THROUGH OUT ROUTINE AND ADDED NEW SECTIONS
 ;            AND SORTS
 ;ACHS*3.1*8 2/14/04 ITSC/SET/JVK REMOVE QUIT
 ;
A0 ;
 I '$D(^ACHSF(DUZ(2),18,"B")) W !!,*7,?5,"No High Volume Providers for this Facility" D RTRN^ACHS G CANREQ
 I '$D(^ACHSF(DUZ(2),"ES")) W !!,*7,?5,"No MDOL Documents (Orders) Have been entered." D RTRN^ACHS G CANREQ
 S (ACHSPGNO,ACHSLC,ACHSPTOT,ACHSGTOT,ACHSTFLG,ACHSPNOT,ACHSGNOT)=0
 ;
A2 ; Select HVP.
 S Y=$$HVP
 G CANREQ:$D(DUOUT)!$D(DTOUT)
 I +Y<1 W !!,*7,"No Vendor Selected" G CANREQ
 S ACHSVPTR=+$P(Y,U),ACHSHVAB=$P(Y,U,2)
 W !!
SEL W !!?20,"1) Print Report by Date of Service"
 W !?20,"2) Print Report by Date of Issue"
 S ACHSRPT=$$DIR^ACHS("N^1:2:0","Select",1,"","^D QSEL^ACHSDNS",2)
 G:ACHSRPT'?1N.2N EXIT
 ;
A3 ; Select report date.
 I ACHSRPT=1 D
 .D HELP(8,ACHSVPTR)
 .S (ACHSRDAT,ACHSEDAT)=$$DIR^XBDIR("D^::E","Enter Beginning MDOL By Date Service","","","2 ""??"" for list of dates","^D HELP^ACHSMD0(99)",1)
 I ACHSRPT=2 D
 .D HELP2(8,ACHSVPTR)
 .S (ACHSRDAT,ACHSEDAT)=$$DIR^XBDIR("D^::E","Enter Beginning MDOL By Date of Issue","","","2 ""??"" for list of dates","^D HELP2^ACHSMD0(99)",1)
 G CANREQ:$D(DTOUT)!$D(DUOUT)!'ACHSRDAT
 I ACHSRPT=1,'$D(^ACHSF(DUZ(2),"ES",ACHSRDAT)) W !!,*7,?5,"No Documents (Orders)  Available to Print on ",$$FMTE^XLFDT(ACHSRDAT) G A3
 I ACHSRPT=1 S ACHSEDAT=$$DIR^XBDIR("D^::E","Enter Ending MDOL Date",$$FMTE^XLFDT(ACHSEDAT),"","2 ""??"" for list of dates","^D HELP^ACHSMD0(99)",1)
 I ACHSRPT=2 S ACHSEDAT=$$DIR^XBDIR("D^::E","Enter Ending MDOL Date",$$FMTE^XLFDT(ACHSEDAT),"","2 ""??"" for list of dates","^D HELP2^ACHSMD0(99)",1)
 G CANREQ:$D(DTOUT)!$D(DUOUT)!'ACHSEDAT
 I $$EBB^ACHS(ACHSRDAT,ACHSEDAT) G A3
 S ACHSJDAT=$E(ACHSRDAT,2,3)_$$JDT^ACHS(ACHSRDAT,1)
 ;
A2A ; Generate transmission file Y/N.
 S ACHSTXF=$$DIR^XBDIR("Y","Do you want generate a TX FILE for this REPORT ","N","","","",1)
 I $D(DUOUT)!($D(DTOUT)) G A3
 I 'ACHSTXF G A7
 I '$L($$AOP^ACHS(2,1)) D NODIR G CANREQ
 S X="achsm0"_ACHSHVAB_"."_ACHSJDAT
 I '$D(^AFSTXLOG(DUZ(2),1,"B",X)) G A5
 I '$$DIR^XBDIR("Y","A TX FILE Already Exists for this Date - Continue (Y/N) ","","","","",1) G A2A
 I $D(DUOUT)!($D(DTOUT)) G A2A
 ;
A5 ; Open file.
 S ACHSZFN="achsm0"_ACHSHVAB,ACHSZOPT=1,ACHSZDIR=$$AOP^ACHS(2,1)
 D ARCHLIST^ACHSARCH
 S ACHSZFN=$$AOP^ACHS(2,1)_"achsm0"_ACHSHVAB_"."_ACHSJDAT
 I $$DEL^%ZISH($$AOP^ACHS(2,1),"achsm0"_ACHSHVAB_"."_ACHSJDAT)
 S ACHSZIN=0
 D OPENHFS^ACHSTCK1
 I ACHSZZA D ERROR^ACHSTCK1 G CANREQ
 S ACHSHFS1=ACHSZDEV
A7 ; Select printer.
 U IO(0)
 W !
 S %ZIS="P",%ZIS("A")="Enter Printer Output Device: "
 D ^%ZIS
 I POP G CANREQ
 I IOM<132 W !!,*7,"Device Right Margin < 132 Char -- Select another Device" G A7
 S ACHSRDT=$$HTE^XLFDT($H)
 D CHK16^ACHSPS16
 G A0:$D(DUOUT)
 I '$D(ACHS("PRINT","ERROR")) G A8
 G A0:$$DIR^XBDIR("E","","","","","",1)
 G CANREQ
 ;
A8 ;
 U IO(0)
 W !!?10,"Your Request is now being Processed",!
 I $D(ACHS("PRINT",16)) U IO W @ACHS("PRINT",16)
START ;
 K ^TMP("ACHSMD0",$J)
 S ACHSZR=ACHSRDAT-1
A9 ; $O thru Estimated Service dates.
 I ACHSRPT=1 D  G A15
 .F  S ACHSZR=$O(^ACHSF(DUZ(2),"ES",ACHSZR)) Q:ACHSZR=""!(ACHSZR>ACHSEDAT)  D
 ..S ACHSDIEN=""
 ..F  S ACHSDIEN=$O(^ACHSF(DUZ(2),"ES",ACHSZR,ACHSDIEN)) Q:ACHSDIEN=""  D
 ...D A10
A9A ; $O thru Date of Issue.
 I ACHSRPT=2 D  G A15
 .F  S ACHSZR=$O(^ACHSF(DUZ(2),"TB",ACHSZR)) Q:ACHSZR=""!(ACHSZR>ACHSEDAT)  D
 ..S ACHSTYP=""
 ..F  S ACHSTYP=$O(^ACHSF(DUZ(2),"TB",ACHSZR,ACHSTYP)) Q:ACHSTYP=""  D
 ...Q:ACHSTYP'="I"
 ...S ACHSDIEN=""
 ...F  S ACHSDIEN=$O(^ACHSF(DUZ(2),"TB",ACHSZR,ACHSTYP,ACHSDIEN)) Q:ACHSDIEN=""  D A10
A10 ; $O thru document IENs.
 ;S ACHSDIEN=$O(^ACHSF(DUZ(2),"ES",ACHSZR,ACHSDIEN))
 ;G A9:ACHSDIEN=""
 S ACHSX=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0))
 Q:$P(ACHSX,U,12)=4  ; Skip canceled docs.
 ;ITSC/SET/JVK ACHS*3.1*8 2.19.04
 ;I +$P(ACHSX,U,4)=2 S ^TMP("ACHSMD0",$J,DUZ(2),"D",ACHSDIEN)="" Q
 I +$P(ACHSX,U,4)=2 S ^TMP("ACHSMD0",$J,DUZ(2),"D",ACHSDIEN)=""
 ;ACHS*3.1*6 4/7/03 IHS/SET/FCJ SORT BY DOS
 ;S ^TMP("ACHSMD0",$J,DUZ(2),$P(ACHSX,U,17),ACHSDIEN)=""
 S ^TMP("ACHSMD0",$J,DUZ(2),$P(ACHSX,U,17),ACHSZR,ACHSDIEN)=""
 ;G A10
 Q
 ;
A15 ;
 F ACHSRTYP="F","I","D" S (ACHSPGNO,ACHSPTOT,ACHSGTOT,ACHSPNOT,ACHSGNOT,ACHSLC)=0 D A18
 I $D(ACHS("PRINT",16)) U IO D 10^ACHSPS16
 D ^%ZISC
 I 'ACHSTXF G EXIT
 S IO=ACHSHFS1
 D ^%ZISC
 S ACHSEXFS="achsm0"_ACHSHVAB_"."_ACHSJDAT
 D TXLOGADD^ACHSTXUT
 G EXIT:ACHSY>0
 U IO(0)
 W *7,!,"Entry NOT Successfully Posted to Data Tranmission Log - Notify Supervisor",!
 D RTRN^ACHS
 G EXIT
 ;
CANREQ ;
 U IO(0)
 W !!?20,"Request Cancelled"
 D RTRN^ACHS
EXIT ; Kill vars, quit.
 K DIR,DIC,DFN
 D EN^XBVK("ACHS"),^ACHSVAR
 Q
 ;
HELP(Z,V) ;EP - From DIR.  Z = Number of dates to display. V = Ptr to VENDOR.
 N X,Y
 S X=3991231,Y=0
 W !!,"Recent MDOL by date of Service for ",$P(^AUTTVNDR(ACHSVPTR,0),U)," :"
 F  S X=$O(^ACHSF(DUZ(2),"ES",X),-1) Q:('X)!(Y=Z)  D
 .I $P(^ACHSF(DUZ(2),"D",$O(^ACHSF(DUZ(2),"ES",X,0)),0),U,8)=ACHSVPTR W !?20,$$FMTE^XLFDT(X) S Y=Y+1 Q:Y=Z  I 'Y#10 D RTRN^ACHS Q:$G(ACHSQUIT)  ; The reverse $ORDER lists as error to %INDEX.
 K ACHSQUIT
 Q
HELP2(Z,V) ;EP - From DIR.  Z = Number of dates to display. V = Ptr to VENDOR.
 N X,Y
 S X=3991231,Y=0,ACHSTYP=0
 W !!,"Recent MDOL by date of issue for ",$P(^AUTTVNDR(ACHSVPTR,0),U)," :"
 F  S X=$O(^ACHSF(DUZ(2),"TB",X),-1) Q:'X  F  S ACHSTYP=$O(^ACHSF(DUZ(2),"TB",X,ACHSTYP)) Q:(ACHSTYP'="I")!(Y=Z)  D  Q:Y=Z
 .I $P(^ACHSF(DUZ(2),"D",$O(^ACHSF(DUZ(2),"TB",X,ACHSTYP,0)),0),U,8)=ACHSVPTR W !?20,$$FMTE^XLFDT(X) S Y=Y+1 Q:Y=Z  I 'Y#10 D RTRN^ACHS Q:$G(ACHSQUIT)  ; The reverse $ORDER lists as error to %INDEX.
 K ACHSQUIT
 Q
 ;
NODIR ;EP - Display missing parameter message.
 U IO(0)
 W *7,!,$$C^XBFUNC("Your EOBR IMPORT DIRECTORY is not defined in your")
 W !,$$C^XBFUNC("CHS AREA OFFICE PARAMETERS file.")
 W !,$$C^XBFUNC("The directory is usually"),!,$$C^XBFUNC("/usr/ihs/reports/"),!,$$C^XBFUNC("for unix systems, and"),!,$$C^XBFUNC("C:\IMPORT\"),!,$$C^XBFUNC("for DOS systems.")
 W !!,$$C^XBFUNC("( The same directory is used for HVP files. )")
 Q
 ;
HVP() ;EP - Select HVP.
 K DUOUT,DTOUT
 S DIC="^ACHSF("_DUZ(2)_",18,",DIC(0)="QAZEM"
 D ^DIC
 Q:$D(DUOUT)!$D(DTOUT)!(+Y<1) -1
 Q Y(0)
 ;
 ;
 ; ACHSRTYP="D":"DENTAL SERVICES"
 ; ACHSRTYP="I":"AO PAYMENTS"
 ; ACHSRTYP="F":"FI PAYMENTS"
 ;
A18 ; -- Print MDOL, Dental, AO Payments, or FI Payments.
 Q:'$D(^TMP("ACHSMD0",$J,DUZ(2),ACHSRTYP))
 U IO
 D SETHDR,HDR
 I ACHSTXF=1 U ACHSHFS1 D HDR
 S ACHSZR=ACHSRDAT,ACHSDIEN=""
B0 ; Loop thru work global.
 ;ACHS*3.1*6 4/7/03 IHS/SET/FCJ CHANGED B1 TO A DO LOOP INSTEAD OF G
 ;S ACHSDIEN="" ;ACHS*3.1*6 4/7/03
B1 ;
 ;ACHS*3.1*6 4/7/03 IHS/SET/FCJ CHANGED B1 TO A DO LOOP AND ADDED SORT FOR DOS
 S ACHSDOS=""
 F  S ACHSDOS=$O(^TMP("ACHSMD0",$J,DUZ(2),ACHSRTYP,ACHSDOS)) G:ACHSDOS'?1N.N BEND D
 .S ACHSDIEN=""
 .F  S ACHSDIEN=$O(^TMP("ACHSMD0",$J,DUZ(2),ACHSRTYP,ACHSDOS,ACHSDIEN)) Q:ACHSDIEN'?1N.N  D
 ..S ACHSX=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0))
 ..Q:$P(ACHSX,U,8)'=ACHSVPTR
 ..U IO
 ..D LINE
 ..S ACHSPTOT=ACHSPTOT+ACHSCOST,ACHSGTOT=ACHSGTOT+ACHSCOST
 ..I ACHSTXF U ACHSHFS1 D LINE
 ..S ACHSPNOT=ACHSPNOT+1,ACHSGNOT=ACHSGNOT+1,ACHSLC=ACHSLC+1
 ..I ACHSLC#45=0 U IO D FTR1,FTR1A,RTRN^ACHS,SETHDR,HDR I ACHSTXF U ACHSHFS1 D FTR1,FTR1A,HDR
 ;
LINE ;
 I $P(ACHSX,U,3) W $S($P(ACHSX,U,3)=1:"** BLANKET **",1:"** SPEC TRAN **") G DOS
 ;
 W $J($P(ACHSX,U,21),6) ; HRN
 ;
 S Y=$P(ACHSX,U,22)
 D ^AUPNPAT
 ;
 W ?7,$E($P(^DPT(DFN,0),U),1,28) ; Name
 ;
 W ?34,$E(DOB,4,7),$E(DOB,1,3)+1700 ; DOB
 ;
 W ?43,SEX ; Sex
 ;
 W ?45,$P(^AUTTTRI($P(^AUPNPAT(DFN,11),U,8),0),U,2) ; Tribe code
 ;
 W ?49,SSN ; SSN
 ;
 S (X,%)=0
 ; Community, County, State
 F  S X=$O(^AUPNPAT(DFN,51,X)) Q:X=""  S %=X
 I %,$P(^AUPNPAT(DFN,51,%,0),U,3) S %=$P(^AUTTCOM($P(^AUPNPAT(DFN,51,%,0),U,3),0),U,8) W ?59,$E(%,5,7),$E(%,3,4),$E(%,1,2)
 ;
DOS ; Date Of Service - MMDDYY
 S %=$$DOC^ACHS(3,9),%=$E(%,4,7)_$E(%,2,3)
 W ?67,%
 ;
 ; P.O. #
 D FC^ACHSUF
 W ?74,$P(ACHSX,U,14)_ACHSFC_"-"_$P(ACHSX,U)
 ;
 ; Estimated cost
 S X=$P(ACHSX,U,9)
 W ?85,$J(X,10,2)
 S ACHSCOST=X
 ;
 ;
 ; Coverage (Insurance)
 W ?96,"000"
 ;
 ; Account #
 W ?100,$$DOC^ACHS(1,3)
 ;IHS/ITSC/PMF  added the condition to the next line.  Only
 ;do the other routine if this is NOT a blanket order
 I '$P(ACHSX,U,3) D EN^ACHSMD0A($$DOC^ACHS(3,9))
 W !
 Q
 ;
BEND ;
 U IO
 D FTR1
 I ACHSTXF=1 U ACHSHFS1 D FTR1
BENDA ;
 S ACHSTFLG=ACHSTFLG+1
 U IO
 D FTR1,FTR1A
 W !!
 I ACHSTXF=1 U ACHSHFS1 D FTR1,FTR1A W !!
 D RTRN^ACHS
 Q
 ;
SETHDR ;
 S ACHSPGNO=ACHSPGNO+1,ACHSPTOT=0,ACHSPNOT=0
 Q
 ;
HDR ;
 W @IOF,$$C^XBFUNC("MASTER DELIVERY ORDER LISTING FOR: "_$$LOC^ACHS,IOM),!
 I ACHSRPT=1 W $$C^XBFUNC("BY DATE OF ESTIMATED SERVICE",IOM),!
 I ACHSRPT=2 W $$C^XBFUNC("BY DATE OF ISSUE",IOM),!
 S X="FOR PATIENTS TREATED BY: "_$P(^AUTTVNDR(ACHSVPTR,0),U)
 W !?2,ACHSRDT,?IOM-$L(X)/2,X,?IOM-10,"Page ",ACHSPGNO
 S X=$S(ACHSRTYP="I":"FOR AO PAYMENT FOR SERVICES PROVIDED : ",ACHSRTYP="F":"FOR FI PAYMENT FOR SERVICES PROVIDED : ",ACHSRTYP="D":"FOR DENTAL SERVICES PROVIDED : ",1:"DATE(S) OF SERVICE: ")
 W !,$$C^XBFUNC(X_$$FMTE^XLFDT(ACHSRDAT)_" - "_$$FMTE^XLFDT(ACHSEDAT),IOM),!!
 W "IHS #",?16,"PATIENT NAME",?38,"DOB",?43,"S",?45,"TRB",?49,"SOC SEC #",?59,"COMM-CD",?67,"ESTDOS",?74,"PURCH OR #",?85,"EST. COST",?96,"COV",?100,"ACCT NO",!
 W $$R("-",6),?7,$$R("-",28),?36,$$R("-",6),?43,$$R("-",1),?45,$$R("-",3),?49,$$R("-",9),?59,$$R("-",7),?67,$$R("-",6),?74,$$R("-",10),?85,$$R("-",10),?96,$$R("-",3),?100,$$R("-",15),!
 Q
 ;
FTR1 ;
 I ACHSTFLG=0 W !?40,"NO. ITEMS (THIS PAGE): ",$J(ACHSPNOT,3),?69,"SUB-TOTAL(THIS PAGE):",?95,$J($FN(ACHSPTOT,",",2),15)
 I ACHSTFLG>0 W !?7,"TOTAL PAGES IN REPORT: ",$J(ACHSPGNO,3),?40,"NO ITEMS (ALL PAGES):",$J(ACHSGNOT,5),?69,"GRAND TOTAL(ALL PAGES):",?95,$J($FN(ACHSGTOT,",",2),15)
 Q
 ;
FTR1A ;
 W !!," Date: ",$$R("_",13),?25,"Funds Available Signature:",?60,$$R("_",30),!!
 W " Date: ",$$R("_",13),?25,"Ordering Official Signature:",?60,$$R("_",30),!!
 W " Date: ",$$R("_",13),?25,"Vendor Services Received:",?60,$$R("_",30),!!
 Q
 ;
R(X,Y) Q $$REPEAT^XLFSTR(X,Y)
 ;
