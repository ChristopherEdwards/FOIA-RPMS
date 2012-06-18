AUM111 ;IHS/SD/RNB - ICD 9 CODES FOR FY 2012 ; [ 09/09/2010  8:30 AM ]
 ;;12.0;TABLE MAINTENANCE;;SEP 27,2011
START ;EP
 I $$VERSION^XPDUTL("BCSV")>0 D ^AUM111RL Q  ;if BCSV is loaded for 2011 ICD codes
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 S U="^"
 D RSLT("Beginning FY 2012 ICD Update.")
 D DASH,ICD9NEW
 D DASH,ICD9REV
 D DASH,ICD9INAC
 D DASH,ICD0NEW
 D DASH,ICD0REV
 D DASH,ICD0INAC
 D DASH
 D RSLT("End FY 2012 ICD Update.")
 Q
ADDOK D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
DIE ;EP
 NEW @($P($T(SVARS),";",3))
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR
 Q
E(L) I L="ICD9NEW" Q $P($P($T(@L^AUM111A),";",3),":",1)
 I L="ICD9VNEW" Q $P($P($T(@L^AUM111E),";",3),":",1)
 I L="ICD9ENEW" Q $P($P($T(@L^AUM111B),";",3),":",1)
 I L="ICD9REV" Q $P($P($T(@L^AUM111C),";",3),":",1)
 I L="ICD9DINA" Q $P($P($T(@L^AUM111D),";",3),":",1)
 I L="ICD9EINA" Q $P($P($T(@L^AUM111D),";",3),":",1)
 I L="ICD9PNEW" Q $P($P($T(@L^AUM111D),";",3),":",1)
 I L="ICD9PREV" Q $P($P($T(@L^AUM111E),";",3),":",1)
 I L="ICD9PINA" Q $P($P($T(@L^AUM111E),";",3),":",1)
 I L="ICD9OINA" Q $P($P($T(@L^AUM111D),";",3),":",1)
 I L="ICD0OREV" Q $P($P($T(@L^AUM111C),";",3),":",1)
 I L="ICD9OREV" Q $P($P($T(@L^AUM111C),";",3),":",1)
DIK NEW @($P($T(SVARS),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2104",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS),";",3)) D MES^XPDUTL(%)
 Q
IXDIC(DIC,DIC0,D,X,DLAYGO,DINUM) ;EP
 NEW @($P($T(SVARS),";",3))
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 D IX^DIC
 Q Y
ICD9NEW ;
 D RSLT($$E("ICD9NEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 ;  loads new ICD9 CODES
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW+AUMI^AUM111A),";;",2) Q:AUMLN="END"  D ICD9NPRC
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW2+AUMI^AUM111E),";;",2) Q:AUMLN="END"  D ICD9NPRC
 D NEWVCODS
 Q
ICD9NPRC ;
 S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 S DA=+Y
 S DR="3///"_$P(AUMLN,U,2)       ;diagnosis
 S DR=DR_";10///"_$P(AUMLN,U,3)  ;description
 S DR=DR_";100///@"              ;inactive flag
 S DR=DR_";102///@"              ;inactive date
 S DR=DR_";9999999.04///3111001" ;date added
 S DR=DR_";9.5///"_$P(AUMLN,U,4) ;use with sex
 S DR=DR_";5///"_$P(AUMLN,U,5)   ;MDC
 I $P(AUMLN,U,7)=1 S DR=DR_";70///1"  ;complication/comorbidity
 S DIE="^ICD9("
 S AUMDA=DA
 D DIE
 ;  this part loads DRGs if there are any
 S (AUMDRG,AUMDRGS,DR)=""
 S AUMDRGS=$P(AUMLN,U,6)
 I $L(AUMDRGS,",")>0 D
 .F AUMJ=1:1:$L(AUMDRGS,",") D
 ..S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ..S DR=60+(AUMJ-1)_"///"_AUMDRG
 ..S DA=AUMDA
 ..S DIE="^ICD9("
 ..D DIE
 F AUMJ=AUMJ:1:6 D
 .S DR=60+(AUMJ)_"////@"
 .S DA=AUMDA
 .S DIE="^ICD9("
 .D DIE
 I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 ;remove any data in OTHER WORDS or TAXONOMY
 I $D(^ICD9(AUMDA,9999999.21,0)) D
 .S AUMO=0
 .F  S AUMO=$O(^ICD9(AUMDA,9999999.21,AUMO)) Q:+AUMO=0  D
 ..S DA(1)=AUMDA
 ..S DA=AUMO
 ..S DIK="^ICD9("_DA(1)_",9999999.21,"
 ..D ^DIK
 I $D(^ICD9(AUMDA,9999999.41,0)) D
 .S AUMO=0
 .F  S AUMO=$O(^ICD9(AUMDA,9999999.41,AUMO)) Q:+AUMO=0  D
 ..S DA(1)=AUMDA
 ..S DA=AUMO
 ..S DIK="^ICD9("_DA(1)_",9999999.41,"
 ..D ^DIK
 Q
