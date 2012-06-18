ACHSRR ; IHS/ITSC/PMF - RE-PRINT CHS FORMS ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
A0 ;;                        Select;
 ;;                    1.  Reprint INDIVIDUAL Document(s);
 ;;                    ;
 ;;                    ;
 ;;                    2.  Reprint A Particular 'BATCH' of Documents;
 ;;                    ;
 ;;                    ;
 ;
 S ACHSREG=0,ACHSRPNT="",ACHSALL=1
 K ^TMP("ACHSRR",$J)
 ;
 F ACHS=1:1:6 S ACHS(ACHS)=$P($T(A0+ACHS),";",3)
 S ACHS=$P($T(A0),";",3)
 S Y=$$DIR^XBDIR("N^1:2",.ACHS,1,"","","^D HELP^ACHS(""H1"",""ACHSRR"")",2)
 I $D(DUOUT)!$D(DTOUT) D END Q
 G BATPRT:Y=2
A3 ;
 ;
 D ^ACHSUD    ;SELECT CHS DOCUMENT ACHSDIEN HOLDS IEN FOR ^ACHSF(,"D"
 ;
 I $D(DUOUT) D END Q
 G A0:('$D(ACHSDIEN))&('$D(^TMP("ACHSRR",$J)))
 ;
 ;IF DOCUMENTS TO BE PRINTED ARE IN THE TMP FILE AND NO MORE DOCS HAVE
 ;BEEN CHOSEN THEN CHOOSE A DEVICE IN B1^ACHSRP
 I ('$D(ACHSDIEN))&($D(^TMP("ACHSRR",$J))) D B1^ACHSRP D END Q
 S (T,ACHSIC)=0
 K ACHSWORK
A4 ;
 S T=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T)) G A5:+T=0,A4:$P(^(T,0),U,2)="P"
 S ACHSIC=ACHSIC+1
 I ACHSIC=1 W !!?10,"----------------------------------------------------",!?10,"TRANS",?30,"TRANS",!?11,"NUM",?19,"D A T E",?30,"TYPE",?40,"AMOUNT",!?10,"----------------------------------------------------",!!
 I ACHSIC#10=0,$$DIR^XBDIR("E","                    Enter '^' to CANCEL ","","","","",1)
 I $D(DTOUT) D END Q
 G A5:$D(DUOUT)
 S ACHSWORK(ACHSIC)=T
 ;
 W ?10,$J(ACHSIC,3)
 ;'TRANSACTION DATE'
 W ?17,$$FMTE^XLFDT($P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0)),U))
 ;'TRANSACTION TYPE'
 W ?32,$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0)),U,2)
 ;'FULL PAYMENT'
 W $P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0)),U,5)
 ;'IHS PAYMENT AMOUNT'
 W ?35,$J($FN($P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0)),U,4),",",2),11)
 ;'TRANSACTION TYPE'
 W "   <",$$EXTSET^XBFUNC(9002080.02,1,$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",T,0)),U,2)),">",!
 G A4
 ;
A5 ;
 G B:ACHSIC=1
 S ACHS("PASS")=0
 W !!?10,"Print which transaction? (1-",ACHSIC,") "
 D READ^ACHSFU
 G A7
 ;
A6 ;
 W !!?10,"Print which other transaction? (1-",ACHSIC,") "
 D READ^ACHSFU
A7 ;
 G A3:$D(DUOUT)!$D(DTOUT)!(Y=""),A8:Y?1"?".E
 S Y=+Y
 I Y<1!(Y>ACHSIC) W !?10,*7,"Invalid entry - try again." G A6:ACHS("PASS"),A5
 D B0         ;SET INTO TMP GLOBAL FOR PRINTING
 G A6
 ;
A8 ;
 W !!,"Enter the transaction number for the transaction you wish to print.",!!
 G A6
 ;
B ;
 S Y=$$DIR^XBDIR("Y","Do you wish to print this transaction","YES","","","",2)
 G A3:$D(DUOUT)!$D(DTOUT)!('Y)
 D B0          ;SET INTO TMP GLOBAL FOR PRINTING
 G A3
 ;
 ;SET INTO TMP GLOBAL FOR PRINTING
B0 ;
 S ACHSXT=ACHSWORK(Y)
 S ACHSTOS=$$DOC^ACHS(0,4)     ;'TYPE OF SERVICE'
 S ACHS("PASS")=1
 S ^TMP("ACHSRR",$J,DUZ(2),ACHSTOS,ACHSDIEN,ACHSXT)=""
 Q
 ;
BATPRT ; Batch Reprint.
 S X1=DT
 ;'P.O. BATCH PRINT RETAIN DAYS'   DEFAULT RETAIN 10 DAYS
 S X2=$S(+$P($G(^ACHSF(DUZ(2),0)),U,10):-$P($G(^(0)),U,10),1:-10)
 D C^%DTC
 S ACHSKDT=9999999-X,(R,ACHSRR)=""
B1 ;
 S R=$O(^ACHS(7,"CZ",R))
 G C1:R=""
 F ACHS=0:0 S ACHSRR=$O(^ACHS(7,"CZ",R,ACHSRR)) G B1:ACHSRR="" S ACHSXDT=9999999-$P($G(^ACHS(7,ACHSRR,0)),U,2) I ACHSXDT'<ACHSKDT D
 .;KILL OFF THE 'CHS DOCUMENT PRINTED LIST' ENTRY FOR DATES TO BE PURGED
 . K ^ACHS(7,"B",$P(^ACHS(7,ACHSRR,0),U),ACHSRR)
 .K ^ACHS(7,"CZ",ACHSXDT,ACHSRR)
 .K ^ACHS(7,ACHSRR)
 .S $P(^ACHS(7,0),U,4)=$P(^ACHS(7,0),U,4)-1   ;DECREMENT # OF ENTRIES
 ;
C1 ;
 S (R,ACHSRR)="",ACHSIC=0
 K ACHSWORK
C2 ;
 S R=$O(^ACHS(7,"CZ",R))
 G CEND:R=""
C3 ;
 S ACHSRR=$O(^ACHS(7,"CZ",R,ACHSRR))
 G C2:ACHSRR="",C3:'$D(^ACHS(7,ACHSRR,"D","B"))
 S A=""
 F ACHS=0:0 Q:$O(^ACHS(7,ACHSRR,"D","B",A))=""  S A=$O(^(A))
 S ACHSIC=ACHSIC+1
 I ACHSIC=1 W !!?10,"---------------------------------------------------------",!?10,"ITM #",?19,"D A T E",?30,"FIRST DOC #",?45,"LAST DOC #",?60,"# DOC'S",!?10,"---------------------------------------------------------",!!
 I ACHSIC#10=0 W !?20,"Enter '^' to CANCEL  " D READ^ACHSFU G CEND:$D(DUOUT)!$D(DTOUT) W !
 S ACHSWORK(ACHSIC)=ACHSRR_U_$O(^ACHS(7,ACHSRR,"D","B",""))_U_A_U_$P($G(^ACHS(7,ACHSRR,"D",0)),U,4)
 W ?10,$J(ACHSIC,3),?17,$$FMTE^XLFDT($P($G(^ACHS(7,ACHSRR,0)),U,2)),?30,$P(ACHSWORK(ACHSIC),U,2),?45,$P(ACHSWORK(ACHSIC),U,3),?61,$J($P(ACHSWORK(ACHSIC),U,4),3),!
 G C3
 ;
CEND ;
 I ACHSIC=0 W !!,"No 'Batches' on File for Reprinting ",!,"Press RETURN..." D READ^ACHSFU G ACHSRR
 W !!?10,"ENTER ITEM #  :  "
 D READ^ACHSFU
 I $D(DUOUT)!$D(DTOUT)!(Y="") D END Q
 I Y>ACHSIC!(Y<1)!('(Y?1.N))!('$D(ACHSWORK(+Y))) W "  Invalid Selection -- TRY AGAIN",*7 G CEND
 I Y?1"?".E W !!,"Enter Item Number of 'BATCH' of Documents you wish to REPRINT " G CEND
 G ACHSRR:ACHSIC=0,A0:Y=""
 S ACHSRR=+$P(ACHSWORK(Y),U)
 F R=0:0 S R=$O(^ACHS(7,ACHSRR,"D",R)) Q:'R  S ACHSXS=$P($G(^ACHS(7,ACHSRR,"D",R,0)),U,2),ACHSXD=$P($G(^(0)),U,3),ACHSXT=$P($G(^(0)),U,4),ACHSTOS=$P($G(^ACHSF(ACHSXS,"D",ACHSXD,0)),U,4),^TMP("ACHSRR",$J,ACHSXS,ACHSTOS,ACHSXD,ACHSXT)=""
 D B1^ACHSRP      ;GO BACK TO ASK FOR DEVICE
 G A0
 ;
DATES ; Select range of Dates of P.O.'s to print.
 S ACHSBDT=$$DATE^ACHS("B","P.O. print","entry")
 S ACHSEDT=$$DATE^ACHS("E","P.O. print","entry")
 Q
 ;
END ; 
 K A,DTOUT,DUOUT,R,T,X
 I $G(ACHSDUZ2) S ^TMP("ACHSDUZ2",$J)=ACHSDUZ2
 D EN^XBVK("ACHS"),^ACHSVAR
 I $G(^TMP("ACHSDUZ2",$J)) S ACHSDUZ2=$G(^TMP("ACHSDUZ2",$J)) K ^($J)
 Q
 ;
H1 ;EP - From DIR via HELP^ACHS().
 ;;@;*7
 ;;      Enter Selection 1 or 2 to Select Single or Batch Reprint
 ;;###
