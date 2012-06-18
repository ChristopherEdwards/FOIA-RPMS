AMHLEI ; IHS/CMI/LAB - DISPLAY/EDIT TREATMENT NOTES ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
 ;; ;
EP1(DFN,AMHREC) ;EP CALLED FROM PROTOCOL
 S AMHREC=$G(AMHREC)
 I AMHREC,'$D(^AMHREC(AMHREC,0)) S AMHREC=""
 Q:'$G(DFN)
 Q:'$D(^DPT(DFN))
 ;get intake document or create new one
 D GETINT
 D FULL^VALM1
 I '$G(AMHINT) W !!,"Error creating intake document." Q
 D EN
 ;D FULL^VALM1
 K VALMHDR
 K X,Y
 Q
EN ; EP -- main entry point for AMH UPDATE ACTIVITY RECORDS
 S VALMCC=1
 D EN^VALM("AMH INTAKE LIST/EDIT")
 D CLEAR^VALM1
 Q
 ;
GETINT ;
 S AMHINT=$O(^AMHPINTK("B",DFN,0))
 Q:AMHINT
 D ^XBFMK
 S (DINUM,X)=DFN,DIC(0)="L",DIC="^AMHPINTK(",DLAYGO=9002011.07,DIADD=1,DIC("DR")=".06////^S X=DT" K DD,DO D FILE^DICN K DLAYGO,DIADD,DINUM
 I Y=-1 W !!,"Adding new Intake Document failed!!!" H 4 D ^XBFMK Q
 S AMHINT=+Y
 D ^XBFMK
 S DA=AMHINT,DIE="^AMHPINTK("
 S DR=".07//"_$S(AMHREC:$$FMTE^XLFDT($P($P(^AMHREC(AMHREC,0),U),".")),1:$$FMTE^XLFDT(DT))_";.08//^S X=$P(^VA(200,DUZ,0),U)"
 S DR=DR_";.02//"_$S(AMHREC:$$FMTE^XLFDT($P($P(^AMHREC(AMHREC,0),U),".")),1:$$FMTE^XLFDT(DT))_";.03//^S X=$P(^VA(200,DUZ,0),U)"
 D ^DIE,^XBFMK
 Q
BACK ;EP - go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
D ;
 W !
 D ^XBFMK S DA=AMHINT,DIE="^AMHPINTK(",DR=AMHX2 D ^DIE D ^XBFMK
 Q
RB ;EP
 D FULL^VALM1
 W !!!
 D ^XBFMK S DA=DFN,DIE="^AMHPINTK(",DR=1000 D ^DIE D ^XBFMK
 D BACK
 Q
ED ;EP
 D FULL^VALM1
 W !!!
 D ^XBFMK
 S DA=DFN,DIE="^AMHPINTK("
 S DR=".02//"_$S(AMHREC:$$FMTE^XLFDT($P($P(^AMHREC(AMHREC,0),U),".")),1:$$FMTE^XLFDT(DT))_";.03//^S X=$P(^VA(200,DUZ,0),U)"_";4100"
 D ^DIE K DIE,DR,DA,DIU,DIV,DIW
 D ^XBFMK
 D BACK
 Q
DP ;update designated provider
 S (AMHPAT,AMHPATH)=DFN D 1^AMHLEA S (DFN,AMHPAT)=AMHPATH K AMHPATH
 D BACK
 Q
GATHER ;EP - called from AMHUAR
 K ^TMP("AMHLEI1",$J)
 D DISP^AMHLEI2(DFN)
 Q
HDR ;EP -- header code
 S VALMHDR(1)="Patient Name:  "_$P(^DPT(DFN,0),U)_"     DOB:  "_$$FTIME^VALM1($P(^DPT(DFN,0),U,3))_"   Sex:  "_$P(^DPT(DFN,0),U,2)
 Q
 ;
INIT ;EP -- init variables and list array
 D GATHER ;gather up all records for display
 S VALMCNT=AMHCTR
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
DISP ;
 D EN^AMHLEI1(DFN)
 D BACK
 Q
EXIT ; -- exit code
 K AMHRCNT,AMHPTP,AMHE,AMHCTR,AMHLEL,AMHLETXT,AMHGNUM,AMHTPN,AMHCOL,AMHLEI,AMHINT
 K VALMCC,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;
DEL ;EP - called from protocol
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a Intake Document.",!,"Please see your supervisor or program manager.",! D PAUSE^AMHLEA,BACK Q
 D FULL^VALM1
 ;are you sure??
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this INTAKE DOCUMENT",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y W !!,"Intake document not deleted." D PAUSE^AMHLEA,BACK Q
 W !!!
 D ^XBFMK S DA=DFN,DIK="^AMHPINTK(" D ^DIK D ^XBFMK
 W !!,"Intake document deleted." D PAUSE^AMHLEA
 D BACK
 Q
