ACHSTXAR ; IHS/ITSC/PMF - REGENERATION OF EXPORT GLOBAL ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13,14**;JUN 11, 2001
 ;ACHS*3.1*13 6.26.2007 IHS/OIT/FCJ FIXED EXITING IF NO DOC SELECTED
 ;ACHS*3.1*14 11.5.2007 IHS/OIT/FCJ RE-EXPORT UFMS INSTEAD OF CORE RECORDS
 ;
 ;ACHS*3.1*14 11.5.2007 IHS/OIT/FCJ ADDED COMMENT AND TEST FOR EXPORT ALREADY RAN
 I $D(^ACHSTXST("C",DT,DUZ(2))) W !!,"EXPORT PROGRAM ALREADY RUN THIS DATE FOR THIS FACILITY",*7 H 2 G EXIT1
 S Y=$$DIR^XBDIR("S^1:Re-Export a Batch;2:Select (up to) 101 transactions","Which Re-export option","1","","Select one of the re-export options or ""^""","^D HELP^ACHSTXAR(""H"")","2")
 G EXIT1:$D(DUOUT)!$D(DTOUT)
 ;ACHS*3.1*13 IHS/OIT/FCJ ADDED TEST FOR ^TMP IN NXT LINE TO EXIT IF NO DOCS SELECTED ACHS*3.1*14 CHANGE RTN FR ACHSTXA1 TO ACHSTXF1
 ;I Y=2 D SELDOC G EXIT1:$D(DUOUT)!$D(DTOUT)!'$D(^TMP("ACHSTXAR",$J)),^ACHSTXA1
 I Y=2 D SELDOC G EXIT1:$D(DUOUT)!$D(DTOUT)!'$D(^TMP("ACHSTXAR",$J)) G ^ACHSTXF1:ACHSTXTY="U" G ^ACHSTXA1
 D LINES^ACHSFU,HDR
 S ACHSCHSS=""
 D ^ACHSUF
 K ACHSCHSS
 S (J,ACHSEDT,ACHSBDT)=0,ACHSRR="",ACHSF638=$$PARM^ACHS(0,8)
 F I=2:1:7 S ACHSRTYP(I)=0
 W !?10,"FACILITY NAME: ",$$LOC^ACHS
L1 ;
 I '$D(^ACHSTXST(DUZ(2),1,0)) W !!,*7,"NO DATA ON FILE FOR THIS FACILITY, JOB CANCELLED" G EXIT1
 S ACHS("MAX")=+$P($G(^ACHSTXST(DUZ(2),1,0)),U,4),ACHS("NUM")=10
 S:ACHS("MAX")<10 ACHS("NUM")=ACHS("MAX")
 S Y=$$DIR^XBDIR("NO^1:"_ACHS("MAX"),"ENTER NUMBER OF EXPORT ENTRIES TO DISPLAY ",ACHS("NUM"),"","ENTER A NUMBER BETWEEN 1 AND "_ACHS("MAX"),"",2)
 G L2:(Y=""),EXIT1:$D(DUOUT)!$D(DTOUT)
 S ACHS("NUM")=+Y
L2 ;
 S (ACHSR,ACHSRR)=0,ACHSLCAT=0
 D HDR1
L3 ;
 S ACHSR=$O(^ACHSTXST("AC",DUZ(2),ACHSR))
 G L4:ACHSR=""
 S ACHSRR=$O(^ACHSTXST("AC",DUZ(2),ACHSR,""))
 G L3:ACHSRR=""
 S ACHSLCAT=ACHSLCAT+1,X=^ACHSTXST(DUZ(2),1,ACHSRR,0),X1=$$FMTE^XLFDT($P(X,U)),X2=$$FMTE^XLFDT($P(X,U,2)),X3=$$FMTE^XLFDT($P(X,U,3)),ACHS(ACHSLCAT)=ACHSRR
 W $J(ACHSLCAT,4),?10,X1,?25,X2,?40,X3,?55,$J($P(X,U,5),5),!
 I ACHSLCAT+1>ACHS("NUM") G L4
 I '(ACHSLCAT#10) W:$$DIR^XBDIR("E","'^' TO STOP ") "" G:$D(DUOUT) L4 D HDR1
 G L3
 ;
L4 ;
 I 'ACHSLCAT G NORECDS^ACHSTX8
 S Y=$$DIR^XBDIR("N^1:"_ACHSLCAT,"ENTER ITEM # FOR EXPORT DATE","","","","",2)
 G NORECDS^ACHSTX8:$D(DUOUT)!$D(DTOUT)
 S ACHS("REXNUM")=ACHS(+Y)
 W *7,!!!?15,"*******************NOTICE******************",!?15,"The number of records in this re-export",!?15,"might differ from the number in the original.",!?15,"*******************************************",!!
 D KILLGLBS^ACHSTX
 I ACHSTXTY="U" G ^ACHSTXF1
 S ACHSBDT=$P($G(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0)),U,2)
 S ACHSBDT=ACHSBDT-1
 S ACHSEDT=$P($G(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0)),U,3)
 K ACHS("MAX"),ACHS("NUM"),ACHSLCAT,ACHSR,ACHSRR,X1,X2,X3
 G S2^ACHSTX2
 ;
