BGOREPCV ; IHS/MSC/MGH - RECONVERT REPRODUCTIVE FACTORS;25-May-2010 11:21;MGH
 ;;1.1;BGO COMPONENTS;**6**;Mar 20, 2007
 ;
CONVRH ;EP - called from post init
 NEW BGOX,BGOY,BGOZ
 D EN^DDIOL("Rechecking conversion of Reproductive History field to individual field values","","!!")
 S BGOX=0 F  S BGOX=$O(^AUPNREP(BGOX)) Q:BGOX'=+BGOX  D
 .S BGOY=$P(^AUPNREP(BGOX,0),U,2)
 .Q:BGOY=""
 .Q:$E(BGOY,1,2)="G0"
 .S BGOZ=$$PARSERHS^AUPNREP(BGOY)
 .Q:BGOZ=""
 .D ^XBFMK
 .S DIE="^AUPNREP(",DA=BGOX,DR="1103///"_$P(BGOZ,U,1)_";1107///"_$P(BGOZ,U,2)_";1113///"_$P(BGOZ,U,3)_";1133///"_$P(BGOZ,U,4)_";1131///"_$P(BGOZ,U,5)_";1///@"
 .D ^DIE
 .I $D(Y) D EN^DDIOL("Entry "_BGOX_" failed")
 .D ^XBFMK
 Q
