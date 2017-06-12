ABSPOSE2 ; IHS/SD/lwj - E1 generation routine ; [ 10/24/2005 10:09:07 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**21,24,40,42**;JUN 21, 2001;Build 15
 ;
 ;IHS/SD/RLT - 05/22/07 - Patch 21
 ;  Enhanced E1 - modified version of ABSPOSE1
 ;    See comments in ABSPOSE1 for further E1 details
 ;
 ;IHS/SD/RLT - 02/13/08 - Patch 24
 ;  Fixed Medicare name and DOB lookup (IM27373)
 Q
MAIN ;EP
 N POP
 S POP=0
 ;
 F  D PROCESS  Q:POP
 ;
 Q
PROCESS ;
 N E1PNAM,E1PIEN,E1PINFO,E1PHARM,E1IEN,E1DATE
 ;
 S POP=1
 ; get patient
 S E1PINFO=$$GETPAT
 Q:E1PINFO<1
 S E1PIEN=$P(E1PINFO,U)  ;VA(200 patient IEN
 S E1PNAM=$P(E1PINFO,U,2)  ;VA(200 patient name
 ;
 ; get pharmacy
 S E1PHARM=$$GETPHARM    ;ien ^ABSP(9002313.56
 Q:E1PHARM<1
 ;
 ; get ^ABSPE rec
 S E1IEN=$$GETABSPE      ;ien ^ABSPE
 Q:E1IEN<1    ;had prev one, didn't want new one
 ;
 S E1DATE=$$GETDATE      ;E1DATE - service date sent in header
 Q:E1DATE=""
 ;
 ; create transmission
 D CRTE1
 U $P W !!,"Transmitting eligibility check, please stand by.....",!!
 D SEND^ABSPOSAE(TDATA,E1IEN)  ;send trans
 S POP=0
 ;
 Q
GETPAT() ; Prompt for patient.
 ;
 N ABSPDUZ2,PATDONE,Y,DIC
 N X
 S X=""
 ;
 S PATDONE=0   ;set to one when done prompting
 S Y=0
 S ABSPDUZ2=+$G(DUZ(2)),DUZ(2)=0
 ;
 U $P W !!!
 ;
 S DIC=2,DIC(0)="AEMQZ"
 S DIC("A")="Generate eligibility chk (Med Part D) for which patient? "
 F  D  Q:PATDONE
 . D ^DIC
 . U $P W !
 . S:(($G(DUOUT))!($G(DTOUT))!(Y>0)!(X="")) PATDONE=1
 K DIC
 S DUZ(2)=ABSPDUZ2
 ;
 Q Y
GETPHARM() ; Prompt for pharmacy.
 ;
 N PHARM,HLDPHARM,Y,PDONE,PHMCNT,DIC
 ;
 S (PHMCNT,PDONE,PHARM,Y)=0
 ;
 F  S PHARM=$O(^ABSP(9002313.56,PHARM)) Q:'+PHARM  D
 . S PHMCNT=PHMCNT+1
 . S:PHMCNT=1 HLDPHARM=PHARM
 Q:PHMCNT=1 HLDPHARM
 ;
 W !!
 S DIC=9002313.56,DIC(0)="AEMQZ"
 S DIC("B")=$P($G(^ABSP(9002313.56,HLDPHARM,0)),U)
 S DIC("A")="Please specify the pharmacy: "
 F  D  Q:PDONE
 . D ^DIC
 . U $P W !
 . S:(($G(DUOUT))!($G(DTOUT))!(Y>0)) PDONE=1
 ;
 Q +Y
GETDATE() ; Prompt for service date.
 N CURDISP,X1,X2,BEGDT,ENDDT,E1DT
 ;
 S Y=DT
 D DD^%DT
 S CURDISP=Y
 ;
 S X1=DT,X2=-90
 D C^%DTC
 S BEGDT=X
 S Y=X
 D DD^%DT
 S BEGDISP=Y
 ;
 S X1=DT,X2=+90
 D C^%DTC
 S ENDDT=X
 S Y=X
 D DD^%DT
 S ENDDISP=Y
 ;
 W !,"Accept the default current date of ",CURDISP," or"
 W !,"Enter a date between ",BEGDISP," and ",ENDDISP,!
 S E1DT=$$DATE^ABSPOSU1("Enter Service Date: ",DT,0,BEGDT,ENDDT,"EX")
 S:E1DT="^"!(E1DT="^^")!(E1DT=-1) E1DT=""
 Q E1DT
 ;
GETABSPE() ; If E1 previously sent, find it and prompt to send again.
 ; If doesn't exist, create new one.
 ;
 N X,DIC,DLAYGO,Y,NEWE1,CRTNWE1,E1IEN
 S DIC="^ABSPE(",DIC(0)="XZ"
 S X="`"_E1PIEN
 S (NEWE1,CRTNWE1)=0
 ;
 ;look for old E1
 D ^DIC
 K DIC
 S E1IEN=+Y
 S:E1IEN<1 CRTNWE1=1   ;doesn't exist - add
 S:E1IEN>0 NEWE1=$$PRMPT(E1IEN)  ;exist - send again?
 ;
 ; Yes, send again - delete old entry
 I NEWE1 D
 . N DIK,DA
 . S DIK="^ABSPE("
 . S DA=E1IEN
 . D ^DIK
 . K DIK,DA
 . S CRTNWE1=1
 ;
 ; create new entry
 I CRTNWE1 D
 . S DIC="^ABSPE("
 . S X="`"_E1PIEN
 . S DLAYGO=9002313.7,DIC(0)="LXZ"
 . D ^DIC
 ;
 Q +Y
 ;
PRMPT(E1IEN) ;Display previous response and prompt to send again.
 ;
 N RESULT,DIR,STATUS
 ;
 ; if previous result an error, send new E1
 S RESULT=$$GET1^DIQ(9002313.7,E1IEN_",",9999999,"E")
 Q:RESULT'="" 1
 ;
 ; if status rejected, send new E1
 S STATUS=$$GET1^DIQ(9002313.7,E1IEN_",",112,"E")
 Q:STATUS="R" 1
 ;
 ;
 U $P
 W !!!,"A check was previously submitted for this patient: "
 D DISPLAY(E1IEN)
 ;
 S DIR("A")="Would you like to send a new eligibility check? "
 ;S DIR("B")="Y"  ;IHS/OIT/CNI/SCR patch 40 change default answer to "N"
 S DIR("B")="N"
 S DIR(0)="YAO"
 D ^DIR
 ;
 Q Y
CRTE1 ; Creates transmission record, updates ^ABSPE.
 ;
 N FS,SS
 N DIE,DA,DR
 ;N TDATA
 ;
 S TDATA=""
 S DIE="^ABSPE(",DA=E1IEN
 S FS=$C(28),SS=$C(30)     ;field and segment separators
 ;
 D HEADER
 D PATIENT
 D INSURER
 ;
 ;update ^ABSPE with the patient and insurance information
 ;
 D ^DIE
 ;
 ;update ^ABSPE with raw message
 D RAWTRANS
 ;
 Q
 ;
HEADER ; Header Seg
 ;
 N XDATA
 ;
 S XDATA=$G(^ABSP(9002313.56,E1PHARM,0))  ;E1PHARM set from call to GETPHARM
 ;
 ;101 BIN (Emdeon plan # hard coded to 006015) + 102 Version (always 51) +
 ;103 Trans Code (always E1)
 S TDATA="00102451E1"   ;Troop extended elig response
 ; IHS/OIT/CASSevern/Pieran/RAN 10/31/2011 Patch 42 Allow us to send D.0 version of Troop Eligibility
 S:$D(^ABSP(9002313.99,1,"ABSPICNV")) TDATA="011727D0E1"
 ;
 ;104 Processor control number (Emdeon terminal id for sending pharmacy)
 S TDATA=TDATA_$S($D(^ABSP(9002313.99,1,"ABSPICNV")):2222222222,1:$TR($J($P(XDATA,U,6),10)," ","0"))
 ;109 Transaction Count (1 for the E1)+202 Service Prov ID Qual (always 07)
 S TDATA=TDATA_107
 ;
 ;201 Service Provider ID
 S TDATA=TDATA_$$ANFF^ABSPECFM($P(XDATA,U,2),15)  ;NCPDP number
 ;S TDATA=TDATA_$$ANFF^ABSPECFM("1234567",15)  ;forces rejection
 ;
 ;401 Data of Service
 ;Date can be -90 to +90 of current date.
 S TDATA=TDATA_$$DTF1^ABSPECFM(E1DATE)
 ;
 ;110 Software Vendor/Certification ID
 S TDATA=TDATA_$$ANFF^ABSPECFM(" ",10)  ;real??  don't know yet
 ;S TDATA=TDATA_$$ANFF^ABSPECFM("TROOPELIG",10) ;NDC's testing system
 ;
 ;add segment and field separators
 S TDATA=TDATA_SS_FS
 ;
 Q
PATIENT ; Patient Seg
 ;
 N ABSP304,ABSP305,ABSP310,ABSP311,ABSP332,ABSP323,ABSP324
 N ABSP325,ABSP326,XDATA,XDATA11,ABSPNAM
 ;
 N STCODE
 ;
 S XDATA=$G(^DPT(E1PIEN,0))  ;patient data
 S XDATA11=$G(^DPT(E1PIEN,.11)) ;address info
 ;
 ;preset field 111 to AM01 (seg id)
 S TDATA=TDATA_"AM01"_FS
 ;
 ;304 DOB - try Medicare DOB first
 ; else use patient DOB
 ;Next line for testing ONLY Don't forget to comment it back out....and uncomment the line below it.
 S ABSP304=$$DTF1^ABSPECFM($$GET1^DIQ(9000003,E1PIEN_",",2102,"I"))    ;RLT - Patch 24
 ;IHS/OIT/Pieran/RCS - Patch 42;DOB was not taken from patient when DOB="00000000"
 ;S:ABSP304="" ABSP304=$$DTF1^ABSPECFM($P(XDATA,U,3))                   ;RLT - Patch 24
 S:'ABSP304 ABSP304=$$DTF1^ABSPECFM($P(XDATA,U,3))                      ;RCS - Patch42;RLT - Patch 24
 S TDATA=TDATA_"C4"_ABSP304_FS
 S DR="304////"_ABSP304_";"
 ;
 ;305 Patient Gender
 S ABSP305=$E($P(XDATA,U,2),1,1)
 S ABSP305=$S(ABSP305="M":"1",ABSP305="F":"2",1:"0")
 S ABSP305=$$NFF^ABSPECFM(ABSP305,1)
 S TDATA=TDATA_"C5"_ABSP305_FS
 S DR=DR_"305////"_ABSP305_";"
 ;
 ;patient name - try Medicare name first
 ; else use patient name
 ;S ABSPNAM=$$GET1^DIQ(9000003,E1PIEN_",",.01,"E")
 S ABSPNAM=$$GET1^DIQ(9000003,E1PIEN_",",2101,"E")                     ;RLT - Patch 24
 S:ABSPNAM="" ABSPNAM=$P(XDATA,U)
 ;
 ;310 Patient First Name
 S ABSP310=$$ANFF^ABSPECFM($P($P(ABSPNAM,",",2)," "),12)
 S TDATA=TDATA_"CA"_ABSP310_FS
 S DR=DR_"310////"_ABSP310_";"
 ;
 ;311 Patient Last Name
 S ABSP311=$$ANFF^ABSPECFM($P(ABSPNAM,",",1),15)
 S TDATA=TDATA_"CB"_ABSP311_FS
 S DR=DR_"311////"_ABSP311_";"
 ;
 ;322 Patient Street Address - not used yet
 ;S ABSP322=$$ANFF^ABSPECFM($P(XDATA11,U),30)
 ;S TDATA=TDATA_"CM"_ABSP322_FS
 ;S DR=DR_"322////"_ABSP322_";"
 ;
 ;323 Patient City Address  - not used yet
 ;S ABSP323=$$ANFF^ABSPECFM($P(XDATA11,U,4),20)
 ;S TDATA=TDATA_"CN"_ABSP323_FS
 ;S DR=DR_"323////"_ABSP323_";"
 ;
 ;324 Patient State/Province Address - not used yet
 ;S ABSP324=""
 ;S STCODE=$P(XDATA11,U,5)
 ;S:STCODE'="" ABSP324=$P($G(^DIC(5,STCODE,0)),U,2)
 ;S ABSP324=$$ANFF^ABSPECFM(ABSP324,2)
 ;S TDATA=TDATA_"CO"_ABSP324_FS
 ;S DR=DR_"324////"_ABSP324_";"
 ;
 ;325 Patient Zip/Postal Zone - currently last field
 ; so the segment separator must be there
 S ABSP325=$$ANFF^ABSPECFM($P(XDATA11,U,6),15)
 S TDATA=TDATA_"CP"_ABSP325_SS_FS
 S DR=DR_"325////"_ABSP325_";"
 ;
 ;326 Patient Phone Number - not used yet
 ; if they want this, remove the segment separator from
 ; the zip code
 ;S ABSP326=$TR($$GET1^DIQ(2,E1PIEN_",",.131,"E"),"()-")
 ;S ABSP326=$$NFF^ABSPECFM(ABSP326,10)
 ;S TDATA=TDATA_"CQ"_ABSP326_SS_FS
 ;S DR=DR_"326////"_ABSP326_";"
 ;
 Q
INSURER ; Insurance Seg
 ;
 N ABSP302,ABSP301,ABSPCID
 ;
 S TDATA=TDATA_"AM04"_FS
 ;
 ;302 Cardholder ID - medicare cardholder
 ; id, else use last 4 of SSN
 S ABSP302=$$GET1^DIQ(9000003,E1PIEN_",",.03,"E")
 S ABSP302S=$$GET1^DIQ(9000003,E1PIEN_",",.04,"E")
 S:ABSP302'="" ABSP302=ABSP302_ABSP302S
 I ABSP302="" D
 . S ABSP302=$$GET1^DIQ(2,E1PIEN_",",.09,"E")
 . S ABSP302=$E(ABSP302,$L(ABSP302)-3,$L(ABSP302))
 ;
 S ABSP302=$TR(ABSP302,"-/.","")
 S ABSP302=$$ANFF^ABSPECFM(ABSP302,20)
 S TDATA=TDATA_"C2"_ABSP302
 ;S TDATA=TDATA_"C2"_ABSP302_FS  ; Bart's system
 S DR=DR_"302////"_ABSP302
 ;
 ;301 group number - just for testing
 ; Bart's system - don't know if this fld
 ; will be needed for live - put the fld
 ; separator on 302 (above) if 301 is needed
 ;COMMENT THE THREE LINES BELOW BACK OUT WHEN DONE TESTING
 ;S ABSP301=$$ANFF^ABSPECFM("TATA",10)
 ;S TDATA=TDATA_"C1"_ABSP301
 ;S DR=DR_"301////"_ABSP301
 ;
 Q
RAWTRANS ; Raw trans in ^ABSPE
 ;
 N WP,I
 ;
 F I=1:100:$L(TDATA) S WP(I/100+1,0)=$E(TDATA,I,I+99)
 D WP^DIE(9002313.7,E1IEN_",",1000,"","WP")
 ;
 Q
DISPLAY(E1IEN) ;EP - E1 result
 ;
 N ABSPPNAM,ABSP112,ABSP504,ABSP526,COVER
 N ABSP503,ABSPCUT,ABSPSTR,ABSP03,ABSP302
 S (ABSPPNAM,ABSP112,ABSP504,ABSP503,ABSP536)=""
 ;
 S ABSPPNAM=$$GET1^DIQ(9002313.7,E1IEN_",",.01,"E")
 S ABSP03=$$GET1^DIQ(9002313.7,E1IEN_",",.03,"E")
 S ABSP112=$$GET1^DIQ(9002313.7,E1IEN_",",112,"E")
 S ABSP302=$$GET1^DIQ(9002313.7,E1IEN_",",302,"E")
 S ABSP503=$$GET1^DIQ(9002313.7,E1IEN_",",503,"E")
 S ABSP504=$$GET1^DIQ(9002313.7,E1IEN_",",504,"E")
 S ABSP526=$$GET1^DIQ(9002313.7,E1IEN_",",526,"E")
 S ABSPINS=ABSP504_ABSP526
 I ABSPINS["&" D DISPLAY^ABSPOSE1(E1IEN) Q
 D PARSE504(ABSP504,.COVER)
 D PARSE526(ABSP526,.COVER)
 ;
 W !,"On:               ",ABSP03
 W !,"Patient Name:     ",ABSPPNAM
 W !,"Medicare ID:      ",ABSP302
 W !,"Status:           ",ABSP112
 W !,"Authorization #:  ",ABSP503
 ;
 I ABSP112'="A" D
 . W !,"Result:"
 . ;
 . N LINECNT
 . S LINECNT=1
 . ;
 . I $D(ABSP504) D
 .. S ABSPSTR=1
 .. I $L(ABSP504)>50 D
 ... S LINECNT=$L(ABSP504)\50
 ... S:LINECNT#50'=0 LINECNT=LINECNT+1
 .. F ABSPCUT=1:1:LINECNT D
 ... W ?18,$E(ABSP504,ABSPSTR,ABSPSTR+50),!,"  "
 ... S ABSPSTR=ABSPSTR+50
 . ;
 . S LINECNT=1
 . ;
 . I $D(ABSP526) D
 .. S ABSPSTR=1
 .. I $L(ABSP526)>50 D
 ... S LINECNT=$L(ABSP526)\50
 ... S:LINECNT#50'=0 LINECNT=LINECNT+1
 .. F ABSPCUT=1:1:LINECNT D
 ... W ?18,$E(ABSP526,ABSPSTR,ABSPSTR+50),!,"  "
 ... S ABSPSTR=ABSPSTR+50
 ;
 I ABSP112="A" D
 . W !!,"PATIENT INFORMATION"
 . W !," LAST NAME       :  ",COVER(1,"LAST NAME")
 . W !," FIRST NAME      :  ",COVER(1,"FIRST NAME")
 . W !," DOB             :  ",$$DATE(COVER(1,"DOB"))
 . W !!,"MEDICARE D INFORMATION"
 . W !," Insurance Level :  ",COVER(1,"INS LVL")
 . W !," BIN             :  ",COVER(1,"BIN")
 . W !," PCN             :  ",COVER(1,"PCN")
 . W !," GROUP           :  ",COVER(1,"GROUP")
 . W !," CARDHOLDER ID   :  ",COVER(1,"CARD ID")
 . W !," PERSON CODE     :  ",COVER(1,"PERSON CD")
 . W !," PHONE NUMBER    :  ",COVER(1,"PHONE #")
 . W !," CONTRACT ID     :  ",COVER(1,"CONTRACT ID")
 . W !," RX BENEFIT PLAN :  ",COVER(1,"PBP")
 . W !," EFFECTIVE DATE  :  ",$$DATE(COVER(1,"EFF DATE"))
 . W !," TERMINATION DATE:  ",$$DATE(COVER(1,"TRM DATE"))
 . W !," LOW-INCOME COST :  ",COVER(1,"LICS")
 . W !," FORMULARY ID    :  ",COVER(1,"FORMULARY ID")
 . W !!,"FUTURE MEDICARE PART D INFORMATION:"
 . W !," EFFECTIVE DATE  :  ",$$DATE(COVER(1,"FUTURE EFF DATE"))
 . W !," TERMINATION DATE:  ",$$DATE(COVER(1,"FUTURE TRM DATE"))
 . ;
 . W !!,"OTHER COVERAGE INFORMATION"
 . W !,"Secondary Coverage"
 . I $TR(COVER(2,"DISPCHK")," ","")="" D
 .. W !," None"
 . E  D
 .. W !," Insurance Level :  ",COVER(2,"INS LVL")
 .. W !," BIN             :  ",COVER(2,"BIN")
 .. W !," PCN             :  ",COVER(2,"PCN")
 .. W !," GROUP           :  ",COVER(2,"GROUP")
 .. W !," CARDHOLDER ID   :  ",COVER(2,"CARD ID")
 .. W !," PERSON CODE     :  ",COVER(2,"PERSON CD")
 .. W !," RELATIONSHIP CD :  ",COVER(2,"RELATIONSHIP CD")
 .. W !," PHONE NUMBER    :  ",COVER(2,"PHONE #")
 . ;
 . W !,"Tertiary Coverage"
 . I $TR(COVER(3,"DISPCHK")," ","")="" D
 .. W !," None"
 . E  D
 .. W !!," Insurance Level :  ",COVER(3,"INS LVL")
 .. W !," BIN             :  ",COVER(3,"BIN")
 .. W !," PCN             :  ",COVER(3,"PCN")
 .. W !," GROUP           :  ",COVER(3,"GROUP")
 .. W !," CARDHOLDER ID   :  ",COVER(3,"CARD ID")
 .. W !," PERSON CODE     :  ",COVER(3,"PERSON CD")
 .. W !," RELATIONSHIP CD :  ",COVER(3,"RELATIONSHIP CD")
 .. W !," PHONE NUMBER    :  ",COVER(3,"PHONE #")
 ;
 Q
 ;
PARSE504(INS504,COVER) ; 
 ;
 S COVER(1,"LAST NAME")=$E(INS504,4,16)
 S COVER(1,"FIRST NAME")=$E(INS504,20,29)
 S COVER(1,"DOB")=$E(INS504,33,40)
 S COVER(1,"INS LVL")=$E(INS504,44,44)
 S COVER(1,"BIN")=$E(INS504,48,53)
 S COVER(1,"PCN")=$E(INS504,57,66)
 S COVER(1,"GROUP")=$E(INS504,70,84)
 S COVER(1,"CARD ID")=$E(INS504,88,107)
 S COVER(1,"PERSON CD")=$E(INS504,111,113)
 S COVER(1,"PHONE #")=$E(INS504,117,126)
 S COVER(1,"CONTRACT ID")=$E(INS504,130,135)
 S COVER(1,"PBP")=$E(INS504,139,141)
 S COVER(1,"EFF DATE")=$E(INS504,145,152)
 S COVER(1,"TRM DATE")=$E(INS504,156,163)
 S COVER(1,"LICS")=$E(INS504,167,167)
 S COVER(1,"FORMULARY ID")=$E(INS504,171,178)
 S COVER(1,"FUTURE EFF DATE")=$E(INS504,182,189)
 S COVER(1,"FUTURE TRM DATE")=$E(INS504,193,200)
 ;
 Q
PARSE526(INS526,COVER) ;
 ;
 S COVER(2,"INS LVL")=$E(INS526,4,4)
 S COVER(2,"BIN")=$E(INS526,8,13)
 S COVER(2,"PCN")=$E(INS526,17,26)
 S COVER(2,"GROUP")=$E(INS526,30,44)
 S COVER(2,"CARD ID")=$E(INS526,48,67)
 S COVER(2,"PERSON CD")=$E(INS526,71,73)
 S COVER(2,"RELATIONSHIP CD")=$E(INS526,77,77)
 S COVER(2,"PHONE #")=$E(INS526,81,90)
 S COVER(2,"DISPCHK")=COVER(2,"INS LVL")_COVER(2,"BIN")_COVER(2,"PCN")_COVER(2,"GROUP")_COVER(2,"CARD ID")_COVER(2,"PERSON CD")_COVER(2,"RELATIONSHIP CD")_COVER(2,"PHONE #")
 ;
 S COVER(3,"INS LVL")=$E(INS526,94,94)
 S COVER(3,"BIN")=$E(INS526,98,103)
 S COVER(3,"PCN")=$E(INS526,107,116)
 S COVER(3,"GROUP")=$E(INS526,120,134)
 S COVER(3,"CARD ID")=$E(INS526,138,157)
 S COVER(3,"PERSON CD")=$E(INS526,161,163)
 S COVER(3,"RELATIONSHIP CD")=$E(INS526,167,167)
 S COVER(3,"PHONE #")=$E(INS526,171,180)
 S COVER(3,"DISPCHK")=COVER(3,"INS LVL")_COVER(3,"BIN")_COVER(3,"PCN")_COVER(3,"GROUP")_COVER(3,"CARD ID")_COVER(3,"PERSON CD")_COVER(3,"RELATIONSHIP CD")_COVER(3,"PHONE #")
 ;
 Q
DATE(CCYYMMDD) ;
 I $TR(CCYYMMDD," ","")="" Q ""
 D ^XBFMK      ;kill FileMan variables
 S Y=CCYYMMDD-17000000
 D DD^%DT
 Q Y
