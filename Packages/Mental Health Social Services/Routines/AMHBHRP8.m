AMHBHRP8 ; IHS/CMI/LAB - behavioral health display for GUI ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
TEST ;
 D LISTDATE(.RETVAL,40503,"D",,"01/01/1995","01/20/2005")
 Q
LISTDATE(AMHARRAY,AMHPAT,AMHTYPE,AMHNUM,AMHBD,AMHED,AMHPROG) ;EP - AMHBH RPT LIST VISIT DATES
 NEW AMHR
 S JOB=$J,AMHGUI=1,XWBWRAP=1
 S ZTIO="",ZTQUEUED=1
 S AMHARRAY="^XTMP(""AMHRPT"","_$J_")"
 K ^XTMP("AMHRPT",$J)
 I $G(AMHPAT)="" S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Invalid DFN of patient passed" D KILL Q
 I $G(AMHTYPE)="" S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Invalid type of report type passed" D KILL Q
 I "LNADPS"'[AMHTYPE S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Invalid report type passed" D KILL Q
 I $G(AMHTYPE)="N",$G(AMHNUM)="" S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Number of visits not passed for N type" D KILL Q
 I $G(AMHTYPE)="D",$G(AMHBD)="" S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Beginning date not passed and type is date range" D KILL Q
 I AMHBD]"" D DT^DILF("X",AMHBD,.AMHBD) I $G(AMHBD)=-1 S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Invalid beginning date passed" D KILL Q
 I $G(AMHTYPE)="D",$G(AMHED)="" S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Ending date not passed and type is date range" D KILL Q
 I AMHED]"" D DT^DILF("X",AMHED,.AMHED) I $G(AMHED)=-1 S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Invalid ending date passed" D KILL Q
 I $G(AMHTYPE)="P",$G(AMHPROG)="" S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="Program type not passed and type is program" D KILL Q
 S (DFN,AMHPAT,AUPNPAT)=AMHPAT
 K AMHV D @AMHTYPE
 I '$O(AMHV(0)) S ^XTMP("AMHRPT",JOB,.5)=2,^XTMP("AMHRPT",JOB,1)="No visits found" D KILL Q
 K ^XTMP("AMHRPT",JOB)
 S ^XTMP("AMHRPTRUN",JOB)=""
 D ^XBKSET
 ;S ZTRTN="TSK^AMHBHRP8",ZTIO="",ZTDESC="AMH LIST VISITS DISPLAY",ZTSAVE("DFN")="",ZTSAVE("AMH*")="",ZTSAVE("JOB")="",ZTDTH=$H D ^%ZTLOAD
 ;F I=1:1:120 Q:$G(^XTMP("AMHRPTRUN",$J))="DONE"  H 1
 D TSK
 D KILL
 Q
 ;
TSK ;
 D ^XBKSET
 S ^XTMP("AMHRPTRUN",JOB)="START"
 D GUIR^XBLM("PRINT^AMHVDL","^XTMP(""AMHRPT"",JOB)")
 S ^XTMP("AMHRPT",JOB,.5)=$O(^XTMP("AMHRPT",JOB,""),-1)+1
 S ^XTMP("AMHRPTRUN",JOB)="DONE"
 Q
 ;
KILL ;
 K DFN,AMHPAT,AUPNPAT
 K AMHOA,AMHBT,AMHTOT
 K AMHCTR,AMHGUI,AMHSF,DIC,JOB,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
 D EN^XBVK("AMH")
 Q
L ;get patients last visit
 ;AMHV array
 I '$D(^AMHREC("AE",DFN)) Q
 S D=$O(^AMHREC("AE",DFN,"")),R=$O(^AMHREC("AE",DFN,D,""))
 I R S AMHV(D,R)=""
 Q
S ;san only
 S D=0,V=0
 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $P(^AMHREC(V,0),U,33)="S" S AMHV(D,V)=""
 Q
N ;patients last N visits
 S (C,D)=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!(C=AMHNUM)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V!(C=AMHNUM)  S C=C+1,AMHV(D,V)=""
 Q
P ;on program
 S D=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $P(^AMHREC(V,0),U,2)=AMHPROG S AMHV(D,V)=""
 Q
A ;all visits
 S D=0,V=0
 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  S AMHV(D,V)=""
 Q
D ;date rante
 S E=9999999-AMHBD,D=9999999-AMHED-1_".99" F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  S AMHV(D,V)=""
 Q
