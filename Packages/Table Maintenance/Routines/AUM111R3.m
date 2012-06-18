AUM111R3 ;IHS/SD/RNB - ICD 9 CODES FOR FY 2012 ; [ 09/09/2010  8:30 AM ]
 ;;12.0;TABLE MAINTENANCE;;SEP 27,2011
 ;
 ; -----------------------------------------------------
ICD0REV ;
 D RSLT^AUM111R1("ICD OPERATION/PROCEDURE, REVISED 2011 CODES:")  ;("ICD9PREV")
 D RSLT^AUM111R1($J("",8)_"CODE      DESCRIPTION")
 D RSLT^AUM111R1($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 ;F AUMI=1:1 S AUMLN=$P($T(ICD9PREV+AUMI^AUM111B),";;",2) Q:AUMLN="END"  D  ;IHS/SD/SDR 11/30/09 HEAT8884
 F AUMI=1:1 S AUMLN=$P($T(ICD9PRE2+AUMI^AUM111E),";;",2) Q:AUMLN="END"  D  ;IHS/SD/SDR 11/30/09 HEAT8884
 .S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 .S Y=$$IXDIC^AUM111R1("^ICD0(","ILX","AB",$P(AUMLN,U))
 .I Y=-1 D RSLT^AUM111R1("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S (DA,AUMIEN)=+Y
 .S DR="4///"_$P(AUMLN,U,2)        ;operation/procedure
 .S DR=DR_";10///"_$P(AUMLN,U,3)   ;description
 .;
 .S DR=DR_";100///@"               ;inactive flag
 .S DR=DR_";102///@"               ;inactive date
 .;
 .;;S DR=DR_";2100000///3111001"     ;date updated
 .S DR=DR_";2100000///"_DT     ;date updated
 .;
 .S DR=DR_";9.5///"_$P(AUMLN,U,4)  ;use with sex
 .S DIE="^ICD0("
 .S AUMDA=DA
 .D DIE^AUM111R1
 .;
 .;effective date multiple
 .K AUMFLG
 .S AUMLDT=0
 .S AUMLDT=$O(^ICD0(AUMIEN,66,"B",9999999),-1)  ;get last date in multiple
 .I +AUMLDT>0 D  ;entry exists; check if status is correct (active)
 ..S AUMMIEN=$O(^ICD0(AUMIEN,66,"B",AUMLDT,0))
 ..I +AUMMIEN=0 S AUMLDT=0 Q  ;quit if incomplete entry for some reason
 ..I $P($G(^ICD0(AUMIEN,66,AUMMIEN,0)),U,2)=1 Q  ;already active
 ..S AUMLDT=0  ;set date to zero so it will add entry
 .I +AUMLDT=0 D  ;no entry or needs a new entry
 ..K DIC,DIE,DA,X,Y
 ..S DA(1)=AUMIEN
 ..S DIC="^ICD0("_DA(1)_",66,"
 ..S DIC("P")=$P(^DD(80.1,66,0),U,2)
 ..S DIC(0)="L"
 ..S X="3101001"  ;use active date of 10/01/2010
 ..S DIC("DR")=".02////1"
 ..D ^DIC
 ..I Y<0 S AUMFLG=1
 .;
 .;operation/proc multiple
 .S AUMLDT=0
 .S AUMLDT=$O(^ICD0(AUMIEN,67,"B",9999999),-1)  ;get last entry
 .I +AUMLDT>0 D  ;there is an entry
 ..S AUMMIEN=$O(^ICD0(AUMIEN,67,"B",AUMLDT,0))
 ..I +AUMMIEN=0 S AUMLDT=0 Q  ;quit if incomplete entry
 ..I $P($G(^ICD0(AUMIEN,67,AUMMIEN,0)),U,2)=$P(AUMLN,U,2) Q
 ..S AUMLDT=0  ;set date to zero so it will add entry
 .I +AUMLDT=0 D  ;no entry or needs a new entry
 ..K DIC,DIE,DA,X,Y
 ..S DA(1)=AUMIEN
 ..S DIC="^ICD0("_DA(1)_",67,"
 ..S DIC("P")=$P(^DD(80.1,67,0),U,2)
 ..S DIC(0)="L"
 ..S X="3101001"  ;use active date of 10/01/2010
 ..S DIC("DR")="1////"_$P(AUMLN,U,2)  ;oper/proc
 ..D ^DIC
 ..I Y<0 S AUMFLG=1
 .;
 .;description multiple
 .S AUMODESC=""
 .S AUMLDT=0
 .S AUMLDT=$O(^ICD0(AUMIEN,68,"B",9999999),-1)
 .I +AUMLDT>0 D  ;there is an entry
 ..S AUMMIEN=$O(^ICD0(AUMIEN,68,"B",AUMLDT,0))
 ..I +AUMMIEN=0 S AUMLDT=0  Q
 ..I $P($G(^ICD0(AUMIEN,68,AUMMIEN,0)),U)=$P(AUMLN,U,3) Q
 ..S AUMLDT=0
 .I +AUMLDT=0 D  ;no entry or needs a new entry
 ..K DIC,DIE,DA,X,Y
 ..S DA(1)=AUMIEN
 ..S DIC="^ICD0("_DA(1)_",68,"
 ..S DIC("P")=$P(^DD(80.1,68,0),U,2)
 ..S DIC(0)="L"
 ..S X="3101001"  ;use active date of 10/01/2010
 ..S DIC("DR")="1////"_$P(AUMLN,U,3)  ;description
 ..D ^DIC
 ..I Y<0 S AUMFLG=1
 .;
 .;loads MDC and DRGs if any
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
 .....D DIE^AUM111R1
 .I $G(AUMFLG) D RSLT^AUM111R1("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT^AUM111R1($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
