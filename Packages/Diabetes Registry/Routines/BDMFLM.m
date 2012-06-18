BDMFLM ; cmi/anch/maw - LIST MANAGER API'S ; 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;;AUG 11, 2006
 ;; ;
DOC ;Documentation APIs for BDMLM  Generic Display
 ;This utility uses the Veterans Administration List Manager (VALM)
 ;
 ; APIs
 ;
 ; FILE^BDMFLM("Directory","File Name")   Displays file indicated
 ;
 ; SFILE^BDMFLM                           Selection of host file
 ;                                      for display
 ;
 ; VIEWR^BDMFLM("TAG^ROUTINE","Header")   Displays printout of the
 ;                                      routine. (non - FM, using IO)
 ; VIEWD^BDMFLM("Tag^Routine","Header")   Displays printout of the
 ;                                      routine. (FM - using EN1^DIP)
 ; DIQ^BDMFLM("DIC","DA")                 Displays EN1^DIQ for the DIC,DA
 ; ARRAY^BDMFLM("array(","Header")        Displays the array(..,n,0)
 ;                                      (%RCR notation)
 ;
 ;
EN ; -- main entry point for BDM DISPLAY
 D EN^VALM("BDM DISPLAY")
 Q
 ;
HDR ;EP; -- header code
 I BDMHDR]"" S VALMHDR(1)=BDMHDR
 Q
 ;
INIT ;EP; -- init variables and list array
MARKERS I $G(BDMLMARK) F I=10:10 Q:'$D(@VALMAR@(I))  D
 . F J=10:10:80 D CNTRL^VALM10(I,J,1,IORVON,IORVOFF)
 K BDMLMARK
 S VALMCNT=$O(^TMP("BDMVR",$J,+$G(BDMNODE),""),-1)
 Q
 ;
HELP ;EP; -- help code
 S X="?"
 D DISP^XQORM1
 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BDMVR",$J)
K ;
 K BDMAR,BDMDIR,BDMFL,BDMFN,BDMHDR,BDMI,BDMROU,BDMDIR
 I '$G(XQORS) D CLEAR^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
 ;
FILE(BDMDIR,BDMFN)    ;PEP pull up a file into the TMP global for display
 I '$D(BDMHDR) S BDMHDR=""
 N Y,X,I,BDMNODE
 S BDMNODE=$G(XQORS)+1
 S Y=$$OPEN^%ZISH(BDMDIR,BDMFN,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",BDMDIR,BDMFN,"'." G EFILE
 K ^TMP("BDMVR",$J,+$G(BDMNODE))
 ;THE READ STATEMENT BELOW IS A READ FROM A HOST FILE WHICH REQUIRES A
 ;DIRECT READ VS AN FM CALL
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^TMP("BDMVR",$J,+$G(BDMNODE),I,0)=X Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 S VALMCNT=$O(^TMP("BDMVR",$J,+$G(BDMNODE),""),-1)
 D EN
 K ^TMP("BDMVR",$J,+$G(BDMNODE))
EFILE ;
 Q
 ;
VIEWR(BDMROU,BDMHDR)         ;PEP USING BDMROU print to a host file for viewing
 I '$D(BDMHDR) S BDMHDR=""
 U IO(0)
 S Y=$$PWD^%ZISH(.BDMDIR)
 S BDMDIR=$S($G(BDMDIR(1))]"":BDMDIR(1),1:"C:\Inetpub\Ftproot\Pub\")
 S BDMFN="BDM"_$J
 S X=$$OPEN^%ZISH(BDMDIR,BDMFN,"W")
 I IO="" S BDMQUIT="" Q
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 U IO
 D @BDMROU
 D ^%ZISC
 D HOME^%ZIS
 D FILE(BDMDIR,BDMFN)
 S X=$$DEL^%ZISH(BDMDIR,BDMFN)
 K BDMDIR,BDMFN,BDMHDR,BDMNODE,BDMDIR,BDMFN
 Q
 ;
VIEWD(BDMROU)         ;PEP ** USING BDMROU print to a host file for viewing
 U IO(0)
 S Y=$$PWD^%ZISH(.BDMDIR)
 S BDMDIR=$S($G(BDMDIR(1))]"":BDMDIR(1),1:"C:\Inetpub\Ftproot\Pub\")
 S BDMFN="BDM"_$J
 D DF^%ZISH(.BDMDIR)
 S X=$$OPEN^%ZISH(BDMDIR,BDMFN,"W")
 S IOP=IO_";P-DEC;"_IOM_";"_IOSL
 D ^%ZISC
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 S %ZIS("IOPAR")="("""_BDMDIR_BDMFN_""":""W"")"
 D @BDMROU
 D ^%ZISC
 D HOME^%ZIS
 D FILE^BDMFLM(BDMDIR,BDMFN)
 S X=$$DEL^%ZISH(BDMDIR,BDMFN)
 K BDMDIR,BDMFN,BDMNODE,BDMDIR,BDMFN
 Q
 ;
ARRAY(BDMAR,BDMHDR)  ;PEP  Display an array that has (...,n,0) structure
 I '$D(BDMHDR) S BDMHDR=""
 N Y,X,I,BDMNODE
 S BDMNODE=$G(XQORS)+1
 K ^TMP("BDMVR",$J,BDMNODE)
 S %X=BDMAR,%Y="^TMP(""BDMLM"","_$J_","_BDMNODE_","
 D %XY^%RCR
 D EN
 K ^TMP("BDMVR",$J,+$G(BDMNODE))
 K BDMNODE,BDMDIR,BDMFN
ARRAYE ;
 Q
 ;
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 N I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ;
