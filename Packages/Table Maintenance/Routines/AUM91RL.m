AUM91RL ;IHS/SD/DMJ,SDR - ICD 9 CODES FOR FY 2009 ; [ 08/18/2003  11:02 AM ]
 ;;10.2;TABLE MAINTENANCE;;MAR 09, 2010
START ;EP
 ;
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 S U="^"
 D RSLT^AUM91RL1("Beginning AUM*9.1 RELOAD, ICD Update.")
 D DRGS^AUM91E  ;update DRGs
 D DASH^AUM91RL1,ICD9NEW
 D DASH^AUM91RL1,ICD9REV
 D DASH^AUM91RL1,ICD9INAC
 D DASH^AUM91RL1,ICD0NEW
 D DASH^AUM91RL1,ICD0REV
 D DASH^AUM91RL1,ICD0INAC
 ;D DASH^AUM91RL1,ICD9OREV
 ;D DASH^AUM91RL1,ICD0OREV
 D DASH^AUM91RL1
 D RSLT^AUM91RL1("End AUM*9.1 RELOAD ICD Update.")
 Q
 ; ---------------------------------
ICD9NEW ;
 D RSLT^AUM91RL1("ICD 9 DIAGNOSIS, NEW CODES:")  ;("ICD9NEW")
 D RSLT^AUM91RL1($J("",8)_"CODE      DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----      -----------")
 ;  loads new ICD9 CODES
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW+AUMI^AUM91A),";;",2) Q:AUMLN="END"  D ICD9NPRC
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW2+AUMI^AUM91E),";;",2) Q:AUMLN="END"  D ICD9NPRC
 F AUMI=1:1 S AUMLN=$P($T(ICD9NEW3+AUMI^AUM91F),";;",2) Q:AUMLN="END"  D ICD9NPRC
 D NEWVCODS
 Q
