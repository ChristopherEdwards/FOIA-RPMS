AUM31 ;IHS/ASDST/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2003 ; [ 09/13/2002  11:02 AM ]
 ;;03.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
START ;EP
 ;
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 S U="^"
 ;
 D RSLT("Beginning FY 2003 ICD Update.")
 D DASH,ICD9NEW,DASH,ICD9INAC,DASH,ICD9REV
 D DASH,ICD0NEW,DASH,ICD0REV,DASH
 ;D ICD0INAC,DASH
 D RSLT("End FY 2003 ICD Update.")
 Q
 ; -----------------------------------------------------
ADDOK D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
DIE NEW @($P($T(SVARS),";",3))
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR
 Q
E(L) I L="ICD9NEW" Q $P($P($T(@L^AUM31A),";",3),":",1)
 I L="ICD9VNEW" Q $P($P($T(@L^AUM31C),";",3),":",1)
 I L="ICD9ENEW" Q $P($P($T(@L^AUM31B),";",3),":",1)
 I L="ICD9REV" Q $P($P($T(@L^AUM31C),";",3),":",1)
 I L="ICD9INAC" Q $P($P($T(@L^AUM31C),";",3),":",1)
 I L="ICD9PNEW" Q $P($P($T(@L^AUM31D),";",3),":",1)
 I L="ICD9PREV" Q $P($P($T(@L^AUM31B),";",3),":",1)
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
IXDIC(DIC,DIC0,D,X,DLAYGO) NEW @($P($T(SVARS),";",3))
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 D IX^DIC
 Q Y
 ; -----------------------------------------------------
