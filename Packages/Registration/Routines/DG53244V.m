DG53244V ;BPOIFO/KEITH - NAME STANDARDIZATION ; 27 Jan 2002 11:05 PM
 ;;5.3;Registration;**244**;Aug 13, 1993
 ;
PRT ;Do report output
 I '$D(ZTQUEUED),$E(IOST)="C" D WAIT^DICD
 N DGOUT,DGLINE,DGTITL,DGPAGE,DGPG,DGNMSP,DGPNOW
 S DGOUT=0,DGNMSP="DPTNAME"
 D RUN^DG53244U(DGFLAG) Q:DGOUT
 D HINI D:DGFMT="D" GDETAIL D STOP Q:DGOUT
 I $E(IOST)="C" D END
 I DGFMT="D" D
 .D HDR(0) Q:DGOUT  D PARAM Q:DGOUT
 .D HDR(1) Q:DGOUT  D PDETAIL
 .Q
 Q:DGOUT
 D HDR(2),STATS(0)
 Q:DGOUT
 I $E(IOST)="C" N DIR S DIR(0)="E" W ! D ^DIR
 K DGLIM,DGFLAG,DGFMT,DGFLD,DGEXC,^TMP(DGNMSP,$J)
 Q
 ;
STATS(DGXM) ;Print statistics page
 ;Input: DGXM=number > 0 to set array for mailman--
 ;            pass by reference (optional)
 ;
 N DGI,DGY,DGX,DGFILE,DGFLD,DGET,DGPDT,DGTOT,DGSEC
 S DGXM=+$G(DGXM),(DGET,DGFILE,DGTOT,DGSEC)=0
 I DGXM D  Q:DGOUT
 .S DGX=" " D SOUT Q:DGOUT
 .S DGY="Patient Name Conversion Statistics",DGX=""
 .S $E(DGX,(80-$L(DGY)\2))=DGY D SOUT Q:DGOUT
 .S DGX=$E(DGLINE,1,80) D SOUT Q:DGOUT
 .S DGX="Field",$E(DGX,30)="Evaluated",$E(DGX,41)="Changed"
 .S $E(DGX,50)="Type 1",$E(DGX,58)="Type 2",$E(DGX,66)="Type 3"
 .S $E(DGX,74)="Type 4" D SOUT Q:DGOUT
 .S DGX=$E(DGLINE,1,80) D SOUT
 .Q
 F  S DGFILE=$O(^XTMP(DGNMSP,"STATS",DGFILE)) Q:'DGFILE!DGOUT  D
 .S DGFLD=0
 .F  S DGFLD=$O(^XTMP(DGNMSP,"STATS",DGFILE,DGFLD)) Q:'DGFLD!DGOUT  D
 ..S DGY=^XTMP(DGNMSP,"STATS",DGFILE,DGFLD),DGX=DGFILE_","_DGFLD
 ..S $E(DGX,10)=$P(DGY,U,7),$E(DGX,30)=$J(+$P(DGY,U),9,0)
 ..S $E(DGX,41)=$J(+$P(DGY,U,2),7,0),$E(DGX,50)=$J(+$P(DGY,U,3),6,0)
 ..S $E(DGX,58)=$J(+$P(DGY,U,4),6,0),$E(DGX,66)=$J(+$P(DGY,U,5),6,0)
 ..S $E(DGX,74)=$J(+$P(DGY,U,6),6,0),DGET=DGET+$P(DGY,U)
 ..D SOUT
 ..Q
 .Q
 Q:DGOUT  S DGX=$E(DGLINE,1,80)
 D SOUT Q:DGOUT
 S DGY=^XTMP(DGNMSP,"STATS")
 S DGX="REPORT TOTAL:",$E(DGX,30)=$J(DGET,9,0)
 S $E(DGX,41)=$J(+$P(DGY,U,3),7,0),$E(DGX,50)=$J(+$P(DGY,U,4),6,0)
 S $E(DGX,58)=$J(+$P(DGY,U,5),6,0),$E(DGX,66)=$J(+$P(DGY,U,6),6,0)
 S $E(DGX,74)=$J(+$P(DGY,U,7),6,0)
 D SOUT Q:DGOUT  S DGX=" " D SOUT Q:DGOUT  S DGX=""
 S $E(DGX,10)="Exception types: 1 Name value contains no comma"
 D SOUT Q:DGOUT  S DGX=""
 S $E(DGX,27)="2 Parenthetical text is removed from name"
 D SOUT Q:DGOUT  S DGX=""
 S $E(DGX,27)="3 Name value cannot be converted"
 D SOUT Q:DGOUT  S DGX=""
 S $E(DGX,27)="4 Characters are removed or changed"
 D SOUT Q:DGOUT  S DGX=" " D SOUT Q:DGOUT  S DGX=""
 S $E(DGX,24)="Total name values evaluated:  "_$J(+DGY,7,0)
 D SOUT Q:DGOUT  S DGX=""
 S $E(DGX,20)="Total patient records to change:  "_$J(+$P(DGY,U,2),7,0)
 D SOUT Q:DGOUT
 S DGPDT=$G(^XTMP(DGNMSP,0,0)) Q:'DGPDT
 S DGX=" " D SOUT S DGX="" Q:DGOUT
 S $E(DGX,12)="Name conversion processing started "_$$FMTE^XLFDT(+DGPDT)
 D SOUT S DGX="" Q:DGOUT
 I $P(DGPDT,U,2) D  Q:DGOUT
 .S $E(DGX,12)="Name conversion processing completed "_$$FMTE^XLFDT($P(DGPDT,U,2))
 .D SOUT Q
 S DGX=" " D SOUT Q:DGOUT
 S DGI=0 F  S DGI=$O(^XTMP(DGNMSP,0,DGI)) Q:'DGI!DGOUT  D
 .S DGY=^XTMP(DGNMSP,0,DGI),DGX=""
 .S $E(DGX,1)=DGI_". "_$$FMTE^XLFDT($P(DGY,U))
 .I $P(DGY,U,2) D
 ..S DGX=DGX_" to "_$$FMTE^XLFDT($P(DGY,U,2))
 ..S DGSEC=DGSEC+$$FMDIFF^XLFDT($P(DGY,U,2),$P(DGY,U),2)
 .I $P(DGY,U,4) D
 ..S DGX=DGX_", names processed: "_($P(DGY,U,4)-$P(DGY,U,3))
 ..S DGTOT=DGTOT+($P(DGY,U,4)-$P(DGY,U,3))
 ..Q
 .D SOUT
 .Q
 Q:'DGSEC!DGOUT
 S DGX=" " D SOUT Q:DGOUT
 S DGY="Processing time:  "_$$TIME(DGSEC)
 S DGX="",$E(DGX,(80-$L(DGY)\2))=DGY
 D SOUT Q:'DGTOT!DGOUT
 S DGY="Processing rate:  "_(DGTOT\(DGSEC/3600))_" name values per hour"
 S DGX="",$E(DGX,(80-$L(DGY)\2))=DGY D SOUT
 Q
 ;
