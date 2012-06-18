BDPLMUPD ; IHS/CMI/TMJ - UPDATE USING LISTMAN ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
START ;
 W:$D(IOF) @IOF
 W $$CTR("View/Update Designated Provider List",80)
PAT ;
 D ^XBFMK
 S BDPPAT=""
 W !! S DIC("A")="Enter Patient Name: ",DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." G END
 S BDPPAT=+Y
 I $$DOD^AUPNPAT(BDPPAT)]"" W !!,"*****Note:  Patient is Decesased.  DOD:  ",$$FMTE^XLFDT($$DOD^AUPNPAT(BDPPAT)) W !! K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 D EN
END ;
 D EOJ
 K BDPP,BDPQUIT,BDPW
 Q
 ;
PPEP(BDPPAT,BDPTYPE) ;PEP - entry point to view/update one patient's providers
 ;BDPPAT - patient DFN
 I '$G(BDPPAT) Q
 ;D EN^XBNEW("EN^BDPLMUPD","BDPPAT")
 D EN
 ;D FULL^VALM1
 Q
EN ; -- main entry point for BDP UPDATE 
 D EN^VALM("BDP DESG PROV UPD - 1 PAT")
 D EN^XBVK("BDP")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$TR($J(" ",80)," ","-")
 S VALMHDR(2)="Designated Provider List for: "_IORVON_$P(^DPT(BDPPAT,0),U)_IOINORM_"   HRN: "_$$HRN^AUPNPAT(BDPPAT,DUZ(2),2)
 S C=3
 I $$DOD^AUPNPAT(BDPPAT)]"" S VALMHDR(C)="Patient is Deceased.  DOD:  "_$$FMTE^XLFDT($$DOD^AUPNPAT(BDPPAT)) S C=C+1
 S VALMHDR(C)=$TR($J(" ",80)," ","-")
 S C=C+1
 S VALMHDR(C)="#    Category",$E(VALMHDR(C),35)="Provider",$E(VALMHDR(C),70)="Updated"
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
INIT ; -- init variables and list array
 S VALMSG="?? for more actions  + next screen  - prev screen"
 D GATHER ;gather up all records for display
 S VALMCNT=BDPLINE
 Q
 ;
GATHER ;
 K BDPLIST
 S BDPRCNT=0,BDPLINE=0
 S BDPD=0 F  S BDPD=$O(^BDPRECN("AA",BDPPAT,BDPD)) Q:BDPD'=+BDPD  D
 .S BDPX=$O(^BDPRECN("AA",BDPPAT,BDPD,0))
 .Q:$P($G(^BDPRECN(BDPX,0)),U,3)=""
 .S BDPRCNT=BDPRCNT+1,BDPLINE=BDPLINE+1,Y=BDPRCNT
 .S $E(Y,5)=$E($$VAL^XBDIQ1(90360.1,BDPX,.01),1,28)
 .S $E(Y,35)=$E($$VAL^XBDIQ1(90360.1,BDPX,.03),1,30)
 .;S BDPY=$P(^BDPRECN(BDPX,0),U,3)
 .;S $E(Y,57)=$E($$VAL^XBDIQ1(200,BDPY,53.5),1,13)
 .S $E(Y,70)=$$FMTE^XLFDT($P(^BDPRECN(BDPX,0),U,5),5)
 .S BDPLIST(BDPLINE,0)=Y,BDPLIST("IDX",BDPLINE,BDPRCNT)=BDPX
 Q
 ;
EOJ ;
 D EN^XBVK("BDP")
 K DFN
 K DDSFILE,DIPGM,Y
 K X,Y,%,DR,DDS,DA,DIC
 K BDPCASE,BDPX,BDPD,BDPRCNT,BDPLINE,BDPCDATE
 D CLEAR^VALM1,FULL^VALM1
 K VALM,VALMHDR,VALMKEY,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMLST,VALMVAR,VALMLFT,VALMBCK,VALMCC,VALMAR,VALMBG,VALMCAP,VALMCOFF,VALMCNT,VALMCON,BALMON,VALMEVL,VALMIOXY
 D KILL^AUPNPAT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
HS ;EP called from protocol to generate hs
 D FULL^VALM1
 D EN^XBNEW("HS1^BDPLMUPD","BDPPAT")
 D BACK
 Q
HS1 ;EP - called from xbnew
 S X=""
 I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3) I X,$D(^APCHSCTL(X,0)) S X=$P(^APCHSCTL(X,0),U)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 K DIC,DR,DD S DIC("B")=X,DIC="^APCHSCTL(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DD,D0,D1,DQ
 I Y=-1 D PAUSE,BACK Q
 S APCHSTYP=+Y,APCHSPAT=BDPPAT
 S BDPHDR="PCC Health Summary for "_$P(^DPT(BDPPAT,0),U)
 D VIEWR^XBLM("EN^APCHS",BDPHDR)
 S (DFN,Y)=BDPPAT D ^AUPNPAT
 D BACK
 Q
 ;
BACK ;
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER
 S VALMCNT=BDPLINE
 D HDR
 Q
PAUSE ;EP
 NEW DIR
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR
 Q
 ;
