APCD3M ; IHS/CMI/LAB - PCC TO 3M CODER INTERFACE ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;;2.0
 ;
 ; This routine processes inbound HL7 messages from the 3M Coder
 ; and generates outbound HL7 messages to send to the 3M Coder.
 ;
 ; The entry point IN is called by the HL7 package to process
 ; an inbound message from the 3M Coder.  An entry is generated
 ; in file 9001001.9 for the specified visit which contains the
 ; ICD codes and provider narratives required to generate the
 ; appropriate V POV and V PROCEDURE entries for this visit.
 ;
 ; The entry point OUT is called to generate an HL7 message
 ; containing patient demographic and medical data required
 ; by the 3M Coder to assign ICD codes to V POV entries.  The
 ; visit IEN is passed in APCDVSIT.
 ;
 ;cmi/anch/maw 10/11/2005 modified due to change in 3m structure
 ;cmi/anch/maw 12/2/2005 maw added clean of destination queue before sending
 ;cmi/anch/maw 3/6/2007 maw modified DISPCPT to screen off description 
 ;cmi/anch/maw 3/6/2007 maw modified DISPICD to get if a V code
 ;cmi/tucson/lab 11/12/2007 code set versioning
 ;
 Q  ;do not enter at top of routine
 ;
IN ; EP - PROCESS HL7 MESSAGE FROM 3M CODER
 ;maw this is where the inbound stuff starts
 NEW APCD3COD,APCD3IEN,APCD3NAR,APCDQ,I,J,X,Y
 D INMAIN
 D EOJ
 Q
 ;
INMAIN ; INBOUND MAINLINE LOGIC
 D INSTALL ;                          generate 9001001.9 entry
 Q
 ;
INSTALL ; GENERATE 9001001.9 ENTRY
 F J=1:1 S X=$G(APCDHL7M(J)) Q:X=""  D  Q:$G(APCD3MER)
 .  S Y=$P(X,"|") ;                  get segment
 .  I Y="PV1" D IPV1 Q  ;            pv1 segment
 .  I Y="DG1" D IDG1 Q  ;            dg1 segment
 .  I Y="PR1" D IPR1 Q  ;            pr1 segment
 .  I Y="DRG" D IDRG Q  ;            drg segment
 .  Q
 Q
 ;
IPV1 ; PV1 SEGMENT
 S X=$P(X,"|",20)
 I 'X S APCD3MER="200^No Visit IEN in Message" D ERR Q
 S DIC="^APCD3MV(",DIC(0)="L",DLAYGO=9001001.9,DIC("DR")=".02////"_UIF
 S DINUM=X
 D FILE
 I Y<0 S APCD3MER="100^Error adding message to 3M file" D ERR Q
 S APCD3IEN=+Y
 Q
 ;
IDG1 ; DG1 SEGMENT
 S APCD3COD=$P($P(X,"|",4),U) ;      get ICD9 code
 S APCD3TXT=$P($P(X,"|",4),U,2)  ;icd desc
 S APCD3DTP=$P(X,"|",7)  ;diagnosis type
 Q:$G(APCD3DTP)="A"  ;don't file admit dx
 ;I $E(APCD3COD,1,1)="E" S APCDECOD=APCD3COD D  Q
 ;. I APCDECOD'["." S APCDECOD=$E(APCDECOD,1,4)_"."_$E(APCDECOD,5,999)
 ;. D UPDCODE Q
 I $E(APCD3COD,1,1)="E" D
 . I APCD3COD'["." S APCD3COD=$E(APCD3COD,1,4)_"."_$E(APCD3COD,5,999)
 I $E(APCD3COD,1,1)'="E" D
 . I APCD3COD'["." S APCD3COD=$E(APCD3COD,1,3)_"."_$E(APCD3COD,4,999)
 I APCD3COD="" S APCD3MER="204^POV ICD9 code missing" Q
 S X=APCD3COD,DA(1)=APCD3IEN,DIC="^APCD3MV("_DA(1)_",11,",DIC(0)="L",DIC("P")=$P(^DD(9001001.9,1101,0),U,2)
 S DIC("DR")=".02///"_$G(APCD3TXT)
 D FILE
 I Y<0 S APCD3MER="210^Error adding POV to 3M file" D ERR Q
 S APCDDG1=+Y
 Q
 ;
