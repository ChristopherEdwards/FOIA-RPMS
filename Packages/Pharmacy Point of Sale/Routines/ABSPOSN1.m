ABSPOSN1 ; IHS/FCS/DRS - NCPDP forms for ILC A/R ;    [ 09/12/2002  10:15 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ; *****
 ; *****  Interface to ABSB, the ILC A/R package
 ; *****  This code is reached _ONLY_ by sites using ILC A/R,
 ; *****  and who choose to interface to it.
 ; *****
 ; Note: references to ^ABSBCOMB are legitimately supposed to be such;
 ; they are testing for ILC A/R Version 2 - they were definitely left
 ; as such and purposefully not changed to ^ABSPCOMB
 Q
 ;
EN1 ;Entry point to NCPDP PHARMACY PRE BILLING REPORT option
 N EXIT
 S EXIT=0
 D HEADER^ABSPOSN7("NCPDP Pharmacy - Pre Billing List")
 D DEVICE^ABSPOSN7("Print report on which DEVICE? ",.EXIT)
 I EXIT W @IOF Q
 D EN^ABSPOSN5("NCPDP PHARMACY PRE BILLING REPORT","APRX1")
 D ^%ZISC
 W @IOF
 Q
 ;----------------------------------------------------------------------
 ; Obsolete option ; but it will be in the new NCPDP forms.
 ;EN2      ;Entry point to NCPDP PHARMACY FORM ALIGNMENT option
 ;----------------------------------------------------------------------
EN3 ;Entry point to PRINT NCPDP PHARMACY FORMS option
 I '$D(^ABSBITMS) D  Q  ; cannot reach this until you have ILC A/R
 . D IMPOSS^ABSPOSUE("P","TI","This option is ONLY for ILC A/R.",,"EN3",$T(+0)) ; and it should be unreachable, too - so what are you doing here?
 I $D(^ABSBCOMB) D  Q  ; I running the ILC A/R V2 package, then
 . D EN^ABSB1592("NCPDP") Q  ; call the generalized routine
 ; to print the forms. 
 ;  It provides a consistent interface across all forms printing!
 ;  Same, whether you're doing UB92 or NCPDP or whatever.
 ; But the old a/r package still uses this code:
 N EXIT,DA,OK
 K ^BLLAUDIT($J,"APRX")
 S EXIT=0
 D HEADER^ABSPOSN7("NCPDP Pharmacy - Print Forms")
 D DEVICE^ABSPOSN7("Print NCPDP PHARMACY FORMS on which DEVICE? ",.EXIT)
 I EXIT W @IOF Q
 ;
 I IO'=$P U $P W !,"Printing Forms..."
 U IO
 S DA=""
 F  D  Q:'+DA!(EXIT)
 .S DA=$O(^ABSBITMS(9002302,"APRX",1,DA))
 .Q:'+DA
 .D PBITEM^ABSPOSN2(DA)
 .S ^BLLAUDIT($J,"APRX",DT,DA)=""
 .D:IO=$P CONTINUE^ABSPOSN7(.EXIT)
 .I IO'=$P U $P W "."
 .U IO
 D ^%ZISC
 U $P
 I EXIT W @IOF Q
 ;
 W !!
 S OK=$$YESNO^ABSPOSU3("Did NCPDP Pharmacy Forms print correctly? ",,0,9999)
 ;
 I '(OK=1) D  Q
 .K ^BLLAUDIT($J,"APRX")
 W !!
 S OK=$$YESNO^ABSPOSU3("Okay to UPDATE the bills? ",,0,99999)
 I '(OK=1) D  Q
 .W *7,!!,"No updating of bills has occurred!" H 2
 .K ^BLLAUDIT($J,"APRX")
 ;
 W !!,"Updating printed bills..."
 S DA=""
 F  D  Q:'+DA
 .S DA=$O(^BLLAUDIT($J,"APRX",DT,DA))
 .Q:'+DA
 .W "."
 .D UPDATE(DA)
 K ^BLLAUDIT($J,"APRX")
 W @IOF
 Q
 ;----------------------------------------------------------------------
EN4 ;Entry point to REPRINT ONE NCPDP PHARMACY FM option
 N EXIT,DIC,Y,DA,PCNLIST
 S EXIT=0
 D HEADER^ABSPOSN7("NCPDP Pharmacy - Reprint One Form")
 ;
EN4B ; loop back here to ask F another one
 S DIC="^ABSBITMS(9002302,",DIC(0)="AEMNQ"
 ;S DIC("S")="I $P($G(^(9)),U,2)[""RX"""
 ; This screen relies on certain conventions about A/R types naming
 ; We may have to remove it or generalize it someday.
 ; F now, let the quick and dirty thing here run its course
 S DIC("S")="N % S %=$P($G(^(9)),U,2) I %[""RX""!(%[""PH"")"
 D ^DIC
 S DA=+Y
 I $D(DUOUT) W @IOF Q
 I '$D(^ABSBCOMB) G EN4A ; old a/r package - just the one; go Do it
 I DA<0 D  Q  ; okay, got the list
 . I '$D(PCNLIST) Q  ; didn't select any
 . ;I DUZ=120,DUZ(2)=1859 W !,"You're going to print ",! ZW PCNLIST W !
 . D EN^ABSB1592("NCPDP",.PCNLIST) ; call the omniprint routine
 W !,"Okay.  Select another one, or hit enter.",!
 S PCNLIST(DA)="" G EN4B
 ;
EN4A ;
 W !!
 D DEVICE^ABSPOSN7("Print NCPDP PHARMACY FORM on which DEVICE? ",.EXIT)
 I EXIT W @IOF Q
 ;S DTIME=99999999
 I IO'=$P U $P W !,"Printing Forms..."
 D PBITEM^ABSPOSN2(DA)
 D ^%ZISC
 ;S DTIME=600
 ;
 W @IOF
 Q
 ;------------------------------------------------------------------
 ;UPDATE the PRINT PCS PHARMACY flag and DATE BILLED Multiple
UPDATE(PCNDFN) ;
 N COMPANY,BILLDFN,SELFPAY,VL,BILLTOT
 S COMPANY=$S($P(^ABSBITMS(9002302,PCNDFN,0),U,3)="":"SELF PAY",1:$P(^ABSBITMS(9002302,PCNDFN,0),U,3))
 I $D(^ABSBITMS(9002302,PCNDFN,2,0)) S BILLDFN=$P(^ABSBITMS(9002302,PCNDFN,2,0),"^",3)+1,^ABSBITMS(9002302,PCNDFN,2,0)="^9002302.04DA^"_BILLDFN_"^"_BILLDFN
 E  S ^ABSBITMS(9002302,PCNDFN,2,0)="^9002302.04DA^1^1",BILLDFN=1
 S SELFPAY=0
 I BILLDFN=1 F VL=0:0 S VL=$O(^ABSBITMS(9002302,PCNDFN,7,VL)) Q:'VL  I $P(^(VL,0),U,4)["SELF-PAY" S SELFPAY=SELFPAY+$P(^(0),U,2)
 S BILLTOT=SELFPAY+$P(^ABSBITMS(9002302,PCNDFN,3),U,1)
 S ^ABSBITMS(9002302,PCNDFN,2,BILLDFN,0)=DT_"^NONE^"_BILLTOT_"^"_COMPANY
 S $P(^ABSBITMS(9002302,PCNDFN,"PB"),U,6)=0
 K ^ABSBITMS(9002302,"APRX",1,PCNDFN)
 S ^ABSBITMS(9002302,"APRX",0,PCNDFN)=""
 Q
