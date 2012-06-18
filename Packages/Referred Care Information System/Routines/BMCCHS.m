BMCCHS ; IHS/OIT/FCJ - CHS INTERFACE RTN 1 OF 2 ;         [ 09/22/2006  10:03 AM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**2**;JAN 09, 2006
 ;
 ;IHS/ITSC/FCJ Added entries for link to CHS denial documents,
 ;    also added other entries for CHS PO entry
 ;    field:  32,1106,1107,1108,1201,1101,1128
 ;    ADD MULT DENIAL PRV AND MULT DENIAL REASONS
 ;4.0 IHS/OIT/FCJ TEST FOR CLOSE AND REQUIRE PO PARAMETER
 ;BMC 4.0*2* 6.5.06 IHS/OIT/FCJ CHS IS PASSING -1 FOR CPT/ICD CODES
 ;
 W:'$D(ZTQUEUED) !!,"NO ENTRY FROM THE TOP OF ^BMCCHS",!!
 Q
 ;
 ;----------
SET(BMCRIEN,BMCCHS) ;EP - SET BMCCHS ARRAY FOR CHS PACKAGE
 ; d set^bmcchs(referral_ien,.array_name)
 ; BMCRIEN is the IEN of the RCIS REFERRAL
 ; BMCCHS is array into which values are set
 ;
 NEW BMCCHSX
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 F BMCCHSX=.01,.02,.03,.04,.05,.06,.07,.08,.09,.11,.13,.14,.15,.32,1101,1105,1106,1107,1108,1112,1113,1114,1128,1201 D
 .S BMCCHS(BMCCHSX)=$$VALI^XBDIQ1(90001,BMCRIEN,BMCCHSX)
 F BMCCHSX=1105,1106 D
 .S BMCCHS(BMCCHSX)=$P(BMCCHS(BMCCHSX),".")
 Q
 ;----------
STAT(BMCRIEN,F,BMCCHS)         ;EP - CHS STATUS INFORMATION
 ; d stat^bmcchs(referral_ien,"G",.array_name)
 ;   or
 ; s array(.07)=prim denial prov
 ; s array(.15)=closed
 ; s array(1112)=chs approval status
 ; s array(1113)=chs approval/denial date
 ; s array(1114)=chs prim denial reason
 ; s array(1128)=chs denial number
 ; s array(1106)=chs dos
 ; s array(4301...)=mult denial prov
 ; s array(4401...)=mult denial reasons
 ; d stat^bmcchs(referral_ien,"P",.array_name)
 ;
 ; BMCRIEN is the IEN of the RCIS REFERRAL
 ; BMCCHS is array into which values are set
 ; F is a flag:  G to get values, P to put values in file
 ;
 NEW BMCCHSX
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 D @("STAT"_F)
 I $G(BMCCHS(1128))'="" D DENIAL
 Q
 ;
STATG ; GET CHS STATUS INFORMATION
 F BMCCHSX=1112,1113,1114 S BMCCHS(BMCCHSX)=$$VALI^XBDIQ1(90001,BMCRIEN,BMCCHSX)
 Q
 ;
STATP ; SET CHS STATUS INFORMATION
 S DIE="^BMCREF(",DA=BMCRIEN,DR=""
 F BMCCHSX=1112,1113,1114 S:$G(BMCCHS(BMCCHSX))'="" DR=DR_$S(DR="":"",1:";")_BMCCHSX_"///"_BMCCHS(BMCCHSX)
 Q:DR=""
 D DIE^BMCFMC
 S DIE="^BMCREF(",DA=BMCRIEN,DR=""
 I $G(BMCCHS(1128))'="" D
 .;4.0 IHS/OIT/FCJ CHG NXT SECTION TO TEST FOR PARAMETER
 .;F BMCCHSX=.07,.15,1106,1128 S:$G(BMCCHS(BMCCHSX))'="" DR=DR_$S(DR="":"",1:";")_BMCCHSX_"///"_BMCCHS(BMCCHSX)
 .F BMCCHSX=.07,.14,1106,1128 S:$G(BMCCHS(BMCCHSX))'="" DR=DR_$S(DR="":"",1:";")_BMCCHSX_"////"_BMCCHS(BMCCHSX)
 .I $P($G(^BMCPARM(DUZ(2),4100)),U,3)="Y" D
 ..S BMCCHSX=.15
 ..S:$G(BMCCHS(BMCCHSX))'="" DR=DR_$S(DR="":"",1:";")_BMCCHSX_"////"_BMCCHS(BMCCHSX)
 .Q:DR=""
 .D DIE^BMCFMC
 Q
 ;----------
AUTH(BMCRIEN,BMCAIEN,F,BMCCHS) ;EP - CHS AUTHORIZATIONS MULTIPLE
 ; d auth^bmcchs(referral_ien,authorization_ien,"G",.array_name)
 ;   or
 ; s array(.02)=dollar value
 ; d auth^bmcchs(referral_ien,authorization_ien,"P",.array_name)
 ;   or
 ; d auth^bmcchs(referral_ien,authorization_ien,"D")
 ;
 ; BMCRIEN is the referral ien
 ; BMCAIEN is the CHS AUTHORIZATION ien
 ; BMCCHS is the variable array root
 ; F is a flag:  G to get values, P to put values in file, D to
 ;               delete entries
 ;
 NEW BMCCHSV,BMCCHSX
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 Q:'$G(BMCAIEN)
 D @("AUTH"_F)
 Q
 ;
AUTHG ; GET CHS AUTHORIZATION VALUES
 Q:'$D(^BMCREF(BMCRIEN,41,BMCAIEN,0))
 F BMCCHSX=.02,.03,.04,.05,.06,.07,.08,.09,.13 S BMCCHS(BMCCHSX)=""
 S DIC=90001,DR=4100,DR(90001.41)=".02;.03;.04;.05;.06;.07;.08;.09;.13",DA(90001.41)=BMCAIEN,DA=BMCRIEN,DIQ="BMCCHSV",DIQ(0)="I"
 D DIQ1^BMCFMC
 F BMCCHSX=.02,.03,.04,.05,.06,.07,.08,.09,.13 S BMCCHS(BMCCHSX)=$G(BMCCHSV(90001.41,BMCAIEN,BMCCHSX,"I"))
 Q
 ;
AUTHP ; SET CHS AUTHORIZATION VALUES INTO FILE
 I '$D(^BMCREF(BMCRIEN,41,BMCAIEN,0)) D AUTHPADD Q
 D AUTHPMOD
 Q
 ;
AUTHPADD ; ADD NEW CHS AUTHORIZATION
 S DIC("DR")=""
 F BMCCHSX=.02,.03,.04,.05,.06,.07,.08 S:$G(BMCCHS(BMCCHSX))'="" DIC("DR")=DIC("DR")_$S(DIC("DR")="":"",1:";")_BMCCHSX_"///"_BMCCHS(BMCCHSX)
 I $G(BMCCHS(.09))'="" S DIC("DR")=DIC("DR")_";.09////"_BMCCHS(.09)
 I $G(BMCCHS(.13))'="" S DIC("DR")=DIC("DR")_";.13////"_BMCCHS(.13)
 S DIC="^BMCREF("_BMCRIEN_",41,",DIC(0)="L",DA(1)=BMCRIEN,DIC("P")=$P(^DD(90001,4100,0),U,2),X=BMCAIEN,DINUM=BMCAIEN
 D FILE^BMCFMC
 Q
AUTHPMOD ; MODIFY EXISTING CHS AUTHORIZATION
 S DR=""
 F BMCCHSX=.02,.03,.04,.05,.06,.07,.08 S:$G(BMCCHS(BMCCHSX))'="" DR=DR_$S(DR="":"",1:";")_BMCCHSX_"///"_BMCCHS(BMCCHSX)
 I $G(BMCCHS(.09))'="" S DR=DR_";.09////"_BMCCHS(.09)
 I $G(BMCCHS(.13))'="" S DR=DR_";.13////"_BMCCHS(.13)
 S DIE="^BMCREF("_BMCRIEN_",41,",DA(1)=BMCRIEN,DA=BMCAIEN
 D DIE^BMCFMC
 Q
 ;
AUTHD ; DELETE CHS AUTHORIZATION ENTRY
 Q:'$D(^BMCREF(BMCRIEN,41,BMCAIEN,0))
 S DIK="^BMCREF("_BMCRIEN_",41,",DA=BMCAIEN,DA(1)=BMCRIEN
 D DIK^BMCFMC
 Q
 ;---------
 ;IHS/ITSC/FCJ ADDED NXT SECTION
DENIAL ;TEST AND ADD MULT DENIAL PROVIDERS AND MULT DENIAL REASONS
 S DLAYGO=90001,BMCCHSX=4300,BMCCHSP=0,BMCCHSR=0,DIC("DR")=""
 F  S BMCCHSX=$O(BMCCHS(BMCCHSX)) Q:(BMCCHSX>4499)!(BMCCHSX'?1N.N)  D
 .Q:BMCCHS(BMCCHSX)=""  S X="`"_BMCCHS(BMCCHSX)
 .I BMCCHSX>4400 D
 ..S BMCCHSP=BMCCHSP+1
 ..S DIC="^BMCREF("_BMCRIEN_",44,",DIC(0)="L",DLAYGO=90001
 ..S DA(1)=BMCRIEN
 ..I '$D(^BMCREF(BMCRIEN,44,0)) S ^BMCREF(BMCRIEN,44,0)="^90001.44PA^0^0"
 ..D ^DIC
 .E  I BMCCHSX<4400 D
 ..S BMCCHSR=BMCCHSR+1
 ..S DIC="^BMCREF("_BMCRIEN_",43,",DIC(0)="L",DLAYGO=90001
 ..S DA(1)=BMCRIEN
 ..I '$D(^BMCREF(BMCRIEN,43,0)) S ^BMCREF(BMCRIEN,43,0)="^90001.43PA^0^0"
 ..D ^DIC
 K DIC,DA,X,Y,DLAYGO
 Q
 ;---------
DXA(BMCRIEN,BMCCHS) ;EP - ADD DIAGNOSIS
 ; s array(.01)=ICD9 ien
 ; s array(.02-.06) to appropriate internal values
 ; d dxa^bmcchs(referral_ien,.array_name)
 ;
 NEW BMCCHSQ,BMCCHSX,BMCCHSY
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 S BMCCHS(.03)=BMCRIEN
 S BMCCHSQ=0
 F BMCCHSX=.01,.02,.03,.04,.05 S:$G(BMCCHS(BMCCHSX))="" BMCCHSQ=1
 Q:BMCCHS(.01)=-1  ;BMC 4.0*2 6.5.06 IHS/OIT/FCJ CHS IS PASSING -1
 Q:BMCCHSQ
 S BMCCHSX=BMCCHS(.01),BMCCHSY=0
 ;  check for duplicate icd9 codes for same TYPE (provisional or final)
 F  S BMCCHSY=$O(^BMCDX("AD",BMCRIEN,BMCCHSY)) Q:'BMCCHSY  I $P(^BMCDX(BMCCHSY,0),U)=BMCCHSX,$P(^(0),U,4)=BMCCHS(.04) S BMCCHSQ=1 Q
 I BMCCHSQ D  Q  ;               dupe so increment COUNT field
 . S BMCCHSX=$$VALI^XBDIQ1(90001.01,BMCCHSY,.07)
 . S BMCCHSX=BMCCHSX+1
 . S DR=".07////"_BMCCHSX,DIE="^BMCDX(",DA=BMCCHSY
 . D DIE^BMCFMC
 S DIC("DR")=""
 F BMCCHSX=.02,.03,.04,.05,.06 S:$G(BMCCHS(BMCCHSX))'="" DIC("DR")=DIC("DR")_$S(DIC("DR")="":"",1:";")_BMCCHSX_"////"_BMCCHS(BMCCHSX)
 S DIC("DR")=DIC("DR")_";.07////1"
 S DIC="^BMCDX(",DIC(0)="L",DLAYGO=90001.01,X=BMCCHS(.01)
 D FILE^BMCFMC
 Q
 ;---------
DXD(BMCRIEN,BMCCHS) ;EP - DELETE DIAGNOSIS
 ; s array(.01)=ICD9 ien
 ; s array(.04)=P or F
 ; d dxd^bmcchs(referral_ien,.array_name)
 ;
 NEW BMCCHSQ,BMCCHSX,BMCCHSY
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 S BMCCHSQ=0
 F BMCCHSX=.01,.04 S:$G(BMCCHS(BMCCHSX))="" BMCCHSQ=1
 Q:BMCCHSQ
 S BMCCHSX=BMCCHS(.01),BMCCHSY=0
 ;  find icd9 code for same TYPE (provisional or final)
 F  S BMCCHSY=$O(^BMCDX("AD",BMCRIEN,BMCCHSY)) Q:'BMCCHSY  I $P(^BMCDX(BMCCHSY,0),U)=BMCCHSX,$P(^(0),U,4)=BMCCHS(.04) S BMCCHSQ=1 Q
 I BMCCHSQ D  Q  ;    found it so decrement COUNT field and delete if 0
 . S BMCCHSX=$$VALI^XBDIQ1(90001.01,BMCCHSY,.07)
 . S BMCCHSX=BMCCHSX-1
 . I BMCCHSX=0 S DIK="^BMCDX(",DA=BMCCHSY D ^DIK Q  ; delete entry
 .; if count>0 update count and leave entry
 . S DR=".07////"_BMCCHSX,DIE="^BMCDX(",DA=BMCCHSY
 . D DIE^BMCFMC
 Q
 ;---------
PXA(BMCRIEN,BMCCHS) ;EP - ADD PROCEDURE
 ; s array(.01)=CPT code ien
 ; s array(.02-.07) to appropriate internal values
 ; d px^bmcchs(referral_ien,.array_name)
 ;
 NEW BMCCHSQ,BMCCHSX,BMCCHSY
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 S BMCCHS(.03)=BMCRIEN
 S BMCCHSQ=0
 F BMCCHSX=.01,.02,.03,.04,.05,.07 S:$G(BMCCHS(BMCCHSX))="" BMCCHSQ=1
 Q:BMCCHSQ
 Q:BMCCHS(.01)=-1  ;BMC 4.0*2* 6.5.06 IHS/OIT/FCJ CHS IS PASSING -1
 S BMCCHSX=BMCCHS(.01),BMCCHSY=0
 ;  check for duplicate cpt codes for same TYPE (provisional or final)
 F  S BMCCHSY=$O(^BMCPX("AD",BMCRIEN,BMCCHSY)) Q:'BMCCHSY  I $P(^BMCPX(BMCCHSY,0),U)=BMCCHSX,$P(^(0),U,4)=BMCCHS(.04) S BMCCHSQ=1 Q
 I BMCCHSQ D  Q  ;               dupe so increment UNITS field
 . S BMCCHSX=$G(BMCCHS(.07))
 . Q:BMCCHSX=""
 . S BMCCHSX=BMCCHSX+$$VALI^XBDIQ1(90001.02,BMCCHSY,.07)
 . S DR=".07////"_BMCCHSX,DIE="^BMCPX(",DA=BMCCHSY
 . D DIE^BMCFMC
 S DIC("DR")=""
 F BMCCHSX=.02,.03,.04,.05,.06,.07 S:$G(BMCCHS(BMCCHSX))'="" DIC("DR")=DIC("DR")_$S(DIC("DR")="":"",1:";")_BMCCHSX_"////"_BMCCHS(BMCCHSX)
 S DIC="^BMCPX(",DIC(0)="L",DLAYGO=90001.02,X=BMCCHS(.01)
 D FILE^BMCFMC
 Q
 ;---------
PXD(BMCRIEN,BMCCHS) ;EP - DELETE PROCEDURE
 ; s array(.01)=CPT ien
 ; s array(.04)=P or F
 ; s array(.07)=number of units
 ; d dxd^bmcchs(referral_ien,.array_name)
 ;
 NEW BMCCHSQ,BMCCHSX,BMCCHSY
 Q:'$G(BMCRIEN)
 Q:'$D(^BMCREF(BMCRIEN,0))
 S BMCCHSQ=0
 F BMCCHSX=.01,.04,.07 S:$G(BMCCHS(BMCCHSX))="" BMCCHSQ=1
 Q:BMCCHSQ
 S BMCCHSX=BMCCHS(.01),BMCCHSY=0
 ;  find cpt code for same TYPE (provisional or final)
 F  S BMCCHSY=$O(^BMCPX("AD",BMCRIEN,BMCCHSY)) Q:'BMCCHSY  I $P(^BMCPX(BMCCHSY,0),U)=BMCCHSX,$P(^(0),U,4)=BMCCHS(.04) S BMCCHSQ=1 Q
 I BMCCHSQ D  Q  ;    found it so decrement UNITS field and delete if 0
 . S BMCCHSX=$$VALI^XBDIQ1(90001.02,BMCCHSY,.07)
 . S BMCCHSX=BMCCHSX-BMCCHS(.07)
 . I BMCCHSX<1 S DIK="^BMCPX(",DA=BMCCHSY D ^DIK Q  ; delete entry
 .; if units>0 update units and leave entry
 . S DR=".07////"_BMCCHSX,DIE="^BMCPX(",DA=BMCCHSY
 . D DIE^BMCFMC
 Q
