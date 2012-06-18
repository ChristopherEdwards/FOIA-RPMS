ABMPT258 ; IHS/ASDST/SDR - 3P BILLING 2.5 Patch 8 POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 Q
PREINST ;reset entries in 3P Page 3 Questions file
 S DIK="^ABMQUES("
 F ABMQ=25,26,29,30 D
 .S DA=ABMQ
 .D ^DIK
 S ABMDEL="^ABMPSTAT"
 K @ABMDEL
 S ABMDEL="^ABMCCLMR"
 K @ABMDEL
 Q
EN ; EP
 D QUES  ;add questions 32 and 33; 34/35
 D EXP25  ;add export mode 25 ADA-2002
 D EXP26  ;add export mode 26 ADA-99 v2000
 D EXP23  ;edit name of 837D to say ADA
 D ECODES ; add new error codes
 D DXLAG  ;put default in uncoded Dx lag time of 45 days
 D PCCST  ;new billing status (59)/uncoded Dxs and (60)Visit in Review Status
 D EXPUPDT  ;update export modes with new questions
 D VTYP  ;add ambulance VT
 D TPCODES  ;add codes to 3P Codes file
 D TURNON^DIAUTL(9999999.06,.14,"y")  ;turn on audit for LOCATION field .14
 D TURNON^DIAUTL(9999999.06,.15,"y")  ;turn on audit for LOCATION field .15
 D TURNON^DIAUTL(9999999.06,.16,"y")  ;turn on audit for LOCATION field .16
 D TURNON^DIAUTL(9999999.06,.17,"y")  ;turn on audit for LOCATION field .17
 Q
 ;
EXP25 ;
 K DIC,DR,DINUM,DLAYGO,DIE
 S DIC="^ABMDEXP("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S X="ADA-2002",DINUM=25
 K DD,DO
 D ^DIC
 Q:Y<0
 S DA=+Y
 S DIE="^ABMDEXP("
 S DR=".04////ABMDF25;.05////ABMDF25X;.06///C;.07///Dental Claim Form Dated 2002;.08///1,2,3,4,9,16,17,18,34,35;.11////ABMDES4;.15///H"
 D ^DIE
 Q
EXP26 ;
 K DIC,DR,DINUM,DLAYGO,DIE
 S DIC="^ABMDEXP("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S X="ADA-99 v2000",DINUM=26
 K DD,DO
 D ^DIC
 Q:Y<0
 S DA=+Y
 S DIE="^ABMDEXP("
 S DR=".04////ABMDF26;.05////ABMDF26X;.06///C;.07///Dental Claim Form Dated 2000;.08///1,2,3,4,9,16,17,18;.11////ABMDES4;.15///H"
 D ^DIE
 Q
QUES ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=32,X="NUMBER OF ENCLOSURES"
 S DIC("DR")=".02////W32;.03////ABMDE30;.04////32;1////ABMDE3C"
 K DD,DO
 D ^DIC
 ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=33,X="OTHER DENTAL CHARGES"
 S DIC("DR")=".02////W33;.03////ABMDE30;.04////33;1////ABMDE3C"
 K DD,DO
 D ^DIC
 ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=34,X="REFERENCE LAB CLIA#"
 S DIC("DR")=".02////W34;.03////ABMDE30;.04////34;1////ABMDE3C"
 K DD,DO
 D ^DIC
 ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=35,X="IN-HOUSE CLIA#"
 S DIC("DR")=".02////W35;.03////ABMDE30;.04////35;1////ABMDE3C"
 K DD,DO
 D ^DIC
 Q
EXP23 ;
 S DIE="^ABMDEXP("
 S DA=23
 S DR=".01///837 DENT (ADA)"
 D ^DIE
 Q