ICD9NPRC ;
 S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 I Y=-1 D RSLT^AUM91RL1("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 S DA=+Y
 S DR="3///"_$P(AUMLN,U,2)                   ;diagnosis
 S DR=DR_";10///"_$P(AUMLN,U,3)         ;description
 ;
 S DR=DR_";100////@"                               ;inactive flag
 S DR=DR_";102////@"                               ;inactive date
 ;
 S DR=DR_";9999999.04///3081001"       ;date added
 S DR=DR_";16///3081001"  ;activation date
 ;
 S DR=DR_";9.5///"_$P(AUMLN,U,4)        ;use with sex
 S DR=DR_";5///"_$P(AUMLN,U,5)           ;MDC
 S DIE="^ICD9("
 S AUMDA=DA
 D DIE^AUM91RL1
 ;
 ;effective date multiple
 D EFFDTMUL("NEW")
 ;diagnosis multiple
 D SDSCMULT("NEW")
 ;description multiple
 D DESCMULT("NEW")
 ;
 ;  this part loads DRGs if there are any
 S (AUMDRG,AUMDRGS,DR)=""
 S AUMDRGS=$P(AUMLN,U,6)
 I $L(AUMDRGS,",")>0 D
 .F AUMJ=1:1:$L(AUMDRGS,",") D
 ..S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ..S DR=60+(AUMJ-1)_"///"_AUMDRG
 ..S DA=AUMDA
 ..S DIE="^ICD9("
 ..D DIE^AUM91RL1
 F AUMJ=AUMJ:1:5 D
 .S DR=60+(AUMJ)_"////@"
 .S DA=AUMDA
 .S DIE="^ICD9("
 .D DIE^AUM91RL1
 I $D(Y) D RSLT^AUM91RL1("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 D RSLT^AUM91RL1($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
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
 D DASH^AUM91RL1
 D RSLT^AUM91RL1("ICD 9 DIAGNOSIS, NEW V-CODES:")  ;("ICD9VNEW")
 D RSLT^AUM91RL1($J("",8)_"CODE      DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9VNEW+AUMI^AUM91E),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 .I Y=-1 D RSLT^AUM91RL1("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="3///"_$P(AUMLN,U,2)   ;diagnosis
 .S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 .;
 .S DR=DR_";100///@"   ;inactive flag
 .S DR=DR_";102///@"   ;inactive date
 .S DR=DR_";9999999.04///3081001"   ;date added
 .;
 .S DR=DR_";9.5///"_$P(AUMLN,U,4)   ;use with sex
 .S DR=DR_";5///"_$P(AUMLN,U,5)     ;MDC
 .S DIE="^ICD9("
 .S AUMDA=DA
 .D DIE^AUM91RL1
 .;
 .;effective date multiple
 .K AUMFLG
 .D EFFDTMUL("NEW")
 .;diagnosis multiple
 .D SDSCMULT("NEW")
 .;description multiple
 .D DESCMULT("NEW")
 .;
 .;  this part loads the DRGs if there are any
 .S (AUMDRGS,DR)=""
 .S AUMDRGS=$P(AUMLN,U,6)
 .I $L(AUMDRGS,",")>0 D
 ..F AUMJ=1:1:$L(AUMDRGS,",") D
 ...S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ...S DR=60+(AUMJ-1)_"///"_AUMDRG
 ...S DA=AUMDA
 ...S DIE="^ICD9("
 ...D DIE^AUM91RL1
 .I $D(Y)!$G(AUMFLG) D RSLT^AUM91RL1("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT^AUM91RL1($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 ;loads new E-CODES
 D DASH^AUM91RL1
 D RSLT^AUM91RL1("ICD 9, NEW/REVISED E-CODES:")  ;("ICD9ENEW")
 D RSLT^AUM91RL1($J("",8)_"CODE      DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9ENEW+AUMI^AUM91B),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 .I Y=-1 D RSLT^AUM91RL1("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="3///"_$P(AUMLN,U,2)   ;diagnosis
 .S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 .S DR=DR_";100///@"   ;inactive flag
 .S DR=DR_";102///@"   ;inactive date
 .S DR=DR_";9999999.04///3081001"   ;date added
 .S DR=DR_";9.5///"_$P(AUMLN,U,4)   ;use with sex
 .S DIE="^ICD9("
 .S AUMDA=DA
 .D DIE^AUM91RL1
 .;
 .;effective date multiple
 .K AUMFLG
 .D EFFDTMUL("NEW")
 .;diagnosis multiple
 .D SDSCMULT("NEW")
 .;description multiple
 .D DESCMULT("NEW")
 .;
 .I $G(AUMFLG) D RSLT^AUM91RL1("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT^AUM91RL1($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
 ;
ICD9INAC ;
 D RSLT^AUM91RL1("ICD 9 DIAGNOSIS, INACTIVE CODES:")  ;("ICD9DINA")
 D RSLT^AUM91RL1($J("",8)_"CODE     DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9DINA+AUMI^AUM91D),";;",2) Q:X="END"  D
 .S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(X,U)_" ")
 .I Y=-1 D RSLT^AUM91RL1(" CODE '"_X_"' not found (that's OK).") Q
 .S DA=+Y,AUMDA=+Y
 .S DIE="^ICD9("
 .S DR="102///3081001"  ;inactive date
 .S DR=DR_";100////1"  ;inactive flag
 .D DIE^AUM91RL1
 .;effective date multiple
 .K AUMFLG
 .K DIC,DIE,DA,X,Y
 .S DA(1)=AUMDA
 .S DIC="^ICD9("_DA(1)_",66,"
 .S DIC("P")=$P(^DD(80,66,0),U,2)
 .S DIC(0)="L"
 .S X="3081001"  ;use active date of 10/01/2008
 .S DIC("DR")=".02////0"
 .D ^DIC
 .I $G(AUMFLG) D RSLT^AUM91RL1("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(X,U)_"' FAILED.") Q
 .D RSLT^AUM91RL1($J("",8)_$P(^ICD9(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD9(AUMDA,0),U,3),1,30))
 .Q
 Q
 ;
ICD9OINA ;
 D RSLT^AUM91RL1("ICD 9 DIAGNOSIS, OTHER INACTIVATED CODES:")  ;("ICD9OINA")
 D RSLT^AUM91RL1($J("",8)_"CODE     DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----     -----------")
 NEW AUMI,DA,DIE,DR,X
 F AUMI=1:1 S X=$P($T(ICD9OINA+AUMI^AUM91D),";;",2) Q:X="END"  D
 .S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(X,U))
 .I Y=-1 D RSLT^AUM91RL1(" CODE '"_X_"' not found (that's OK).") Q
 .S DA=+Y,AUMDA=+Y
 .S DIE="^ICD9("
 .S DR="102///3081001"  ;inactive date
 .S DR=DR_";100////1"  ;inactive flag
 .D DIE^AUM91RL1
 .;effective date multiple
 .K DIC,DIE,DA,X,Y
 .S DA(1)=AUMDA
 .S DIC="^ICD9("_DA(1)_",66,"
 .S DIC("P")=$P(^DD(80,66,0),U,2)
 .S DIC(0)="L"
 .S X="3081001"  ;use active date of 10/01/2008
 .S DIC("DR")=".02////0"
 .D ^DIC
 .I $D(Y) D RSLT^AUM91RL1("ERROR:  Edit of INACTIVE DATE field for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT^AUM91RL1($J("",8)_$P(^ICD9(AUMDA,0),U,1)_$J("",4)_$E($P(^ICD9(AUMDA,0),U,3),1,30))
 .Q
 Q
 ;
ICD9REV ;
 D RSLT^AUM91RL1("ICD9REV")
 D RSLT^AUM91RL1($J("",8)_"CODE      DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9REV+AUMI^AUM91C),";;",2) Q:AUMLN="END"  D PROCESS
 Q
 ;
PROCESS S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(AUMLN,U)_" ",80)
 I Y=-1 D RSLT^AUM91RL1("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 S DA=+Y
 S DR="3///"_$P(AUMLN,U,2)   ;diagnosis
 S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 ;
 S DR=DR_";100///@"   ;inactive flag
 S DR=DR_";102///@"   ;inactive date
 S DR=DR_";2100000///"_DT   ;date updated
 ;
 S DR=DR_";9.5///"_$P(AUMLN,U,4)   ;use with sex
 S DR=DR_";5///"_$P(AUMLN,U,5)     ;MDC
 S DIE="^ICD9("
 S AUMDA=DA
 D DIE^AUM91RL1
 ;effective date multiple
 D EFFDTMUL("REV")
 ;diagnosis multiple
 D SDSCMULT("REV")
 ;description multiple
 D DESCMULT("REV")
 ;
 ;clear DRGs in case there are less than before
 F AUMJ=60:1:65 D
 .S DIE="^ICD9("
 .S DA=AUMDA
 .S DR=AUMJ_"////@"
 .D ^DIE
 ;
 ;  this part loads the DRGs if there are any
 S (AUMDRGS,DR)=""
 S AUMDRGS=$P(AUMLN,U,6)
 I $L(AUMDRGS,",")>0 D
 .F AUMJ=1:1:$L(AUMDRGS,",") D
 ..S AUMDRG=$TR($P(AUMDRGS,",",AUMJ)," ")
 ..S DR=60+(AUMJ-1)_"///"_AUMDRG
 ..S DA=AUMDA
 ..S DIE="^ICD9("
 ..D DIE^AUM91RL1
 I $D(Y) D RSLT^AUM91RL1("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 D RSLT^AUM91RL1($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 Q
 ;
ICD9OREV ;
 D RSLT^AUM91RL1("ICD 9 DIAGNOSIS, OTHER MODIFIED CODE TITLES:")  ;("ICD9OREV")
 D RSLT^AUM91RL1($J("",8)_"CODE      DESCRIPTION")
 D RSLT^AUM91RL1($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9OREV+AUMI^AUM91C),";;",2) Q:AUMLN="END"  D
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC^AUM91RL1("^ICD9(","ILX","AB",$P(AUMLN,U),80)
 .I Y=-1 D RSLT^AUM91RL1("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="3///"_$P(AUMLN,U,2)   ;diagnosis
 .S DR=DR_";10///"_$P(AUMLN,U,3)  ;description
 .;
 .S DR=DR_";100///@"   ;inactive flag
 .S DR=DR_";102///@"   ;inactive date
 .S DR=DR_";2100000///"_DT   ;date updated
 .;
 .S DR=DR_";9.5///"_$P(AUMLN,U,4)   ;use with sex
 .S DR=DR_";5///"_$P(AUMLN,U,5)   ;MDC
 .S DIE="^ICD9("
 .S AUMDA=DA
 .D DIE^AUM91RL1
 ;effective date multiple
 D EFFDTMUL("REV")
 ;diagnosis multiple
 D SDSCMULT("REV")
 ;description multiple
 D DESCMULT("REV")
 Q
 ;
 ;
EFFDTMUL(AUMX) ;
 ;effective date multiple
 S AUMLDT=0
 S AUMLDT=$O(^ICD9(AUMDA,66,"B",9999999),-1)  ;get last date in multiple
 I +AUMLDT>0 D  ;entry exists; check if status is correct (active)
 .S AUMMIEN=$O(^ICD9(AUMDA,66,"B",AUMLDT,0))
 .I +AUMMIEN=0 S AUMLDT=0 Q  ;quit if incomplete entry for some reason
 .I AUMX="REV",(AUMLDT=3081001) Q  ;already has 10/01/2008 entry
 .I $P($G(^ICD9(AUMDA,66,AUMMIEN,0)),U,2)=1 Q  ;already active
 .S AUMLDT=0  ;set date to zero so it will add entry
 I +AUMLDT=0 D  ;no entry or needs a new entry
 .K DIC,DIE,DA,X,Y
 .S DA(1)=AUMDA
 .S DIC="^ICD9("_DA(1)_",66,"
 .S DIC("P")=$P(^DD(80,66,0),U,2)
 .S DIC(0)="L"
 .S X="3081001"  ;use active date of 10/01/2008
 .S DIC("DR")=".02////1"
 .D ^DIC
 Q
 ;
DESCMULT(AUMX) ;
 S AUMODESC=""
 S AUMLDT=0
 S AUMLDT=$O(^ICD9(AUMDA,68,"B",9999999),-1)
 I +AUMLDT>0 D  ;there is an entry
 .S AUMMIEN=$O(^ICD9(AUMDA,68,"B",AUMLDT,0))
 .I +AUMMIEN=0 S AUMLDT=0  Q
 .I AUMX="REV",(AUMLDT=3081001) Q  ;already has 10/01/2008 entry
 .I $P($G(^ICD9(AUMDA,68,AUMMIEN,0)),U)=$P(AUMLN,U,3) Q
 .S AUMLDT=0
 I +AUMLDT=0 D  ;no entry or needs a new entry
 .K DIC,DIE,DA,X,Y
 .S DA(1)=AUMDA
 .S DIC="^ICD9("_DA(1)_",68,"
 .S DIC("P")=$P(^DD(80,68,0),U,2)
 .S DIC(0)="L"
 .S X="3081001"  ;use active date of 10/01/2008
 .S DIC("DR")="1////"_$P(AUMLN,U,3)  ;description
 .D ^DIC
 Q
 ;
SDSCMULT(AUMX) ;
 S AUMLDT=0
 S AUMLDT=$O(^ICD9(AUMDA,67,"B",9999999),-1)  ;get last entry
 I +AUMLDT>0 D  ;there is an entry
 .S AUMMIEN=$O(^ICD9(AUMDA,67,"B",AUMLDT,0))
 .I +AUMMIEN=0 S AUMLDT=0 Q  ;quit if incomplete entry
 .I AUMX="REV",(AUMLDT=3081001) Q  ;already has 10/01/2008 entry
 .I $P($G(^ICD0(AUMDA,67,AUMMIEN,0)),U,2)=$P(AUMLN,U,2) Q
 .S AUMLDT=0  ;set date to zero so it will add entry
 I +AUMLDT=0 D  ;no entry or needs a new entry
 .K DIC,DIE,DA,X,Y
 .S DA(1)=AUMDA
 .S DIC="^ICD9("_DA(1)_",67,"
 .S DIC("P")=$P(^DD(80,67,0),U,2)
 .S DIC(0)="L"
 .S X="3081001"  ;use active date of 10/01/2008
 .S DIC("DR")="1////"_$P(AUMLN,U,2)  ;diagnosis
 .D ^DIC
 Q
 ;
 ;
ICD0NEW ;
 D ICD0NEW^AUM91RL2
 Q
 ;
 ; -----------------------------------------------------
ICD0REV ;
 D ICD0REV^AUM91RL2
 Q
ICD0INAC ;
 D ICD0INAC^AUM91RL2
 Q
ICD0OREV ;
 D ICD0OREV^AUM91RL2
 Q
