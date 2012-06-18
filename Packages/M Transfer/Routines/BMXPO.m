BMXPO ; IHS/CMI/MAW - Populate appcontext with all namespaced RPC's ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
MAIN ;EP - this is the main routine driver
 N BMXQFLG
 D ASK
 I $G(BMXQFLG) D XIT Q
 ;D CLEAN(BMXAPP)
 D POP(BMXAPP,BMXNS)
 D XIT
 Q
 ;
GUIEP(RETVAL,BMXSTR) ;EP - gui entry point
 N P,BMXAPP,BMXNS
 S P="|"
 S BMXGUI=1
 S BMXAPP=$P(BMXSTR,P)
 S BMXNS=$P(BMXSTR,P,2)
 K ^BMXTMP($J)
 S RETVAL="^BMXTMP("_$J_")"
 S ^BMXTMP($J,0)="T00250DATA"_$C(30)
 ;D CLEAN(BMXAPP)
 D POP(BMXAPP,BMXNS)
 D XIT
 Q
 ;
ASK ;-- ask the name of the OPTION to populate
 W !
 S DIC=19,DIC(0)="AEMQZ",DIC("A")="Populate which Application Context: "
 D ^DIC
 I '$G(Y) S BMXQFLG=1 Q
 S BMXAPP=+Y
 W !
 K DIC
 S DIR(0)="F^1:3",DIR("A")="Populate RPC's from which Namespace: "
 D ^DIR
 I $D(DIRUT) S BMXQFLG=1 Q
 S BMXNS=$G(Y)
 Q
 ;
CLEAN(APP) ;-- clean out the RPC multiple first
 S DA(1)=APP
 S DIK="^DIC(19,"_DA(1)_","_"""RPC"""_","
 N BMXDA
 S BMXDA=0 F  S BDMDA=$O(^DIC(19,APP,"RPC",BMXDA)) Q:'BMXDA  D
 . S DA=BMXDA
 . D ^DIK
 K ^DIC(19,APP,"RPC","B")
 Q
 ;
POP(APP,NS) ;populate the app context with RPC's
 I '$G(BMXGUI) W !,"Populating Application Context"
 N BMXDA
 S BMXDA=NS
 F  S BMXDA=$O(^XWB(8994,"B",BMXDA)) Q:BMXDA=""!($E(BMXDA,1,3)'=NS)  D
 . N BMXIEN
 . S BMXIEN=0 F  S BMXIEN=$O(^XWB(8994,"B",BMXDA,BMXIEN)) Q:'BMXIEN  D
 .. Q:$O(^DIC(19,APP,"RPC","B",BMXIEN,0))
 .. N BDMIENS,BDMFDA,BDMERR
 .. S BDMIENS(1)=APP
 .. S BDMIENS="+2,"_APP_","
 .. S BDMFDA(19.05,BDMIENS,.01)=BMXIEN
 .. D UPDATE^DIE("","BDMFDA","BDMIENS","BDMERR(1)")
 .. I '$G(BMXGUI) W "."
 Q
 ;
XIT ;-- clean vars
 D EN^XBVK("BMX")
 Q
 ;
