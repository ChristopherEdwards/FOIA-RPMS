ACHSTX2R ; IHS/ITSC/PMF - EXPORT DATA.  reexport selected documents  
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;we get here if we are reexporting POs specified by the user.
 ;
 ;same initialization as exporting for the first time
 D INIT^ACHSTX11 I STOP Q
 ;
 ; Select transactions from particular documents for export.     
 KILL ^TMP("ACHSTXAR",$J)
 NEW D,T
 F  D ^ACHSUD Q:$D(DUOUT)!$D(DTOUT)!'$D(ACHSDIEN)  D SELDOC Q:%=11
 ;
 K ACHSDIEN
 I $$DIR^XBDIR("E")
 ;
 ;Now, if we have transactions, call them up one by one and
 ;examine them.  Use the same code path used for exporting
 ;for the first time.
 ;
 ;
 S ACHSDATE="" F  S ACHSDATE=$O(^TMP("ACHSTXAR",$J,ACHSDATE)) Q:ACHSDATE=""  D
 . S ACHSDIEN="" F  S ACHSDIEN=$O(^TMP("ACHSTXAR",$J,ACHSDATE,ACHSDIEN)) Q:ACHSDIEN=""  D
 .. S ACHSTY="" F  S ACHSTY=$O(^TMP("ACHSTXAR",$J,ACHSDATE,ACHSDIEN,ACHSTY)) Q:ACHSTY=""  D
 ... ;we use var DA for the next level so that it matchs what
 ... ;the main export code does
 ... S DA="" F  S DA=$O(^TMP("ACHSTXAR",$J,ACHSDATE,ACHSDIEN,ACHSTY,DA)) Q:DA=""  D
 .... S ACHSDOCN=^TMP("ACHSTXAR",$J,ACHSDATE,ACHSDIEN,ACHSTY,DA)
 .... D ^ACHSDOCR I 'OK Q
 .... D ^ACHSVNDR I 'OK Q
 .... S ACHSCTY=ACHSTY
 .... D EXTR4^ACHSTX11
 .... Q
 ... Q
 .. Q
 . Q
 Q
 ;
SELDOC ;
 ;now that we have a pointer to a document, ACHSDIEN, lets pick
 ;what transaction we want.
 ;
 S ACHSDOCR=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0))
 I ACHSDOCR="" W !!,"Invalid PO" Q
 S ACHSDOCN="0"_$P(ACHSDOCR,U,14)_ACHSFC_$E($P(ACHSDOCR,U)+100000,2,6)
 ;The SELTRANS module returns these vars set for this doc and trans:
 ;ACHSDATE       date of the transaction activity
 ;ACHSTY         transaction type
 ;T              transaction number
 ;
 S T=$$SELTRANS(ACHSDIEN)
 I $D(DUOUT)!$D(DTOUT)!'T S %=11,STOP=1 Q
 ;
 ;if they asked to remove a selection, do so
 ;else   set the transaction into the list
 I $P(T,U,2)="-" S T=$P(T,U,1) KILL ^TMP("ACHSTXAR",$J,ACHSDATE,ACHSDIEN,ACHSTY,T)
 E  S ^TMP("ACHSTXAR",$J,ACHSDATE,ACHSDIEN,ACHSTY,T)=ACHSDOCN
 S (%,ACHSSDI)=0
 ;
 W !!,"The list now consists of the following transactions:"
 F  S ACHSSDI=$O(^TMP("ACHSTXAR",$J,ACHSSDI)) Q:'ACHSSDI  S D=0 F  S D=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D)) Q:'D  D
 . S ACHSTYP="" F  S ACHSTYP=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D,ACHSTYP)) Q:ACHSTYP=""  S T=0 F  S T=$O(^TMP("ACHSTXAR",$J,ACHSSDI,D,ACHSTYP,T)) Q:'T  D
 .. S ACHSDOCN=^TMP("ACHSTXAR",$J,ACHSSDI,D,ACHSTYP,T)
 .. S %=%+1
 .. W !,$J(%,2),".  ",$P(^ACHSF(DUZ(2),"D",D,0),U,14),"-",$$FC^ACHS(DUZ(2)),"-",$P(^ACHSF(DUZ(2),"D",D,0),U,1)
 .. D DISTRANS(D,T)
 .. Q
 . Q
 ;
 I %=10 S %=11
 Q
 ;
SELTRANS(D) ; Display trans of doc D, and allow selection.
 D HELP("H1")
 NEW C,T
 W !!?10,"----------------------------------------------------",!?10,"TRANS",?30,"TRANS",!?11,"NUM",?19,"D A T E",?30,"TYPE",?40,"AMOUNT",!?10,"----------------------------------------------------",!!
 S (C,T)=0
 F  S T=$O(^ACHSF(DUZ(2),"D",D,"T",T)) Q:+T=0  S Y=^(T,0),C=C+1,C(C)=T W !?10,$J(C,3) D DISTRANS(D,T)
 ;
 S Y=$$DIR^XBDIR("N^-"_C_":"_C,"Re-export which transaction","1","","Enter the number corresponding to the transaction you want re-exported","^D HELP^ACHSTXAR(""H1"")",2)
 ;
 Q:$D(DUOUT)!$D(DTOUT)!(Y=0) 0
 I Y<1 Q C(-1*Y)_"^-"
 Q C(Y)
 ;
DISTRANS(D,T) ; 
 S Y=^ACHSF(DUZ(2),"D",D,"T",T,0)
 S ACHSDATE=$P(Y,U,1),ACHSTY=$P(Y,U,2)
 W ?17,$$FMTE^XLFDT(ACHSDATE),?32,ACHSTY,$P(Y,U,5),?35,$J($FN($P(Y,U,4),",",2),11),"   <",$$EXTSET^XBFUNC(9002080.02,1,$P(Y,U,2)),">"
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
 ;
H1 ;
 ;;Enter a number corresponding to the transaction that you want to re-export.
 ;;Enter a "-" before the number to remove the transaction from the list.
 ;;###
 ;
