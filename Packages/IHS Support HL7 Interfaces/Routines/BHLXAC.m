BHLXAC ; cmi/flag/maw - BHL Autocreate X12 fields, segs, msgs ; 
 ;;3.01;BHL IHS Interfaces with GIS;**2**;OCT 15, 2002
 ;
 ;
 ;
 ;this routine will read in a spreadsheet of an X12 message spec
 ;create the fields with data locations, add the fields to the
 ;appropriate segment, then add the appropriate segment to the
 ;appropriate message.
 ;
MAIN ;-- this is the main routine driver
 S C=","
 S BHLXFNM=$$FASK
 Q:$G(BHLXFNM)=""
 S BHLXMSG=$E($P(BHLXFNM,U,2),4,6)
 Q:BHLXMSG'?.N
 S BHLXIN=$$IN
 D READ($P(BHLXFNM,U),$P(BHLXFNM,U,2),BHLXMSG)
 Q:$G(BHLXNF)
 D EOJ
 Q
 ;
ASK() ;-- ask the type of message
 S DIR(0)="F^3:3",DIR("A")="What is the X12 message type "
 D ^DIR
 K DIR
 I $D(DIRUT) Q ""
 Q Y
 ;
FASK() ;-- file name
 S DIR(0)="F",DIR("A")="What is the directory to load from"
 D ^DIR
 K DIR
 I $D(DIRUT) Q ""
 S BHLXDIR=Y
 K Y
 S DIR(0)="F",DIR("A")="What is the filename to load from"
 D ^DIR
 K DIR
 I $D(DIRUT) Q ""
 Q BHLXDIR_U_Y
 ;
IN() ;-- ask if this is an inbound message
 S DIR(0)="Y",DIR("A")="Is this an inbound message "
 D ^DIR
 K DIR
 I $D(DIRUT) Q ""
 Q Y
 ;
READ(DIR,FNM,MSG) ;-- read in the file and start creating
 S BHLXP="X1 IHS "_MSG
 N Y
 S BHLXY=$$OPEN^%ZISH(DIR,FNM,"R")
 I +$G(Y) S BHLXNF=1 Q
 S BHLXMI=$O(^INTHL7M("B",BHLXP,0))
 I 'BHLXMI S BHLXMI=$$MADD(BHLXP)
 F BHLI=1:1 U IO R BHLX:DTIME D  Q:BHLX=""
 . Q:BHLX=""
 . S LOOP=$P(BHLX,C)
 . I LOOP="" S LOOP="HF"
 . S SEG=$P(BHLX,C,2)
 . S FLDS=$P(BHLX,C,5)
 . S RPT=$S($P(BHLX,C,6)'="":1,1:0)
 . S SEQ=$P(BHLX,C,7)
 . S BHLXSEG=$$SADD(BHLXP,LOOP,SEG,SEQ)
 . S BHLXMG=$$MSGADD(BHLXMI,BHLXSEG,SEQ,RPT,BHLXIN)
 . F BHLJ=1:1:FLDS D  Q:BHLJ=""
 .. Q:BHLJ=""
 .. S BHLAFLD=$$FLDADD(BHLXP,LOOP,SEG,BHLJ,BHLXSEG,MSG)
 .. S BHLXSEGE=$$SEGADD(BHLXSEG,BHLJ,BHLAFLD)
 Q
 ;
SADD(XP,LP,SG,SQ)  ;-- add the segment
 S X=XP_" "_LP_" "_SG_" "_SQ
 I $O(^INTHL7S("B",X,0)) Q $O(^INTHL7S("B",X,0))
 K DD,DO
 S DIC="^INTHL7S(",DIC(0)="L"
 S DIC("DR")=".02///"_$E(SG,1,3)
 D FILE^DICN
 Q +Y
 ;
FLDADD(XP,LP,SG,LJ,XSG,MG)       ;-- add the field
 S X=XP_" "_LP_" "_SG_" "_LJ
 I $O(^INTHL7F("B",X,0)) Q $O(^INTHL7F("B",X,0))
 K DD,DO,DIC
 S DIC(0)="AEMLQZ",DIC="^INTHL7F("
 S DTL="@"_MG_LP_SG_LJ
 S DIC("DR")=".02///STRING;.03///999;3///"_DTL
 D FILE^DICN
 Q +$G(Y)
 ;
MADD(MSG)        ;-- add the message
 K DD,DO,DIC
 S DIC="^INTHL7M(",DIC(0)="L",X=MSG
 S DIC("DR")=".12///X12"
 D FILE^DICN
 Q +Y
 ;
SEGADD(ASEG,ASEQ,AFLD) ;-- add the field to the segment
 S X=AFLD
 I $O(^INTHL7S("FIELD",AFLD,ASEG,0)) Q $O(^INTHL7S("FIELD",AFLD,ASEG,0))
 K DD,DO,DIC
 S DA(1)=ASEG
 S DIC="^INTHL7S("_ASEG_",1,",DIC(0)="L"
 S DIC("P")=$P(^DD(4010,1,0),"^",2)
 S DIC("DR")=".02///"_ASEQ
 D FILE^DICN
 Q +$G(Y)
 ;
MSGADD(MMSG,MSEG,MSEQ,MRPT,IN) ;-- add the segment to the message
 I $O(^INTHL7M("SEG",MSEG,MMSG,0)) Q $O(^INTHL7M("SEG",MSEG,MMSG,0))
 K DD,DO,DIC
 S DA(1)=MMSG
 S DIC="^INTHL7M("_MMSG_",1,",DIC(0)="L"
 S DIC("P")=$P(^DD(4011,1,0),"^",2)
 S X=MSEG
 S DIC("DR")=".02///"_MSEQ_";.03///"_MRPT
 I $G(IN) S DIC("DR")=DIC("DR")_";.07///PARSE;.12///FILLER"
 D FILE^DICN
 Q +$G(Y)
 ;
EOJ ;-- kill variables and quit     
 D ^%ZISC
 D EN^XBVK("BHL")
 Q
 ;
