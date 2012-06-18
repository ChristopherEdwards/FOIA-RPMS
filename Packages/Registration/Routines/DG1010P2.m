DG1010P2 ;ALB/REW - PRINT 1010 CONT'D PART II ;2/29/92
 ;;5.3;Registration;;Aug 13, 1993
 ;;1
CONT ;    CONTINUES FROM DG1010P1
 K DGP,%DT,DGA,DGD2,DGNOCITY,DGX,DGTMP
 F I=.21,.211,.22,.33,.331,.34 S DGP(I)=$G(^DPT(DFN,I))
PARTII W !?50,"PART II - EMERGENCY CONTACT DATA",!,$C(13),DGLUND
GETCON ;
 K DGD
 S DGQ=1
 S DGQ(1)="1A.  FIRST NEXT OF KIN"
 S DGQ(2)="2A.  SECOND NEXT OF KIN"
 S DGQ(3)="3A.  FIRST CONTACT IN AN EMERGENCY"
 S DGQ(4)="4A.  SECOND CONTACT IN AN EMERGENCY"
 S DGQ(5)="5A.  DESIGNEE"
 FOR DGI=.21,.211,.33,.331,.34 D  S DGQ=DGQ+1
 .N DGZ4PC
 .S DGZ4PC=$P("7^3^1^4^2",U,DGQ)
 .FOR DGDPC=1,2,9,11 S:(DGDPC=1) DGBLANK=0 S DGD(DGI,DGDPC)=$$UNK^DG1010P0($P(DGP(DGI),U,DGDPC),0,DGBLANK) S:(DGDPC=1) DGBLANK=+DGUNK
 .S (DGADDR,DGDSTR)=""
 .FOR DGDPC=3,4,5 S DGD1=$P(DGP(DGI),U,DGDPC) I $L(DGD1) S DGDSTR=DGDSTR_$S(DGDPC=3:"",1:",")_DGD1
 .FOR DGDPC=6,7,8 S DGD(DGI,DGDPC)=$P(DGP(DGI),U,DGDPC)
 .S DGDSTR=$$UNK^DG1010P0(DGDSTR,0,DGBLANK)
 .S DGDCTY=$$UNK^DG1010P0(DGD(DGI,6),0,1)_$S((DGUNK=0):", ",1:"")
 .S DGDST=$$UNK^DG1010P0($P($G(^DIC(5,+DGD(DGI,7),0)),U,1),0,1)_$S((DGUNK=0):", ",1:"")
 .S DGDZIP=$$DISP^DG1010P0(DGP(.22),DGZ4PC,0,1)
 .S:DGDZIP&($L(DGDZIP>5)) DGDZIP=$E(DGDZIP,1,5)_"-"_$E(DGDZIP,6,9)
 .S DGDSL=DGDCTY_DGDST_DGDZIP
 .S DGDSUM=$L(DGDSTR)+$L(DGDSL)
 .W !,DGQ(DGQ),?35,"| ",DGQ,"B.  RELATIONSHIP",?66,"| ",DGQ,"C.  HOME TELEPHONE NUMBER",?99,"| ",DGQ,"D.  WORK TELEPHONE NUMBER"
 .W !?5,$E(DGD(DGI,1),1,30),?35,"| ",?42,$E(DGD(DGI,2),1,24),?66,"| ",?73,DGD(DGI,9),?99,"| ",?106,DGD(DGI,11)
 .W ?131,$C(13),DGLUND,!,DGQ,"E.  ADDRESS (Number, Street, City, State, ZIP Code)"
 .W !?5,DGDSTR
 .W:(DGDSUM<128) $S((DGDSUM=0):"",($L(DGDSTR)=DGDSUM):"",1:", "_DGDSL)
 .W:(DGDSUM>127) !?5,DGDSL
 .W ?131,$C(13),DGLUND
 .I DGQ=4 F I=1:1:2 W !,$P($T(DESTXT+I),";;",2)
 .I DGQ=4 W ?131,$C(13),DGLUND
 F I=1:1:5 W !,$P($T(NOTETXT+I),";;",2)
 D FOOTER
 G:$G(DGSTOP) CLEANUP^DG1010P7
 D HEADER
 G PARTIII^DG1010P3
FOOTER ;
 ;RETURNS DGSTOP=1 IF STOP CALLED FOR
 S DGPAGE=DGPAGE+1
 W !,DGLDOUBL,!,"Reg Date/Time:  ",DGAP,?52,"PRINTED: ",DGNOW,?(124-$L(DGCLK)),"Clerk: ",DGCLK
 F I=$Y:1:$S($D(IOSL):(IOSL-5),1:61) W !
 W !,"AUTOMATED VA FORM 10-10",?124,"PAGE: ",DGPAGE
 S DGSTOP=$$SUBSEQ^DGUTL
 I DGSTOP D STOPPED^DGUTL
 Q
HEADER ;
 W !,DGNAM,?115,$J(DGSS,13),!,DGLDOUBL
 Q
DESTXT ;
 ;;  I DESIGNATE THE FOLLOWING PERSON TO RECEIVE POSSESSION OF ALL PERSONAL PROPERTY LEFT ON THE PREMISES UNDER
 ;;  VA CONTROL AFTER I LEAVE SUCH PLACE OR AT TIME OF MY DEATH (This does not constitute a will or transfer of title.)
 ;;
NOTETXT ;
 ;;NOTE - The law (38 USC 8520 et seq.) provides that upon the death of any veteran receiving care or treatment by the Department of
 ;;Veterans Affairs in any institution or of a dependent or survivor of a veteran admitted to a VA medical facility leaving no
 ;;surviving spouse or next of kin or heir entitled to inherit, all personal property, including money or balances in bank, all 
 ;;claims and choses in action, owned by such person, and not disposed of by will or otherwise will become the property of the 
 ;;United States as trustee for the general Post Fund.