SOUT ;Output statistics line
 I DGXM S DGXM=DGXM+1,DGXM(DGXM,0)=DGX Q
 D:$Y>(IOSL-3) HDR(2) Q:DGOUT  W !?26,DGX
 Q
 ;
GDETAIL ;Generate report detail global
 K ^TMP(DGNMSP,$J)
 N DGNAME,DFN,DGFILE,DGIFN,DGFIELD,DGX,DGTYPE,DGSSN
 S DGNAME=""
 F  S DGNAME=$O(^XTMP(DGNMSP,"B",DGNAME)) Q:DGNAME=""  S DFN=0 D
 .F  S DFN=$O(^XTMP(DGNMSP,"B",DGNAME,DFN)) Q:'DFN  S DGFILE=0 D
 ..S DGSSN=$P($G(^DPT(DFN,0)),U,9)
 ..F  S DGFILE=$O(^XTMP(DGNMSP,DFN,DGFILE)) Q:'DGFILE  S DGIFN=0 D
 ...F  S DGIFN=$O(^XTMP(DGNMSP,DFN,DGFILE,DGIFN)) Q:'DGIFN  D
 ....S DGFIELD=0
 ....F  S DGFIELD=$O(^XTMP(DGNMSP,DFN,DGFILE,DGIFN,DGFIELD)) Q:'DGFIELD  D
 .....Q:'$$OKFLD(DGFILE,DGFIELD)
 .....S DGX=^XTMP(DGNMSP,DFN,DGFILE,DGIFN,DGFIELD),DGTYPE=$P(DGX,U,3)
 .....Q:'$$OKTYP(DGTYPE)
 .....S ^TMP(DGNMSP,$J,DGNAME,DFN,DGFILE,DGIFN,DGFIELD)=DGSSN_U_DGX
 .....Q
 ....Q
 ...Q
 ..Q
 .Q
 Q
 ;
