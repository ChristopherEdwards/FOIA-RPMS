ACRFXPT ;IHS/OIRM/DSD/AEF - CREATE EXPORT FILE [ 10/27/2004   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13**;NOV 05, 2001
 ;
 ;This routine finds and exports the UNIX DHR data file to CORE
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 ;N ACRDATA,ACRHN,ACRPW,ACRUN,FILE,OUT,Y
 ;D LIST                                    ;ACR*2.1*13.06 IM14144
 ;D SEL(.OUT,.Y)                            ;ACR*2.1*13.06 IM14144
 ;I $G(OUT) D  Q                            ;ACR*2.1*13.06 IM14144
 ;. D JCMD^ACRFUTL("rm /usr/spool/afsdata/acr.files") ;ACR*2.1*13.06 IM14144
 N ACRDATA,ACRHN,ACRPW,ACRUN,FILE,OUT,Y,ACRDIR   ;ACR*2.1*13.06 IM14144 
 S ACRDIR=$$ARMSDIR^ACRFSYS(1)                   ;ACR*2.1*13.06 IM14144
 D LIST(ACRDIR)                                  ;ACR*2.1*13.06 IM14144
 D SEL(.OUT,.Y,ACRDIR)                           ;ACR*2.1*13.06 IM14144
 I $G(OUT) D DEL^ACRFZISH(ACRDIR,"acr.files") Q  ;ACR*2.1*13.06 IM14144
 S ACRFN=Y
 S ACRDATA=$G(^ACRSYS(1,403))
 S ACRUN=$P(ACRDATA,U) ;CORE LOGIN NAME
 S ACRPW=$P(ACRDATA,U,2) ;CORE PASSWORD
 S ACRHN=$P(ACRDATA,U,3) ;CORE HOST NAME
 D EXPORT(ACRDIR,ACRFN,ACRUN,ACRPW,ACRHN)        ;ACR*2.1*13.06 IM14144
 K ^TMP("ACR",$J)
 G EN
 Q
EXPORT(ACRDIR,ACRFN,ACRUN,ACRPW,ACRHN) ;- EXPORT FILE TO CORE ;ACR*2.1*13.06 IM14144
 ;
 ;      INPUT:
 ;      ACRDIR =  DIRECTORY PATH
 ;      ACRFN  =  UNIX FILENAME
 ;      ACRUN  =  CORE LOGIN NAME
 ;      ACRPW  =  CORE PASSWORD
 ;      ACRHN  =  CORE HOSTNAME
 ;
 W !
 ;D TCMD^ACRFUTL("/usr/spool/afsdata/acrdhrsend "_ACRFN_" "_ACRUN_" "_ACRPW_" "_ACRHN) ;ACR*2.1*13.06 IM14144
 D TCMD^ACRFUTL(ACRDIR_"acrdhrsend "_ACRFN_" "_ACRUN_" "_ACRPW_" "_ACRHN) ;ACR*2.1*13.06 IM14144
 H 2
 D PAUSE^ACRFWARN
 Q
SEL(OUT,Y,ACRDIR)         ;                          ;ACR*2.1*13.06 IM14144
 ;----- SELECT FILE TO EXPORT
 ;
 N DIR,X
 W !
 S DIR(0)="F^3:30"
 S DIR("A")="Select FILE for export"
 S DIR("?")="Enter file name to export, or '??' for a list of files"
 S DIR("??")="^D LIST^ACRFXPT(ACRDIR)"         ;ACR*2.1*13.06 IM14144
 F  D  Q:$G(OUT)  Q:$G(Y)]""
 . D ^DIR
 . I $D(DTOUT)!($D(DUOUT)) S OUT=1 Q
 . I '$D(^TMP("ACR",$J,"FILES",Y)) D  K Y
 . . W !,?5,"No such file "_Y
 Q
 ;LIST     ;----- LIST UNIX DHR FILES FOR EXPORT ;ACR*2.1*13.06 IM14144
 ;
 ;N OUT                                      ;ACR*2.1*13.06 IM14144
 ;D ^XBKVAR                                  ;ACR*2.1*13.06 IM14144
 ;S OUT=0                                    ;ACR*2.1*13.06 IM14144
 ;D BLD,READ(.OUT)                           ;ACR*2.1*13.06 IM14144
 ;Q:$G(OUT)                                  ;ACR*2.1*13.06 IM14144
 ;S OUT=0                                    ;ACR*2.1*13.06 IM14144
 ;D SHOW                                     ;ACR*2.1*13.06 IM14144
 ;Q                                          ;ACR*2.1*13.06 IM14144
