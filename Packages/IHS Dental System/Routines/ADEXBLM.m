ADEXBLM ; IHS/ADC/GTH - LIST MANAGER API'S ;  [ 03/24/1999   8:35 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;; ;
DOC ;Documentation APIs for ADEXBLM  Generic Display
 ;This utility uses the Veterans Administration List Manager (VALM)
 ;
 ; APIs
 ;
 ; FILE^ADEXBLM("Directory","File Name")   Displays file indicated
 ;
 ; SFILE^ADEXBLM                           Selection of host file
 ;                                      for display
 ;
 ; VIEWR^ADEXBLM("TAG^ROUTINE","Header")   Displays printout of the
 ;                                      routine. (non - FM, using IO)
 ; VIEWD^ADEXBLM("Tag^Routine","Header")   Displays printout of the 
 ;                                      routine. (FM - using EN1^DIP)
 ; DIQ^ADEXBLM("DIC","DA")                 Displays EN1^DIQ for the DIC,DA
 ; ARRAY^ADEXBLM("array(","Header")        Displays the array(..,n,0)
 ;                                      (%RCR notation)
 ;                                      
 ;                                          
EN ; -- main entry point for XB DISPLAY
 D EN^VALM("XB DISPLAY")
 Q
 ;
HDR ; -- header code
 I XBHDR]"" S VALMHDR(1)=XBHDR
 ;S VALMHDR(1)="This is a test header for XB DISPLAY."
 ;S VALMHDR(2)="This is the second line"
 Q
 ;
INIT ; -- init variables and list array
 ;F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
 ;S VALMCNT=30
MARKERS ;FHL 9/9/98
 ;I $G(ADEXBLMMARK) F I=10:10 Q:'$D(@VALMAR@(I))  D
 ;. F J=10:10:80 D CNTRL^VALM10(I,J,1,IORVON,IORVOFF)
 ;KILL ADEXBLMMARK
 I $G(XBLMMARK) F I=10:10 Q:'$D(@VALMAR@(I))  D
 . F J=10:10:80 D CNTRL^VALM10(I,J,1,IORVON,IORVOFF)
 KILL XBLMMARK
 S VALMCNT=$O(^TMP("ADEXBLM",$J,XBNODE,""),-1)
 Q
 ;
HELP ; -- help code
 S X="?"
 D DISP^XQORM1
 W !!
 Q
 ;
EXIT ; -- exit code
 KILL ^TMP("ADEXBLM",$J,XBNODE)
K ;
 KILL XBAR,XBDIR,XBFL,XBFN,XBHDR,XBI,XBROU,XBDIR
 I '$G(XQORS) D CLEAR^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
 ;
