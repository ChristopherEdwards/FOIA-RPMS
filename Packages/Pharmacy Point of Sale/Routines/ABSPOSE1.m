ABSPOSE1 ; IHS/SD/lwj - E1 gereration routine ; [ 10/24/2005 10:09:07 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**14,15,16**;JUN 21, 2001
 ;
 ;IHS/SD/lwj 10/24/05  Medicare Part D E1 Transmission routine
 ;  This routine will:
 ;    * prompt the user for which patient an E1 should be generated for
 ;    * determine if there are multiple pharmacies and prompt for one
 ;    * determine if a previous E1 was sent - if so, it will prompt if
 ;       the user would like to create a new E1
 ;    * create the shell of the ^ABSPE entry
 ;    * generate the E1 transmission
 ;    * call ^ABSPOSAE to send the E1 and process the response
 ;    * prompt for another patient
 ;
 ; 11/15/05 WE WERE ONLY ABLE TO TEST WITH NDC TROOP FACILITATION -
 ;  ADJUSTMENTS WILL BE NEEDED WHEN WE KNOW MORE AND ARE READY TO
 ;  GO LIVE.
 ;
 ; IHS/SD/RLT - 1/13/06 - Patch 15
 ;    Pam Swchweitzer requested the program to end when a blank
 ;    patient is entered.
 ;
 ; IHS/SD/RLT - 2/3/06 - Patch 16
 ;    Fixed display error for fields 504 and 526.
 ;
 ;    Fixed elig file write and lookup.  Changed X from name to `IEN so
 ;    fileman is not confused on names that bring up muliple records. 
 ;
 Q
MAIN ;EP
 N POP
 S POP=0
 ;
 F  D PROCESS  Q:POP
 ;
 Q
PROCESS ;
 N E1PNAM,E1PIEN,E1PINFO,E1PHARM,E1IEN
 ;
 S POP=1
 ; prompt for the patient
 S E1PINFO=$$GETPAT
 Q:E1PINFO<1
 S E1PIEN=$P(E1PINFO,U)  ;VA(200 patient IEN
 S E1PNAM=$P(E1PINFO,U,2)  ;VA(200 patient name
 ;
 ; determine the pharmacy to send on behalf of
 S E1PHARM=$$GETPHARM    ;E1PHARM - ien into ABSP(9002313.56
 Q:E1PHARM<1
 ;
 ; establish the ^ABSPE record to work with
 S E1IEN=$$GETABSPE    ;E1IEN - ien into ^ABSPE
 Q:E1IEN<1    ;must have had a prev one and didn't want a new one
 ;
 ;create the transmission
 D CRTE1
 U $P W !!,"Transmitting eligibility check, please stand by.....",!!
 D SEND^ABSPOSAE(TDATA,E1IEN)  ;send the transaction
 S POP=0
 ;
 ;
 ;
 Q
GETPAT() ;Prompt the user for which patient they would like to generate an E1 for
 ;
 N ABSPDUZ2,PATDONE,Y,DIC
 N X                                                         ;RLT - Patch 15
 S X=""                                                      ;RLT - Patch 15
 ;
 S PATDONE=0   ;set to one when we are done prompting
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
 . ;S:(($G(DUOUT))!($G(DTOUT))!(Y>0)) PATDONE=1              ;RLT - PATCH 15
 . S:(($G(DUOUT))!($G(DTOUT))!(Y>0)!(X="")) PATDONE=1        ;RLT - PATCH 15
 K DIC
 S DUZ(2)=ABSPDUZ2
 ;
 Q Y
GETPHARM() ;when more than one pharmacy is set up for this site, prompt
 ; for which one to use for the E1 transmission (need to know which
 ; NCPDP & terminal ID to use)
 ;
 N PHARM,HLDPHARM,Y,PDONE,PHMCNT,DIC
 ;
 S (PHMCNT,PDONE,PHARM,Y)=0   ;initialize beginning variables
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
 ;
GETABSPE() ; if an E1 was previously sent for this patient, find it
 ; and prompt if the user wishes to send again.  If one doesn't
 ; exist, we'll ask fileman to create it for us now.
 ;
 N X,DIC,DLAYGO,Y,NEWE1,CRTNWE1,E1IEN
 S DIC="^ABSPE(",DIC(0)="XZ"
 ;S X=E1PNAM                             ;RLT - 2/3/06 - Patch 16
 S X="`"_E1PIEN                          ;RLT - 2/3/06 - Patch 16
 S (NEWE1,CRTNWE1)=0
 ;
 ;let's look for an existing E1 for this patient
 D ^DIC
 K DIC
 S E1IEN=+Y
 S:E1IEN<1 CRTNWE1=1   ;patient doesn't exist - add them
 S:E1IEN>0 NEWE1=$$PRMPT(E1IEN)  ;exist - do they want to send again?
 ;
 ; Yes - they want to send again - delete the current entry
 I NEWE1 D
 . N DIK,DA
 . S DIK="^ABSPE("
 . S DA=E1IEN
 . D ^DIK    ;kill the previous entry
 . K DIK,DA
 . S CRTNWE1=1
 ;
 ; creat a new entry
 I CRTNWE1 D
 . S DIC="^ABSPE("
 . ;S X=E1PNAM                             ;RLT - 2/3/06 - Patch 16
 . S X="`"_E1PIEN                          ;RLT - 2/3/06 - Patch 16
 . S DLAYGO=9002313.7,DIC(0)="LXZ"
 . D ^DIC
 ;
 Q +Y
 ;
PRMPT(E1IEN) ; The patient has previously had an E1 sent - if the last response
 ; was accepted, let's display the previous response and prompt if
 ; the wants to send another E1 at this time
 ;
 N RESULT,DIR,STATUS
 ;
 ; if the previous result was an error, let's send a new E1
 S RESULT=$$GET1^DIQ(9002313.7,E1IEN_",",9999999,"E")
 Q:RESULT'="" 1
 ;
 ; if the status reflects the E1 was rejected, let's send a new one
 S STATUS=$$GET1^DIQ(9002313.7,E1IEN_",",112,"E")
 Q:STATUS="R" 1
 ;
 ;
 U $P
 W !!!,"A check was previously submitted for this patient: "
 D DISPLAY(E1IEN)
 ;
 S DIR("A")="Would you like to send a new eligibility check? "
 S DIR("B")="Y"
 S DIR(0)="YAO"
 D ^DIR
 ;
 Q Y
CRTE1 ; This subroutine will:
 ;   * facilitate the creation of the needed E1 header, patient
 ;     and insurance segments (transmission record is TDATA)
 ;   *  update ^ABSPE with the patient/insurance trans data
 ;   *  create raw transmission record for ^ABSPE
 ;
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
 ; for the transmission
 ;
 D ^DIE
 ;
 ;update ^ABSPE with raw message
 D RAWTRANS
 ;
 Q
 ;
HEADER ; This subroutine is responsible for creating the E1 header segment
 ; for the Medicare Part D transmission.  If other E1's are ever produced
 ; this will need to be altered to pull the plan from some other source.
 ; Because of the tight time line for the Medicare Part D E1, we forced
 ; the plan to only work for that plan (006015).  The header segment is
 ; fixed length, will all elements required.
 ;
 ; 11/14/05  THIS SUBROUTINE MUST BE REVIEWED AND ADJUSTED FOR GO LIVE -
 ;  CURRENTLY SET TO WORK WITH NDC TROPP FACILITATION TESTING - SEE
 ;  COMMENTS BELOW
 ;
 N XDATA
 ;
 S XDATA=$G(^ABSP(9002313.56,E1PHARM,0))  ;E1PHARM set from call to GETPHARM
 ;
 ;101 BIN (Emdeon plan # hard coded to 006015) + 102 Version (always 51) +
 ;103 Trans Code (always E1)
 S TDATA="00601551E1"
 ;S TDATA="00998851E1"  ;Bart's test system
 ;S TDATA="01172751E1"   ;good way to force EV rejection
 ;
 ;104 Processor control number (Emdeon terminal id for sending pharmacy)
 S TDATA=TDATA_$TR($J($P(XDATA,U,6),10)," ","0")
 ;
 ;109 Transaction Count (1 for the E1)+202 Service Prov ID Qual (always 07)
 S TDATA=TDATA_107
 ;
 ;201 Service Provide ID
 S TDATA=TDATA_$$ANFF^ABSPECFM($P(XDATA,U,2),15)  ;NCPDP number
 ;S TDATA=TDATA_$$ANFF^ABSPECFM("1234567",15)  ;forces rejection
 ;S TDATA=TDATA_$$ANFF^ABSPECFM("0000238",15)  ;good one for testing
 ;
 ;401 Data of Service (will always use current date for the E1)
 S TDATA=TDATA_$$DTF1^ABSPECFM(DT)
 ;
 ;110 Software Vendor/Certification ID
 S TDATA=TDATA_$$ANFF^ABSPECFM(" ",10)  ;real??  don't know yet
 ;S TDATA=TDATA_$$ANFF^ABSPECFM("TATA",10) ;Bart's testing system
 ;S TDATA=TDATA_$$ANFF^ABSPECFM("TROOPELIG",10) ;NDC's testing system
 ;
 ;add segment and field separators
 S TDATA=TDATA_SS_FS
 ;
 Q
PATIENT ; This subroutine is responsible for creating the patient segment, and
 ; for updating the ^ABSPE record with this information.
 ;
 ; 11/14/05 CHANGES MAY BE NEEDED - THIS SUBROUTINE IS CURRENTLY SET TO
 ;  WORK WITH NDC TESTING - SEE COMMENTS BELOW
 ;
 N ABSP304,ABSP305,ABSP310,ABSP311,ABSP332,ABSP323,ABSP324
 N ABSP325,ABSP326,XDATA,XDATA11,ABSPNAM
 ;
 N STCODE
 ;
 S XDATA=$G(^DPT(E1PIEN,0))  ;patient data
 S XDATA11=$G(^DPT(E1PIEN,.11)) ;address information
 ;
 ;preset field 111 to AM01 (segment identification)
 S TDATA=TDATA_"AM01"_FS
 ;
 ;304 Date of Birth (format
 S ABSP304=$$DTF1^ABSPECFM($P(XDATA,U,3))
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
 ;prepare for patient name - try to use the entry
 ; from the Medicare Eligible file is its there, if
 ; not, use the patient name
 S ABSPNAM=$$GET1^DIQ(9000003,E1PIEN_",",.01,"E")
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
INSURER ; this subroutine will pull together the information
 ; needed for the E1 insurance segment
 ;
 ; 11/15/05 CHANGES MAY BE NEEDED - THIS ROUTINE IS SET
 ;  TO WORK WITH NDC TROOP FACILITATION TESTING - SEE
 ;  COMMENTS BELOW
 ;
 N ABSP302,ABSP301,ABSPCID
 ;
 S TDATA=TDATA_"AM04"_FS
 ;
 ;302 Cardholder ID - will try to retrieve medicare card holder
 ; id, if not available use last 4 of SSN
 S ABSP302=$$GET1^DIQ(9000003,E1PIEN_",",.03,"E")
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
 ;S ABSP301=$$ANFF^ABSPECFM("TATA",10)
 ;S TDATA=TDATA_"C1"_ABSP301
 ;S DR=DR_"301////"_ABSP301
 ;
 Q
RAWTRANS ; create the raw transmission entry in ^ABSPE
 ;
 N WP,I
 ;
 F I=1:100:$L(TDATA) S WP(I/100+1,0)=$E(TDATA,I,I+99)
 D WP^DIE(9002313.7,E1IEN_",",1000,"","WP")
 ;
 Q
DISPLAY(E1IEN) ;EP - display the E1's results
 ;
 N ABSPPNAM,ABSP112,ABSP504,ABSP526,ABSPINS,COVER
 N ABSP503,ABSPCUT,ABSPSTR,ABSP03
 S (ABSPPNAM,ABSP112,ABSP504,ABSP503,ABSP536)=""
 ;
 S ABSPPNAM=$$GET1^DIQ(9002313.7,E1IEN_",",.01,"E")
 S ABSP03=$$GET1^DIQ(9002313.7,E1IEN_",",.03,"E")
 S ABSP112=$$GET1^DIQ(9002313.7,E1IEN_",",112,"E")
 S ABSP503=$$GET1^DIQ(9002313.7,E1IEN_",",503,"E")
 S ABSP504=$$GET1^DIQ(9002313.7,E1IEN_",",504,"E")
 S ABSP526=$$GET1^DIQ(9002313.7,E1IEN_",",526,"E")
 S ABSPINS=ABSP504_ABSP526
 D:ABSPINS["&" PARSEIT(ABSPINS,.COVER)
 ;
 W !,"On:               ",ABSP03
 W !,"Patient Name:     ",ABSPPNAM
 W !,"Status:           ",ABSP112
 W !,"Authorization #:  ",ABSP503
 ;
 I '$D(COVER("COUNT")) D
 . W !,"Result:"
 . ;
 . N LINECNT                             ;RLT - 2/3/06 - Patch 16
 . S LINECNT=1                           ;RLT - 2/3/06 - Patch 16
 . ;
 . I $D(ABSP504) D
 .. S ABSPSTR=1
 .. I $L(ABSP504)>50 D                   ;RLT - 2/3/06 - Patch 16
 ... S LINECNT=$L(ABSP504)\50            ;RLT - 2/3/06 - Patch 16
 ... S:LINECNT#50'=0 LINECNT=LINECNT+1   ;RLT - 2/3/06 - Patch 16
 .. F ABSPCUT=1:1:LINECNT D              ;RLT - 2/3/06 - Patch 16
 ... W ?18,$E(ABSP504,ABSPSTR,ABSPSTR+50),!,"  "
 ... S ABSPSTR=ABSPSTR+50
 . ;
 . S LINECNT=1
 . ;
 . I $D(ABSP526) D
 .. S ABSPSTR=1
 .. I $L(ABSP526)>50 D                   ;RLT - 2/3/06 - Patch 16
 ... S LINECNT=$L(ABSP526)\50            ;RLT - 2/3/06 - Patch 16
 ... S:LINECNT#50'=0 LINECNT=LINECNT+1   ;RLT - 2/3/06 - Patch 16
 .. F ABSPCUT=1:1:LINECNT D              ;RLT - 2/3/06 - Patch 16
 ... W ?18,$E(ABSP526,ABSPSTR,ABSPSTR+50),!,"  "
 ... S ABSPSTR=ABSPSTR+50
 . ;
 . W !!
 ;
 F INSCNT=1:1:$G(COVER("COUNT"))  D
 . W !,"Insurance Level:  ",COVER(INSCNT,"INS LVL")
 . W !,"   BIN:           ",COVER(INSCNT,"BIN")
 . W !,"   PCN:           ",COVER(INSCNT,"PCN")
 . W !,"   GROUP:         ",COVER(INSCNT,"GROUP")
 . W !,"   CARDHOLDER ID: ",COVER(INSCNT,"CARD ID")
 . W !,"   PERSON CODE:   ",COVER(INSCNT,"PERSON CD")
 . W !,"   PHONE NUMBER:  ",COVER(INSCNT,"PHONE #")
 . W !
 ;
 ;
 Q
 ;
PARSEIT(INSFLD,COVER) ; The 504 and 526 fields may actually have
 ; detailed insurance information in them - we need to break
 ; them down for reporting purposes.
 ;
 N INSCNT,NOMORE
 S INSCNT=1
 S NOMORE=0
 ;
 F  D  Q:NOMORE
 . S INSREC=$P(INSFLD,"&",INSCNT)
 . S:INSREC="" NOMORE=1
 . Q:NOMORE
 . I INSCNT=1 D
 .. S COVER(INSCNT,"INS LVL")=$P(INSREC,"#",2)
 .. S COVER(INSCNT,"BIN")=$P($P(INSREC,"#",3),":",2)
 .. S COVER(INSCNT,"PCN")=$P($P(INSREC,"#",4),":",2)
 .. S COVER(INSCNT,"GROUP")=$P($P(INSREC,"#",5),":",2)
 .. S COVER(INSCNT,"CARD ID")=$P($P(INSREC,"#",6),":",2)
 .. S COVER(INSCNT,"PERSON CD")=$P($P(INSREC,"#",7),":",2)
 .. S COVER(INSCNT,"PHONE #")=$P($P(INSREC,"#",8),":",2)
 . I INSCNT'=1 D
 .. S COVER(INSCNT,"INS LVL")=$P(INSREC,"#")
 .. S COVER(INSCNT,"BIN")=$P($P(INSREC,"#",2),":",2)
 .. S COVER(INSCNT,"PCN")=$P($P(INSREC,"#",3),":",2)
 .. S COVER(INSCNT,"GROUP")=$P($P(INSREC,"#",4),":",2)
 .. S COVER(INSCNT,"CARD ID")=$P($P(INSREC,"#",5),":",2)
 .. S COVER(INSCNT,"PERSON CD")=$P($P(INSREC,"#",6),":",2)
 .. S COVER(INSCNT,"PHONE #")=$P($P(INSREC,"#",7),":",2)
 . S INSCNT=INSCNT+1
 ;
 S COVER("COUNT")=INSCNT-1
 ;
 Q
