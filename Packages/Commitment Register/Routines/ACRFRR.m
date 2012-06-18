ACRFRR ;IHS/OIRM/DSD/THL,AEF - DISPLAY AND SELECT DOCUMENTS FOR RECEIVING REPORT OR INVICE AUDIT;  [ 04/02/2007  9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**20,22**;NOV 05, 2001
 ;;ROUTINE USED TO DISPLAY AND SELECT DOCUMENTS FOR RECEIVING REPORT
 ;;OR INVOICE AUDIT
EN ;I '$D(ACRIV)#2 D SHIPTO Q:$D(ACRQUIT)!$D(ACROUT)!(Y<1)
 F  D EN1 Q:$D(ACRQUIT)!$D(ACROUT)
EXIT K ACRSS,ACRTXOBJ,ACRQUIT,ACRPO,ACRRR,ACRXX,ACRFINAL,ACRMAX,ACRPVN,ACRPAYDU,^TMP("ACRRR",$J)
 Q
SHIPTO ;EP;TO SELECT SHIP TO DEPARTMENT FOR DUE IN & RECEIVING REPORTS
 S DIC="^AUTTPRG("
 S DIC("A")="Select Receiving Location: "
 S DIC(0)="AEMQZ"
 S DIC("S")="I $D(^ACRDOC(""DI"",+Y))"
 W !!
 D DIC^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)!(Y<1)
 S ACRRL=+Y
 Q