IPR1 ; PR1 SEGMENT
 S APCD3COD=$P($P(X,"|",4),U) ;      get ICD9 code
 S APCD3TXT=$P($P(X,"|",4),U,2) ; cpt description
 S APCDCTP=$P($P(X,"|",4),U,3) ; get type of coding system
 S APCD3MOD=$P(X,"|",17) ;      get modifier
 I APCD3COD="" S APCD3MER="208^PROC ICD9 code missing" Q
 I $G(APCDCTP)="CP" D ICPT Q  ;goto cpt filer then quit
 I $G(APCDCTP)="H" D ICPT Q  ;hcps codes
 I $E(APCD3COD,1)'?.N D ICPT Q  ;non icd codes
 ;I $L(APCD3COD)>4 D ICPT Q  ;cpt codes 10/25/2005 maw commented out
 I APCD3COD'["." S APCD3COD=$E(APCD3COD,1,2)_"."_$E(APCD3COD,3,999)
 S X=APCD3COD,DA(1)=APCD3IEN,DIC="^APCD3MV("_DA(1)_",12,",DIC(0)="L",DIC("P")=$P(^DD(9001001.9,1201,0),U,2)
 S DIC("DR")=".02///"_$G(APCD3TXT)
 D FILE
 I Y<0 S APCD3MER="211^Error adding Procedure to 3M file" D ERR Q
 S APCDPR1=+Y
 Q
 ;
IDRG ;-- get the drg    
 S APCD3DRG=$P(X,"|",2)
 I APCD3DRG'="" S APCD3DRG="DRG"_+APCD3DRG
 S DIE="^APCD3MV(",DA=APCD3IEN,DR=".03///"_APCD3DRG
 D ^DIE
 I $D(Y) S APCD3MER="220^Error adding DRG to 3M file" D ERR
 Q
 ;
ICPT ;-- file cpt codes
 S X=APCD3COD_" - "_APCD3TXT ;file cpt and text
 S DA(1)=APCD3IEN,DIC="^APCD3MV("_DA(1)_",13,",DIC(0)="L",DIC("P")=$P(^DD(9001001.9,1301,0),U,2)
 I $G(APCD3MOD)?.N S DIC("DR")=".02////"_$G(APCD3MOD)
 D FILE
 Q
 ;
