SDLT ;ALB/LDB - CANCELLATION LETTERS ; 14 Feb 2003 
 ;;5.3;PIMS;**1007**;FEB 27, 2007
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
 ;IHS/ITSC/LJF 10/02/2003 moved IHS mods to BSDLT; added calls here
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added modifications for item 1007.12 to put ancillary items in time order
 ;
 D PRT^BSDLT Q   ;IHS/ITSC/LJF 10/02/2003
 ;WRITE GREETING AND OPENING TEXT OF LETTER
PRT S Y=DT D DTS^SDUTL W @IOF,!,?65,Y,!,?65,$$LAST4(A),!!!!
 I 'SDFORM W !!!!! D ADDR W !!!!
W1 W !,"Dear ",$S($P(^DPT(+A,0),"^",2)="M":"Mr. ",1:"Ms. ")
 N DPTNAME
 S DPTNAME("FILE")=2,DPTNAME("FIELD")=".01",DPTNAME("IENS")=(+A)_","
 S X=$$NAMEFMT^XLFNAME(.DPTNAME,"G","M") W X,","
 ;
 W !! K ^UTILITY($J,"W"),DIWF,DIWR,DIWF S DIWL=1,DIWF="C80WN" F Z0=0:0 S Z0=$O(^VA(407.5,SDLET,1,Z0)) Q:Z0'>0  S X=^(Z0,0) D ^DIWP
 ;
 D ^DIWW K ^UTILITY($J,"W") Q
WRAPP ;WRITE APPOINTMENT INFORMATION
 S:$D(SC)&'$D(SDC) SDC=SC S SDCL=$P(^SC(+SDC,0),"^",1),SDCL=SDCL_" Clinic" D FORM
 ;cmi/anch/maw 11/11/2006 here is where we will put the date stamp in order for ancillaries item 1007.12 patch 1007
 ;first lets split the below line
 ;S SDX1=$S($D(SDX):SDX,1:X) S:$D(SDS) S=SDS F B=3,4,5 I $P(S,"^",B)]"" S SDCL=$S(B=3:"LAB",B=4:"XRAY",1:"EKG"),SDX=$P(S,"^",B) D FORM  ;cmi/anch/maw orig line item 1007.12 patch 1007
 ;cmi/anch/maw 11/11/2006 added below lines to put ancillaries in date/time order item 1007.12 patch 1007
 S SDX1=$S($D(SDX):SDX,1:X)  ;cmi/anch/maw 11/11/2006 split above line item 1007.12 patch 1007
 S:$D(SDS) S=SDS  ;cmi/anch/maw 11/11/2006 split above line item 1007.12 patch 1007
 I $G(S) D  ;cmi/anch/maw 11/11/2006 split above line item 1007.12 patch 1007
 . N BSDARY
 . F B=3,4,5 I $P(S,"^",B)]"" D
 .. S SDCL=$S(B=3:"LAB",B=4:"XRAY",1:"EKG"),SDX=$P(S,"^",B)
 .. Q:'$G(SDX)
 .. S BSDARY(SDX)=SDCL
 . N BSDLP
 . S BSDLP=0 F  S BSDLP=$O(BSDARY(BSDLP)) Q:'BSDLP  D
 .. S SDX=BSDLP,SDCL=$G(BSDARY(BSDLP))
 .. D FORM
 ;cmi/anch/maw 11/11/2006 end of modifications item 1007.12 patch 1007
 S (SDX,X)=SDX1 Q
FORM ;
 D FORM^BSDLT Q   ;IHS/ITSC/LJF 10/02/2003
 S:$D(SDX) X=SDX S SDHX=X D DW^%DTC S DOW=X,X=SDHX X ^DD("FUNC",2,1) S SDT0=X,SDDAT=$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",$E(SDHX,4,5))_" "_+$E(SDHX,6,7)_", "_(1700+$E(SDHX,1,3)) W !?4,DOW,?14,$J(SDDAT,12)
 W ?27,$J(SDT0,8)," ",SDCL I $D(SDLT)&($Y>(IOSL-8)) W @IOF
 Q
REST ;WRITE THE REMAINDER OF LETTER
 D REST^BSDLT Q   ;IHS/ITSC/LJF 10/02/2003
 I SDLET W !?12 K ^UTILITY($J,"W"),DIWL,DIWR,DIWF S DIWL=1,DIWF="C80WN" F Z5=0:0 S Z5=$O(^VA(407.5,SDLET,2,Z5)) Q:Z5'>0  S X=^(Z5,0) D ^DIWP
 D ^DIWW K ^UTILITY($J,"W") Q:'SDFORM
 F I=$Y:1:IOSL-12 W !
 D ADDR Q
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
 .I ^UTILITY("VAPA",$J,11)]"" W "  ",$P(^UTILITY("VAPA",$J,11),U,2)
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
