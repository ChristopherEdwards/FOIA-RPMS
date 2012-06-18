BPCBHRP8 ; IHS/OIT/MJL - behavioral health display for GUI ;
 ;;1.5;BPC;;MAY 26, 2005
 ;
 ;
 ;
TEST ;
 D LISTDATE(.RETVAL,87,"D",,"01/01/1995","01/20/2003")
 Q
LISTDATE(BGUARRAY,BPCPAT,BPCTYPE,BPCNUM,BPCBD,BPCED,BPCPROG) ;EP - BPCBH RPT LIST VISIT DATES
 NEW AMHR
  S JOB=$J,BPCGUI=1,XWBWRAP=1
 S ZTIO="",ZTQUEUED=1
 S BGUARRAY="^XTMP(""BPCRPT"","_$J_")"
 K ^XTMP("BPCRPT",$J)
 I $G(BPCPAT)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid DFN of patient passed" D KILL Q
 I $G(BPCTYPE)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid type of report type passed" D KILL Q
 I "LNADPS"'[BPCTYPE S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid report type passed" D KILL Q
 I $G(BPCTYPE)="N",$G(BPCNUM)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Number of visits not passed for N type" D KILL Q
 I $G(BPCTYPE)="D",$G(BPCBD)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Beginning date not passed and type is date range" D KILL Q
 I BPCBD]"" D DT^DILF("X",BPCBD,.AMHBD) I $G(AMHBD)=-1 S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid beginning date passed" D KILL Q
 I $G(BPCTYPE)="D",$G(BPCED)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Ending date not passed and type is date range" D KILL Q
 I BPCED]"" D DT^DILF("X",BPCED,.AMHED) I $G(AMHED)=-1 S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid ending date passed" D KILL Q
 I $G(BPCTYPE)="P",$G(BPCPROG)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Program type not passed and type is program" D KILL Q
 S (DFN,AMHPAT,AUPNPAT)=BPCPAT
 K AMHV D @BPCTYPE
 I '$O(AMHV(0)) S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="No visits found" D KILL Q
 K ^XTMP("BPCRPT",JOB)
 S ^XTMP("BPCRPTRUN",JOB)=""
 D ^XBKSET
 S ZTRTN="TSK^BPCBHRP8",ZTIO="",ZTDESC="BPC LIST VISITS DISPLAY",ZTSAVE("DFN")="",ZTSAVE("AMH*")="",ZTSAVE("JOB")="",ZTDTH=$H D ^%ZTLOAD
 F I=1:1:120 Q:$G(^XTMP("BPCRPTRUN",$J))="DONE"  H 1
 D KILL
 Q
 ;
TSK ;
 D ^XBKSET
 S ^XTMP("BPCRPTRUN",JOB)="START"
 D GUIR^XBLM("PRINT^AMHVDL","^XTMP(""BPCRPT"",JOB)")
 S ^XTMP("BPCRPT",JOB,.5)=$O(^XTMP("BPCRPT",JOB,""),-1)+1
 S ^XTMP("BPCRPTRUN",JOB)="DONE"
 Q
 ;
KILL ;
 K DFN,AMHPAT,AUPNPAT
 K AMHOA,AMHBT,AMHTOT
 K BPCCTR,BPCGUI,AMHSF,DIC,JOB,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
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
 S (C,D)=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!(C=BPCNUM)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V!(C=BPCNUM)  S C=C+1,AMHV(D,V)=""
 Q
P ;on program
 S D=0 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  I $P(^AMHREC(V,0),U,2)=BPCPROG S AMHV(D,V)=""
 Q
A ;all visits
 S D=0,V=0
 F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  S AMHV(D,V)=""
 Q
D ;date rante
 S E=9999999-AMHBD,D=9999999-AMHED-1_".99" F  S D=$O(^AMHREC("AE",DFN,D)) Q:D'=+D!($P(D,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",DFN,D,V)) Q:V'=+V  S AMHV(D,V)=""
 Q