DISPCPT ;-- display the cpt picklist for user
 S APCDDA=0 F I=1:1 S APCDDA=$O(^APCD3MV(APCDVSIT,13,APCDDA)) Q:'APCDDA  D
 . S APCD3CPT=$P($G(^APCD3MV(APCDVSIT,13,APCDDA,0)),U)
 . S APCD3MOD=$P($G(^APCD3MV(APCDVSIT,13,APCDDA,0)),U,2)
 . W !,$G(I)_")  Cpt: "_$G(APCD3CPT)_$S($G(APCD3MOD)'="":"  Modifier: "_$G(APCD3MOD),1:"")
 . S APCDCPTA(I)=APCDDA_U_APCD3CPT_U_APCD3MOD
 Q:'$O(APCDCPTA(""))
 S APCDPCPT=""
 R !!,"Which CPT should I attach to this procedure: ",APCDRX:DTIME
 Q:APCDRX="^"
 Q:APCDRX=""
 I '$G(APCDCPTA(APCDRX)) W !,"Not a valid Selection, Try Again." G DISPCPT
 S APCDUCPT=$P($G(APCDCPTA(APCDRX)),U)
 ;S APCDPCPT=$P($G(APCDCPTA(APCDRX)),U,2)  ;cmi/anch/maw 3/6/2007 orig line
 S APCDPCPT=+$P($G(APCDCPTA(APCDRX)),U,2)  ;cmi/anch/maw 3/6/2007 modified
 S APCDPMOD=$P($G(APCDPMOD(APCDRX)),U,3)
 ;I $G(APCDPCPT)'="" S APCDPCPT=$O(^ICPT("B",APCDPCPT,0))
 I $G(APCDPCPT)'="" S APCDPCPT=$P($$CPT^ICPTCOD(APCDPCPT),U,1)
 I APCDPCPT=-1 S APCDPCPT=""
 I APCDPCPT'="" S APCDPCPT="`"_APCDPCPT
 I $G(APCDPMOD)'="" D
 .I $$VERSION^XPDUTL("BCSV")>0 S APCDPMOD=$O(^DIC(81.3,APCDPMOD,0)) Q
 .S APCDPMOD=$O(^AUTTCMOD("B",APCDPMOD,0))
 I APCDPMOD'="" S APCDPMOD="`"_APCDPMOD
 ;maw kill these cpt's after the template
 S APCDCPTU(APCDUCPT)=APCDVSIT ;set variable since they were picked
 Q
 ;
DISPICD ;-- display the icd code picklist for user
 S APCDPDA=0 F I=1:1 S APCDPDA=$O(^AUPNVPOV("AD",APCDVSIT,APCDPDA)) Q:'APCDPDA  D
 . Q:'$G(^AUPNVPOV(APCDPDA,0))
 . S APCDDXI=$P(^AUPNVPOV(APCDPDA,0),U)
 . Q:APCDDXI=""
 . ;Q:'$G(^ICD9(APCDDXI,0))  ;cmi/anch/maw 3/6/2007 orig line
 . ;Q:'$D(^ICD9(APCDDXI,0))  ;cmi/anch/maw 3/6/2007 not picking up v codes
 . Q:$P($$ICDDX^ICDCODE(APCDDXI),U,1)<0
 . ;S APCDDXC=$P(^ICD9(APCDDXI,0),U)
 . S APCDDXC=$P($$ICDDX^ICDCODE(APCDDXI,$$VD^APCLV(APCDVSIT)),U,2)
 . ;S APCDDXE=$G(^ICD9(APCDDXI,1))
 . S APCDDXE=$P($$ICDDX^ICDCODE(APCDDXI,$$VD^APCLV(APCDVSIT)),U,4)
 . W !,$G(I)_")  Dx Code: "_$G(APCDDXC)_"  Dx Desc: "_$G(APCDDXE)
 . S APCDICDA(I)=APCDPDA_U_APCDDXC
 Q:'$O(APCDICDA(""))
 S APCDPICD=""
 R !!,"Which DX should I attach to this procedure: ",APCDIRX:DTIME
 Q:APCDIRX="^"
 Q:APCDIRX=""
 I '$G(APCDICDA(APCDIRX)) W !,"Not a valid Selection, Try Again." G DISPICD
 S APCDPICD=$P($G(APCDICDA(APCDIRX)),U,2)
 I $G(APCDPICD)'="" S APCDPICD=+$$CODEN^ICDCODE(APCDPICD,80) I $P(APCDPICD,U)=-1 S APCDPICD=""
 I APCDPICD'="" S APCDPICD="`"_APCDPICD
 Q
 ;
DISPECD ;-- display the ecode picklist for user
 S APCDI=1
 S APCDDA=0 F  S APCDDA=$O(^APCD3MV(APCDVSIT,11,APCDDA)) Q:'APCDDA  D
 . S APCD3ECD=$P($G(^APCD3MV(APCDVSIT,11,APCDDA,0)),U)
 . Q:$E(APCD3ECD,1,1)'="E"
 . W !,$G(APCDI)_")  E Code: "_$G(APCD3ECD)
 . S APCDECDA(APCDI)=APCDDA_U_APCD3ECD
 . S APCDI=APCDI+1
 Q:'$O(APCDECDA(""))
 S APCDPECD=""
 R !!,"Which E Code should I attach to this diagnosis: ",APCDEX:DTIME
 Q:APCDEX="^"
 Q:APCDEX=""
 I '$G(APCDECDA(APCDEX)) W !,"Not a valid Selection, Try Again." G DISPECD
 S APCDUECD=$P($G(APCDECDA(APCDEX)),U)
 S APCDPECD=$P($G(APCDECDA(APCDEX)),U,2)
 I $G(APCDPECD)'="" S APCDCECD=+$$CODEN^ICDCODE(APCDPECD,80) I $P(APCDCECD,U)=-1 S APCDCECD=""
 I APCDCECD="" S APCDPECD=""
 ;I APCDPECD'="" S APCDPECD="`"_APCDPECD
 Q
 ;
FILE ; CALL FILE^DICN
 K DD,DO
 D FILE^DICN
 K D,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM
 Q
 ;
UPDCODE ;-- add ecode to coded entry
 Q:'$G(APCDDG1)
 S DA=$G(APCDDG1)
 Q:$P($G(^APCD3MV(APCD3IEN,11,DA,0)),U,4)  ;e code exists
 S DA(1)=APCD3IEN,DIE="^APCD3MV("_DA(1)_",11,",DR=".04////"_APCDECOD
 D ^DIE
 Q
 ;
OUT(APCDVSIT) ; EP - SEND HL7 MESSAGE TO 3M CODER
 ; called by PCC Data Entry and ADT Data Entry
 D OUTMAIN
 I $G(APCD3MER) D ERR
 Q
 ;
OUTMAIN ; OUTBOUND MAINLINE LOGIC
 D OUTINIT ;                           initialization/check protocol
 D GEN^APCD3MG(APCDVSIT)
 Q:$G(APCD3MER)
 Q:APCDQ
 S APCDIP=$G(APCD3MIP)
 S BHLIP=APCDIP ;needed for protocol
 W !!,"Now Sending to 3M"
 S APCDBP=$O(^INTHPC("B","HL IHS 3M SENDER "_BHLIP,0))
 Q:'APCDBP
 F APCDJOB="FORMAT CONTROLLER","OUTPUT CONTROLLER" D
 . S APCDY=$$CHK^BHLBCK(APCDJOB,"")
 D CLNDST(BHLIP)  ;12/2/2005 maw added to eliminate duplicate sends
 S APCDMSG=$$A^INHB(APCDBP)
 S X="BHL SEND TO 3M",DIC=101 D EN^XQOR
 Q
 ;
CLNDST(IP) ;-- cleanout destination queue before creating message
 N BHLDST
 S BHLDST=$O(^INRHD("B","HL IHS 3M CODER "_IP,0))
 Q:'BHLDST
 K ^INLHDEST(BHLDST)
 Q
 ;
OUTINIT ; OUTBOUND INITIALIZATION
 S APCDQ=1
 D:$G(APCD3MIP)="" OUTGETIP ;          get IP address
 S APCDQ=0
 Q
 ;
OUTGETIP ; GET IP ADDRESS
 I $G(APCD3MIP)="" D
 . W !
 . S DIR(0)="FO^1:2",DIR("A")="Enter your 3M Workstation ID "
 . KILL DA D ^DIR KILL DIR
 . S APCD3MIP=$G(X)
 . Q
 I APCD3MIP="" S APCD3MER="101^No ID address entered" D ERR Q
 Q
 ;
ERR ;-- log the error here
 W !,$P($G(APCD3MER),U,2) Q  ;maw needs work
 S APCDERR="D TRAP^BHLERR"
 I $G(APCD3MER)="GEN" D
 . S BHLEFL=APCDEFL
 . S BHLFLD=APCDFLD
 I $P($G(APCD3MER),U,2)]"" S APCD3MER="GEN"
 S BHLERCD=APCD3MER X APCDERR
 Q
 ;
EOJ ;-- kill variables     
 D EN^XBVK("APCD")
 Q
 ;
