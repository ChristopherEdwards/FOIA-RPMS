BSDX40 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;  APL - Print Appointment Letter
 ;
APL(BSDXY,BSDXAPID,LT)  ; Print Appointment Letter
 ; BSDXAPPT = Pointer to appointment in BSDX APPOINTMENT (^BSDXAPPT) file 9002018.4
 ; LT       = Letter type - "N"=No Show; "A"=Cancelled by Patient; "C"=Cancelled by Clinic
 ; Called by BSDX PRINT APPT LETTER remote procedure
 N BSDXI,BSDXNOD,BSDXTMP,DFN,IN,RES,SCLT,SDC,SDLET,SDS,SDT
 D ^XBKVAR S X="ERROR^BSDXERR",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00080ERRORID"_$C(30)
 I '+BSDXAPID D ERR^BSDXERR("Invalid Appointment ID.") Q
 I '$D(^BSDXAPPT(BSDXAPID,0)) D ERR^BSDXERR("Invalid Appointment ID.") Q
 I $G(LT)="" D ERR^BSDXERR("Invalid Letter Type.") Q
 S BSDXNOD=^BSDXAPPT(BSDXAPID,0)
 S SDT=$P(BSDXNOD,U)  ;Get appt time
 S DFN=$P(BSDXNOD,U,5)  ;Get patient pointer to VA PATIENT (^DPT) file 2
 S RES=$P(BSDXNOD,U,7) S SDC=$P(^BSDXRES(RES,0),U,4)  ;get resource and clinic
 S SDS=^DPT(DFN,"S",SDT,0)
 S SCLT=$S(LT="N":1,LT="C":3,LT="A":4,1:"2") ;get storage position of LETTER pointer
 S SDLET=$P($G(^SC(SDC,"LTR")),U,SCLT)
 I SDLET="" D ERR^BSDXERR($S(SCLT=1:"No-Show",SCLT=2:"Pre-Appointment",SCLT=3:"Clinic Cancellation",1:"Patient Cancellation")_"Letter not defined for Clinic "_$P(^SC(SDC,0),U)_".") Q
 ; data header
 S ^BSDXTMP($J,0)="T10000TEXT"_$C(30)
 ;WRITE GREETING AND OPENING TEXT OF LETTER
 S Y=$P(SDT,".")
 D DTS^SDUTL
 S BSDXTMP="Date Printed: "_Y_$C(10,13)
 S BSDXTMP=BSDXTMP_"#"_$$HRCN^BDGF2(+DFN,DUZ(2))_$C(10,13)
 F I=1:1:4 S BSDXTMP=BSDXTMP_""_$C(10,13)
 D ADDR
 F I=1:1:3 S BSDXTMP=BSDXTMP_""_$C(10,13)
W1 ;
 S BSDXTMP=BSDXTMP_$$GREETING^BSDU(SDLET,DFN)_$C(10,13)
 F I=1:1:2 S BSDXTMP=BSDXTMP_""_$C(10,13)
 ;loop and display initial section of Letter
 S IN=0 F  S IN=$O(^VA(407.5,SDLET,1,IN)) Q:IN'>0  D
 . S BSDXTMP=BSDXTMP_^VA(407.5,SDLET,1,IN,0)_$C(10,13)
 S BSDXTMP=BSDXTMP_""_$C(10,13)
 ;Display appt/clinic info
 D WRAPP
 S BSDXTMP=BSDXTMP_""_$C(10,13)
 ;loop and display final section of letter
 S IN=0 F  S IN=$O(^VA(407.5,SDLET,2,IN)) Q:IN'>0  D
 . S BSDXTMP=BSDXTMP_^VA(407.5,SDLET,2,IN,0)_$C(10,13)
 S BSDXTMP=BSDXTMP_$C(30)
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=BSDXTMP
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
WRAPP ;WRITE APPOINTMENT INFORMATION
 N SDCL,SDX,SDX1,X
 S SDX=SDT S SDCL=$P(^SC(SDC,0),U)_" Clinic" D FORM
 S SDX1=$S($D(SDT):SDT,1:X) S:$D(SDS) S=SDS F B=3,4,5 I $P(S,"^",B)]"" S SDCL=$S(B=3:"LAB",B=4:"XRAY",1:"EKG"),SDX=$P(S,"^",B) D FORM
 S (SDX,X)=SDX1 Q