EXIT ;EP
 Q
 ;
ADD ;EP - add a new dp
 D FULL^VALM1
 NEW DIC,Y,X,BDPCIEN,BDPPROV,BDPRIEN
 W !!
 S DIC="^BDPTCAT(",DIC(0)="AEMQ",DIC("A")="Enter the PROVIDER Category: " D ^DIC K DIC
 I Y<0 W !,"No updating done...." D PAUSE,BACK Q
 S BDPCIEN=+Y
 I $D(^BDPRECN("AA",BDPPAT,BDPCIEN)) S X=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0)) I $P($G(^BDPRECN(X,0)),U,3)'="" D  D PAUSE,BACK Q
 .W !!,"This patient already has a provider assigned for category ",!?5,$P(^BDPTCAT(BDPCIEN,0),U)
 .W !,"Please use the CH (Change Provider) action item to change this provider."
 ;get provider name for this category
 W !
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Enter Provider Name: ",DIC("B")=$P(^VA(200,DUZ,0),U)
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 D ^DIC K DIC
 I Y<0 W !,"No updating done...." D PAUSE,BACK Q
 S BDPPROV=+Y
 ;add new entry for this patient
 S X=$$ADD1^BDPAPI(BDPPAT,BDPCIEN)
 I 'X W !!,"error updating designated provider" D PAUSE,BACK Q
 S BDPRIEN=X
 S X=$$EDIT^BDPAPI(BDPRIEN,BDPCIEN,BDPPROV)
 I 'X W !!,"error updating designated provider" D PAUSE,BACK Q
 W !!,"Provider ",$P(^VA(200,BDPPROV,0),U)," successfully added as",!,"the designated ",$P(^BDPTCAT(BDPCIEN,0),U)," provider.",!
 D PAUSE
 D BACK
 Q
 ;
CHANGE ;EP - change existing DP
 D FULL^VALM1
 ;
 NEW DIC,Y,X,BDPCIEN,BDPPROV,BDPRIEN
 D GETITEM
 I '$G(BDPRIEN) D PAUSE,BACK Q
 I 'BDPRIEN W !,"No item selected to change." D PAUSE,BACK Q
 S BDPCIEN=$P(^BDPRECN(BDPRIEN,0),U)
 W ! S DIC("A")="Enter New Designated "_$$VAL^XBDIQ1(90360.1,BDPRIEN,.01)_": ",DIC="^VA(200,",DIC(0)="AEMQ",DIC("B")=$P(^VA(200,DUZ,0),U) D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Provider Selected." D PAUSE,BACK Q
 S BDPPROV=+Y
 I $P(^BDPRECN(BDPRIEN,0),U,3)=BDPPROV W !!,"That is the currently documented provider." D PAUSE,BACK Q
 S X=$$EDIT^BDPAPI(BDPRIEN,BDPCIEN,BDPPROV)
 I 'X W !!,"error updating designated provider" D PAUSE,BACK Q
 W !!,"Provider ",$P(^VA(200,BDPPROV,0),U)," successfully added as",!,"the designated ",$P(^BDPTCAT(BDPCIEN,0),U)," provider.",!
 D PAUSE
 D BACK
 Q
DELETE ;EP - delete exisiting DP
 D FULL^VALM1
 ;
 NEW DIC,Y,X,BDPCIEN,BDPPROV,BDPRIEN
 D GETITEM
 I '$G(BDPRIEN) D PAUSE,BACK Q
 I 'BDPRIEN W !,"No item selected to DELETE." D PAUSE,BACK Q
 S BDPCIEN=$P(^BDPRECN(BDPRIEN,0),U)
 W !!,"Are you sure you want to DELETE ",$$VAL^XBDIQ1(90360.1,BDPRIEN,.03),!?3,"as the designated ",$$VAL^XBDIQ1(90360.1,BDPRIEN,.01),"?"
 K DIR S DIR(0)="Y",DIR("A")="Please confirm",DIR("B")="N" KILL DA D ^DIR KILL DIR
 S BDPPROV=$$VALI^XBDIQ1(90360.1,BDPRIEN,.03)
 NEW DA,DIE,DR
 S DA=BDPRIEN,DIE="^BDPRECN(",DR=".03///@" D ^DIE
 W !!,"Provider ",$P(^VA(200,BDPPROV,0),U)," successfully DELETED as",!," the designated ",$P(^BDPTCAT(BDPCIEN,0),U)," provider.",!
 D PAUSE
 D BACK
 Q
 ;
GETITEM ;get record
 I 'BDPRCNT W !,"No Items to change" Q
 NEW BDPIT
 S BDPRIEN=0
 S DIR(0)="N^1:"_BDPRCNT_":0",DIR("A")="Select item to change" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BDPIT=Y
 S (X,Y)=0 F  S X=$O(BDPLIST("IDX",X)) Q:X'=+X!(BDPRIEN)  I $O(BDPLIST("IDX",X,0))=BDPIT S Y=$O(BDPLIST("IDX",X,0)),BDPRIEN=BDPLIST("IDX",X,Y)
 I '$D(^BDPRECN(BDPRIEN,0)) S BDPRIEN=0 Q
 Q
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