PDETAIL ;Print report detail
 N DGNAME,DFN,DGFILE,DGIFN,DGFIELD,DGX,DGR
 S (DGR,DGNAME)=""
 F  S DGNAME=$O(^TMP(DGNMSP,$J,DGNAME)) Q:DGNAME=""!DGOUT  S DFN=0 D
 .F  S DFN=$O(^TMP(DGNMSP,$J,DGNAME,DFN)) Q:'DFN!DGOUT  S DGFILE=0 D
 ..F  S DGFILE=$O(^TMP(DGNMSP,$J,DGNAME,DFN,DGFILE)) Q:'DGFILE!DGOUT  D
 ...S DGIFN=0
 ...F  S DGIFN=$O(^TMP(DGNMSP,$J,DGNAME,DFN,DGFILE,DGIFN)) Q:'DGIFN!DGOUT  D
 ....S DGFIELD=0
 ....F  S DGFIELD=$O(^TMP(DGNMSP,$J,DGNAME,DFN,DGFILE,DGIFN,DGFIELD)) Q:'DGFIELD!DGOUT  D
 .....S DGX=^TMP(DGNMSP,$J,DGNAME,DFN,DGFILE,DGIFN,DGFIELD)
 .....D:$Y>(IOSL-3) HDR(1) Q:DGOUT
 .....W ! I DGR'=DFN W $E(DGNAME,1,20),?22,$P(DGX,U) S DGR=DFN
 .....W ?33,$P(^XTMP(DGNMSP,"STATS",DGFILE,DGFIELD),U,7)
 .....W ?54,$P(DGX,U,2),?90,$P(DGX,U,3),?125,$$EXC($P(DGX,U,4))
 .....Q
 ....Q
 ...Q
 ..Q
 .Q
 Q
 ;
EXC(DGE) ;Format exception types with commas
 N DGI,DGX S DGX=""
 F DGI=1:1:$L(DGE) S DGX=DGX_$E(DGE,DGI)_","
 Q $E(DGX,1,($L(DGX)-1))
 ;
OKFLD(DGFILE,DGFIELD) ;Check field screen
 Q:DGFLD="A" 1
 I DGFIELD=.01 Q ($D(DGFLD(DGFIELD))&(DGFILE=2))
 I DGFILE=2.01 Q $D(DGFLD(DGFILE))
 Q:$D(DGFLD(DGFIELD)) 1
 Q:$D(DGFLD(DGFILE)) 1
 Q 0
 ;
OKTYP(DGTYPE) ;Check exception types
 N DGI,DGOK S (DGI,DGOK)=0
 F  Q:DGOK  S DGI=$O(DGEXC(DGI)) Q:'DGI  S:DGTYPE[DGI DGOK=1
 Q DGOK
 ;
PARAM N DGEND S DGEND=0
 W !!?(IOM\2-25),"The following report parameters have been selected:"
 W !!?(IOM\2-28),"Report generation action:  ",DGFLAG(DGFLAG)
 W !?(IOM\2-28),"           Report format:  ",DGFMT(DGFMT)
 W !?(IOM\2-28),"        Fields to return:" S DGEND=0
 S DGI="" F  S DGI=$O(DGFLD(DGI)) Q:DGI=""  D
 .W:DGEND ! W ?(IOM\2-1),DGFLD(DGI) S DGEND=1
 .Q
 W !?(IOM\2-28),"    Exceptions to report:" S DGEND=0
 S DGI="" F  S DGI=$O(DGEXC(DGI)) Q:DGI=""  D
 .W:DGEND ! W ?(IOM\2-1),DGEXC(DGI) S DGEND=1
 .Q
 Q
 ;
HINI ;Initialize header variables
 S DGLINE="",$P(DGLINE,"-",133)="",DGPAGE=1,DGPG=0
 S DGPNOW=$P($$FMTE^XLFDT($$NOW^XLFDT()),":",1,2)
 S DGTITL="<*>  Patient Name Standardization Report  <*>"
 Q
 ;
HDR(DGTY,DGNEG) ;Print header
 ;Input: DGTY=type of header where:
 ;            '0'=report parameters
 ;            '1'=detailed report
 ;            '2'=summary report
 ;      DGNEG='1' to indicate a negative report (optional)
 N Y
 Q:DGOUT
 I $E(IOST)="C",DGPG N DIR S DIR(0)="E" W ! D ^DIR S DGOUT=Y'=1 Q:DGOUT
 N DGX,DGP S DGP=$S($G(^XTMP("DPTNAME",0,0)):"",1:"Potential ")
 D STOP Q:DGOUT
 W:DGPG!($E(IOST)="C") $$XY(IOF,1,0)
 W:$X $$XY("",0,0)
 W DGLINE,!?(132-$L(DGTITL)\2),DGTITL
 I DGTY=0 S DGX="Report Parameters for "_DGP_"Name Conversion"
 I DGTY=1 S DGX="Detail of "_DGP_"Name Field Changes"
 I DGTY=2 S DGX="Name Field "_DGP_"Change Statistics"
 W !?(132-$L(DGX)\2),DGX
 W !,DGLINE
 W !,"Date printed: ",DGPNOW,?(126-$L(DGPAGE)),"Page: ",DGPAGE
 W !,DGLINE
 S DGPAGE=DGPAGE+1,DGPG=1
 Q:'DGTY
 D:DGTY=1
 .W !,"Patient Name",?22,"SSN",?33,"Field"
 .W ?54,"Old Name Value",?90,"New Name Value",?125,"Codes"
 .Q
 D:DGTY=2
 .W !?26,"Field",?56,"Evaluated",?67,"Changed",?76,"Type 1"
 .W ?84,"Type 2",?92,"Type 3",?100,"Type 4"
 .Q
 W !,DGLINE
 Q
 ;
