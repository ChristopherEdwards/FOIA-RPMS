BSDAIU ; IHS/ANMC/LJF - ADDRESS & INSURANCE UPDATE ; 
 ;;5.3;PIMS;**1007,1010,1012**;APR 26, 2002
 ;
 ;cmi/anch/maw 09/01/2008 PIMS Patch 1010 RQMT33 added number in household and income in DEM
 ;cmi/anch/maw 09/01/2008 PIMS Patch 1010 RQMT6 added mother and fathers employer name
 ;cmi/flag/maw 05/14/2010 PIMS Patch 1012 RQMT142 added call to this report from Appointment Managment
 ;
 ;
OR ;EP - called from Other Reports on Appointment Management if no patient
 I $G(DFN) D PATE Q  ;cmi/maw 05/14/2010 skip patient if already exists
 NEW DFN,BSDFORM
 S DFN=+$$READ^BDGF("PO^2:QEMZ","Select PATIENT") Q:'DFN
PATE ;EP - called from Other Reports on Appointment Management if patient
 D ZIS^BDGF("PQ","BEGIN^BSDAIU","ADDRESS/INSURANCE FORM","DFN")
 Q
 ;
 ;
BEGIN ;EP;  entry point from queuing and from BSDFORM
 U IO
 D DEM,EC,TRIBE,PRVT,MCR,MCD,PRT2
 ;
 I '$G(BSDFORM) D ^%ZISC      ;close device if not called within a loop
 D KILL^AUPNPAT               ;kill patient variables
 Q
 ;
DEM ;-- print demographics
 NEW X,I
 S X=$$DIVNM^BSDU($$DIV^BSDU) W !!,?80-$L(X)\2,X         ;division
 W !?16,$$CONF^BSDU
 W !,?17,"*** PATIENT ADDRESS AND INSURANCE UPDATE ***"
 W !,?9,"*** PLEASE MAKE CORRECTIONS TO ANY INCORRECT INFORMATION ***"
 W !!,$E($$GET1^DIQ(2,DFN,.01),1,27)                     ;pat name
 W ?30,"HRCN: ",$$HRCN^BDGF2(DFN,+$G(DUZ(2)))            ;chart #
 W ?44,"DOB: ",$$GET1^DIQ(2,DFN,.03)                     ;date of birth
 W ?62,"AGE: ",$$GET1^DIQ(9000001,DFN,1102.98)           ;printable age
 W !,"SSN: ",$$GET1^DIQ(2,DFN,.09)                       ;ssn
 ;
 I $$GET1^DIQ(9000001,DFN,1112)["PENDING" D
 . W !!,$$REPEAT^XLFSTR("*",80)
 . W !?3,"ELIGIBILITY PENDING - HAVE PATIENT SEE APPROPRIATE PERSONNEL FOR VERIFICATION"
 . W !!,$$REPEAT^XLFSTR("*",80)
 ;
 I $G(^DPT(DFN,.11))="" D
 . W !,?3,"Please enter your address,work and phone number on "
 . W "the line below."
 . W !!,?3," " N X S $P(X,"_",75)="" W X K X
 E  D
 . ;address and phone number
 . W ! F I=.111,.112,.113 S X=$$GET1^DIQ(2,DFN,I) I X]"" W !,X  ;street
 . W ?48,"Home: ",$$GET1^DIQ(2,DFN,.131)                   ;home phone
 . W !,$$GET1^DIQ(2,DFN,.114),", ",$$STATE(2,DFN,.115)     ;city,state
 . W " ",$$GET1^DIQ(2,DFN,.116)                            ;zip
 . W ?48,"Birth Place: ",$$STATE(2,DFN,.093)               ;birth state
 ;
 W !!,?3,"Employer: ",$$GET1^DIQ(9000001,DFN,.19)          ;employer
 W ?48,"Work Phone: ",$$GET1^DIQ(2,DFN,.132)               ;work phone
 W !,?3,"Spouse's Employer: ",$$GET1^DIQ(9000001,DFN,.22)  ;spouse empl
 W ?48,"Work Phone: ",$$GET1^DIQ(2,DFN,.258)               ;spouse phon
 ;
 W !!,?3,"Father's Name: ",$$GET1^DIQ(2,DFN,.2401)         ;father
 W ?48,"Birthplace: ",$$GET1^DIQ(9000001,DFN,2602)_", "    ;birth city
 W $$STATE(9000001,DFN,2603)                               ;birth state
 W !,?3,"Father's Employer: ",$$GET1^DIQ(9000001,DFN,2701)  ;fathers employer name cmi/maw 9/1/2008 PIMS Patch 1010 RQMT6
 W !,?3,"Mother's Name: ",$$GET1^DIQ(2,DFN,.2403)          ;maiden name
 W ?48,"Birthplace: ",$$GET1^DIQ(9000001,DFN,2605)_", "    ;birth city
 W $$STATE(9000001,DFN,2606)                               ;birth state
 W !,?3,"Mother's Employer: ",$$GET1^DIQ(9000001,DFN,2702)  ;mothers employer name cmi/maw 9/1/2008 PIMS Patch 1010 RQMT6
 W !!?3,"Number in Household: ",$$GET1^DIQ(9000001,DFN,.35)  ;number in household cmi/maw 9/1/2008 PIMS Patch 1010 RQMT33
 W ?48,"Household Income: ",$$GET1^DIQ(9000001,DFN,.36)    ;household income cmi/maw 9/1/2008 PIMS Patch 1010 RQMT33 
 Q
 ;