LIST(ACRDIR) ;----- LIST UNIX DHR FILES FOR EXPORT ;ACR*2.1*13.06 IM14144
 ;
 N OUT
 D ^XBKVAR
 S OUT=0
 D BLD(ACRDIR)                                ;ACR*2.1*13.06 IM14144
 D READ(.OUT,ACRDIR)                          ;ACR*2.1*13.06 IM14144
 Q:$G(OUT)
 S OUT=0
 D SHOW
 Q
 ;
 ;BLD ;----- BUILD UNIX FILE acr.files        ;ACR*2.1*13.06 IM14144
 ;
 ;D JCMD^ACRFUTL("ls -l /usr/spool/afsdata/afsdh* > /usr/spool/afsdata/acr.files") ;ACR*2.1*13.06 IM14144
 ;D JCMD^ACRFUTL("ls -l /usr/spool/afsdata/bar* >> /usr/spool/afsdata/acr.files") ;TO ALLOW SELECTION OF AR FILES TO SEND TO CORE ;ACR*2.1*13.06 IM14144
BLD(ACRDIR) ;----- BUILD UNIX FILE acr.files ;ACR*2.1*13.06 IM14144
 D JCMD^ACRFUTL("ls -l "_ACRDIR_"afsdh* > "_ACRDIR_"acr.files") ;ACR*2.1*13.06 IM14144
 D JCMD^ACRFUTL("ls -l "_ACRDIR_"bar* >> "_ACRDIR_"acr.files") ;SELECT AR FILES TO SEND TO CORE ;ACR*2.1*13.06 IM14144
 Q
READ(OUT,ARCDIR)          ;                       ;ACR*2.1*13.06 IM14144
 ;----- READ CONTENTS OF UNIX FILE acr.files INTO ^TMP GLOBALS
 ;
 N FILE,I,QUIT,X,Y
 K ^TMP("ACR",$J)
 ;D OPEN^%ZISH("FILE","/usr/spool/afsdata/","acr.files","R") ;ACR*2.1*13.06 IM14144
 ;I POP W !,"UNABLE TO OPEN acr.files" S OUT=1 Q  ;ACR*2.1*13.06 IM14144
 ;U IO                                            ;ACR*2.1*13.06 IM14144
 D HFS^ACRFZISH(ACRDIR,"acr.files","R",.%DEV)     ;ACR*2.1*13.06 IM14144
 I $G(%DEV)']"" S OUT=1 Q
 U %DEV
 F I=1:1 D  Q:$G(QUIT)
 . R X:DTIME I $$STATUS^%ZISH S QUIT=1 Q
 . S ^TMP("ACR",$J,"DATA",I,0)=X
 D CLOSE^%ZISH("FILE")
 S I=0
 F  S I=$O(^TMP("ACR",$J,"DATA",I)) Q:'I  D
 . S X=^TMP("ACR",$J,"DATA",I,0)
 . S ^TMP("ACR",$J,"FILES",$P($E(X,55,999),"/",5),0)=$TR($E(X,28,40)," ","")_U_$E(X,42,53)_U_$P($E(X,55,999),"/",5)
 Q
SHOW ;----- SHOW A LIST OF UNIX DHR FILES
 ;
 N DATA,DIR,FILE,OUT,PAGE
 D HOME^%ZIS
 W @IOF
 S OUT=0
 I '$D(^TMP("ACR",$J,"FILES")) W !,"No files to export" Q
 S FILE=""
 F  S FILE=$O(^TMP("ACR",$J,"FILES",FILE)) Q:FILE']""  D  Q:$G(OUT)
 . I $Y>(IOSL-5) D HDR(.OUT) Q:$G(OUT)
 . S DATA=^TMP("ACR",$J,"FILES",FILE,0)
 . W !,$J($P(DATA,U),15)
 . W ?18,$P(DATA,U,2)
 . W ?32,$P(DATA,U,3)
 Q
HDR(OUT) ;----- WRITE HEADER
 ;
 N DIR
 I $E(IOST)="C",$G(PAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S OUT=1 Q
 S PAGE=$G(PAGE)+1
 W @IOF
 W !,"FILES PENDING EXPORT:"
 Q
