BSTSWSV1 ;GDIT/HS/BEE-Standard Terminology Web Service Handling (CONT) ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,4,5,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
SCODE(NMID) ;EP - Get a list of concepts in subsets
 ;
 ;Input
 ; NMID (Optional) - Codeset to run
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 1:Successful remote call
 ;       0:Unsuccessful remote call
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 N BSTSSRV,PRI,STS,II
 ;
 S NMID=$G(NMID)
 ;
 ;Get list of servers
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,"")
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found"
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" D
 .. I NMID=1552 S CSTS=$$RCODE^BSTSDTS5(.BSTSWS) Q
 .. S CSTS=$$SCODE^BSTSDTS4(.BSTSWS)
 . ;
 . ;Log call times (needs completed)
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status variable
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
DILKP(OUT,IN,DEBUG) ;EP - Perform a Web Service Drug Ingredient Lookup
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ; IN Array - List of search parameters
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 1:Successful remote call
 ;       0:Unsuccessful remote call
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found"
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$DILKP^BSTSDTS1(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times (needs completed)
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status variable
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
 ;
USEARCH(OUT,IN,DEBUG) ;EP - Perform a Web Service UNIVERSE Search
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ; IN Array - List of search parameters
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 1:Successful remote call
 ;       0:Unsuccessful remote call
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found"
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . S CSTS=$$USEARCH^BSTSDTS4(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times (needs completed)
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status variable
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
CKDTS(BSTSWS) ;EP - Determine whether to perform remote call
 ;
 ;Input: BSTSWS Array of Web Service data
 ;
 ;Returns: 1 - Make call to DTS
 ;         0^Server Set to Local - Do not make DTS call
 ;
 NEW BIEN,SWCHLCL,%,VAR,STS,CKPRD,NWCK,BSTS,ERR
 ;
 ;Retrieve definition IEN
 S BIEN=$G(BSTSWS("IEN")) Q:BIEN="" 0
 ;
 ;If CHECK FOR DTS CONNECTION ON is blank allow it
 S SWCHLCL=$$GET1^DIQ(9002318.2,BIEN_",",.13,"I") Q:SWCHLCL="" 1
 ;
 ;Skip for overrides
 I $G(BSTSWS("TBYPASS"))=1 Q 1
 ;
 ;If there is a date/time see if check needs to be performed
 ;If date is in the future stay local
 D NOW^%DTC I SWCHLCL>% Q "0^Server Set To Local"
 ;
 ;Perform a DTS Remote lookup
 S STS=$$VERSIONS^BSTSAPI("VAR")
 ;
 ;If success, clear out CHECK FOR DTS CONNECTION ON
 I +STS=2 D UPDT(BIEN,"@") Q 1
 ;
 ;Update CHECK FOR CONNECTION AFTER value - if blank use 60 minutes in future
 D UPDT(BIEN,$P(STS,U,2))
 ;
 Q "0^Server Set To Local"
 ;
SWLCL(BSTSWS,STS) ;EP - Switch To Local Check
 ;
 ;This call determines whether the DTS server should be switched to local
 ;
 NEW %,NWCK,BSTS,ERR,CKPRD,BIEN,MXSR,CTIME,SUCCESS
 ;
 ;Retrieve definition IEN
 S BIEN=$G(BSTSWS("IEN")) Q:BIEN=""
 ;
 ;Skip for overrides
 I $G(BSTSWS("TBYPASS"))=1 Q
 ;
 ;Check if call succeeded, if not switch to local
 S SUCCESS=$P(STS,U) I SUCCESS=0 D UPDT(BIEN,$S($P(STS,U,2)]"":$P(STS,U,2),1:"DTS call failed")) S $P(STS,U,2)="Switched Server to LOCAL" Q
 ;
 ;Get the call time
 S CTIME=$P(STS,U,3)
 ;
 ;Get the MAXIMUM REMOTE SEARCH TIME
 S MXSR=$$GET1^DIQ(9002318.2,BIEN_",",.15,"I") S:MXSR="" MXSR=60
 ;
 ;If time was too long, switch to local
 I CTIME>MXSR S $P(STS,U,2)="Switched Server to LOCAL" D UPDT(BIEN,"Call was successful but its duration exceeded the MAXIMUM REMOTE SEARCH TIME") Q
 ;
 Q
 ;
UPDT(BIEN,VAL,OVMSG) ;EP - Update the CHECK FOR DTS CONNECTION ON
 ;
 ;Input: BIEN - Pointer to Web Service Entry
 ;        VAL - Error Message - Switch Server to Local
 ;            - @ - Switch Server back on
 ;      OVMSG - Override message on @
 Q:BIEN=""
 I $G(VAL)'="@" D ^ZTER
 S OVMSG=$G(OVMSG)
 ;
 NEW BSTS,ERR,ERRMSG,LOG
 ;
 ;Log entry
 I VAL="@",OVMSG]"" S LOG=OVMSG
 E  I VAL="@",OVMSG="" S LOG="Switched DTS connection on"
 E  S LOG="Switched DTS Connection off: "_VAL
 D ELOG^BSTSVOFL(LOG)
 ;
 ;Get the error message
 S ERRMSG=$S(VAL="":"@",VAL'="@":VAL,1:"@")
 ;
 ;If value equals null, switch to local
 I $G(VAL)'="@" D
 . NEW CKPRD,%
 . ;
 . ;Retrieve CHECK FOR CONNECTION AFTER value - if blank use 60
 . S CKPRD=$$GET1^DIQ(9002318.2,BIEN_",",.14,"I") S:CKPRD="" CKPRD=60
 . ;
 . ;Get current date and time
 . D NOW^%DTC
 . ;
 . S VAL=$$FMADD^XLFDT(%,0,0,CKPRD,0)
 ;
 ;Update CHECK FOR DTS CONNECTION ON
 S BSTS(9002318.2,BIEN_",",.13)=VAL
 S BSTS(9002318.2,BIEN_",",3)=$E(ERRMSG,1,245)
 D FILE^DIE("","BSTS","ERR")
 ;
 Q
 ;
CSTMCDST(OUT,IN) ;EP - Perform a Web Service Custom Codeset Listing
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ; IN Array - List of search parameters
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 1:Successful remote call
 ;       0:Unsuccessful remote call
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found"
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . S CSTS=$$CSTMCDST^BSTSDTS5(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times (needs completed)
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status variable
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
ACODE(OUT,IN,DEBUG) ;EP - Perform a Web Service '36' auto-codable ICD10 Listing
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ; IN Array - List of search parameters
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 1:Successful remote call
 ;       0:Unsuccessful remote call
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found"
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . S CSTS=$$ACODE^BSTSDTS3(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times (needs completed)
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status variable
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
A9CODE(OUT,IN,DEBUG) ;EP - Perform a Web Service '36' auto-codable ICD9 Listing
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ; IN Array - List of search parameters
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 1:Successful remote call
 ;       0:Unsuccessful remote call
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found"
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . S CSTS=$$A9CODE^BSTSDTS3(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times (needs completed)
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status variable
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
 ;BSTS*1.0*4;New tag to reset all links back on
RESET ;EP - Turn all the links back on
 ;
 NEW SITE,SIEN
 ;
 S SITE=0 F  S SITE=$O(^BSTS(9002318,SITE)) Q:'SITE  S SIEN=0 F  S SIEN=$O(^BSTS(9002318,SITE,1,SIEN)) Q:'SIEN  D
 . NEW WIEN,IENS,DA
 . ;
 . ;Get the pointer to the web service entry
 . S DA(1)=SITE,DA=SIEN,IENS=$$IENS^DILF(.DA)
 . S WIEN=$$GET1^DIQ(9002318.01,IENS,".01","I") Q:WIEN=""
 . ;
 . ;Quit if online
 . I $$GET1^DIQ(9002318.2,WIEN_",",".13","I")="" Q
 . ;
 . ;Clear the status
 . D UPDT^BSTSWSV1(WIEN,"@","Reset DTS Link for connection retry")
 Q
 ;
CKONOFF() ;Return when an online server is found
 ;
 NEW STS,BSTSSRV,PRI,II
 ;
 ;Get server list
 S STS=$$WSERVER^BSTSWSV(.BSTSSRV,"")
 ;
 ;Loop through list and make each call
 I $D(BSTSSRV)<10 Q 0
 I $D(BSTSSRV)>1 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=IN
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS(.BSTSWS)
 ;
 Q STS
