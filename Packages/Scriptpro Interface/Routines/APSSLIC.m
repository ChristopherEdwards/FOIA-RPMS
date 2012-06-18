APSSLIC ;IHS/MSC/MDM - ScriptPro Interface;28-Sep-2007 10:47;SM
 ;;1.0;IHS SCRIPTPRO INTERFACE;**1**;January 11, 2006
 ; Call via entry point placed in Transform Field of File 9009033.3
 ; Direct entry not supported
 Q
EP1(APSSPIEN,APSSMETH) ;MDM - Main entry point
 ;
 ; Provider IEN required
 I '$G(APSSPIEN) Q ""
 ; Processing Method Required
 I '$G(APSSMETH) Q ""
 ;
 ; Data from Sub-File LICENSING STATE (#200.541)(multiple) from NEW PERSON File (#200)
 ; Data from LOCATION FILE (#9999999.06)
 ;
 ; APSSPIEN = Provider Internal Entry Number passed from calling routine.
 ; APSSMETH = Processing Method
 ;
 ; Method 1
 ; Match it to the state the facility is in
 ; If there is no license for that state then return any valid license
 ; If no valid license found for any state then return NULL
 ;
 ; Method 2
 ; There is no license for the state the facility is in then,
 ; return NULL even if other states have a valid license defined.
 ;
 ; Method 3
 ; Return first valid license found regardless of state
 ; No valid license found, then return NULL
 ;
 ;
 ; APSSENT = Entry in the LICENSING STATE(multiple)
 ; APSSKEY = Key to the LICENSING STATE(multiple)
 ; APSSLNO = Active License Number for the Provider
 ; APSSEDT = The Expiration Date for the Provider's License
 ; APSSIDT = The Internal Format Expiration Date for the Provider's License used to compare dates
 ; APSSFLOC= Facility Location (State) as determined by the users facility ID in DUZ(2)
 ; APSSTATE = License Issuing State
 ; APSSTMP = Temporary holding variable
 ; APSSTMP1 = Temporary holding variable
 ;
 N APSSLNO,APSSEDT,APSSDAT,APSSENT,APSSLNO,APSSKEY,APSSENT,APSSIDT,APSSEXIT,APSSFLOC,APSSTATE
 N APSSTMP,APSSTMP1
 ;
 ; This section processes each entry.
 ;
 S (APSSENT,APSSEXIT)=0,(APSSLNO,APSSTMP)="" ; Initialize working variables
 ;
 ; To check for the License based on the state the facility is located in
1 ; the LOCATION file# (9999999.06) must have the state defined in field .23
 S APSSFLOC=$$GET1^DIQ(9999999.06,DUZ(2),.23) ; Facility Location (State)
 ;
 ; If the processing Method is 1 or 2 and the facility state is NULL then quit processing.
 I (APSSMETH=1!(APSSMETH=2)),APSSFLOC="" Q APSSLNO
 ;
 ; Order through each file entry for this provider.
 F  S APSSENT=$O(^VA(200,APSSPIEN,"PS1",APSSENT)) Q:('APSSENT)!(APSSEXIT)  D
 . ; Initialize the key to the file
 . S APSSKEY=APSSENT_","_APSSPIEN_","
 . ; Retrieve data using FileMan API
 . S APSSTATE=$$GET1^DIQ(200.541,APSSKEY,.01) ; Field .01 License Issuing State
 . S APSSTMP=$$GET1^DIQ(200.541,APSSKEY,1) ; Field 1 License Number
 . S APSSIDT=$$GET1^DIQ(200.541,APSSKEY,2,"I") ; Field 2 Expiration Date Internal format
 . S APSSEDT=$$FMTE^XLFDT(APSSIDT,"5DZ0") ; Field 2 Expiration Date External format conversion
 . ;
 . ; Processing Method
 . I APSSMETH=1 D
 . . ; Grab the first valid License regardless of state
 . . I (APSSIDT>DT)&(APSSTMP="") S APSSTMP1=APSSTMP
 . . ; If the state matches the facility location AND the license is valid stop further processing
 . . I (APSSTATE=APSSFLOC)&(APSSIDT>DT) S APSSLNO=APSSTMP,APSSEXIT=1 Q
 . . Q
 . I APSSMETH=2 D
 . . ; If the state matches the facility location AND the license is valid stop further processing
 . . I (APSSTATE=APSSFLOC)&(APSSIDT>DT) S APSSLNO=APSSTMP,APSSEXIT=1 Q
 . . Q
 . I APSSMETH=3 D
 . .  ; Stop processing any more entries once valid entry is found.
 . . I APSSIDT>DT S APSSLNO=APSSTMP,APSSEXIT=1 Q
 . . Q
 . Q
 ; If processing Method 1 and no license number was found for the facility location
 ; but a valid license was found from a different state than that of the
 ; facility location then use the license that was found.
 I (APSSLNO="")&(APSSMETH=1) S APSSLNO=APSSTMP
 ; Return value
 Q APSSLNO
 ;
SDEA(CLIN) ; Site DEA Number
 N INST,SDEA
 I CLIN="" Q $$GET1^DIQ(4,+$$SITE^VASITE,52,"E")
 S SDEA=""
 S INST=$$GET1^DIQ(44,CLIN,3,"I")
 S SDEA=$$GET1^DIQ(4,INST,52,"E")
 I SDEA="" S SDEA=$$GET1^DIQ(4,+$$SITE^VASITE,52,"E")
 Q SDEA
 ;
SNAME(CLIN) ; Site Name
 N INST,SNAME
 I 'CLIN Q $P($$SITE^VASITE,U,2)
 S INST=$$GET1^DIQ(44,CLIN,3,"I")
 S SNAME=$$GET1^DIQ(4,INST,.01,"E")
 I SNAME="" S SNAME=$P($$SITE^VASITE,U,2)
 Q SNAME
PADDR(PAT) ; Patient Address
 N ADDR,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,PADDR
 S IENS=PAT_","
 D GETS^DIQ(2,IENS,".111;.112;.113;.114;.115;.1112","E","PADDR")
 S ADDR=$G(PADDR(2,IENS,.111,"E"))_U_$G(PADDR(2,IENS,.112,"E"))_U_$G(PADDR(2,IENS,.113,"E"))_U_$G(PADDR(2,IENS,.114,"E"))_U_$G(PADDR(2,IENS,.115,"E"))_U_$G(PADDR(2,IENS,.1112,"E"))
 Q ADDR
