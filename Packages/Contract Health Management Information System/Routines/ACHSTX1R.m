ACHSTX1R ; IHS/ITSC/PMF - REGENERATION OF EXPORT GLOBAL ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; we get here if we are REEXporting.  ask which kind they want
 S Y=$$DIR^XBDIR("S^1:Re-Export a Batch;2:Select (up to) 101 transactions","Which Re-export option","1","","Select one of the re-export options or ""^""","^D HELP^ACHSTX1R(""H"")","2")
 ;
 I $D(DUOUT)!$D(DTOUT) S STOP=1 Q
 ;
 ;now go one of two ways.  If they want to reexport a specific
 ;list of docs do that now.
 I Y=2 D SELDOC Q
 ;if not, they must want to reexport a batch
 ;
 D HDR
 S (J,ACHSEDT,ACHSBDT)=0,ACHSRR=""
 ;
 W !?10,"FACILITY NAME: ",$$LOC^ACHS
 ;
 I '$D(^ACHSTXST(DUZ(2),1,0)) S STOP=4 Q
 ;
 S ACHS("MAX")=+$P($G(^ACHSTXST(DUZ(2),1,0)),U,4),ACHS("NUM")=10
 S:ACHS("MAX")<10 ACHS("NUM")=ACHS("MAX")
 S Y=$$DIR^XBDIR("NO^1:"_ACHS("MAX"),"ENTER NUMBER OF EXPORT ENTRIES TO DISPLAY ",ACHS("NUM"),"","ENTER A NUMBER BETWEEN 1 AND "_ACHS("MAX"),"",2)
 I $D(DUOUT)!$D(DTOUT) S STOP=1 Q
 ;
 S ACHS("NUM")=+Y
L2 ;
 S (ACHSR,ACHSRR)=0,ACHSLCAT=0
 D HDR1
 F  S ACHSR=$O(^ACHSTXST("AC",DUZ(2),ACHSR)) Q:ACHSR=""  D  Q:$D(DUOUT)
 . S ACHSRR=$O(^ACHSTXST("AC",DUZ(2),ACHSR,"")) Q:ACHSRR=""
 . S ACHSLCAT=ACHSLCAT+1,X=^ACHSTXST(DUZ(2),1,ACHSRR,0),X1=$$FMTE^XLFDT($P(X,U)),X2=$$FMTE^XLFDT($P(X,U,2)),X3=$$FMTE^XLFDT($P(X,U,3)),ACHS(ACHSLCAT)=ACHSRR
 . W $J(ACHSLCAT,4),?10,X1,?25,X2,?40,X3,?55,$J($P(X,U,5),5),!
 . I ACHSLCAT+1>ACHS("NUM") Q
 . I '(ACHSLCAT#10) W:$$DIR^XBDIR("E","'^' TO STOP ") ""
 . Q
 ;
 I 'ACHSLCAT Q
 S Y=$$DIR^XBDIR("N^1:"_ACHSLCAT,"ENTER ITEM # FOR EXPORT DATE","","","","",2)
 I $D(DUOUT)!$D(DTOUT) Q
 S ACHS("REXNUM")=ACHS(+Y)
 W *7,!!!?15,"*******************NOTICE******************",!?15,"The number of records in this re-export",!?15,"might differ from the number in the original.",!?15,"*******************************************",!!
 D KILLGLBS^ACHSTX
 S ACHSBDT=$P($G(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0)),U,2)
 S ACHSBDT=ACHSBDT-1
 S ACHSEDT=$P($G(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0)),U,3)
 K ACHS("MAX"),ACHS("NUM"),ACHSLCAT,ACHSR,ACHSRR,X1,X2,X3
 G S2^ACHSTX2
 ;
HDR ;
 U IO(0)
 W @IOF,!,ACHS("*"),!?22,"GENERATE PREVIOUS CHS TRANSMISSION DATA",!,ACHS("*"),!
 Q
 ;
HDR1 ;
 W !!,"ITM #",?10,"EXPORT DATE",?25,"BEG DATE",?40,"END DATE",?55,"# RECORDS",!!
 Q
 ;
SELDOC ; Select transactions from particular documents for export.
 K ^TMP("ACHSTXAR",$J)
 N D,T
 F  D ^ACHSUD Q:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN)  D  Q:%=102
 . S T=$$SELTRANS(ACHSDIEN)
 . I $D(DUOUT)!$D(DTOUT)!'T S %=102 Q
 . I $P(T,U,2)="-" S T=$P(T,U,1) K ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0),U),ACHSDIEN,T)
 . E  S ^TMP("ACHSTXAR",$J,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0),U),ACHSDIEN,T)=""
 . S (%,X)=0
 . W !!,"The list now consists of the following transactions:"
 . F  S X=$O(^TMP("ACHSTXAR",$J,X)) Q:'X  S D=0 F  S D=$O(^TMP("ACHSTXAR",$J,X,D)) Q:'D  S T=0 F  S T=$O(^TMP("ACHSTXAR",$J,X,D,T)) Q:'T  D
 .. S %=%+1
 .. W !!,%,!!
 .. ;for test!!!!!
 .. I %>2 I %<99 S %=99
 .. W !!,%,!!
 .. ;
 .. W !,$J(%,3),".  ",$P(^ACHSF(DUZ(2),"D",D,0),U,14),"-",$$FC^ACHS(DUZ(2)),"-",$P(^ACHSF(DUZ(2),"D",D,0),U,1)
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