FORM ;EP;
 ;IHS/ANMC/LJF 11/24/2000;3/23/2001 see line below
 N DOW,SDDAT,SDHX,SDT0
 S X=SDX
 S SDHX=X
 D DW^%DTC
 S DOW=X,X=SDHX
 S SDT0=$$TIME^BDGF(X),SDDAT=$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",$E(SDHX,4,5))_" "_+$E(SDHX,6,7)_", "_(1700+$E(SDHX,1,3))
 S BSDXTMP=BSDXTMP_DOW_"  "_$J(SDDAT,12)_"  "_$J(SDT0,8)_" "_SDCL_$C(10,13)
 Q
REST ;EP; WRITE THE REMAINDER OF LETTER
 I $G(S1)="C" D FUTURE^BSDLT1(+A,$G(BSDCNT)) K BSDCNT  ;IHS/ANMC/LJF 11/29/2000;9/11/2001
 I SDLET W !?12 K ^UTILITY($J,"W"),DIWL,DIWR,DIWF S DIWL=6,DIWF="C70W" F Z5=0:0 S Z5=$O(^VA(407.5,SDLET,2,Z5)) Q:Z5'>0  S X=^(Z5,0) D ^DIWP  ;IHS/ANMC/LJF 11/24/2000
 D ^DIWW K ^UTILITY($J,"W") I 'SDFORM W @IOF Q  ;IHS/ANMC/LJF 6/5/2002 form feed at end of letter (LJF7 6/11/2002)
 F I=$Y:1:IOSL-12 W !
 D ADDR  W @IOF Q   ;IHS/ANMC/LJF 6/5/2002 put form feed at end of letter (LJF7 6/11/2002)
 ;
ADDR K VAHOW
 S BSDXTMP=BSDXTMP_$$FML^DGNFUNC(DFN)_$C(10,13) S VAHOW=2
 I $D(^DG(43,1,"BT")),'$P(^("BT"),"^",3) S VAPA("P")=""
 S X1=$P(SDT,"."),X2=5 D C^%DTC I '$D(VAPA("P")) S (VATEST("ADD",9),VATEST("ADD",10))=X
 D ADD^VADPT
 N SDCCACT1,SDCCACT2
 S SDCCACT1=^UTILITY("VAPA",$J,12),SDCCACT2=$P($G(^UTILITY("VAPA",$J,22,2)),"^",3)
 ;if confidential address is not active for scheduling/appointment letters, print to regular address
 I ($G(SDCCACT1)=0)!($G(SDCCACT2)'="Y") D
 .F LL=1:1:3 I ^UTILITY("VAPA",$J,LL)]"" S BSDXTMP=BSDXTMP_$S(LL=1:"",1:", ")_^UTILITY("VAPA",$J,LL)
 .S BSDXTMP=BSDXTMP_$C(10,13)
 .I ^UTILITY("VAPA",$J,4)]"" S BSDXTMP=BSDXTMP_^UTILITY("VAPA",$J,4)
 .I ^UTILITY("VAPA",$J,5)]"" S BSDXTMP=BSDXTMP_", "_$P(^UTILITY("VAPA",$J,5),"^",2)
 .I ^UTILITY("VAPA",$J,6)]"" S BSDXTMP=BSDXTMP_"  "_^UTILITY("VAPA",$J,6)_$C(10,13)
 ;if confidential address is active for scheduling/appointment letters, print to confidential address
 I $G(SDCCACT1)=1,$G(SDCCACT2)="Y" D
 .F LL=13:1:16 I ^UTILITY("VAPA",$J,LL)]"" S BSDXTMP=BSDXTMP_^UTILITY("VAPA",$J,LL)_$C(10,13)
 .I ^UTILITY("VAPA",$J,16)']"" S BSDXTMP=BSDXTMP_""_$C(10,13)
 .I ^UTILITY("VAPA",$J,17)]"" S BSDXTMP=BSDXTMP_", "_$P(^UTILITY("VAPA",$J,17),"^",2)_$C(10,13)
 .I ^UTILITY("VAPA",$J,18)]"" S BSDXTMP=BSDXTMP_"  "_$P(^UTILITY("VAPA",$J,18),U,2)_$C(10,13)
 S BSDXTMP=BSDXTMP_""_$C(10,13)
 D KVAR^VADPT
 Q
 ;
LAST4(DFN) ;Return patient "last four"
 N SDX
 S SDX=$G(^DPT(+DFN,0))
 Q $E(SDX)_$E($P(SDX,U,9),6,9)
 ;
