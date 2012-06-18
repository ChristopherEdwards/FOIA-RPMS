PSUCS17 ;BIR/DJE,DJM - GENERATE PSU CS RECORDS (TYPE 17) ;25 AUG 1998
 ;;3.0;PHARMACY BENEFITS MANAGMENT;;Oct 15, 1998
 ;
 ; ***********************************************
 ; TYPE 17 - "Logged for patient"
 ; ***********************************************
EN ;EP  scan the ^XTMP(job,"MC",loc,pat,drug,qt)=PSUIENDA
 ;  where type 17 were stored combining multiples for a patient
 S PSULOC="",PSUMCHK=0,PSUTYP=17
 F  S PSULOC=$O(^XTMP(PSUCSJB,"MC",PSULOC)) Q:PSULOC=""  D
 . S DFN=0
 . F  S DFN=$O(^XTMP(PSUCSJB,"MC",PSULOC,DFN)) Q:DFN'>0  D DRUG
 Q
DRUG ;EP loop drugs within patient
 S Z=0
 F  S Z=$O(^XTMP(PSUCSJB,"MC",PSULOC,DFN,Z)) Q:Z=""  S X=^(Z) D
 . S PSUPIEN(73)=DFN
 . S PSUIENDA=X,PSUDRG=Z
 . S PSUDTM(3)=$$VALI^PSUTL(58.81,PSUIENDA,3),SENDER=PSUSNDR
 . S PSURI="H"
 . N Z
 . D TYP17
 . I 'PSUTQY(5) Q  ; do not send if QTY=0
 . D BUILDREC^PSUCS5
 . K PSUSSN,PSUPLC
 Q
 ;     
TYP17 ; Processing the transaction for dispensing type 17 
 ;('logged for patient'). If the dispensing type=17 and a patient IEN 
 ;is identified, one can use this information one find the ward location
 ;if the patient is still an inpatient when the extract is done.
 D FACILTY
 ;     
 ; (type 17 specific call)
 ; Patient SSN
 D SSN
 ;
 ; Generic name, Location type.
 D GNAME^PSUCS4,LOCTYP^PSUCS4
 ; Requirement 3.2.5.7
 Q:"N"'[PSULTP(1)
 ;
 ;
 ;VA Drug class, Formulary/Non-formulary, National formulary Indicator.
 D NDC^PSUCS4,FORMIND^PSUCS4,NFIND^PSUCS4
 ;
 ;(type 17 specific call)
 ; Dispense unit, unit cost, Quantity
 D DUNIT,UNITC,QTY17
 ;
 ; VA Product name, VA drug class, Packaging
 D VPNAME^PSUCS4,VDC^PSUCS4
 ;
 Q 
 ;
 ;
 ; ****************************************************
 ; Type 17 specific calls
 ; ****************************************************
 ;
 ;           
FACILTY ;
 D OPCHECK I PSURI="" Q  ;SENDER FOUND AS OUTPATIENT
 D IPCHECK
 Q
OPCHECK ;
 ;Field # 58.81,2 [PHARMACY LOCATION]  Points to File # 58.8
 S PSUPL(2)=$$VALI^PSUTL(58.81,PSUIENDA,"2")
 ;
 ;Field # 58.8,20 [OUTPATIENT SITE] Points to File # 59
 S PSUOS(20)=$$VALI^PSUTL(58.8,PSUPL(2),"20")
 Q:PSUOS(20)=""
 ;
 ;Field # 59,.06 [SITE NUMBER]******Field to be extracted
 S PSUSNO(.06)=$$VALI^PSUTL(59,PSUOS(20),".06")
 S SENDER=PSUSNO(.06)
 S PSURI=""
 Q
IPCHECK ;Inpatient Site (field #58.8,2)
 S PSURI="H"
 S PSUIPS(2)=$$VALI^PSUTL(58.8,PSUPL(2),"2")
 ;
 ; use the AOU location finder of DIV^PSUAR1(PSULOC,DTTM)
 S PSUARSUB=PSUCSJB
 S SENDER=$$DIV^PSUAR1(PSUIPS(2),DTTM)
 I SENDER="NULL" S SENDER=PSUSNDR,PSURI="H" Q
 S PSURI=""
 Q
 ;
SSN ;Field # 58.81,73 [PATIENT]  Points to File # 2
 ;Field # 2,.09 [SOCIAL SECURITY NUMBER]**********Field to be extracted
 Q:$G(PSUPIEN(73))=""
 S DFN=PSUPIEN(73) D PID^VADPT
 S PSUSSN(.09)=$TR(VA("PID"),"-","")
 Q
 ; 
DUNIT ;Dispense Unit
 ;Field # 50,14.5 [DISPENSE UNIT]**********Field to be extracted
 S PSUDUN(14.5)=$$VALI^PSUTL(50,PSUDRG(4),"14.5")
 S UNIT=PSUDUN(14.5)
 Q
 ;
UNITC ;Unit Cost
 ;Field # 50,16 [PRICE PER DISPENSE UNIT]**********Field to be extracted
 S PSUPDU(16)=$$VALI^PSUTL(50,PSUDRG(4),"16")
 Q
 ;
QTY17 ;For transactions with a dispensing type =17, total the number of doses
 ;dispensed for the same drug (Field # 58.81,4), regardless of the date 
 ;dispensed within the reporting month. The dispensed (transaction) date
 ;will be the date the first dose was administered to the patient during
 ;the reporting period. The data will be transmitted as a single data
 ;record.
 ;Sum of Values # 58.81,5 [TOTAL QUANTITY]******Field to be extracted
 ;  Store in ^XTMP(job,"MC",loc,dfn,drg,qt)
 S PSUTQY(5)=^XTMP(PSUCSJB,"MC",PSULOC,DFN,PSUDRG,"QT")
 Q