HDR1 ;
 W !!,"ITM #",?10,"EXPORT DATE",?25,"BEG DATE",?40,"END DATE",?55,"# RECORDS",!!
 Q
 ;
HDR ;
 U IO(0)
 W @IOF,!,ACHS("*"),!?22,"GENERATE PREVIOUS CHS TRANSMISSION DATA",!,ACHS("*"),!
 Q
 ;
EXIT1 ;
 U IO(0)
 W !!,"JOB CANCELLED BY OPERATOR"
 D KILL^ACHSTX8
 Q
 ;
SELDOC ; Select transactions from particular documents for export.     
 K ^TMP("ACHSTXAR",$J)
 N D,T
 F  D ^ACHSUD Q:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN)  D  Q:%>101
 . S T=$$SELTRANS(ACHSDIEN)
 . I $D(DUOUT)!$D(DTOUT)!'T S %=102 Q
 . I $P(T,U,2)="-" S T=$P(T,U,1) K ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0),U),ACHSDIEN,T)
 . E  S ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0),U),ACHSDIEN,T)=""
 . ;var X is getting reset, so changing it to ACHSSDI for
 . ;Sel Doc Index    3/1/01   pmf
 . ;S (%,X)=0
 . S (%,ACHSSDI)=0
 . W !!,"The list now consists of the following transactions:"
 . ;F  S X=$O(^TMP("ACHSTXAR",$J,X)) Q:'X  S D=0 F  S D=$O(^TMP("ACHSTXAR",$J,X,D)) Q:'D  S T=0 F  S T=$O(^TMP("ACHSTXAR",$J,X,D,T)) Q:'T  D
 . F  S ACHSSDI=$O(^TMP("ACHSTXAR",$J,ACHSSDI)) Q:'ACHSSDI  S D=0 F  S D=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D)) Q:'D  S T=0 F  S T=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D,T)) Q:'T  D
 .. ;
 .. S %=%+1
 .. W !,$J(%,2),".  ",$P(^ACHSF(DUZ(2),"D",D,0),U,14),"-",$$FC^ACHS(DUZ(2)),"-",$P(^ACHSF(DUZ(2),"D",D,0),U,1)
 .. D DISTRANS(D,T)
 ..Q
 . I %=101 S %=102
 .Q
 K ACHSDIEN
 I $$DIR^XBDIR("E")
 Q
 ;
SELTRANS(D) ; Display trans of doc D, and allow selection.
 D HELP("H1")
 N C,T
 W !!?10,"----------------------------------------------------",!?10,"TRANS",?30,"TRANS",!?11,"NUM",?19,"D A T E",?30,"TYPE",?40,"AMOUNT",!?10,"----------------------------------------------------",!!
 S (C,T)=0
 F  S T=$O(^ACHSF(DUZ(2),"D",D,"T",T)) Q:+T=0  S Y=^(T,0),C=C+1,C(C)=T W !?10,$J(C,3) D DISTRANS(D,T)
 S Y=$$DIR^XBDIR("N^-"_C_":"_C,"Re-export which transaction","1","","Enter the number corresponding to the transaction you want re-exported","^D HELP^ACHSTXAR(""H1"")",2)
 Q:$D(DUOUT)!$D(DTOUT)!(Y=0) 0
 I Y<1 Q C(-1*Y)_"^-"
 Q C(Y)
 ;
DISTRANS(D,T) ; 
 S Y=^ACHSF(DUZ(2),"D",D,"T",T,0)
 W ?17,$$FMTE^XLFDT($P(Y,U,1)),?32,$P(Y,U,2),$P(Y,U,5),?35,$J($FN($P(Y,U,4),",",2),11),"   <",$$EXTSET^XBFUNC(9002080.02,1,$P(Y,U,2)),">"
 Q
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
H ;
 ;;Selection of individual documents is intended to allow the local
 ;;service unit to clear documents that are not processing at higher
 ;;levels.
 ;;
 ;;E.g., if an FI document is PEND'ing for no obligation (P259), the
 ;;S.U. may want to selectively re-export the initial obligation
 ;;transaction of the document.
 ;;
 ;;Or, if the HAS is still showing an IHS document as open after a
 ;;reasonable amount of time has lapsed, the S.U. may want to
 ;;selectively re-export the pay.
 ;;
 ;;( "ZA" and "IP" transactions are not exported. )
 ;;###
 ;
H1 ;
 ;;Enter a number corresponding to the transaction that you want to re-export.
 ;;Enter a "-" before the number to remove the transaction from the list.
 ;;###
 ;
