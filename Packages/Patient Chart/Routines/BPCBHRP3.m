BPCBHRP3 ; IHS/OIT/MJL - behavioral health display for GUI ;
 ;;1.5;BPC;;MAY 26, 2005
 ;
 ;
 ;
TEST ;
 D ACTCL(.RETVAL,"01/01/2000","12/31/2003","")
 Q
ACTCL(BGUARRAY,BPCBD,BPCED,BPCPROV) ;EP - BPCBH RPT SUICIDE STANDARD
  S JOB=$J,BPCGUI=1,XWBWRAP=1
 S ZTIO="",ZTQUEUED=1
 S BGUARRAY="^XTMP(""BPCRPT"","_$J_")"
 I $G(BPCBD)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid beginning date passed" D KILL Q
 D DT^DILF("X",BPCBD,.AMHBD)
 I $G(AMHBD)=-1 S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid beginning date passed" D KILL Q
 I $G(BPCED)="" S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid ending date passed" D KILL Q
 D DT^DILF("X",BPCED,.AMHED)
 I $G(AMHED)=-1 S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid ending date passed" D KILL Q
 I $G(BPCPROV),'$D(^VA(200,BPCPROV,0)) S ^XTMP("BPCRPT",JOB,.5)=2,^XTMP("BPCRPT",JOB,1)="Invalid IEN of provider entry passed" D KILL Q
 S AMHPROV=$G(BPCPROV)
 K ^XTMP("BPCRPT",JOB)
 S ^XTMP("BPCRPTRUN",JOB)=""
 D ^XBKSET
 D PROC^AMHRP8
 S ZTRTN="TSK^BPCBHRP3",ZTIO="",ZTDESC="BPC ACTIVE CLIENT LIST",ZTSAVE("AMH*")="",ZTSAVE("JOB")="",ZTDTH=$H D ^%ZTLOAD
 F I=1:1:120 Q:$G(^XTMP("BPCRPTRUN",$J))="DONE"  H 1
 D KILL
 Q
 ;
TSK ;
 D ^XBKSET
 S ^XTMP("BPCRPTRUN",JOB)="START"
 D GUIR^XBLM("^AMHRP8P","^XTMP(""BPCRPT"",JOB)")
 S ^XTMP("BPCRPT",JOB,.5)=$O(^XTMP("BPCRPT",JOB,""),-1)+1
 S ^XTMP("BPCRPTRUN",JOB)="DONE"
 Q
 ;
KILL ;
 K AMHOA,AMHBT,AMHTOT
 K BPCCTR,BPCGUI,AMHSF,DIC,JOB,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
 D XIT^AMHRP8
 Q