ECODES ;
 ; 194-197 for IM15307/IM14092 - MSP on page 2
 ;194
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=194
 S X="NO MSP FORM FOR INPATIENT CLAIM"
 S DIC("DR")=".02///The system indicates that there is no MSP Form on file.  Please verify that an MSP Form has been obtained and is on file."
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;195
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=195
 S X="MSP STATUS GREATER THAN 90 DAYS"
 S DIC("DR")=".02///The MSP Form on file in Pat Reg indicates the last form obtained exceeds the 90-day time period set by CMS.  Please verify an MSP form has been obtained and is on file."
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;196
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=196
 S X="MSP UNSPECIFIED - VERIFY YOUR ELIGIBILITY IN REGISTRATION"
 S DIC("DR")=".02///MSP entries do not exist on the Medicare page in Pat Reg but the sequencing in the claim editor indicates Medicare is secondary payer."
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;197
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=197
 S X="PATIENT IS AN MSP PATIENT"
 S DIC("DR")=".02///An MSP entry exists in Pat Reg but the claim editor sequencing does not indicate Mediacre is secondary.  Please verify the accuracy of the Medicare entries in Pat Reg."
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;199
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=199
 S X="LAB CHARGES WITH NO REFERRING PROVIDER ON PAGE 3"
 S DIC("DR")=".02///Enter Referring Provider on page 3"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;200
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=200
 S X="CLIA NUMBER MISSING"
 S DIC("DR")=".03///E"
 K DD,DO
 D FILE^DICN
 D SITE(200)
 ;203 IM15111
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=203
 S X="FORMAT OF MEDICARE/MEDICAID NAME INCORRECT"
 S DIC("DR")=".02///CORRECT NAME FORMAT IN PAT REG."
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(203)
 ;204 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=204
 S X="POINT OF PICKUP FOR PATIENT IS MISSING"
 S DIC("DR")=".02///ENTER POINT OF PICKUP"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(204)
 ;205 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=205
 S X="ORIGINATING ZIP CODE MISSING"
 S DIC("DR")=".02///ENTER ORIGINATING ZIP CODE"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(205)
 ;206 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=206
 S X="DESTINATION FOR THE PATIENT IS MISSING OR INCOMPLETE"
 S DIC("DR")=".02///POPULATE DESTINATION FIELDS ON PAGE 3A"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(206)
 ;207 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=207
 S X="MEDICAL NECESSITY INDICATOR BLANK"
 S DIC("DR")=".02///ANSWER MEDICAL NECESSITY QUESTION ON PAGE 3A"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(207)
 ;208 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=208
 S X="PATIENT WEIGHT REQUIRED"
 S DIC("DR")=".02///ANSWER PATIENT WEIGHT QUESTION ON PAGE 3A"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(208)
 ;209 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=209
 S X="AMBULANCE PROCEDURE REQUIRES MODIFIER"
 S DIC("DR")=".02///ENTER MODIFIER FOR AMBULANCE PROCEDURE"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(209)
 ;210 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=210
 S X="DRUG NAME/DOSAGE REQUIRED FOR NOC DRUG"
 S DIC("DR")=".02///ENTER DRUG NAME/DOSAGE ON PAGE 3"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(210)
 ;211 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=211
 S X="MILEAGE DATA MISSING"
 S DIC("DR")=".02///ENTER A0425 OR A0888 ON PAGE 8H OR 8K"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;212 - ambulance billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=212
 S X="QL modifier is used - other modifiers will be skipped"
 S DIC("DR")=".02///Remove QL if other modifiers are necessary"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 ;213 - Rx billing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=213
 S X="PHARMACY DATA EXISTS IN PCC THAT IS NOT ON CLAIM"
 S DIC("DR")=".03///W"
 K DD,DO
 D FILE^DICN
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////E"
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
DXLAG ; default lag time to 45 days
 S DIE="^ABMDPARM(DUZ(2),"
 S DA=1
 S DR=".52///45"
 D ^DIE
 Q
PCCST ;
 K DIC,X,DINUM
 S DIC="^ABMDCS("
 S DINUM=59
 S X="UNCODED DX EXISTS ON VISIT"
 S DIC(0)="ML"
 K DD,DO
 D FILE^DICN
 ;
 K DIC,X,DINUM
 S DIC="^ABMDCS("
 S DINUM=60
 S X="VISIT IN REVIEW STATUS"
 S DIC(0)="ML"
 K DD,DO
 D FILE^DICN
 ;
 K DIC,X,DINUM
 S DIC="^ABMDCS("
 S DINUM=61
 S X="INPATIENT CODING INCOMPLETE"
 S DIC(0)="ML"
 K DD,DO
 D FILE^DICN
 Q
EXPUPDT ;
 F ABMEXPM=3,14,22,23 D
 .S ABMQUES=$P($G(^ABMDEXP(ABMEXPM,0)),U,8)
 .Q:ABMQUES["34,35"
 .S ABMQUES=ABMQUES_",34,35"
 .S DIE="^ABMDEXP("
 .S DA=ABMEXPM
 .S DR=".08////"_ABMQUES
 .D ^DIE
 ;
 S ABMQUES=$P($G(^ABMDEXP(14,0)),U,8)
 Q:ABMQUES["19"
 S ABMQUES=ABMQUES_",19"
 S DIE="^ABMDEXP("
 S DA=14
 S DR=".08///"_ABMQUES
 D ^DIE
 Q
VTYP ; new visit type 902-ambulance
 K DIC,X,DINUM
 S DIC="^ABMDVTYP("
 S X="AMBULANCE"
 S DIC(0)="EML"
 S DINUM=902
 K DD,DO
 D FILE^DICN
 Q
TPCODES ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMDCODE("
 S DIC(0)="LM"
 S DLAYGO=9002274.03
 S ABMCNT=0
 S ABMTAG="CODES"
 F  D  Q:$P($T(@ABMTAG+ABMCNT),";;",2)="END"
 .S ABMCREC=$P($T(@ABMTAG+ABMCNT),";;",2)
 .S ABMCNT=ABMCNT+1
 .S X=$P(ABMCREC,";",1)
 .Q:$D(^ABMDCODE("AC",$P(ABMCREC,";",2),X))=10
 .S DIC("DR")=".02////"_$P(ABMCREC,";",2)
 .S DIC("DR")=DIC("DR")_";.03////"_$P(ABMCREC,";",3)
 .S DIC("DR")=DIC("DR")_";.04////"_$P(ABMCREC,";",4)
 .K DD,DO
 .D FILE^DICN
 Q
CODES ;;A0;V;Originating zip code-ambulance only;0
 ;;32;V;Multiple patient ambulance transport;0
 ;;B2;C;CAH Attestation;0
 ;;END
 Q
