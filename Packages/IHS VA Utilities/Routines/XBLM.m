XBLM ; IHS/ADC/GTH - LIST MANAGER API'S ;  [ 09/30/2004  12:07 PM ]
 ;;3.0;IHS/VA UTILITIES;**5,6,8,10**;JUNE 18 1998
 ; XB*3*5,6 IHS/ADC/GTH 10-31-97 Use %ZIS to open HF vs $$OPEN^%ZISH
 ; XB*3*8 - IHS/ASDST/GTH 12-07-00 - Fix EOF bug in UNIX, timed READ.
 ;
 ; Documentation APIs for XBLM Generic Display.
 ;
 ; This utility uses the Veterans Administration List Manager
 ; (VALM).
 ;
 ; APIs
 ;
 ; FILE^XBLM("Directory","File Name")
 ;     Displays file indicated.
 ;
 ; SFILE^XBLM
 ;     Selection of host file for display.
 ;
 ; VIEWR^XBLM("TAG^ROUTINE","Header")
 ;     Displays printout of the routine. (non - FM, using IO)
 ;
 ; VIEWD^XBLM("Tag^Routine","Header")
 ;     Displays printout of the routine. (FM - using EN1^DIP)
 ;
 ; DIQ^XBLM("DIC","DA")
 ;     Displays EN1^DIQ for the DIC,DA.
 ;
 ; ARRAY^XBLM("array(","Header")
 ;     Displays the array(..,n,0) (%RCR notation)
 ;
 ; >>GUI<<                                      
 ;
 ; GUIR^XBLM("TAG^ROUTINE","root(")
 ;     Returns the hard coded output in the array specified.
 ;     "(" not required.
 ;
 ; GUID^XBLM("TAG^ROUTINE","root(")
 ;     Returns the output of the FM routine specified in the
 ;     array specified.  Most often the call is "EN1^DIP".
 ;                                          
 ; S XBGUI=1,XBY="root(" D entry_point^XBLM    
 ;     The entry points sense these two variables and will
 ;     put the output into the array specified.
 ;
EN ;EP -- main entry point for XB DISPLAY
 D EN^VALM("XB DISPLAY")
 Q
 ;
HDR ;EP -- header code
 I XBHDR]"" S VALMHDR(1)=XBHDR
 Q
 ;
INIT ;EP -- init variables and list array
MARKERS ;
 I $G(XBLMMARK) F I=10:10 Q:'$D(@VALMAR@(I))  D
 . F J=10:10:80 D CNTRL^VALM10(I,J,1,IORVON,IORVOFF)
 .Q
 KILL XBLMMARK
 S VALMCNT=$O(^TMP("XBLM",$J,XBNODE,""),-1)
 Q
 ;
HELP ;EP -- help code
 S X="?"
 D DISP^XQORM1
 W !!
 Q
 ;
EXIT ;EP -- exit code
 KILL ^TMP("XBLM",$J,XBNODE)
K ;
 KILL XBAR,XBDIR,XBFL,XBFN,XBHDR,XBI,XBROU,XBDIR
 I '$G(XQORS) D CLEAR^VALM1
 K IOPAR,IOUPAR
 Q
 ;
EXPND ;EP -- expand code
 Q
 ;