EC ; emergency contact info
 W !!,?3,"Emergency Contact: ",$$GET1^DIQ(2,DFN,.331)      ;ec name
 W !,?3,"Relationship: ",$$GET1^DIQ(2,DFN,.332)            ;ec relation
 ;W ?48,"Phone No.: ",$$GET1^DIQ(2,DFN,339)                 ;ec phone cmi/anch/maw 6/29/2007 orig code PATCH 1007
 W ?48,"Phone No.: ",$$GET1^DIQ(2,DFN,.339)                 ;ec phone cmi/anch/maw 6/29/2007 mod code PATCH 1007
 W !,?3,"Mailing Address: ",$$GET1^DIQ(2,DFN,.333)         ;ec street
 W !,?3,"City: ",$$GET1^DIQ(2,DFN,.336)                    ;ec city
 W ?28,"State: ",$$STATE(2,DFN,.337)                       ;ec state
 W ?48,"Zip: ",$$GET1^DIQ(2,DFN,.338)                      ;ec zip
 Q
 ;
TRIBE ; print tribe info
 W !!,"ELIGIBILITY: ",$$GET1^DIQ(9000001,DFN,1112),!
 W !,"TRIBE OF MEMBERSHIP/CORP.   BLOOD QUANTUM   TRIBE QUANTUM   TRIBE"
 W !,"-------------------------   -------------   -------------   -----"
 W !,$E($$GET1^DIQ(9000001,DFN,1108),1,25)                 ;tribe/corp
 W ?29,$$GET1^DIQ(9000001,DFN,1110)                        ;blood quant
 W ?45,$$GET1^DIQ(9000001,DFN,1109)                        ;tribe quant
 W ?60,$E($$GET1^DIQ(9000001,DFN,1127),1,5)                ;old tribe
 Q
 ;
PRVT ;find private insurance
 W !!,?3,"INSURANCE COMPANY",?35,"POLICY #",?51,"ELIGIBILITY DATES",!
 W ?3,$$REPEAT^XLFSTR("-",27),?35,$$REPEAT^XLFSTR("-",12)
 W ?51,$$REPEAT^XLFSTR("-",26)
 ;
 I '$D(^AUPNPRVT(DFN)) D  Q
 . W !,"   *** NO PRIVATE INSURANCE INFORMATION ON RECORD ***"
 ;
 NEW X,Y,X0,Y0
 S X=0 F  S X=$O(^AUPNPRVT(DFN,11,X)) Q:'X  D
 . Q:'$D(^AUPNPRVT(DFN,11,X,0))  S X0=^(0)
 . S Y=+X0 Q:'Y!('$D(^AUTNINS(+Y,0)))  S Y0=^(0)
 . W !,?3,$P(Y0,U),?35,$P(X0,U,2)
 . I +$P(X0,U,6) D
 .. N Y S Y=$P(X0,U,6) X ^DD("DD") W ?51,Y," to "
 . I +$P(X0,U,7) D
 .. N Y S Y=$P(X0,U,7) X ^DD("DD") W ?66,Y
 Q
 ;