ICD9NEW ;
 D RSLT($$E("ICD9NEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 ;  loads new ICD9 CODES
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW+AUMI^AUM31A),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="3///"_$P(AUMLN,U,2)                   ;diagnosis
 . S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 . S DR=DR_";100///@"                               ;inactive flag
 . S DR=DR_";102///@"                               ;inactive date
 . S DR=DR_";9999999.04///3021001"       ;date added
 . S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 . S DR=DR_";5///"_$P(AUMLN,U,5)           ;MDC
 . S DIE="^ICD9("
 . S AUMDA=DA
 . D DIE
 . ;  this part loads the DRGs if there are any
 . S (AUMDRGS,DR)=""
 . S AUMDRGS=$P(AUMLN,U,6)
 . I $L(AUMDRGS,",")>0 D
 .. F AUMJ=1:1:$L(AUMDRGS,",") D
 ... S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ... S DR=60+(AUMJ-1)_"///"_AUMDRG
 ... S DA=AUMDA
 ... S DIE="^ICD9("
 ... D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 ;  loads NEW V-CODES
 D DASH
 D RSLT($$E("ICD9VNEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9VNEW+AUMI^AUM31C),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="3///"_$P(AUMLN,U,2)                   ;diagnosis
 . S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 . S DR=DR_";100///@"                               ;inactive flag
 . S DR=DR_";102///@"                               ;inactive date
 . S DR=DR_";9999999.04///3021001"       ;date added
 . S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 . S DR=DR_";5///"_$P(AUMLN,U,5)           ;MDC
 . S DIE="^ICD9("
 . S AUMDA=DA
 . D DIE
 . ;  this part loads the DRGs if there are any
 . S (AUMDRGS,DR)=""
 . S AUMDRGS=$P(AUMLN,U,6)
 . I $L(AUMDRGS,",")>0 D
 .. F AUMJ=1:1:$L(AUMDRGS,",") D
 ... S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ... S DR=60+(AUMJ-1)_"///"_AUMDRG
 ... S DA=AUMDA
 ... S DIE="^ICD9("
 ... D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 ;  loads new E-CODES
 D DASH
 D RSLT($$E("ICD9ENEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9ENEW+AUMI^AUM31B),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="3///"_$P(AUMLN,U,2)                   ;diagnosis
 . S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 . S DR=DR_";100///@"                               ;inactive flag
 . S DR=DR_";102///@"                               ;inactive date
 . S DR=DR_";9999999.04///3021001"       ;date added
 . S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 . S DIE="^ICD9("
 . S AUMDA=DA
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
 ; -----------------------------------------------------
ICD9INAC ;
 D RSLT($$E("ICD9INAC"))
 D RSLT($J("",8)_"CODE     DESCRIPTION")
 D RSLT($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9INAC+AUMI^AUM31C),";;",2) Q:X="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(X,U))
 . I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 . S DA=+Y,AUMDA=+Y
 . S DIE="^ICD9("
 . S DR="102///3021001"
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(^ICD9(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD9(AUMDA,0),U,3),1,30))
 .Q
 Q
 ; -----------------------------------------------------
ICD9REV ;
 D RSLT($$E("ICD9REV"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9REV+AUMI^AUM31C),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="3///"_$P(AUMLN,U,2)                   ;diagnosis
 . S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 . S DR=DR_";100///@"                               ;inactive flag
 . S DR=DR_";102///@"                               ;inactive date
 . S DR=DR_";2100000///"_DT                   ;date updated
 . S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 . S DR=DR_";5///"_$P(AUMLN,U,5)           ;MDC
 . S DIE="^ICD9("
 . S AUMDA=DA
 . D DIE
 . ;  this part loads the DRGs if there are any
 . S (AUMDRGS,DR)=""
 . S AUMDRGS=$P(AUMLN,U,6)
 . I $L(AUMDRGS,",")>0 D
 .. F AUMJ=1:1:$L(AUMDRGS,",") D
 ... S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ... S DR=60+(AUMJ-1)_"///"_AUMDRG
 ... S DA=AUMDA
 ... S DIE="^ICD9("
 ... D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
 ; -----------------------------------------------------
ICD0NEW ;
 D RSLT($$E("ICD9PNEW"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9PNEW+AUMI^AUM31D),";;",2) Q:AUMLN="END"  D 
 . S Y=$$IXDIC("^ICD0(","ILX","AB",$P(AUMLN,U))
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="4///"_$P(AUMLN,U,2)                   ;operation/procedure
 . S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 . S DR=DR_";100///@"                                ;inactive flag
 . S DR=DR_";102///@"                               ;inactive date
 . S DR=DR_";9999999.04///3021001"       ;date added
 . S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 . S DIE="^ICD0("
 . S AUMDA=DA
 . D DIE
 . ;  loads MDC and DRGs if any
 . S (AUMMANDD,AUMMDC,AUMDRGS)=""
 . S AUMMANDD=$P(AUMLN,U,5)
 . F AUMK=1:1:$L(AUMMANDD,"-") D
 .. S AUMREC=""
 .. S AUMREC=$P(AUMMANDD,"~",AUMK)
 .. S AUMMDC=$P(AUMREC,"-")
 .. S AUMDRGS=$P(AUMREC,"-",2)
 .. I $G(AUMMDC)'="" D
 ... S DIC="^ICD0("_AUMDA_",""MDC"","
 ... S DIC("P")=$P(^DD(80.1,7,0),U,2)
 ... S DA(1)=AUMDA
 ... S DIC(0)="LXI"
 ... S DLAYGO=80.1
 ... S X=AUMMDC
 ... D ^DIC
 ... I AUMDRGS="" K Y
 ... I +$G(Y)>0,$G(AUMDRGS)'="" D
 .... F AUMJ=1:1:$L(AUMDRGS,",") D
 ..... S AUMDRG=$P(AUMDRGS,",",AUMJ)
 ..... S DR=AUMJ_"///"_AUMDRG
 ..... S DA=AUMMDC
 ..... S DIE="^ICD0("_AUMDA_",""MDC"","
 ..... D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
 ;
 ; -----------------------------------------------------
ICD0REV ;
 D RSLT($$E("ICD9PREV"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9PREV+AUMI^AUM31B),";;",2) Q:AUMLN="END"  D
 . S Y=$$IXDIC("^ICD0(","ILX","AB",$P(AUMLN,U))
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="4///"_$P(AUMLN,U,2)                   ;operation/procedure
 . S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 . S DR=DR_";100///@"                                ;inactive flag
 . S DR=DR_";102///@"                               ;inactive date
 . S DR=DR_";2100000///"_DT                   ;date updated
 . S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 . S DIE="^ICD0("
 . S AUMDA=DA
 . D DIE
 . ;  loads MDC and DRGs if any
 . S (AUMMANDD,AUMMDC,AUMDRGS)=""
 . S AUMMANDD=$P(AUMLN,U,5)
 . F AUMK=1:1:$L(AUMMANDD,"-") D
 .. S AUMREC=""
 .. S AUMREC=$P(AUMMANDD,"~",AUMK)
 .. S AUMMDC=$P(AUMREC,"-")
 .. S AUMDRGS=$P(AUMREC,"-",2)
 .. I $G(AUMMDC)'="" D
 ... S DIC="^ICD0("_AUMDA_",""MDC"","
 ... S DIC("P")=$P(^DD(80.1,7,0),U,2)
 ... S DA(1)=AUMDA
 ... S DIC(0)="LXI"
 ... S DLAYGO=80.1
 ... S X=AUMMDC
 ... D ^DIC
 ... I AUMDRGS="" K Y
 ... I +$G(Y)>0,$G(AUMDRGS)'="" D
 .... F AUMJ=1:1:$L(AUMDRGS,",") D
 ..... S AUMDRG=$P(AUMDRGS,",",AUMJ)
 ..... S DR=AUMJ_"///"_AUMDRG
 ..... S DA=AUMMDC
 ..... S DIE="^ICD0("_AUMDA_",""MDC"","
 ..... D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
ICD0INAC ;
 D RSLT($$E("ICD9INAC"))
 D RSLT($J("",8)_"CODE     DESCRIPTION")
 D RSLT($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD0INAC+AUMI^AUM31C),";;",2) Q:X="END"  D
 . S Y=$$IXDIC("^ICD9(","ILX","AB",X)
 . I Y=-1 D RSLT(" CODE '"_X_"' not found (that's OK).") Q
 . S DA=+Y
 . S DIE="^ICD9("
 . S DR="102///3021001"
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(^ICD9(DA,0),U,1)_$J("",4)_$E($P(^ICD9(DA,0),U,3),1,30))
 .Q
 Q