NEWVCODS ;  loads NEW V-CODES
 D DASH
 D RSLT($$E("ICD9VNEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9VNEW+AUMI^AUM111E),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 .I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="3///"_$P(AUMLN,U,2)       ;diagnosis
 .S DR=DR_";10///"_$P(AUMLN,U,3)  ;description
 .S DR=DR_";100///@"              ;inactive flag
 .S DR=DR_";102///@"              ;inactive date
 .S DR=DR_";9999999.04///3111001" ;date added
 .S DR=DR_";9.5///"_$P(AUMLN,U,4) ;use with sex
 .S DR=DR_";5///"_$P(AUMLN,U,5)   ;MDC
 .S DIE="^ICD9("
 .S AUMDA=DA
 .D DIE
 .;  this part loads the DRGs if there are any
 .S (AUMDRGS,DR)=""
 .S AUMDRGS=$P(AUMLN,U,6)
 .I $L(AUMDRGS,",")>0 D
 ..F AUMJ=1:1:$L(AUMDRGS,",") D
 ...S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ...S DR=60+(AUMJ-1)_"///"_AUMDRG
 ...S DA=AUMDA
 ...S DIE="^ICD9("
 ...D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 ;  loads new E-CODES
 D DASH
 D RSLT($$E("ICD9ENEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9ENEW+AUMI^AUM111B),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 .I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="3///"_$P(AUMLN,U,2)        ;diagnosis
 .S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 .S DR=DR_";100///@"               ;inactive flag
 .S DR=DR_";102///@"               ;inactive date
 .S DR=DR_";9999999.04///3111001"  ;date added
 .S DR=DR_";9.5///"_$P(AUMLN,U,4)  ;use with sex
 .S DIE="^ICD9("
 .S AUMDA=DA
 .D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
ICD9INAC ;
 D RSLT($$E("ICD9DINA"))
 D RSLT($J("",8)_"CODE     DESCRIPTION")
 D RSLT($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9DINA+AUMI^AUM111D),";;",2) Q:X="END"  D
 .S Y=$$IXDIC("^ICD9(","ILX","AB",$P(X,U))
 .I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 .S DA=+Y,AUMDA=+Y
 .S DIE="^ICD9("
 .S DR="102///3111001"
 .S DR=DR_";100////1"
 .D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(^ICD9(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD9(AUMDA,0),U,3),1,30))
 .Q
 ;inact. E-CODES
 D DASH
 D RSLT($$E("ICD9EINA"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR,X
 F AUMI=1:1 S AUMLN=$P($T(ICD9EINA+AUMI^AUM111D),";;",2) Q:AUMLN="END"  D
 .S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U))
 .I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 .S DA=+Y,AUMDA=+Y
 .S DIE="^ICD9("
 .S DR="102///3111001"
 .S DR=DR_";100////1"
 .D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(^ICD9(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD9(AUMDA,0),U,3),1,30))
 .Q
 Q
ICD9OINA ;
 D RSLT($$E("ICD9OINA"))
 D RSLT($J("",8)_"CODE     DESCRIPTION")
 D RSLT($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9OINA+AUMI^AUM111D),";;",2) Q:X="END"  D
 .S Y=$$IXDIC("^ICD9(","ILX","AB",$P(X,U))
 .I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 .S DA=+Y,AUMDA=+Y
 .S DIE="^ICD9("
 .S DR="102///3111001"
 .S DR=DR_";100////1"
 .D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(^ICD9(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD9(AUMDA,0),U,3),1,30))
 .Q
 Q
ICD9REV ;
 D RSLT($$E("ICD9REV"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9REV+AUMI^AUM111C),";;",2) Q:AUMLN="END"  D PROCESS
 Q
PROCESS S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 S DA=+Y
 S DR="3///"_$P(AUMLN,U,2)        ;diagnosis
 S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 S DR=DR_";100///@"               ;inactive flag
 S DR=DR_";102///@"               ;inactive date
 ;;S DR=DR_";2100000///3111001"     ;date updated
 S DR=DR_";2100000///"_DT     ;date updated
 S DR=DR_";9.5///"_$P(AUMLN,U,4)  ;use with sex
 S DR=DR_";5///"_$P(AUMLN,U,5)    ;MDC
 I $P(AUMLN,U,7)=1 S DR=DR_";70///1"  ;complication/comorbidity
 S DIE="^ICD9("
 S AUMDA=DA
 D DIE
 ;clear DRGs in case there are less than before
 F AUMJ=60:1:65 D
 .S DIE="^ICD9("
 .S DA=AUMDA
 .S DR=AUMJ_"////@"
 .D ^DIE
 ;  this part loads the DRGs if there are any
 S (AUMDRGS,DR)=""
 S AUMDRGS=$P(AUMLN,U,6)
 I $L(AUMDRGS,",")>0 D
 .F AUMJ=1:1:$L(AUMDRGS,",") D
 ..S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ..S DR=60+(AUMJ-1)_"///"_AUMDRG
 ..S DA=AUMDA
 ..S DIE="^ICD9("
 ..D DIE
 I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 Q
