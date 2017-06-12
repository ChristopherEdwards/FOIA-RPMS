ABSPECP3 ; IHS/FCS/DRS - Receipts ;  [ 09/19/2002  10:16 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,42**;JUN 21, 2001;Build 15
 ;
 ;-----------------------------------------------------------------
 ;IHS/SD/lwj 9/19/02  NCPDP 5.1 changes
 ; There were many, many changes with the coming of NCPDP 5.1.  One
 ; is that 42% of the existing claim fields, and 50% of the existing
 ; result fields changed field type, value types, and field names.
 ; The changes in field names cause this program a little grief 
 ; so adjustments were made accordingly.
 ;
 ;
 ;-----------------------------------------------------------------
 ;
 Q
 ; TMP("C",field)=value for claim header
 ; TMP("C",field,"RX",n)=values for claim medication
 ; TMP("R",field)=values for claim response
 ; TMP("R",field,"RX",n)=values for medication responses
 Q
 ;
 ; * BEGIN * for file 9002313.99, Field RECEIPT STYLE
RECEIPT ;EP - from ABSPECP0, RECEIPT^ABSPOS6E
 N SRC S SRC="TMP"
 D FULL() Q
FULL0 ;EP - from ABSPECP0
 W " - RECEIPT -",!
 D PRINT("TMP","PCS1") Q
ANMC ;
 ; Write any kind of page header here
 D PRINT("TMP","ANMC1")
 Q
 ; * END * of receipt styles
 ;
TEST ;O 51:("TMP.OUT":"W") U 51 S SRC="TMP" D FULL() C 51 Q
FULL(DIV,LEV,RX) ; print it all    
 ;  WHAT YOU'RE LOOKING FOR PROBABLY IS NOT HERE
 ;  LOOK BELOW, AT "PRINTSEG" INSTEAD!!!!!!!!!!!
 ; recurse, filling in parameters
 I '$D(DIV) D FULL("C"),FULL("R") Q
 I '$D(LEV) D  D FULL(DIV,0) Q  ; header, then prescription come at end
 .W " = = = = = ",$S(DIV="C":"CLAIM",DIV="R":"RESPONSE")," = = = = =",!
 ;
 ;IHS/SD/lwj  9/19/02  NCPDP 5.1  Prescription Number is now called
 ; Prescription/Service Ref Num - within the do loop one line
 ; was commented out and the next 2 lines were added to adjust for chg.
 ;
 I $G(LEV)=1,'$D(RX) D  Q
 .;S RX=0 F  S RX=$O(@SRC@("C","Prescription Number","RX",RX)) Q:'RX  D
 .S RX=0
 .F  S RX=$O(@SRC@("C","Prescription/Service Ref Num","RX",RX)) Q:'RX  D
 ..;W " * TMP * Prescription Number ",RX," * TMP * ",!
 ..D FULL(DIV,LEV,RX)
 I '$D(IOM) N IOM S IOM=80
 N FIELD,TITLE,VALUE
 S FIELD="" F  S FIELD=$O(@SRC@(DIV,FIELD)) Q:FIELD=""  D
 .;W "LEV=",LEV,",FIELD=",FIELD,!
 .I LEV=0,$D(@SRC@(DIV,FIELD))>9 Q  ; header skips prescription fields
 .I LEV=1,$D(@SRC@(DIV,FIELD))<9 Q  ; prescription skips header fields
 .; Specialized titles are done here
 .I 0
 .E  S TITLE=FIELD_": "
 .N OUTPUT
 .I LEV=0 S VALUE=@SRC@(DIV,FIELD),OUTPUT=1
 .;I LEV=1 ZW DIV,FIELD,RX R ">>",%,!
 .I LEV=1 D
 ..I FIELD="Reject Code" D  S OUTPUT=0 Q
 ...N X,I S X="" F I=0:1 S X=$O(@SRC@(DIV,FIELD,"RX",RX,X)) Q:X=""  D
 ....S VALUE=@SRC@(DIV,FIELD,"RX",RX,X)
 ....S TITLE="Reject code: "
 ....D OUTPUT
 ..I FIELD="NDC Number" D  S OUTPUT=0 Q
 ...S VALUE=$$FORMTNDC^ABSPOS9($TR(@SRC@(DIV,FIELD,"RX",RX),"-",""))
 ...D OUTPUT
 ..I FIELD="DUR Response Data" D  S OUTPUT=0 Q
 ...N X S X=@SRC@(DIV,FIELD,"RX",RX)
 ...S VALUE="" D OUTPUT ; "DUR Response Data:"
 ...N FIELD
 ...D DUROUT(X)
 ..I FIELD="Preferred Product" D  S OUTPUT=0 Q  ;OIT/PIERAN/RCS/Patch 42
 ...N X,I S X="" F I=0:1 S X=$O(@SRC@(DIV,FIELD,"RX",RX,X)) Q:X=""  D
 ....S VALUE=@SRC@(DIV,FIELD,"RX",RX,X)
 ....S TITLE="Preferred Product "_X_": "
 ....D OUTPUT
 ..I FIELD="Additional Information" D  S OUTPUT=0 Q  ;OIT/PIERAN/RCS/Patch 42
 ...N X,I S X="" F I=0:1 S X=$O(@SRC@(DIV,FIELD,"RX",RX,X)) Q:X=""  D
 ....S VALUE=@SRC@(DIV,FIELD,"RX",RX,X)
 ....S TITLE="Additional Information "_X_": "
 ....D OUTPUT
 ..S VALUE=@SRC@(DIV,FIELD,"RX",RX),OUTPUT=1
 .I OUTPUT D OUTPUT
 I LEV=0 W " - - Prescription - -",! D FULL(DIV,1)
 Q
OUTPUT ; TITLE,VALUE,!
 W TITLE
 N X S X=VALUE
 N Y S Y=IOM-$X-1 W $E(X,1,Y) S X=$E(X,Y+1,$L(X))
 F  W ! Q:X=""  W $E(X,1,IOM) S X=$E(X,IOM+1,$L(X))
 Q
DUROUT(X)          ; output of DUR string
 N I,L,Y S L=53 F I=0:1:2 D
 .N Y S Y=$E(X,I*L+1,I*L+L)
 .I Y?." " Q  ; blank section
 .I $E(Y,1,2)=" 0" Q  ; PCS test has this
 .I $E(Y,1,2)="  " Q  ; PCS test has this
 .I $E(Y,1,2)="0 " Q  ; PCS test has this (?)
 .I I W "   - - - DUR response data, part ",I+1," - - -",!
 .D DUROUT1(Y)
 Q
DUROUT1(X)         ; output of one substring of DUR string
 N Y
 S TITLE="   Drug Conflict Code: ",VALUE=$$DUR^ABSPECP2($E(X,1,2))
 D OUTPUT
 S TITLE="   Severity Index Code: ",VALUE=$E(X,3) D OUTPUT
 S TITLE="   Other Pharmacy Indicator: "
 S VALUE=$$OTHPHARM^ABSPECP2($E(X,4)) D OUTPUT
 S TITLE="   Previous Date of Fill: ",VALUE=$E(X,5,12)
 I VALUE?8N,VALUE>19900000 S Y=VALUE-17000000 X ^DD("DD") S VALUE=Y
 D OUTPUT
 S TITLE="   Qty. of Previous Fill: ",VALUE=+$E(X,13,17) D OUTPUT
 S TITLE="   Database Indicator: ",VALUE=$E(X,18) D OUTPUT
 S TITLE="   Other Prescriber Indicator: "
 S VALUE=$$OTHPRESC^ABSPECP2($E(X,19)) D OUTPUT
 S TITLE="   Message: ",VALUE=$E(X,20,49) D OUTPUT
 ; bytes 50-53 reserved
 Q
PRINT(SRC,FORMAT) ;
 D PRINTSEG("C0"_FORMAT)
 D PRINTSEG("R0"_FORMAT)
 N RX S RX=0
 F  S RX=$O(@SRC@("C","Prescription Number","RX",RX)) Q:'RX  D
 .D PRINTSEG("C1"_FORMAT)
 .D PRINTSEG("R1"_FORMAT)
 Q
PRINTSEG(SEG) ;
 N DIV S DIV=$E(SEG)
 N LINE,STOP F LINE=0:1 D  Q:$G(STOP)
 .N X S X=$T(@SEG+LINE) I X'[";;" D IMPOSS^ABSPOSUE("P","TI",SEG,,"PRINTSEG",$T(+0)) ; internal error ; missing "*"
 .N FIELD S FIELD=$P(X,";",3)
 .I FIELD="*" S STOP=1 Q
 .F  Q:$E(FIELD)'=" "  S FIELD=$E(FIELD,2,$L(FIELD)) ; leading sp okay
 .Q:FIELD=""  ; empty entry is okay
 .I FIELD="Reject Code" D  Q
 . .N X,I S X="" F I=0:1 S X=$O(@SRC@(DIV,FIELD,"RX",RX,X)) Q:X=""  D
 . . .S VALUE=@SRC@(DIV,FIELD,"RX",RX,X)
 . . .S TITLE=FIELD_":"
 . . .D OUTPUT
 .I FIELD="DUR Response Data" D  Q
 . .S X=$G(@SRC@(DIV,FIELD,"RX",RX))
 . .S TITLE=FIELD_":",VALUE=""
 . .I X="" S TITLE="No "_FIELD D OUTPUT Q
 . .S VALUE="" D OUTPUT ; "DUR Response Data"
 . .N FIELD D DUROUT(X)
 .N VALUE D GETVALUE
 .N TITLE S TITLE=$P(X,";",4)
 .;ZW TITLE R ">>",%,! ZW VALUE R ">>",%,!
 .I TITLE="" S TITLE=FIELD_": "
 .E  X TITLE
 .;ZW TITLE R ">>",%,!
 .I FORMAT'="PCS",VALUE=""!(VALUE?." ") Q
 .D OUTPUT
 Q
GETVALUE ; given SEG,FIELD,RX
 I $E(SEG,2)=0 D  ; a header field
 .S VALUE=$G(@SRC@($E(SEG),FIELD))
 E  I $E(SEG,2)=1 D  ; a prescription field
 .S VALUE=$G(@SRC@($E(SEG),FIELD,"RX",RX))
 E  D IMPOSS^ABSPOSUE("P","TI",SEG,,"GETVALUE",$T(+0)) ; internal error
 Q
 ; Piece 3 - field name
 ; Piece 4 - execute to set TITLE=something based on FIELD and VALUE
 ;Cn is for the claim, Rn is for the response
 ;x0 is for the header, x1 is for the prescription
 ;xxPCS1 is for the receipt for the PCS certification testing
 ;xxANMC1 is for the ANMC receipt
C0ANMC1 ;;Patient Name;S TITLE=""
 ;;Cardholder ID Number
 ;;Electronic Payor
 ;;Claim ID
 ;;*
 ;;
C0PCS1 ;;Patient Name;S TITLE=""
 ;;Group Number
 ;;Cardholder ID Number
 ;;Electronic Payor
 ;;Pharmacy Number
 ;;Claim ID
 ;;Transaction Code
 ;;*
C1ANMC1 ;;Medication Name;S TITLE=""
 ;;Metric Quantity;S TITLE="Quantity: "
 ;;NDC Number
 ;;Date Filled
 ;;Prescription Number
 ;;Transmitted On;S TITLE="Claim sent "
 ;;*
C1PCS1 ;;Medication Name;S TITLE=""
 ;;Date Filled
 ;;Metric Quantity
 ;;Prescription Number
 ;;NDC Number
 ;;DUR Response Data
 ;;Reject Code
 ;;*
R0ANMC1 ;;
 ;;*
R0PCS1 ;;
 ;;*
R1ANMC1 ;;Response Status (Prescription);S TITLE="Prescription Status:"
 ;;Authorization Number
 ;;DUR Response Data
 ;;Reject Code
 ;;Message
 ;;Message (more)
 ;;*
R1PCS1 ;;
 ;;Response Status (Prescription);S TITLE=""
 ;;Authorization Number
 ;;Patient Pay Amount;S TITLE=$J(FIELD,21)
 ;;Ingredient Cost Paid;S TITLE=$J(FIELD,21)
 ;;Contract Fee Paid;S TITLE=$J(FIELD,21)
 ;;Sales Tax Paid;S TITLE=$J(FIELD,21)
 ;;Total Amount Paid;S TITLE=$J(FIELD,21)
 ;;*
C0ALL ;;Claim ID 
 ;;Electronic Payor
 ;;Billing Item IEN
 ;;Transmit Flag
 ;;Transmitted On
 ;;Created On
 ;;Patient Name
 ;;Billing Item PCN #
 ;;Billing Item VCN #
 ;;BIN Number
 ;;Version/Release Number
 ;;Transaction Code
 ;;Processor Control Number
 ;;Pharmacy Number
 ;;Group Number
 ;;Cardholder ID Number
 ;;Person Code
 ;;Date of Birth
 ;;Sex Code
 ;;Relationship Code
 ;;Customer Location
 ;;Other Coverage Code
 ;;Eligibility Clarification Code
 ;;Patient First Name
 ;;Patient Last Name
 ;;*
C1ALL ;;Date Filled
 ;;Prescription Number
 ;;New/Refill Code
 ;;Metric Quantity
 ;;Days Supply
 ;;Compound Code
 ;;NDC Number
 ;;Dispense As Written
 ;;Ingredient Cost
 ;;Sales Tax
 ;;Prescriber ID
 ;;Dispensing Fee Submitted
 ;;Date Prescription Written
 ;;Number Refills Authorized
 ;;PA/MC Code & Number
 ;;Level of Service
 ;;Prescription Origin Code
 ;;Prescription Clarification
 ;;Primary Prescriber
 ;;Clinic ID N
 ;;*
R0ALL ;;
 ;;*
R1ALL ;;
 ;;*