MCR ;find medicare information
 W !!,?3,"MEDICARE NUMBER",?21,"RELEASE DATE"
 W ?35,"MEDICARE ELIGIBILITY DATES/COVERAGE"
 N X,Y,Z S $P(X,"-",16)="",$P(Y,"-",12)="",$P(Z,"-",36)=""
 W !,?3,$$REPEAT^XLFSTR("-",16),?21,$$REPEAT^XLFSTR("-",12)
 W ?35,$$REPEAT^XLFSTR("-",36)
 ;
 I '$D(^AUPNMCR(DFN)) D  Q
 . W !,"   *** NO MEDICARE INFORMATION ON RECORD ***"
 ;
 N X,Y,X0,Y0
 S X0=^AUPNMCR(DFN,0) D
 . S Y=$P(X0,U,3) Q:'Y  W !,?3,Y               ;medicare number
 . S Y=$P(X0,U,4) Q:'Y!('$D(^AUTTMCS(+Y,0)))  S Y0=^(0) W ?14,Y0
 W ?21,$$GET1^DIQ(9000001,DFN,.04)
 S X=0
 F  S X=$O(^AUPNMCR(DFN,11,X)) Q:'X  D
 . Q:'$D(^AUPNMCR(DFN,11,X,0))  S X0=^(0)
 . I $P(X0,U) D
 .. N Y S Y=$P(X0,U) X ^DD("DD") W ?35,Y," to "
 . I $P(X0,U,2) D
 .. N Y S Y=$P(X0,U,2) X ^DD("DD") W ?50,Y
 . I $P(X0,U,3)'="" D
 .. N Y S Y=$P(X0,U,3) W ?65,Y
 . W !
 Q
 ;
MCD ;find medicaid information 
 W !!,?3,"MEDICAID NUMBER",?35,"MEDICAID ELIGIBILITY DATES/COVERAGE"
 W !?3,$$REPEAT^XLFSTR("-",16),?35,$$REPEAT^XLFSTR("-",36)
 ;
 I '$D(^AUPNMCD("B",DFN)) D  Q
 . W !,"   *** NO MEDICAID INFORMATION ON RECORD ***"
 ;
 NEW X,Y,Z,X0,Y0,IFN
 S IFN=0 F  S IFN=$O(^AUPNMCD("B",DFN,IFN)) Q:IFN=""  D
 . S X0=^AUPNMCD(IFN,0) D
 .. S Y=$P(X0,U,3) W !,?3,Y               ;medicaid number
 .. S Y=$P(X0,U,4) Q:'Y!('$D(^DIC(5,+Y,0)))  S Y0=$P(^(0),U,2) W ?14,Y0
 .. S Y=$S($P(X0,U,8):$P(X0,U,8),1:"") Q:'Y  X ^DD("DD") S Z=Y
 . S X=0 F  S X=$O(^AUPNMCD(IFN,11,X)) Q:'X  D
 .. Q:'$D(^AUPNMCD(IFN,11,X,0))  S X0=^(0)
 .. I $P(X0,U) D
 ... N Y S Y=$P(X0,U) X ^DD("DD") W ?35,Y," to "
 .. I $P(X0,U,2) D
 ... N Y S Y=$P(X0,U,2) X ^DD("DD") W ?50,Y
 .. I $P(X0,U,3)'="" D
 ... N Y S Y=$P(X0,U,3) W ?65,Y
 I $G(Z) W !!,?3,"Medicaid date of last update: ",Z,!
 Q
 ;
PRT2 ;print request for current information
 NEW X,Y
 W !!,?3,"Does this include Dental coverage?  Yes___  No___"
 W !!,?3,"Is this a work related Injury?      Yes___ No___",!
 W ?3,"Date of Injury: _______________________"
 W !!,?8,"We appreciate your cooperation and assistance in filling"
 W " out this form."
 W !,?3,"It is important that we keep our patient registration"
 W " files accurate so"
 W !,?3,"that we can provide a better service to you."
 W !!,?3,"The Business Office, ",$$GET1^DIQ(9999999.06,DUZ(2),.02)
 W ?50,"Printed ",$$TIME^BDGF($$NOW^XLFDT),"  ",$$FMTE^XLFDT(DT)
 Q
 ;
STATE(FILE,PAT,FIELD) ; returns state abbreviation for state field sent
 NEW X S X=$$GET1^DIQ(FILE,PAT,FIELD,"I")
 Q $$GET1^DIQ(5,+X,1)