EN1 ;EP;SELECT PURCHASE ORDER FOR RECEIVING ACTION
 K ACRPVN
 W @IOF
 W !?20,"SELECT DOCUMENT FOR ",$S('$D(ACRIV)#2:"RECEIVING ACTION",1:"INVOICE AUDIT")
 S DIC="^ACRDOC("
 S DIC(0)="AEMQZ"
 S DIC("A")="Requisition/PO NO.: "
 I '$D(ACRIV)#2 D  I 1
 .S DIC("S")="I $D(^ACRSS(""J"",+Y)) S ACRAPV=$G(^ACROBL(+Y,""APV"")),ACRDOC=^ACRDOC(+Y,0),ACRREF=$P(ACRDOC,U,13),ACRREF=$P(^AUTTDOCR(ACRREF,0),U)"
 .S DIC("S")=DIC("S")_" I ACRREF=103!(ACRREF=349)!(ACRREF=326)!(ACRREF=210),$P(ACRDOC,U,4)'=35,'$P(ACRDOC,U,18),$P(ACRAPV,U)=""A"",$P(ACRAPV,U,8)=""A"""
 I $D(ACRIV)#2 D
 .S DIC("S")="I $P($G(^ACRDOC(+Y,""PO"")),U,5)!+$G(^(""TRNG3"")) S ACRDOC=^(0),ACRREF=$P(ACRDOC,U,13),ACRAPV=$G(^ACROBL(+Y,""APV"")),ACRREF=$P($G(^AUTTDOCR(+ACRREF,0)),U)"
 .S DIC("S")=DIC("S")_" I ""^103^204^349^326^210^""[(U_ACRREF_U)!$P(ACRDOC,U,19),$P(ACRAPV,U,8)=""A"""
 W !!
 D DIC^ACRFDIC
 I +Y<1!$D(ACRQUIT)!$D(ACROUT) S ACRQUIT="" Q
 S ACRDOCDA=+Y
 I $P($G(^ACROBL(ACRDOCDA,"APV")),U,9)=1 D  Q
 .W !!,"Final INVOICE AUDIT has been completed for this document."
 .D PAUSE^ACRFWARN
 .K ACRQUIT
 D SETDOC^ACRFEA1
 S ACRRRNO=$P(ACRDOCPO,U,21)
 I '$D(ACRIV)#2,$P($G(^ACROBL(ACRDOCDA,"APV")),U,6)=1 D  I $D(ACRQUIT) K ACRQUIT Q
 .I '$D(^ACRRR("AC",ACRDOCDA))&'$D(^ACRRR("C",ACRDOCDA)) D  Q
 ..S DA=ACRDOCDA
 ..S DIE="^ACROBL("
 ..S DR="909///@"
 ..D DIE^ACRFDIC
 ..K ACRQUIT
 .W *7,*7
 .W !!,"The document selected above ID NO.: ",ACRDOCDA," is identified"
 .W !,"as having a 'FINAL' Receiving Report on file.  Use the 'PD' Print Document"
 .W !,"function to print a copy of the Receiving Report or contact your ARMS manager"
 .W !,"to re-open the document if further receiving action is required"
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 I $D(ACRIV)#2 D  I $D(ACRQUIT)!$D(ACROUT) K ACRQUIT Q
 .D VENDOR
 .Q:$D(ACRQUIT)!$D(ACROUT)
 D ^ACRFRR1
 Q
ACRRR ;EP;
 K ACRIV
 S ACRRR=""
 G EN
ACRIV ;EP;
 K ACRRR
 S ACRIV=""
 G EN
VENDOR ;EP;FOR FINANCE TO REVIEW AND EDIT VENDOR DATA
 F  D V1 Q:$D(ACRQUIT)!$D(ACROUT)
 ;K ACRQUIT                                        ;ACR*2.1*22.17
 K:$G(ACRQUIT)'=1 ACRQUIT                          ;ACR*2.1*22.17
 Q
V1 D VHEAD^ACRFRR1
 I 'D0 D  Q
 .W *7,*7
 .W !!,"The VENDOR/PAYEE data is not complete for this order."
 .W !,"Please refer this order to your Procurement office for resolution."
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 S DIR(0)="YO"
 S DIR("B")="YES"
 S DIR("A",1)="Are you ABSOLUTELY CERTAIN that ALL this VENDOR DATA is correct."
 S DIR("A",2)="You CANNOT change any VENDOR DATA after the payment has been recorded."
 S DIR("A",3)="   "
 S DIR("A")="Is the PAYEE data correct"
 W !
 D DIR^ACRFDIC
 I +Y=1 S ACRQUIT=""
 Q:$D(ACRQUIT)!$D(ACROUT)
 I Y=0 D VCHANGE^ACRFRR1
 Q:$D(ACRQUIT)
 ;S DA=$P(^ACRDOC(ACRDOCDA,5),U,5)  ;ACR*2.1*22.14
 S (ACRVND,DA)=$P(^ACRDOC(ACRDOCDA,5),U,5)  ;ACR*2.1*22.14
 S DIE="^AUTTVNDR("
 S DR="[ACR VENDOR REMIT TO ADDRESS]"
 D DDS^ACRFDIC
 I $D(ACRSCREN) K ACRSCREN D DIE^ACRFDIC
 Q                                                ;ACR*2.1*22.14
 ;I '$P($G(^ACRAU(DUZ,1)),U,15) D  Q              ;ACR*2.1*22.14
 S ACRVAUTH=$$EDITAUTH^ACRFVLK(DUZ)   ; Get ARMS User Vendor Edit Authority;ACR*2.1*22.14
 I ",A,F,"'[(","_ACRVAUTH_",") D MSG^ACRFVLK Q    ;ACR*2.1*22.14
 ;.W @IOF,!!,"You do not have authority to edit data other than the REMIT TO ADDRESS."  ;ACR*2.1*22.14
 ;.W !,"If other vendor data needs to be added or changed, contact the ARMS Manager"  ;ACR*2.1*22.14
 ;.W !,"to find someone who can add or change the vendor data before processing payment."  ;ACR*2.1*22.14
 ;.D PAUSE^ACRFWARN  ;ACR*2.1*22.14
 ;I $P($G(^ACRAU(DUZ,1)),U,15) D  Q               ;ACR*2.1*22.14
 W @IOF,!!,"WARNING:  Vendor data is shared by many different computer systems."
 W !,"Be ABSOLUTLEY CERTAIN the vendor data you are adding or changing is correct"
 W !,"before making any changes."
 D PAUSE^ACRFWARN
 ; D ADD^AUTTVLK                 ; ACR*2.1*20.14
 D ADD^ACRFVLK                   ; ACR*2.1*20.14
 Q
VCHNG ;NEW SUBROUTINE                                  ;ACR*2.1*22.14
 K ACRQUIT
 S DIR(0)="YO"
 S DIR("B")="YES"
 S DIR("A")="Do you want to change the Payee to a different Vendor?"
 W !
 D DIR^ACRFDIC
 I +Y D VCHANGE^ACRFRR1 Q
 S ACRQUIT=1
 Q
 ;
IDATE S DA=ACRDOCDA
 S DIE="^ACRDOC("
 S DR="113210T;103200T;103200.2T;103200.1T;2001"
 W !
 D DIE^ACRFDIC
 S ACRDOCPO=^ACRDOC(ACRDOCDA,"PO")
 S ACRIVNO=$P(ACRDOCPO,U,16)
 S DA=ACRDOCDA
 S DIE="^ACRDOC("
 N X
 S DR=";103811////"
 S X=0
 F  S X=$O(^ACRDOC(ACRDOCDA,20,X)) Q:'X  I $P(^ACRDOC(ACRDOCDA,20,X,0),U)'["NOT STATED",$P(^(0),U)]"" S DR=DR_$P(^ACRDOC(ACRDOCDA,20,X,0),U)_"," Q:$L(DR)>60
 S DR="103810////"_ACRIVNO_DR
 D DIE^ACRFDIC
 Q
REOPEN ;EP;TO RE-OPEN A RECEIVING REPORT WHICH HAS BEEN FINANLIZED
 W @IOF
 W !?15,"UTILITY TO RE-OPEN FINALIZED ",$S('$D(ACRIV)#2:"RECEIVING REPORTS",1:"PAYMENT")
 F  D RE Q:$D(ACRQUIT)
 K ACRQUIT
 Q
RE ;SELECT RECEIVING REPORT DOCUMENT TO RE-OPEN
 S DIC="^ACRDOC("
 S DIC(0)="AEMQ"
 S DIC("A")="Document NO.: "
 S DIC("S")="S ACRAPV=$G(^ACROBL(+Y,""APV"")) I $P(ACRAPV,U,6)=1&$D(^ACRRR(""AC"",+Y))!($P(ACRAPV,U,9)=1)"
 S:$D(ACRIV)#2 DIC("S")="S ACRAPV=$G(^ACROBL(+Y,""APV"")) I $P(ACRAPV,U,9)=1"
 W !!
 D DIC^ACRFDIC
 K ACRAPV
 I +Y<1 S ACRQUIT="" Q
 Q:'$D(^ACROBL(+Y,0))!'$D(^ACROBL(+Y,"APV"))
 S ACRDOCDA=+Y
 S ACRDOC=$S($P(^ACRDOC(+Y,0),U,2)]"":$P(^(0),U,2),1:$P(^(0),U))
 I '$D(ACRIV)#2,$P($G(^ACROBL(ACRDOCDA,"APV")),U,9)=1 N ACRIV S ACRIV=""
 S DIR(0)="YO"
 S DIR("A",1)="Are you certain you want to RE-OPEN Document NO. "_ACRDOC
 S DIR("A")="for further "_$S('$D(ACRIV)#2:"receiving action",1:"invoice audit")
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:Y'=1
 K ACRDR
 I $D(ACRIV)#2 D  Q:$D(ACRQUIT)!$D(ACROUT)
 .S DIR(0)="YO"
 .S DIR("A",1)="Do you also want to RE-OPEN Document NO. "_ACRDOC
 .S DIR("A")="for further receiving action"
 .S DIR("B")="NO"
 .W !
 .D DIR^ACRFDIC
 .S:Y=1 ACRDR="909////2;"
 S DA=ACRDOCDA
 S DIE="^ACROBL("
 S DR=$G(ACRDR)_$S('$D(ACRIV)#2:"909////2",1:"912////2")
 D DIE^ACRFDIC
 S ACR=0
 F  S ACR=$O(^ACRSS("J",ACRDOCDA,ACR)) Q:'ACR  I $D(^ACRSS(ACR,0)),$P(^(0),U,2)'=ACRDOCDA S ACRDOC($P(^(0),U,2))=""
 S ACRDOC(ACRDOCDA)=""
 S ACR=0
 I '$D(ACRIV)#2!$D(ACRDR) F  S ACR=$O(ACRDOC(ACR)) Q:'ACR  I $D(^ACRRR("C",ACR)) D
 .S ACRRRDA=0
 .F  S ACRRRDA=$O(^ACRRR("C",ACR,ACRRRDA)) Q:'ACRRRDA  D
 ..S ACRRR0=$G(^ACRRR(ACRRRDA,0))
 ..I $P(ACRRR0,U,8)=1,$P(ACRRR0,U,11)'=1 D
 ...S DA=ACRRRDA
 ...S DIE="^ACRRR("
 ...S DR=".08////2"
 ...D DIE^ACRFDIC
 W !!,ACRDOC," is now available for additional ",$S('$D(ACRIV)#2:"receiving",1:"payment")," action."
 D PAUSE^ACRFWARN
 Q