FILE(XBDIR,XBFN) ;PEP - pull up a file into the TMP global for display
 ;      or into an array for GUI (see GUIR and GUID entry points)
 I '$D(XBHDR) S XBHDR=""
 NEW Y,X,I,XBNODE
 S XBNODE=$G(XQORS)+1
 ;S Y=$$OPEN^%ZISH(XBDIR,XBFN,"M")
 ;open hfs with zis
 D DF^%ZISH(.XBDIR)
 ;
 ; IHS/ADC/GTH XB*3*5 start of open HF change 
 KILL %ZIS
 I ('$D(^%ZIS(1,"B","XBLM HF DEVICE")))!('$D(^%ZIS(2,"B","P-XBLM"))) D ^XBLMSET
 S IOP="XBLM HF DEVICE",%ZIS("HFSMODE")="R",%ZIS("HFSNAME")=XBDIR_XBFN
 D ^%ZIS
 I POP W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",XBDIR,XBFN,"'." S Y=$$DIR^XBDIR("E") G EFILE
 KILL ^TMP("XBLM",$J,XBNODE)
 ; F I=1:1 U IO R X:DTIME S:($L(X)>250) X=$E(X,1,250) S X=$$STRIP(X) S ^TMP("XBLM",$J,XBNODE,I,0)=X Q:$$STATUS^%ZISH ; XB*3*8
 F I=1:1 U IO R X S:($L(X)>250) X=$E(X,1,250) S X=$$STRIP(X) S ^TMP("XBLM",$J,XBNODE,I,0)=X Q:$$STATUS^%ZISH  ; XB*3*8 - UNIX does not find EOF w/timed READ, writes to ^TMP(, and fills up journal space.
 D ^%ZISC
 ; IHS/ADC/GTH XB*3*5 END of open HF change 
 ;
 I $G(XBGUI) D  KILL ^TMP("XBLM",$J,XBNODE) Q
 . S I=0
 . S XBY=$$OPENROOT(XBY)
 . F  S I=$O(^TMP("XBLM",$J,XBNODE,I)) Q:'+I  S XBZ=XBY_"I)",@XBZ=^TMP("XBLM",$J,XBNODE,I,0)
 .Q
 D EN^XBLM
 KILL ^TMP("XBLM",$J,XBNODE)
EFILE ;
 Q
 ;
SFILE ;PEP - Select a host file for display.
OPEN ;
 S IOP="HOME"
 D ^%ZIS,DT^DICRW,^XBCLS
 W !!,"Select a Directory and File",!!
 S Y=$$PWD^%ZISH(.XBDIR),XBDIR=XBDIR(1)
 KILL DIR
 S DIR(0)="F^1:30",DIR("A")="Directory ",DIR("B")=XBDIR
 K XBDIR
 D ^DIR
 KILL DIR
 Q:$G(DTOUT)
 Q:Y["^"
 S XBDIR=Y
FNAME ;PEP - Select a file (directory can be pre-loaded into XBDIR)
 KILL DIR
FNAME1 ;
 S DIR(0)="FO^1:15",DIR("A")="File Name "
 D ^DIR
 KILL DIR
 Q:$G(DTOUT)
 G:Y["^" OPEN
 G:Y="" OPEN
 I Y?.N,$D(XBFL(Y)) S DIR("B")=XBFL(Y) G FNAME1
 I Y["*" K XBFL S X=$$LIST^%ZISH(XBDIR,Y,.XBFL) D  G FNAME
 . F XBI=1:1 Q:'$D(XBFL(XBI))  W !?5,XBI,?10,XBFL(XBI) I '(XBI#20) R X:DTIME
 .Q
 S XBFN=Y
 ;S X=$$OPEN^%ZISH(XBDIR,XBFN,"M")
 ;open hfs with zis
 D DF^%ZISH(.XBDIR)
 ;
 ; IHS/ADC/GTH XB*3*5 start of open HF change 
 KILL %ZIS
 I ('$D(^%ZIS(1,"B","XBLM HF DEVICE")))!('$D(^%ZIS(2,"B","P-XBLM"))) D ^XBLMSET
 S IOP="XBLM HF DEVICE",%ZIS("HFSMODE")="R",%ZIS("HFSNAME")=XBDIR_XBFN
 D ^%ZIS
ES ;
 I POP W !,"error on open of file ",XBDIR,XBFN,! S Y=$$DIR^XBDIR("E") Q:Y=1  G FNAME
 D ^%ZISC
 D FILE^XBLM(XBDIR,XBFN)
 K XBFN
ESFILE ;
 G FNAME
 Q
 ;
VIEWR(XBROU,XBHDR) ;PEP ** USING XBROU print to a host file for viewing
 I '$D(XBHDR) S XBHDR=""
 I +$G(IO(0)) U IO(0) D:'$G(XBGUI) WAIT^DICD
 S Y=$$PWD^%ZISH(.XBDIR)
 S XBDIR=XBDIR(1),XBFN="XB"_$J
 ;open hfs with zis
 D DF^%ZISH(.XBDIR)
 K %ZIS
 S XBIOM=IOM
 I ('$D(^%ZIS(1,"B","XBLM HF DEVICE")))!('$D(^%ZIS(2,"B","P-XBLM"))) D ^XBLMSET
 S IOP="XBLM HF DEVICE;"_IOM_";6000"
 S %ZIS("HFSMODE")="W",%ZIS("HFSNAME")=XBDIR_XBFN
 D ^%ZIS
 U IO
 K DX ;IHS/JDH 6/17/98 prevent <MODER> if defined when DIQ is called
 D @XBROU
 D ^%ZISC,HOME^%ZIS
 D FILE^XBLM(XBDIR,XBFN)
 S X=$$DEL^%ZISH(XBDIR,XBFN)
 S IOM=XBIOM
 KILL XBDIR,XBFN,XBHDR,XBNODE,XBDIR,XBFN,XBIOM
 ; IHS/ADC/GTH XB*3*5 END of open HF change 
 ;
 Q
 ;
GUIR(XBROU,XBY) ;PEP - give routine and target array
 Q:$L(XBY)=0
 ;
 S XBGUI=1
 D VIEWR^XBLM(XBROU,"")
 KILL XBGUI,XBY
 Q
 ;
GUID(XBROU,XBY) ;PEP give routine and target array for FM prints
 Q:$L(XBY)=0
 S:XBY["(" XBY=$P(XBY,"(")
 S XBGUI=1
 D VIEWD^XBLM(XBROU,"")
 KILL XBGUI,XBY
 Q
 ;
VIEWD(XBROU,XBHDR) ;PEP ** USING XBROU print to a host file for viewing
 S:'$D(XBHDR) XBHDR=""
 I +$G(IO(0)) I '$G(XBGUI) U IO(0) D WAIT^DICD
 S XBFN="XB"_$J,Y=$$PWD^%ZISH(.XBDIR),XBDIR=XBDIR(1)
 ;S X=$$OPEN^%ZISH(XBDIR,XBFN,"W"),IOP=IO_";P-OTHER;"_IOM_";"_IOSL
 ;open hfs with zis
 D DF^%ZISH(.XBDIR)
 ;
 ; IHS/ADC/GTH XB*3*5 start of open HF change 
 KILL %ZIS
 S XBIOM=IOM
 I ('$D(^%ZIS(1,"B","XBLM HF DEVICE")))!('$D(^%ZIS(2,"B","P-XBLM"))) D ^XBLMSET
 S IOP="XBLM HF DEVICE;"_IOM_";6000"
 S %ZIS("HFSMODE")="W",%ZIS("HFSNAME")=XBDIR_XBFN
 ;D ^%ZIS   ;XBROU must open device, XB*3*10, dmj
 D @XBROU
 K DX ;IHS/JDH 6/17/98 prevent <MODER> if defined when DIQ is called
 D ^%ZISC,HOME^%ZIS
 D FILE^XBLM(XBDIR,XBFN)
 S X=$$DEL^%ZISH(XBDIR,XBFN)
 S IOM=XBIOM
 KILL XBDIR,XBFN,XBNODE,XBDIR,XBFN,XBIOM
 ; IHS/ADC/GTH XB*3*5 END of open HF change 
 ;
 Q
 ;
DIQ(DIC,DA) ;PEP - Display DIC and DA after call to EN^DIQ
 S IOSTO=IOST,IOST="P-DEC",IOSLO=IOSL,IOSL=6000
 I DIC=+DIC S DIC=$$DIC^XBDIQ1(DIC)
 I DA'=+DA D PARSE^XBDIQ1(DA)
 NEW DIQ,DR
 S DIQ(0)="C"
 D VIEWR^XBLM("EN^DIQ")
 S IOST=IOSTO
 KILL IOSTO
 S IOSL=IOSLO
 KILL IOSLO,XBNODE,XBDIR,XBFN
 Q
 ;
ARRAY(XBAR,XBHDR) ;PEP  Display an array that has (...,n,0) structure
 I '$D(XBHDR) S XBHDR=""
 NEW Y,X,I,XBNODE
 S XBNODE=$G(XQORS)+1
 KILL ^TMP("XBLM",$J,XBNODE)
 S %X=XBAR,%Y="^TMP(""XBLM"","_$J_","_XBNODE_","
 D %XY^%RCR,EN^XBLM
 KILL ^TMP("XBLM",$J,XBNODE),XBNODE,XBDIR,XBFN
ARRAYE ;
 Q
 ;
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ;
OPENROOT(XBY) ;EP - return OPen RooT form of XBY .. for %RCR use
 NEW L
 S L=$L(XBY)
 I XBY["(",$E(XBY,L)="," G CONT
 I XBY'["(" S XBY=XBY_"(" G CONT
 I XBY["(",$E(XBY,L)=")" S XBY=$E(XBY,1,L-1)_"," G CONT
CONT ;
 Q XBY
 ;