ICD0NEW ;
 D RSLT($$E("ICD9PNEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9PNEW+AUMI^AUM111D),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC("^ICD0(","ILX","AB",$P(AUMLN,U))
 .I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="4///"_$P(AUMLN,U,2)       ;operation/procedure
 .S DR=DR_";10///"_$P(AUMLN,U,3)  ;description
 .S DR=DR_";100///@"              ;inactive flag
 .S DR=DR_";102///@"              ;inactive date
 .S DR=DR_";9999999.04///3111001" ;date added
 .S DR=DR_";9.5///"_$P(AUMLN,U,4) ;use with sex
 .S DIE="^ICD0("
 .S AUMDA=DA
 .D DIE
 .;  loads MDC and DRGs if any
 .S (AUMMANDD,AUMMDC,AUMDRGS)=""
 .S AUMMANDD=$P(AUMLN,U,5)
 .F AUMK=1:1:$L(AUMMANDD,"-") D
 ..S AUMREC=""
 ..S AUMREC=$P(AUMMANDD,"~",AUMK)
 ..S AUMMDC=$P(AUMREC,"-")
 ..S AUMDRGS=$P(AUMREC,"-",2)
 ..I $G(AUMMDC)'="" D
 ...K DIC
 ...S DIC="^ICD0("_AUMDA_",""MDC"","
 ...S DIC("P")=$P(^DD(80.1,7,0),U,2)
 ...S DA(1)=AUMDA
 ...S DIC(0)="LXI"
 ...S DLAYGO=80.1
 ...S X=AUMMDC
 ...D ^DIC
 ...I AUMDRGS="" K Y
 ...I +$G(Y)>0,$G(AUMDRGS)'="" D
 ....F AUMJ=1:1:$L(AUMDRGS,",") D
 .....S AUMDRG=$P(AUMDRGS,",",AUMJ)
 .....S DR=AUMJ_"///"_AUMDRG
 .....S DA=AUMMDC
 .....S DIE="^ICD0("_AUMDA_",""MDC"","
 .....D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
ICD0REV ;
 D RSLT($$E("ICD9PREV"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9PREV+AUMI^AUM111E),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC("^ICD0(","ILX","AB",$P(AUMLN,U))
 .I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="4///"_$P(AUMLN,U,2)        ;operation/procedure
 .S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 .S DR=DR_";100///@"               ;inactive flag
 .S DR=DR_";102///@"               ;inactive date
 .;;S DR=DR_";2100000///3111001"     ;date updated
 .S DR=DR_";2100000///"_DT     ;date updated
 .S DR=DR_";9.5///"_$P(AUMLN,U,4)  ;use with sex
 .S DIE="^ICD0("
 .S AUMDA=DA
 .D DIE
 .;  loads MDC and DRGs if any
 .K ^ICD0(AUMDA,"MDC")  ;clear existing entries
 .S (AUMMANDD,AUMMDC,AUMDRGS)=""
 .S AUMMANDD=$P(AUMLN,U,5)
 .F AUMK=1:1:$L(AUMMANDD,"-") D
 ..S AUMREC=""
 ..S AUMREC=$P(AUMMANDD,"~",AUMK)
 ..S AUMMDC=$P(AUMREC,"-")
 ..S AUMDRGS=$P(AUMREC,"-",2)
 ..I $G(AUMMDC)'="" D
 ...S DIC="^ICD0("_AUMDA_",""MDC"","
 ...S DIC("P")=$P(^DD(80.1,7,0),U,2)
 ...S DA(1)=AUMDA
 ...S DIC(0)="LXI"
 ...S DLAYGO=80.1
 ...S X=AUMMDC
 ...D ^DIC
 ...I AUMDRGS="" K Y
 ...I +$G(Y)>0,$G(AUMDRGS)'="" D
 ....F AUMJ=1:1:$L(AUMDRGS,",") D
 .....S AUMDRG=$P(AUMDRGS,",",AUMJ)
 .....S DR=AUMJ_"///"_AUMDRG
 .....S DA=AUMMDC
 .....S DIE="^ICD0("_AUMDA_",""MDC"","
 .....D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
ICD0INAC ;
 D RSLT($$E("ICD9PINA"))
 D RSLT($J("",8)_"CODE     DESCRIPTION")
 D RSLT($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9PINA+AUMI^AUM111E),";;",2) Q:X="END"  D
 .S Y=$$IXDIC("^ICD0(","ILX","AB",$P(X,U))
 .I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 .S DA=+Y
 .S DIE="^ICD0("
 .S DR="102///3111001"
 .S DR=DR_";100////1"
 .S AUMDA=DA
 .D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(X,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(^ICD0(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD0(AUMDA,0),U,4),1,30))
 .Q
 Q
