ACRFEA21 ;IHS/OIRM/DSD/THL,AEF - EDIT FINANCIAL DATA;  [ 5/09/2007  8:03 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**5,20,22**;NOV 05, 2001
 ;;CONTINUATION OF ACRFEA2  -- HEAVILY REWRITTEN MRS:ACR*2.1*20.14
APPROVE ;EP;TO INITIATE APPROVAL PROCESS
 S ACRAPCHK=""
 N X,Y,ACRCCQ,ACRVND
 S (X,Y,ACRCCQ)=0
 S ACRVND=$P($G(^ACRDOC(ACRDOCDA,"PO")),U,5)
 I $$REQTP^ACRFSSU(ACRDOCDA)["CREDIT CARD" S ACRCCQ=1
 ;
 F  S X=$O(^ACRSS("J",ACRDOCDA,X)) Q:'X  S Y=Y+$P($G(^ACRSS(X,"DT")),U,4)
 I Y D
 .I $G(ACRREF)'=600 D CHECK^ACRFWARN
 .Q:$D(ACRQUIT)
 .;I ACRCCQ,Y>2500 D CHECKCC^ACRFWARN(Y)               ;ACR*2.1*5.17 ;ACR*2.1*22.06 IM23064
 .I ACRCCQ,Y>3000 D CHECKCC^ACRFWARN(Y)               ;ACR*2.1*22.06 IM23064
 .Q:$D(ACROUT)                                        ;ACR*2.1*5.17
 .I ACRCCQ!($P(ACRDOC0,U,12)),'ACRVND D NOVEN
 .;Q:$D(ACRQUIT)                                      ;ACR*2.1*5.17 ;ACR*2.1*22.11k 
 .;I ACRCCQ,'$P(ACRDOC0,U,25) D NOCCH  ;ACR*2.1*22.11k
 .;Q:$D(ACRQUIT)                       ;ACR*2.1*22.11k
 .I ACRCCQ,'$P(^ACRDOC(ACRDOCDA,0),U,25) D NOCCH  ;ACR*2.1*22.11k
 Q:$D(ACRQUIT)                         ;ACR*2.1*22.11k
 I +ACRVND,ACRCCQ!("^103^349^326^210^148^"[(U_ACRREF_U)) D
 .D CHKVNDR^ACRFVLK
 .;I $D(ACRVERR) S ACROUT=""  ;ACR*2.1*22.11j IM23064
 .I $D(ACRVERR) D  Q          ;ACR*2.1*22.11j IM23064
 ..W *7                       ;ACR*2.1*22.11j IM23064
 ..W !!,ACRVERR               ;ACR*2.1*22.11j IM23064
 ..D PAUSE^ACRFWARN           ;ACR*2.1*22.11j IM23064
 ..S ACROUT=""                ;ACR*2.1*22.11j IM23064
 .D HOME^ACRFMENU
 Q:$D(ACROUT)                                         ;ACR*2.1*5.17
 K ACRAPCHK
 Q:$D(ACROUT)
 ;
 I $P(ACRDOC0,U,12)="" D             ;DRAFT PAYMENT DEFAULT
 .S DA=ACRDOCDA
 .S DIE="^ACRDOC("
 .S DR=".12////0"
 .D DIE^ACRFDIC
 K ACRSSRQD
 S ACRREFDA=$P(ACRDOC0,U,13)
 S ACRREF=$P(^AUTTDOCR(ACRREFDA,0),U)
 S ACRCISDA=$P(^ACRDOC(ACRDOCDA,0),U,16)
 I ACRREF=148,$$ACSREQ^ACRFTO(ACRDOCDA)=1 D
 .S ACRSSRQD="AGREEMENT TO CONTINUE IN SERVICE not signed."
 I "^116^204^103^148^349^326^130^210^"[(U_ACRREF_U) D
 .N:ACRREF=148 X
 .S ACRSSDA=0
 .F  S ACRSSDA=$O(^ACRSS("C",ACRDOCDA,ACRSSDA)) Q:'ACRSSDA!$D(ACRSSRQD)  D
 ..I $D(^ACRSS(ACRSSDA,0)) D SSCHK^ACRFSSA
 ..I ACRREF=148 S X=$G(X)+$P($G(^ACRSS(ACRSSDA,"DT")),U,4)
 I ACRREFX=130,$P($G(^ACROBL(ACRDOCDA,"JST")),U)="" S ACRSSRQD="Purpose of Travel missing"
 I ACRREFX=103!(ACRREFX=349)!(ACRREFX=326),'ACRCCQ D  Q:$D(ACRI)
 .K ACRI
 .D 103^ACRFCHK
 .I $D(ACRI) D  Q
 ..W !!,*7,*7,"PO cannot be sent for approval until required BASIC DATA is completed."
 ..D PAUSE^ACRFWARN
 I ACRREF=103!(ACRREF=349)!(ACRREF=326)!(ACRREF=210),'ACRCCQ,'$P(ACRDOC0,U,4) D
 .I 'ACRCISDA S ACRSSRQD="Contract/Small Purchase Data missing." Q
 .I ACRCISDA,'$D(^ACGS(ACRCISDA,0))!'$D(^ACGS(ACRCISDA,"DT"))!'$D(^ACGS(ACRCISDA,"DT1"))!'$D(^ACGS(ACRCISDA,"DT2"))!'$D(^ACGS(ACRCISDA,"DT3")) S ACRSSRQD=$S($D(ACRSSRQD):ACRSSRQD_" and ",1:"")_"Contract/Small Purchase Data missing." Q
 .K ^TMP("ACG",$J)
 .S ACGRDA=ACRCISDA
 .D EN2^ACGSRQ
 .I $D(^TMP("ACG",$J)),^TMP("ACG",$J,"T")>0 S ACRSSRQD=$S($D(ACRSSRQD):ACRSSRQD_" and ",1:"")_"Contract/Small Purchase Data missing."
 .K ^TMP("ACG",$J)
 I ACRREF=130!(ACRREF=600),'$P(ACRDOC0,U,15),'$D(^ACRTV("D",ACRDOCDA)) D
 .S ACRSSRQD="NO TRAVEL DAYS RECORDED FOR THIS TRAVEL ORDER."
 I $D(ACRSSRQD) D  Q
 .W !!,*7,*7,"DOCUMENT CANNOT BE SENT FOR APPROVAL."
 .W !,ACRSSRQD
 .K ACRSSRQD
 .D PAUSE^ACRFWARN
 I $P(^ACRDOC(ACRDOCDA,0),U,19) D  I $D(ACRQUIT) K ACRQUIT Q
 .D CALLIM^ACRFBPA
 .Q:'$D(ACRQUIT)
 .K ACRQUIT
 .W *7,*7
 .W !,"The DOLLAR AMOUNT of this call exceeds the amount authorized by the BPA."
 .W !,"You are required to get verbal authorization to exceed the call limit."
 .S DIR(0)="YO"
 .S DIR("A")="Did you receive verbal authorization to exceed the call limit"
 .S DIR("B")="NO"
 .S DIR("?",1)="Enter 'Y' if you are authorized to exceed the call limit."
 .S DIR("?")="Enter 'N' if you do not have proper authorization to exceed the call limit."
 .D DIR^ACRFDIC
 .I $G(Y)'=1 S ACRQUIT="" Q
 .I $G(Y)=1 D
 ..D NOW^%DTC
 ..S DA=ACRDOCDA
 ..S DIE="^ACRDOC("
 ..S DR="21////"_%_";22////"_DUZ
 ..D DIE^ACRFDIC
APVS W !
 I ACRREF=130,$P($G(^ACRDOC(ACRDOCDA,"TO")),U,25) D OTA
 Q:$D(ACRQUIT)
 D ^ACRFAPVS
 N ACRDOCDA,ACRDOC,ACRID
 D ACRREV^ACRFPRCS
 K ACROUT,ACRQUIT
 Q
NOVEN ;GIVE NO VENDOR W/CC MESSAGE
 D WARNING^ACRFWARN
 W !!,"A request for credit card purchase or draft payment cannot be sent for approval"
 W !,"until a VENDOR has been selected from the Standard Vendor table."
 W !!,"Select '2' - 'Requested Vendor' from the edit screen for this document"
 W !,"and select a VENDOR/CONTRACTOR from the Standard Vendor table."
 W !!,"If the requested vendor is not on the Standard Vendor table, contact"
 W !,"your purchasing agent for assistance in getting the vendor added to the"
 W !,"Standard Vendor table."
 D PAUSE^ACRFWARN
 S ACRQUIT=""                          ;ACR*2.1*22.11k
 Q
NOCCH ;GIVE HOLDER MESSAGE
 W !!,"A request for credit card purchase or draft payment cannot be sent for approval"
 W !!,"without the credit card holder's name on file."
 W !,"Please enter the name of the credit card holder before proceeding."
 D PAUSE^ACRFWARN
 S ACRQUIT=""                          ;ACR*2.1*22.11k
 Q
OTA ;ACKNOWLEDGE TRAVEL ADVANCE
 Q:$P($G(^ACROTA(ACRDOCDA,1)),U,3)]""
 W !!,"I acknowledge request for travel advance."
 I DUZ='$P($G(^ACRDOC(ACRDOCDA,"TO")),U,9) D
 .W !!,"When submitting a Travel Order for approval which includes"
 .W !,"a request for Travel Advance, the request requires the"
 .W !,"signature of the Traveler to acknowledge the request for"
 .W !,"Travel Advance."
 .W !!,"Though you are not the traveler, you can send this TO for"
 .W !,"approval but you must sign to acknowledge the request for"
 .W !,"Travel Advance."
 D ^ACRFESIG
 I $D(ACRQUIT) D  Q
 .S ACRREFDA=$O(^AUTTDOCR("B",130,0))
 .I ACRREFDA D KILL^ACRFAPVS
 .W !!,"Travel order cannot be sent for approval without"
 .W !,"acknowledging request for travel advance."
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 I '$D(^ACROTA(ACRDOCDA,0)) S:'$G(ACRADV) ACRADV=0 D OTA^ACRFSSA1
 D NOW^%DTC
 S DA=ACRDOCDA
 S DIE="^ACROTA("
 S DR="2////"_DUZ_";3////"_%
 D DIE^ACRFDIC
 Q
