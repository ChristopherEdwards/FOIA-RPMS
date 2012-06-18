ACHSVLB ; IHS/ITSC/PMF - PRINT VENDOR LABELS FOR DOCUMENTS ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
A1 ;
 K ^TMP("ACHSVLB",$J)
 D DISP
 I '$D(^TMP("ACHSVLB",$J)) U IO(0) X:$D(IO("S")) ACHSPPC G END
MODE ;
 W !!?5,"Print number of copies by [S]election",!?5,"or by number of [D]ocuments to be printed?"
 S Y=$$DIR^XBDIR("FO","         [S]el or [D]ocuments  ","D","","Press RETURN for ""D"", or enter ""S""","^D HELP^ACHS(""H"",""ACHSVLB"")",2)
 G END:$D(DTOUT)!$D(DUOUT),CPY:Y="S",DOCS:Y="D"
 ;
CPY ;
 S ACHS("CPY")=$$DIR^XBDIR("N^1:5","How many copies",1)
 G END:$D(DTOUT),A1:$D(DUOUT)
 G CVT
 ;
DOCS ;
 S ACHS("DOC")=$$DIR^XBDIR("N^1:100","How many documents per vendor label",30)
 G END:$D(DTOUT),A1:$D(DUOUT)
CVT ;
 S ACHSVNDR="",ACHS=0
CVT1 ;
 S ACHSVNDR=$O(^TMP("ACHSVLB",$J,ACHSVNDR))
 G DEV:ACHSVNDR=""
 S DA=$O(^TMP("ACHSVLB",$J,ACHSVNDR,0))
 I $D(ACHS("CPY")) F ACHSX=0:1 G CVT1:ACHSX=ACHS("CPY") S ACHS=ACHS+1,^TMP("ACHSVLB",$J,ACHS)=DA
 F ACHSX=0:0 S ACHS=ACHS+1,^TMP("ACHSVLB",$J,ACHS)=DA,^TMP("ACHSVLB",$J,ACHSVNDR,DA)=$G(^TMP("ACHSVLB",$J,ACHSVNDR,DA))-ACHS("DOC") Q:^(DA)<1
 G CVT1
 ;
DEV ;
 K IOP
 S %ZIS="PO"
 D ^%ZIS,SLV^ACHSFU:$D(IO("S"))
 I POP D HOME^%ZIS G END
