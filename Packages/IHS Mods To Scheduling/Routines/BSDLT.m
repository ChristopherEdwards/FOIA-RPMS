BSDLT ;ALB/LDB - CANCELLATION LETTERS ; 14 Feb 2003 [ 03/10/2004  10:53 AM ]
 ;;5.3;PIMS;**1013**;APR 26, 2002
 ;COPY OF SDLT WITH IHS MODS
 ;;5.3;Scheduling;**185,213,281**;Aug 13, 1993
 ;IHS/ANMC/LJF 8/18/2000 changed SSN to HRCN using VA(PID)
 ;                       added customized salutation
 ;            11/24/2000 moved left margin in 5 spaces
 ;            11/29/2000 added call to print future appts
 ;             3/23/2001 changed X ^DD("FUNC",2,1) to $$TIME^BDGF
 ;            11/03/2001 used zip code instead of zip+4
 ;             6/05/2002 moved form feed to end of letter
 ;ihs/cmi/maw 05/03/2011 PATCH 1013 added storing of patient tracking on letters
 ;
 ;**************************************************************************
 ;                          MODIFICATIONS
 ;                          
 ;   DATE      PATCH     DEVELOPER  DESCRIPTION OF CHANGES
 ; --------  ----------  ---------  ----------------------------------------
 ; 02/14/03  SD*5.3*281  SAUNDERS   Print letters to confidential address if
 ;                                  requested
 ;
 ;**************************************************************************
 ;
 ;
 ;WRITE GREETING AND OPENING TEXT OF LETTER
PRT ;EP;
 ;IHS/ITSC/WAR 3/10/04 Added 'Date Printed' for Pt clarification
 ;S Y=DT D DTS^SDUTL W !,?65,Y,!,?65,"#",$$HRCN^BDGF2(+A,DUZ(2)),!!!!
 S Y=DT D DTS^SDUTL W !,?51,"Date Printed: ",Y,!,?65,"#",$$HRCN^BDGF2(+A,DUZ(2)),!!!!  ;IHS/ANMC/LJF 8/18/2000; 6/5/2002 removed form feed at front (LJF7 6/11/2002)
 I 'SDFORM W !!!!! D ADDR W !!!!
W1 ;
 W !?5,$$GREETING^BSDU(SDLET,+A)   ;IHS/ANMC/LJF 8/18/2000
 W !! K ^UTILITY($J,"W"),DIWF,DIWR,DIWF S DIWL=6,DIWF="C70W" F Z0=0:0 S Z0=$O(^VA(407.5,SDLET,1,Z0)) Q:Z0'>0  S X=^(Z0,0) D ^DIWP  ;IHS/ANMC/LJF 11/24/2000
 ;
 D ^DIWW K ^UTILITY($J,"W")
 D STORE(+A,SDLET,DT)  ;ihs/cmi/maw store the letter and date printed
 Q
 ;
STORE(PAT,LET,D) ;-- lets store the date printed and letter for tracking
 Q:'$P($G(^BSDPAR($S($G(DIV):DIV,1:1),0)),U,28)  ;quit if the site parameter for tracking letter printing is off
 N FDA,FIENS,FERR
 S FIENS="+2,"_LET_","
 S FDA(407.51,FIENS,.01)=PAT
 S FDA(407.51,FIENS,.02)=DT
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
WRAPP ;WRITE APPOINTMENT INFORMATION
 S:$D(SC)&'$D(SDC) SDC=SC S SDCL=$P(^SC(+SDC,0),"^",1),SDCL=SDCL_" Clinic" D FORM
 S SDX1=$S($D(SDX):SDX,1:X) S:$D(SDS) S=SDS F B=3,4,5 I $P(S,"^",B)]"" S SDCL=$S(B=3:"LAB",B=4:"XRAY",1:"EKG"),SDX=$P(S,"^",B) D FORM
 S (SDX,X)=SDX1 Q
FORM ;EP;
 ;IHS/ANMC/LJF 11/24/2000;3/23/2001 see line below
 S:$D(SDX) X=SDX S SDHX=X D DW^%DTC S DOW=X,X=SDHX S SDT0=$$TIME^BDGF(X),SDDAT=$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",$E(SDHX,4,5))_" "_+$E(SDHX,6,7)_", "_(1700+$E(SDHX,1,3)) W !?9,DOW,?19,$J(SDDAT,12)
 W ?32,$J(SDT0,8)," ",SDCL ;I $D(SDLT)&($Y>(IOSL-8)) W @IOF  ;IHS/ANMC/LJF 11/24/2000
 Q
