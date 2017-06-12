BSTSWSV ;GDIT/HS/BEE-Standard Terminology Web Service Handling ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,4**;Sep 10, 2014;Build 32
 ;
 Q
 ;
SEARCH(OUT,IN,DEBUG) ;EP - Perform a Web Service Search
 ;
 ;Input
 ;OUT-Output variable/global to ret data in (VAR)
 ;IN Array-List of search parms
 ;DEBUG-1:DEBUG mode
 ;
 ;Output
 ;Function returns - [1]^[2]^[3]
 ;[1]-1:Successful remote call
 ;    0:Unsuccessful remote call
 ;[2]-Primary Remote Error Message
 ;[3]-Secondary Remote Error Message (if applicable)
 ;
 ;VAR(#)-[1]^[2]^[3]
 ;[1]-Concept ID
 ;[2]-DTS ID
 ;[3]-Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get server list
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
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
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . S CSTS=$$SEARCH^BSTSDTS2(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status var
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
CNCSR(OUT,IN,DEBUG) ;EP - Perform Web Service Concept Id Search
 ;
 ;Input
 ;OUT-Output variable/global to return information in (VAR)
 ;IN Array-List of search parameters
 ;DEBUG-1:DEBUG mode
 ;
 ;Output
 ;Function returns - [1]^[2]^[3]
 ;[1]-1:Successful remote call
 ;    0:Unsuccessful remote call
 ;[2]-Primary Remote Error Message
 ;[3]-Secondary Remote Error Message (if applicable)
 ;
 ;VAR(#)-[1]^[2]^[3]
 ;[1]-Concept ID
 ;[2]-DTS ID
 ;[3]-Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
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
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$CNCSR^BSTSDTS0(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status var
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ; 
ICD2SMD(OUT,IN,DEBUG) ;EP - Perform Web Service ICD9 to SNOMED mapping retrieval
 ;
 ;Input
 ;OUT-Output variable/global to return information in (VAR)
 ;IN Array-List of search parameters
 ;DEBUG - 1:DEBUG mode
 ;
 ;Output
 ;Function returns-[1]^[2]^[3]
 ;[1]-1:Successful remote call
 ;    0:Unsuccessful remote call
 ;[2]-Primary Remote Error Message
 ;[3]-Secondary Remote Error Message (if applicable)
 ;
 ;VAR(#)-[1]^[2]^[3]
 ;[1]-Concept ID
 ;[2]-DTS ID
 ;[3]-Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get server list
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
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
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$ICD2SMD^BSTSDTS2(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status var
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
DSCLKP(OUT,IN,DEBUG) ;EP - Perform a Web Service Description Id Search
 ;
 ;Input
 ;OUT-Output variable/global to return information in (VAR)
 ;IN Array-List of search parameters
 ;DEBUG-1:DEBUG mode
 ;
 ;Output
 ;Function returns - [1]^[2]^[3]
 ;[1]-1:Successful remote call
 ;    0:Unsuccessful remote call
 ;[2]-Primary Remote Error Message
 ;[3]-Secondary Remote Error Message (if applicable)
 ;
 ;VAR(#)-[1]^[2]^[3]
 ;[1]-Concept ID
 ;[2]-DTS ID
 ;[3]-Description ID
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get server list
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
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
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$DSCSRCH^BSTSDTS2(OUT,.BSTSWS)
 . I $G(BSTSWS("DEBUG")) W !!,"DTS: ",CSTS,!
 . ;
 . ;Log call times
 . S TIME=$P(CSTS,U,3)
 . ;
 . ;Define status var
 . S $P(STS,U)=+CSTS
 . I II<4 S $P(STS,U,II)=$P(CSTS,U,2)
 ;
 Q STS
 ;
SUBLST(DLIST,IN,DEBUG) ;EP - Perform a Web Service Subset Listing
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
 ; VAR(#) - [1]
 ; [1] - DTSId
 ;
 N BSTSSRV,PRI,STS,II
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
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
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$SUBLST^BSTSDTS2(DLIST,.BSTSWS)
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
DTSSR(OUT,IN,DEBUG) ;EP - Perform a Web Service DTS Id Lookup
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
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
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
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$DTSSR^BSTSDTS1(OUT,.BSTSWS)
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
GCDSET(DEBUG) ;EP - Poll server(s) for codeset information
 ;
 ;Input
 ; DEBUG - 1:DEBUG mode
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
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$GCDSDTS4^BSTSDTS0(.BSTSWS)
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
GVRSET(NMID,DEBUG) ;EP - Poll server(s) for codeset information
 ;
 ;Input
 ; NMID - Namespace ID
 ; DEBUG - 1:DEBUG mode
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
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . S BSTSWS("NAMESPACEID")=NMID
 . ;
 . ;Note - do not check for working DTS since this call is used by
 . ;the underlying $$CKDTS^BSTSWSV1 call. This would cause an endless loop
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$GVRDTS4^BSTSDTS0(.BSTSWS)
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
SUBSET(OUT,NMID,DEBUG) ;EP - Poll server(s) for subset information
 ;
 ;Input
 ; NMID - Namespace ID
 ; DEBUG - 1:DEBUG mode
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
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 ;Get list of servers
 S STS=$$WSERVER(.BSTSSRV,DEBUG)
 ;
 ;Loop through list and make each call
 S STS=0,PRI="" F II=2:1 S PRI=$O(BSTSSRV(PRI)) Q:PRI=""  D  Q:+STS
 . ;
 . N BSTSWS,TYPE,TIME,CSTS
 . M BSTSWS=BSTSSRV(PRI)
 . S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 . S BSTSWS("NAMESPACEID")=NMID
 . ;
 . ;Check if DTS server is set to local
 . S STS=$$CKDTS^BSTSWSV1(.BSTSWS) I '+STS Q
 . ;
 . ;Call DTS
 . I TYPE="D" S CSTS=$$SUBSET^BSTSDTS2(OUT,.BSTSWS)
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
TEST(OUT,IN,DEBUG) ;EP - Perform a Test Web Service Search
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
 N BSTSSRV,PRI,STS,II,BSTSWS,TYPE,TIME,CSTS
 ;
 ;Define DEBUG
 S DEBUG=$G(DEBUG,"")
 ;
 M BSTSWS=IN
 ;
 ;Retrieve Web Service Information
 S STS=$$GETWSV(BSTSWS("SERVICE"),.BSTSSRV,DEBUG)
 ;
 ;Make sure service was found
 I $D(BSTSSRV)<10 S STS="0^No Active Server Found" Q 0
 ;
 M BSTSWS=BSTSSRV(1)
 S TYPE=$G(BSTSWS("TYPE")),CSTS=""
 ;
 ;Call DTS
 I TYPE="D" S CSTS=$$TSRCH^BSTSDTS1(OUT,.BSTSWS)
 ;
 Q CSTS
 ;
WSERVER(BSTSSRV,DEBUG) ;P - Retrieve array of Web Server Information
 ;
 ;Input
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function - 0:No Data Returned, 1:Data Returned
 ; BSTSSRV - Array of web service connection information
 ;
 ;Quit if install is running
 L +^TMP("BSTSINSTALL"):1 E  Q 0
 L -^TMP("BSTSINSTALL")
 ;
 N NMIEN
 ;
 ;Loop through servers until successful call
 S NMIEN=0 F  S NMIEN=$O(^BSTS(9002318,NMIEN)) Q:'NMIEN  D
 . N PRI
 . S PRI="" F  S PRI=$O(^BSTS(9002318,NMIEN,1,"C",PRI)) Q:'PRI  D
 .. N IEN
 .. S IEN="" F  S IEN=$O(^BSTS(9002318,NMIEN,1,"C",PRI,IEN)) Q:'IEN  D
 ... N WSIEN,STS,DA,IENS
 ... ;
 ... ;Pull Web Service IEN
 ... S DA(1)=NMIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 ... S WSIEN=$$GET1^DIQ(9002318.01,IENS,".01","I") Q:WSIEN=""
 ... ;
 ... ;Retrieve Web Service Information
 ... S STS=$$GETWSV(WSIEN,.BSTSSRV,DEBUG)
 ;
 Q $S($O(BSTSSRV(""))]"":"1",1:"0")
 ;
GETWSV(WSIEN,BSTSSRV,DEBUG) ;EP - Retrieve Single Web Service Connection Info
 ;
 ;Input
 ; WSIEN - Pointer to 9002318.2
 ; DEBUG - 1:DEBUG mode
 ;
 ;Output
 ; Function - 0:No Data Returned, 1:Data Returned
 ; BSTSSRV - Array of web service connection information
 ;
 N DA,IENS,URLRT,PORT,TYPE,TIME,USER,PASS,II,SPATH,IADT,SSL,CTIME,MSTM,RETRY,MFAIL,FWAIT
 ;
 ;Pull Server information
 S IADT=$$GET1^DIQ(9002318.2,WSIEN_",",".1","I")
 I IADT]"",IADT<DT Q 0
 S URLRT=$$GET1^DIQ(9002318.2,WSIEN_",",".02","E")
 S PORT=$$GET1^DIQ(9002318.2,WSIEN_",",".03","E")
 S TYPE=$$GET1^DIQ(9002318.2,WSIEN_",",".04","I")
 S TIME=$$GET1^DIQ(9002318.2,WSIEN_",",".05","I")
 S USER=$$GET1^DIQ(9002318.2,WSIEN_",",".07","E")
 S PASS=$$GET1^DIQ(9002318.2,WSIEN_",",".08","E")
 S IADT=$$GET1^DIQ(9002318.2,WSIEN_",",".1","I")
 S SPATH=$$GET1^DIQ(9002318.2,WSIEN_",",".11","E")
 S SSL=$$GET1^DIQ(9002318.2,WSIEN_",","2.01","E")
 S RETRY=$$GET1^DIQ(9002318.2,WSIEN_",","4.01","E") S:RETRY="" RETRY=1
 S RETRY=RETRY+1
 S CTIME=$$GET1^DIQ(9002318.2,WSIEN_",",".12","I") S:CTIME="" CTIME=2
 S MSTM=$$GET1^DIQ(9002318.2,WSIEN_",",.15,"I") S:MSTM="" MSTM=60
 S MFAIL=$$GET1^DIQ(9002318.2,WSIEN_",","4.02","E") S:MFAIL="" MFAIL=10
 S FWAIT=$$GET1^DIQ(9002318.2,WSIEN_",","4.03","E") S:FWAIT="" FWAIT=7200
 S II=$O(BSTSSRV(""),-1)+1
 S BSTSSRV(II,"URLROOT")=URLRT
 S BSTSSRV(II,"PORT")=PORT
 S BSTSSRV(II,"TYPE")=TYPE
 S BSTSSRV(II,"USER")=USER
 S BSTSSRV(II,"PASS")=PASS
 S BSTSSRV(II,"TIMEOUT")=TIME
 S BSTSSRV(II,"DEBUG")=DEBUG
 S BSTSSRV(II,"SERVICEPATH")=SPATH
 S BSTSSRV(II,"SSL")=SSL
 S BSTSSRV(II,"CTIME")=CTIME
 S BSTSSRV(II,"IEN")=WSIEN
 S BSTSSRV(II,"MSTM")=MSTM
 S BSTSSRV(II,"RETRY")=RETRY
 S BSTSSRV(II,"MFAIL")=MFAIL
 S BSTSSRV(II,"FWAIT")=FWAIT
 ;
 Q 1