STOP ;Check for stop task request
 S:$D(ZTQUEUED) (DGOUT,ZTSTOP)=$S($$S^%ZTLOAD:1,1:0) Q
 ;
XY(X,DGI,DGZ) ;Maintain $X, $Y
 ;Required input: X=screen handling variable
 ;Optional input: DGI=1 if indirection is needed
 ;Optional input: DGZ=0 if $X & $Y are to be zeroed
 N DX,DY S DX=$X,DY=$Y S:$G(DGZ)=0 (DX,DY)=0
 I $G(DGI),$L(X) W @X X ^%ZOSF("XY") Q ""
 W X X ^%ZOSF("XY")
 Q ""
 ;
TITL(DGES) ;Display report title
 ;Required input: DGES=report descriptive title
 N X,DGX
 D ENS^%ZISS S X=0 X ^%ZOSF("RM")
 I $E(IOST)'="C" W $$XY(IOF,1,0),?(IOM-$L(DGES)\2),DGES,! Q
 S:$L(DGES)#1 DGES=DGES_" " S IOTM=3,IOBM=IOSL,DGX=""
 S $P(DGX," ",(80-$L(DGES)\2+1))="",DGX=DGX_DGES_DGX
 W $$XY(IOF,1,0),$$XY(IORVON),DGX,$$XY(IORVOFF),$$XY(IOSTBM,1),!
 Q
 ;
SUBT(DGX) ;Display subtitle
 ;Required input: DGX=subtitle text
 W !!?(80-$L(DGX)\2),$$XY(IORVON),DGX,$$XY(IORVOFF)
 Q
 ;
END ;Clean up
 N X S X=IOM X ^%ZOSF("RM") D DISP0,KILL^%ZISS
 Q
 ;
DISP0 ;Return to full screen scrolling
 N DGRM,DGXY
 Q:$E(IOST)'="C"
 D ENS^%ZISS S DGRM=^%ZOSF("RM"),DGXY=^%ZOSF("XY"),(IOTM,IOBM)=0
 W $$XY(IOSTBM,1),@IOF N DX,DY,X S (DX,DY)=0 X DGXY S X=IOM X DGRM
 Q
 ;
TIME(DGX) ;Externalize run time
 ;Input: DGX=number of seconds
 ;Output: text formatted string with # days, hours, minutes and seconds
 N DGY
 S DGY("D")=DGX\86400
 S DGX=DGX#86400,DGY("H")=DGX\3600,DGX=DGX#3600
 S DGY("M")=DGX\60,DGY("S")=DGX#60
 S DGY("D")=$S('DGY("D"):"",1:DGY("D")_" day"_$S(DGY("D")=1:"",1:"s")_", ")
 S DGY("H")=DGY("H")_" hour"_$S(DGY("H")=1:"",1:"s")_", "
 S DGY("M")=DGY("M")_" minute"_$S(DGY("M")=1:"",1:"s")_", "
 S DGY("S")=DGY("S")_" second"_$S(DGY("S")=1:"",1:"s")
 Q DGY("D")_DGY("H")_DGY("M")_DGY("S")
 ;
XRARY ;Gather xref kills and sets
 N DGI,DGII,DGIEN,DGVAL,DGDATA,DGZ
 S DGI="",DGVAL(1)=2,DGZ=0
 F  S DGZ=$O(DGFIELD(DGZ)) Q:'DGZ  D
 .F  S DGI=$O(DGFIELD(DGZ,DGI)) Q:DGI=""  D
 ..S DGVAL(2)=$P(DGFIELD(DGZ,DGI),U,7)
 ..D FIND^DIC(.11,"","@;IXIE","KP",.DGVAL,"","","","","DGDATA")
 ..S DGIEN=+DGDATA("DILIST",1,0)_"," K DGDATA
 ..D GETS^DIQ(.11,DGIEN,"1.1;2.1","","DGDATA")
 ..F DGII=1.1,2.1 S DGXRARY(DGVAL(2),DGII)=DGDATA(.11,DGIEN,DGII)
 ..Q
 .Q
 Q