RECALL(CL,P) ;-- get recall information and clinic based on patient and clinic passed in
 N RC,CDA
 S CDA=0 F  S CDA=$O(^BSDWL("AB",P,CL,CDA)) Q:'CDA  D
 . Q:$P($G(^BSDWL(CL,1,CDA,0)),U,7)
 . S RC=$P($G(^BSDWL(CL,1,CDA,0)),U,5)
 W !!,?5,"Recall Date: "_$$FMTE^XLFDT($G(RC)),?40,"Clinic/Ward: "_$$GET1^DIQ(44,$P($G(^BSDWL(CL,0)),U),.01)
 Q
 ;
REST ;EP; WRITE THE REMAINDER OF LETTER
 I $G(S1)="C" D FUTURE^BSDLT1(+A,$G(BSDCNT)) K BSDCNT  ;IHS/ANMC/LJF 11/29/2000;9/11/2001
 I SDLET W !?12 K ^UTILITY($J,"W"),DIWL,DIWR,DIWF S DIWL=6,DIWF="C70W" F Z5=0:0 S Z5=$O(^VA(407.5,SDLET,2,Z5)) Q:Z5'>0  S X=^(Z5,0) D ^DIWP  ;IHS/ANMC/LJF 11/24/2000
 D ^DIWW K ^UTILITY($J,"W") I 'SDFORM W @IOF Q  ;IHS/ANMC/LJF 6/5/2002 form feed at end of letter (LJF7 6/11/2002)
 F I=$Y:1:IOSL-12 W !
 D ADDR  W @IOF Q   ;IHS/ANMC/LJF 6/5/2002 put form feed at end of letter (LJF7 6/11/2002)
 ;
ADDR K VAHOW S DFN=+A W !?12,$$FML^DGNFUNC(DFN) S VAHOW=2
 I $D(^DG(43,1,"BT")),'$P(^("BT"),"^",3) S VAPA("P")=""
 S X1=DT,X2=5 D C^%DTC I '$D(VAPA("P")) S (VATEST("ADD",9),VATEST("ADD",10))=X
 D ADD^VADPT
 N SDCCACT1,SDCCACT2
 S SDCCACT1=^UTILITY("VAPA",$J,12),SDCCACT2=$P($G(^UTILITY("VAPA",$J,22,2)),"^",3)
 ;if confidential address is not active for scheduling/appointment letters, print to regular address
 I ($G(SDCCACT1)=0)!($G(SDCCACT2)'="Y") D
 .F LL=1:1:4 W:^UTILITY("VAPA",$J,LL)]"" !,?12,^UTILITY("VAPA",$J,LL)
 .W:^UTILITY("VAPA",$J,4)']"" ! I ^UTILITY("VAPA",$J,5)]"" W ", ",$P(^UTILITY("VAPA",$J,5),"^",2)
 I ^UTILITY("VAPA",$J,6)]"" W "  ",^UTILITY("VAPA",$J,6)   ;IHS/ANMC/LJF 11/03/2001 zip code; not zip+4
 ;if confidential address is active for scheduling/appointment letters, print to confidential address
 I $G(SDCCACT1)=1,$G(SDCCACT2)="Y" D
 .F LL=13:1:16 W:^UTILITY("VAPA",$J,LL)]"" !,?12,^UTILITY("VAPA",$J,LL)
 .W:^UTILITY("VAPA",$J,16)']"" ! I ^UTILITY("VAPA",$J,17)]"" W ", ",$P(^UTILITY("VAPA",$J,17),"^",2)
 .I ^UTILITY("VAPA",$J,18)]"" W "  ",$P(^UTILITY("VAPA",$J,18),U,2)
 W ! D KVAR^VADPT Q
 ;
 ;
LAST4(DFN) ;Return patient "last four"
 N SDX
 S SDX=$G(^DPT(+DFN,0))
 Q $E(SDX)_$E($P(SDX,U,9),6,9)