A2 ;
 U IO(0)
 X:$D(IO("S")) ACHSPPC
 S DIE="^ACHSF(",DA=DUZ(2),DR=".02;.03;IF X=1 S Y="""";.04"
 D ^DIE
 G:$D(Y) END
 S ACHSVS=$P(^ACHSF(DUZ(2),1),U,2),ACHSNOLA=$P(^(1),U,3),ACHSHS=$P(^(1),U,4)
 D LINES^ACHSFU
A3 ;
 G A2A:$$DIR^XBDIR("Y","Do you wish to print a TEST LABEL","N","","","",2),END:$D(DTOUT),A1:$D(DUOUT)
START ;
 S ACHSX=0
 D PRINT
END ;
 K ^TMP("ACHSVLB",$J),A,ACHS,ACHSHS,ACHSNOLA,ACHSPPC,ACHSPPO,ACHSVNDR,ACHSVS,ACHSWORK,ACHSX,B,C,D,DA,DIC,DIE,DR,J,P,R,ACHSRR,ACHSTOTL
 D ^%ZISC
 Q
 ;
A2A ; Print Test Label.
 U IO
 X:$D(IO("S")) ACHSPPO
 K ACHS("TEST")
 S A=ACHSNOLA,B=ACHSHS
A2C ;
 F ACHS=1:1:3 W !,$E(ACHS("*"),1,24) I A>1 W ?(B+1),$E(ACHS("*"),1,24) I A>2 W ?((2*B)+1),$E(ACHS("*"),1,24) I A>3 W ?((3*B)+1),$E(ACHS("*"),1,24)
 F ACHS=1:1:ACHSVS W !
 I $D(ACHS("TEST")) G A2
 S ACHS("TEST")=""
 G A2C
 ;
PRINT ; For Multiple Labels Across.
 S ACHSTOTL=0
 F ACHS("I")=1:1:ACHSNOLA S ACHSX=ACHSX+1 Q:'$D(^TMP("ACHSVLB",$J,ACHSX))  S DA=^(ACHSX) I $D(^AUTTVNDR(DA,0)),$D(^(13)) S A=^(13),ACHSTOTL=ACHSTOTL+1 D PR1
 Q:ACHSTOTL=0
 U IO
 X:$D(IO("S")) ACHSPPO
 S B=ACHSHS
 W !,A(1)
 W:ACHSTOTL>1 ?(B+1),A(2)
 W:ACHSTOTL>2 ?(2*B+1),A(3)
 W:ACHSTOTL>3 ?(3*B+1),A(4)
 W !,B(1)
 W:ACHSTOTL>1 ?(B+1),B(2)
 W:ACHSTOTL>2 ?(2*B+1),B(3)
 W:ACHSTOTL>3 ?(3*B+1),B(4)
 W !,C(1)
 W:ACHSTOTL>1 ?(B+1),C(2)
 W:ACHSTOTL>2 ?(2*B+1),C(3)
 W:ACHSTOTL>3 ?(3*B+1),C(4)
 W !
 F %=1:1:4 I $L($G(D(%))) W $G(D(1)) W:ACHSTOTL>1 ?(B+1),$G(D(2)) W:ACHSTOTL>2 ?(2*B+1),$G(D(3)) W:ACHSTOTL>3 ?(3*B+1),$G(D(4)) Q
 F ACHS=1:1:ACHSVS W !
 Q:+DA=0
 G PRINT
 ;
PR1 ;
 S A(ACHSTOTL)=$P(^AUTTVNDR(DA,0),U),B(ACHSTOTL)=$P(A,U),C(ACHSTOTL)=$P(A,U,2)_" "
 I +$P(A,U,3),$D(^DIC(5,+$P(A,U,3),0)) S C(ACHSTOTL)=C(ACHSTOTL)_$P(^(0),U,2)_" "
 S:A(ACHSTOTL)["," A(ACHSTOTL)=$P(A(ACHSTOTL),",",2)_" "_$P(A(ACHSTOTL),",")
 S A(ACHSTOTL)=$E(A(ACHSTOTL),1,35),C(ACHSTOTL)=C(ACHSTOTL)_$P(A,U,4)
 S D(ACHSTOTL)=""
 I $L($P(A,U,5)) S D(ACHSTOTL)=C(ACHSTOTL),C(ACHSTOTL)=B(ACHSTOTL),B(ACHSTOTL)="Attn: "_$E($P(A,U,5),1,20)
 Q
 ;
DISP ; Display Batches for Printing of Labels.
 S (R,ACHSRR)="",ACHS=0
 K ACHSWORK
DIS1 ;
 S R=$O(^ACHS(7,"CZ",R))
 G CEND:'R
DIS2 ;
 S ACHSRR=$O(^ACHS(7,"CZ",R,ACHSRR))
 G DIS1:'ACHSRR,DIS2:'$D(^ACHS(7,ACHSRR,"D","B"))
 S A=""
 F ACHSI=0:0 Q:$O(^ACHS(7,ACHSRR,"D","B",A))=""  S A=$O(^(A))
 S ACHS=ACHS+1
 I ACHS=1 W !!?10,"---------------------------------------------------------",!?10,"ITM #",?19,"D A T E",?30,"FIRST DOC #",?45,"LAST DOC #",?60,"# DOC'S",!?10,"---------------------------------------------------------",!!
 I ACHS#10=0 W:$$DIR^XBDIR("E","                    Enter '^' to CANCEL  ") ! G CEND:$D(DUOUT)
 S ACHSWORK(ACHS)=ACHSRR_U_$O(^ACHS(7,ACHSRR,"D","B",""))_U_A_U_$P(^ACHS(7,ACHSRR,"D",0),U,4)
 W ?10,$J(ACHS,3),?17,$$FMTE^XLFDT($P(^ACHS(7,ACHSRR,0),U,2)),?30,$P(ACHSWORK(ACHS),U,2),?45,$P(ACHSWORK(ACHS),U,3),?61,$J($P(ACHSWORK(ACHS),U,4),3),!
 G DIS2
 ;
CEND ;
 I ACHS=0 W !!,"No 'Batches' on File for Printing Labels.",! G SEL
 S Y=$$DIR^XBDIR("NO^1:"_ACHS,"          ENTER ITEM # ","","","Enter Item Number of 'BATCH' of Labels you wish to PRINT.","",2)
 Q:$D(DUOUT)!$D(DTOUT)
 G SEL:(Y="")
 S ACHSRR=+$P(ACHSWORK(Y),U)
D2 ;
 F R=0:0 S R=$O(^ACHS(7,ACHSRR,"D",R)) Q:'R  S DA=$P(^ACHSF($P(^ACHS(7,ACHSRR,"D",R,0),U,2),"D",$P(^ACHS(7,ACHSRR,"D",R,0),U,3),0),U,8),^TMP("ACHSVLB",$J,$P(^AUTTVNDR(DA,0),U),DA)=$S($D(^TMP("ACHSVLB",$J,$P(^AUTTVNDR(DA,0),U),DA)):^(DA)+1,1:1)
 Q
 ;
SEL ; If user did not select a batch, ask if want to select Vendor(s).
 Q:'$$DIR^XBDIR("Y","Want to select the Vendors","N","","You can select vendors from the VENDOR file from which to print labels.","",2)
 Q:$D(DUOUT)!$D(DTOUT)
 N DIC
 S DIC="^AUTTVNDR(",DIC(0)="AEFMNQ"
 F  D ^DIC Q:+Y<1  S ^TMP("ACHSVLB",$J,$P(^AUTTVNDR(+Y,0),U),+Y)=1
 Q
 ;
H ;EP - From DIR.
 ;;@;!!?10,"You can either select the number of copies of the label to print"
 ;;@;!?10,"for each vendor, or you can select the number of documents per"
 ;;@;!?10,"each label for a vendor."
 ;;###
 ;
