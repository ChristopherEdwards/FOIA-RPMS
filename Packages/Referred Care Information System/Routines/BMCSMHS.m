BMCSMHS ; IHS/PHXAO/TMJ - print face sheet ffrom screenman ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
EN ;EP - called from screenman screen to display hs
 K BMCQUIT
 W:$D(IOF) @IOF
 S APCHSPAT=BMCDFN
 D EN^XBNEW("EN1^BMCSMHS","APCHSPAT")
 D REFRESH
 D XIT
 Q
EN1 ;EP - called from XBNEW from EN
 Q:'$G(APCHSPAT)
 D GETTYP
 G:'$G(APCHSTYP) XIT
 D VIEWR^XBLM("EN^APCHS","PCC Health Summary for "_$P(^DPT(APCHSPAT,0),U))
 Q
DIR ;call to XBDBQUE
 NEW DDS,DIR0,DA,DIE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 Q
GETTYP ; EP - get health summary TYPE
 K APCHSTYP
 K DIC S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC I Y>0 S APCHSTYP=+Y
 K DIC,DA
 Q
XIT ;
 K APCHSPAT,APCHSTYP
 Q
REFRESH ;
 S X=0 X ^%ZOSF("RM")
 W $P(DDGLVID,DDGLDEL,8)
 D REFRESH^DDSUTL
PROC ;
 Q
