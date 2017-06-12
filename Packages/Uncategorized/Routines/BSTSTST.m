BSTSTST ;GDIT/HS/BEE-Standard Terminology Web Service Test ; 19 Nov 2012  9:54 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;;Sep 10, 2014;Build 101
 Q
 ;
TEST ;EP - BSTS TEST WEB SERVICE Option
 ;
 ; Select an existing web service and run sample calls for testing
 ;
 NEW DIC,Y,DIR,QUIT,DEBUG,SR,RES,SERV,IADT,SCNT,RESULT,DLAYGO
 NEW DIROUT,DIRUT,DTOUT,DUOUT
 ;
 ;First Select the web service
SRV S DIC="^BSTS(9002318.2,",DIC(0)="AEMNZ"
 S DLAYGO=9002318.2 D ^DIC S SERV=+Y
 I SERV=-1 Q
 ;
 ;Check if active
 S IADT=$$GET1^DIQ(9002318.2,SERV_",",".1","I")
 I IADT]"",IADT<DT W !!,"This Web Service is not Active",! H 2 G SRV
 ;
 ;Check for debug mode
 S DIR(0)="Y",DIR("B")="N"
 S DIR("A",1)=""
 S DIR("A")="Display DTS connection log (Y/N): "
 D ^DIR
 S QUIT=$$CKANS()
 ;
 ;Check for "^", "^^", timeout
 I QUIT>1 Q
 S DEBUG=$S(Y=1:1,1:"")
 ;
 ;Perform test searches
 S SCNT=0,RES=2 F SR="HEART DISEASE DISORDER","ANTENATAL CARE","EDEMA","DIABETES" D  I RES<2 Q
 . S SCNT=SCNT+1
 . W !!,"Performing search on term: ",SR
 . S RES=$$CALL(SERV,SR,DEBUG)
 . S RESULT(SCNT)=SR_U_RES
 ;
 ;Loop through and display results
 W !!,"TEST RESULTS FOR ",$$GET1^DIQ(9002318.2,SERV_",",.01,"I")
 S SCNT="" F  S SCNT=$O(RESULT(SCNT)) Q:SCNT=""  D
 . N RES
 . S RES=RESULT(SCNT)
 . W !!,"Search Term: ",$P(RES,U)
 . W !,"Search Result: ",$S(+$P(RES,U,2)=2:"Success",1:"Fail")
 . W !,"Error Message: ",$S($P(RES,U,3)]"":$P(RES,U,3),1:"N/A")
 . W !,"Call Completion Time: ",$P(RES,U,4)
 ;
 ;Check for new test
 S DIR(0)="Y",DIR("B")="N"
 S DIR("A",1)=""
 S DIR("A")="Run another test (Y/N): "
 D ^DIR
 S QUIT=$$CKANS()
 ;
 ;Check for "^", "^^", timeout
 I QUIT>1!('Y) Q
 K RESULT
 G SRV
 ;
CKANS()  ;EP - Check answer "^", "^^", and timeout
 ;
 ;User typed "^^"
 I $G(DIROUT) Q 3
 ;
 ;User typed "^" or timed out
 I $G(DUOUT)!$G(DTOUT) Q 2
 ;
 ;User hit ENTER
 I $G(DIRUT) Q 1
 ;
 Q 0
 ;
CALL(SERV,SEARCH,DEBUG) ;EP - Perform Test Search
 ;
 N RESULT,BSTSR,BSTSWS,RES
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")="S"
 S BSTSWS("NAMESPACEID")=36
 S BSTSWS("SUBSET")="IHS Problem List"
 S BSTSWS("SNAPDT")=""
 S BSTSWS("MAXRECS")=100
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("SERVICE")=SERV
 ;
 ;Make DTS search call
 S BSTSR=1
 ;
 ;Perform Test Lookup
 S BSTSR=$$TEST^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 Q BSTSR
