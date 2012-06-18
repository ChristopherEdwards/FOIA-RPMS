ACRFLM ;IHS/OIRM/DSD/THL,AEF - LIST MANAGER API'S ; [ 09/22/2005   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13,19**;NOV 05, 2001
 ;; ;
DOC ;Documentation APIs for ACRLM  Generic Display
 ;This utility uses the Veterans Administration List Manager (VALM)
 ;
 ; APIs
 ;
 ; FILE^ACRFLM("Directory","File Name")   Displays file indicated
 ;
 ; SFILE^ACRFLM                           Selection of host file
 ;                                      for display
 ;
 ; VIEWR^ACRFLM("TAG^ROUTINE","Header")   Displays printout of the
 ;                                      routine. (non - FM, using IO)
 ; VIEWD^ACRFLM("Tag^Routine","Header")   Displays printout of the
 ;                                      routine. (FM - using EN1^DIP)
 ; DIQ^ACRFLM("DIC","DA")                 Displays EN1^DIQ for the DIC,DA
 ; ARRAY^ACRFLM("array(","Header")        Displays the array(..,n,0)
 ;                                      (%RCR notation)
 ;
 ;
EN ; -- main entry point for ACR DISPLAY
 D EN^VALM("ACR DISPLAY")
 Q
 ;
HDR ; -- header code
 I ACRHDR]"" S VALMHDR(1)=ACRHDR
 Q
 ;
INIT ; -- init variables and list array
MARKERS I $G(ACRLMARK) F I=10:10 Q:'$D(@VALMAR@(I))  D
 . F J=10:10:80 D CNTRL^VALM10(I,J,1,IORVON,IORVOFF)
 K ACRLMARK
 S VALMCNT=$O(^TMP("ACRLM",$J,+$G(ACRNODE),""),-1)
 Q
 ;
HELP ; -- help code
 S X="?"
 D DISP^XQORM1
 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("ACRLM",$J,+$G(ACRNODE))
K ;
 K ACRAR,ACRDIR,ACRFL,ACRFN,ACRHDR,ACRI,ACRROU,ACRDIR
 I '$G(XQORS) D CLEAR^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
 ;
FILE(ACRDIR,ACRFN)    ;PEP pull up a file into the TMP global for display
 I '$D(ACRHDR) S ACRHDR=""
 N Y,X,I,ACRNODE
 S ACRNODE=$G(XQORS)+1
 S Y=$$OPEN^%ZISH(ACRDIR,ACRFN,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",ACRDIR,ACRFN,"'." G EFILE
 K ^TMP("ACRLM",$J,+$G(ACRNODE))
 ;THE READ STATEMENT BELOW IS A READ FROM A HOST FILE WHICH REQUIRES A
 ;DIRECT READ VS AN FM CALL
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^TMP("ACRLM",$J,+$G(ACRNODE),I,0)=X Q:$$STATUS^%ZISH=-1   ;DIRECT READ FROM UNIX FILE
 ;D ^%ZISC                                     ;ACR*2.1*13.02 IM13574
 D CLOSE^%ZISH("")                             ;ACR*2.1*13.02 IM13574
 D EN
 K ^TMP("ACRLM",$J,+$G(ACRNODE))
EFILE ;
 Q
 ;
VIEWR(ACRROU,ACRHDR)         ;PEP USING ACRROU print to a host file for viewing
 I '$D(ACRHDR) S ACRHDR=""
 U IO(0)
 ;S Y=$$PWD^%ZISH(.ACRDIR)      ;ACR*2.1*19.03 IM17636
 ;S ACRDIR=$S($G(ACRDIR(1))]"":ACRDIR(1),1:"/usr/spool/uucppublic/") ;ACR*2.1*13.06 IM14144
 S ACRDEF=$$ARMSDIR^ACRFSYS(1)  ;ACR*2.1*13.06 IM14144
 Q:ACRDEF']""                   ;ACR*2.1*13.06 IM14144
 ;S ACRDIR=$S($G(ACRDIR(1))]"":ACRDIR(1),1:ACRDEF)  ;ACR*2.1*13.06 IM14144;ACR*2.1*19.03 IM17636
 S ACRDIR=ACRDEF                ;ACR*2.1*19.03 IM17636
 ;S ACRFN="ACR"_$J              ;ACR*2.1*19.03 IM17636
 S ACRFN="ACR"_$J_".Browser"    ;ACR*2.1*19.03 IM17636
 S X=$$OPEN^%ZISH(ACRDIR,ACRFN,"W")
 I IO="" S ACRQUIT="" Q
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 U IO
 D @ACRROU
 ;D ^%ZISC                                     ;ACR*2.1*13.02 IM13574
 D CLOSE^%ZISH("")                             ;ACR*2.1*13.02 IM13574
 D HOME^%ZIS
 D FILE(ACRDIR,ACRFN)
 S X=$$DEL^%ZISH(ACRDIR,ACRFN)
 K ACRDIR,ACRFN,ACRHDR,ACRNODE,ACRDIR,ACRFN
 Q
 ;
VIEWD(ACRROU)         ;PEP ** USING ACRROU print to a host file for viewing
 U IO(0)
 ;S Y=$$PWD^%ZISH(.ACRDIR)                       ;ACR*2.1*19.03 IM17636
 ;S ACRDIR=$S($G(ACRDIR(1))]"":ACRDIR(1),1:"/usr/spool/uucppublic/") ;ACR*2.1*13.06 IM14144
 S ACRDEF=$$ARMSDIR^ACRFSYS(1)  ;ACR*2.1*13.06 IM14144
 Q:ACRDEF']""                   ;ACR*2.1*13.06 IM14144
 ;S ACRDIR=$S($G(ACRDIR(1))]"":ACRDIR(1),1:ACRDEF)  ;ACR*2.1*13.06 IM14144;ACR*2.1*19.03 IM17636
 S ACRDIR=ACRDEF                ;ACR*2.1*19.03 IM17636
 ;S ACRFN="ACR"_$J              ;ACR*2.1*19.03 IM17636
 S ACRFN="ACR"_$J_".Browser"    ;ACR*2.1*19.03 IM17636
 D DF^%ZISH(.ACRDIR)
 S X=$$OPEN^%ZISH(ACRDIR,ACRFN,"W")
 S IOP=IO_";P-DEC;"_IOM_";"_IOSL
 ;D ^%ZISC                                     ;ACR*2.1*13.02 IM13574
 D CLOSE^%ZISH("")                             ;ACR*2.1*13.02 IM13574
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 S %ZIS("IOPAR")="("""_ACRDIR_ACRFN_""":""W"")"
 D @ACRROU
 D ^%ZISC
 D HOME^%ZIS
 D FILE^ACRFLM(ACRDIR,ACRFN)
 S X=$$DEL^%ZISH(ACRDIR,ACRFN)
 K ACRDIR,ACRFN,ACRNODE,ACRDIR,ACRFN
 Q
 ;
ARRAY(ACRAR,ACRHDR)  ;PEP  Display an array that has (...,n,0) structure
 I '$D(ACRHDR) S ACRHDR=""
 N Y,X,I,ACRNODE
 S ACRNODE=$G(XQORS)+1
 K ^TMP("ACRLM",$J,ACRNODE)
 S %X=ACRAR,%Y="^TMP(""ACRLM"","_$J_","_ACRNODE_","
 D %XY^%RCR
 D EN
 K ^TMP("ACRLM",$J,+$G(ACRNODE))
 K ACRNODE,ACRDIR,ACRFN
ARRAYE ;
 Q
 ;
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 N I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