FILE(XBDIR,XBFN)    ;PEP pull up a file into the TMP global for display
 I '$D(XBHDR) S XBHDR=""
 NEW Y,X,I,XBNODE
 S XBNODE=$G(XQORS)+1
 S Y=$$OPEN^%ZISH(XBDIR,XBFN,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",XBDIR,XBFN,"'." S Y=$$DIR^XBDIR("E") G EFILE
 KILL ^TMP("ADEXBLM",$J,XBNODE)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^TMP("ADEXBLM",$J,XBNODE,I,0)=X Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 ;D EN^ADEXBLM
 ;KILL ^TMP("ADEXBLM",$J,XBNODE)
EFILE ;
 Q
 ;
SFILE ;PEP SELECT FILE
OPEN ;
 S IOP="HOME" D ^%ZIS
 D DT^DICRW
 D ^XBCLS
 W !!,"Select a Directory and File",!!
 S Y=$$PWD^%ZISH(.XBDIR),XBDIR=XBDIR(1)
 KILL DIR
 S DIR(0)="F^1:30",DIR("A")="Directory ",DIR("B")=XBDIR
 D ^DIR
 K DIR
 Q:$G(DTOUT)
 Q:Y["^"
 S XBDIR=Y
FNAME ;
 KILL DIR
FNAME1 ;
 S DIR(0)="F^1:15",DIR("A")="File Name "
 D ^DIR
 K DIR
 Q:$G(DTOUT)
 G:Y["^" OPEN
 I Y?.N,$D(XBFL(Y)) S DIR("B")=XBFL(Y) G FNAME1
 I Y["*" K XBFL S X=$$LIST^%ZISH(XBDIR,Y,.XBFL) D  G FNAME
 .F XBI=1:1 Q:'$D(XBFL(XBI))  W !,?5,XBI,?10,XBFL(XBI) I '(XBI#20) R X:DTIME
 S XBFN=Y
 S X=$$OPEN^%ZISH(XBDIR,XBFN,"R")
ES ;
 I X W !,"error on open of file ",XBDIR,XBFN,! K DIR S DIR(0)="E" D ^DIR K DIR Q:Y=1  G FNAME
 D ^%ZISC
 D FILE^ADEXBLM(XBDIR,XBFN)
ESFILE ;
 Q
 ;
VIEWR(XBROU,XBHDR)         ;PEP ** USING XBROU print to a host file for viewing
 I '$D(XBHDR) S XBHDR=""
 U IO(0)
 ;D WAIT^DICD
 S Y=$$PWD^%ZISH(.XBDIR)
 S XBDIR=XBDIR(1)
 S XBFN="XB"_$J
 S X=$$OPEN^%ZISH(XBDIR,XBFN,"W")
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 S XBIOM=IOM,IOM=80
 ;S IOF=IOF_",!!,"_""">PAGE MARK<"""_",!!"
 ;S IOP=IO_";P-DEC;"_IOM_";"_IOSL
 ;S %ZIS("IOPAR")="("""_XBFN_""":""W"")"
 U IO
 D @XBROU
 D ^%ZISC
 D HOME^%ZIS
 D FILE^ADEXBLM(XBDIR,XBFN)
 S X=$$DEL^%ZISH(XBDIR,XBFN)
 KILL XBDIR,XBFN,XBHDR,XBNODE,XBDIR,XBFN
 S IOM=XBIOM K XBIOM
 Q
 ;
VIEWD(XBROU)         ;PEP ** USING XBROU print to a host file for viewing
 U IO(0)
 ;D WAIT^DICD
 S XBFN="XB"_$J
 S Y=$$PWD^%ZISH(.XBDIR)
 S XBDIR=XBDIR(1)
 D DF^%ZISH(.XBDIR)
 S X=$$OPEN^%ZISH(XBDIR,XBFN,"W")
 S IOP=IO_";P-DEC;"_IOM_";"_IOSL
 D ^%ZISC
 S IOST="P-DEC",IOST(0)=$O(^%ZIS(2,"B","P-DEC",0))
 S IOSL=6000
 S IOF="#"
 ;S IOF=IOF_",!!,"_""">PAGE MARK<"""_",!!"
 S %ZIS("IOPAR")="("""_XBDIR_XBFN_""":""W"")"
 D @XBROU
 D ^%ZISC
 D HOME^%ZIS
 D FILE^ADEXBLM(XBDIR,XBFN)
 S X=$$DEL^%ZISH(XBDIR,XBFN)
 KILL XBDIR,XBFN,XBNODE,XBDIR,XBFN
 Q
 ;
DIQ(DIC,DA)        ;PEP ** EN^DIQ
 S IOSTO=IOST,IOST="P-DEC"
 S IOSLO=IOSL,IOSL=6000
 I DIC=+DIC S DIC=$$DIC^XBDIQ1(DIC)
 I DA'=+DA D PARSE^XBDIQ1(DA)
 NEW DIQ,DR
 S DIQ(0)="C"
 D VIEWR^ADEXBLM("EN^DIQ")
 S IOST=IOSTO
 KILL IOSTO
 S IOSL=IOSLO
 KILL IOSLO
 KILL XBNODE,XBDIR,XBFN
 Q
 ;
ARRAY(XBAR,XBHDR)  ;PEP  Display an array that has (...,n,0) structure
 I '$D(XBHDR) S XBHDR=""
 NEW Y,X,I,XBNODE
 S XBNODE=$G(XQORS)+1
 KILL ^TMP("ADEXBLM",$J,XBNODE)
 S %X=XBAR,%Y="^TMP(""ADEXBLM"","_$J_","_XBNODE_","
 D %XY^%RCR
 D EN^ADEXBLM
 KILL ^TMP("ADEXBLM",$J,XBNODE)
 KILL XBNODE,XBDIR,XBFN
ARRAYE ;
 Q
 ;
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ;
