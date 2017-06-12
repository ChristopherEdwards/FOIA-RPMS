BSTSSTA ;GDIT/HSCD/ALA-Check status of a Web Service ; 27 Mar 2015  11:35 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,4,5**;Sep 10, 2014;Build 9
 ;
EN ; EP
 ; Select an existing web service and run sample calls for testing
 ;
 NEW DIC,Y,DIR,QUIT,DEBUG,SR,RES,IADT,SCNT,RESULT,DLAYGO,CT,%H
 NEW DIROUT,DIRUT,DTOUT,DUOUT,STS,SERV,SDATA,DTSON,BSTUP,BST,%I,ERROR
 ;
 ;First Select the web service
SRV ;EP
 W !!
 S DIC="^BSTS(9002318.2,",DIC(0)="AEMNZ"
 S DLAYGO=9002318.2 D ^DIC S SERV=+Y
 I SERV=-1 Q
 ;
 ;Check if active
 S IADT=$$GET1^DIQ(9002318.2,SERV_",",".1","I")
 I IADT]"",IADT<DT W !!,"This Web Service is not Active",! H 2 G SRV
 ;
DSP ;EP - Display information
 S SDATA=^BSTS(9002318.2,SERV,0)
 S DTSON=$P(SDATA,"^",13)
 I DTSON="" D
 . D CHK
 . S SDATA=^BSTS(9002318.2,SERV,0)
 . S DTSON=$P(SDATA,"^",13)
 ;
 W !!
 S BST(1)="Current Server Status:",CT=1
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Web Service: "
 S CT=CT+1,BST(CT,"F")="?25",BST(CT)=$P(SDATA,"^",1)
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Current Status: "
 S CT=CT+1,BST(CT,"F")="?25",BST(CT)=$S(DTSON="":"ONLINE",1:"OFFLINE")
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Offline Until: "
 S CT=CT+1,BST(CT,"F")="?25",BST(CT)=$S(DTSON="":"N/A",1:$$FMTE^XLFDT(DTSON))
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Last Error Message: "
 S CT=CT+1,BST(CT,"F")="?25",BST(CT)=$S(DTSON="":"N/A",1:$$GET1^DIQ(9002318.2,SERV_",",3,"E"))
 ;
 ;Check if any processes are running
 L +^BSTS(9002318.1,0):0 E  D
 . S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Background process: "
 . S CT=CT+1,BST(CT,"F")="?25",BST(CT)=$P($G(^XTMP("BSTSLCMP",0)),U,3)
 . I $G(^XTMP("BSTSLCMP","STS"))]"" S CT=CT+1,BST(CT,"F")="!?25",BST(CT)=$G(^XTMP("BSTSLCMP","STS"))
 L -^BSTS(9002318.1,0)
 ;
 ;Check if Description Id Population Utility is running
 L +^XTMP("BSTSCFIX"):0 E  D
 . NEW RUN
 . S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Background process: "
 . S CT=CT+1,BST(CT,"F")="?25",BST(CT)="Description Id Population Utility is running"
 . S RUN=$G(^XTMP("BSTSCFIX","RUN")) Q:RUN=""
 . I $G(^XTMP("BSTSCFIX",RUN,"STS"))]"" S CT=CT+1,BST(CT,"F")="!?25",BST(CT)=$G(^XTMP("BSTSCFIX",RUN,"STS"))
 L -^XTMP("BSTSCFIX")
 ;
 ;Check if ICD9 to SNOMED process is running
 L +^TMP("BSTSICD2SMD"):0 E  D
 . S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Background process: "
 . S CT=CT+1,BST(CT,"F")="?25",BST(CT)="ICD9 to SNOMED process is running"
 L -^TMP("BSTSICD2SMD")
 ;
 ;Check if install conversion process is running
 L +^TMP("BSTSPBFH"):0 E  D
 . S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="Background process: "
 . S CT=CT+1,BST(CT,"F")="?25",BST(CT)="Installation conversion process is running"
 L -^TMP("BSTSPBFH")
 ;
 S CT=CT+1,BST(CT,"F")="!!",BST(CT)="Current Server Settings: "
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="CHECK FOR CONNECTION AFTER: "
 S CT=CT+1,BST(CT,"F")="?35",BST(CT)=$S($P(SDATA,"^",14)="":"60 minutes (default)",1:$$FRMT($P(SDATA,"^",14))_" minutes")
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="CONNECTION TIMEOUT OVERRIDE: "
 S CT=CT+1,BST(CT,"F")="?35",BST(CT)=$S($P(SDATA,"^",12)="":" 2 seconds (default)",1:$$FRMT($P(SDATA,"^",12))_" seconds")
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="MAXIMUM REMOTE SEARCH TIME: "
 S CT=CT+1,BST(CT,"F")="?35",BST(CT)=$S($P(SDATA,"^",15)="":"60 seconds (default)",1:$$FRMT($P(SDATA,"^",15))_" seconds")
 S CT=CT+1,BST(CT,"F")="!?5",BST(CT)="TIMEOUT OVERRIDE: "
 S CT=CT+1,BST(CT,"F")="?35",BST(CT)=$S($P(SDATA,"^",5)="":"60 seconds (default)",1:$$FRMT($P(SDATA,"^",5))_" seconds")
 S CT=CT+1,BST(CT,"F")="!!",BST(CT)="  "
 S CT=CT+1,BST(CT,"F")="!",BST(CT)="Choose from the following options"
 ;
 D EN^DDIOL(.BST)
 K BST
 ;
 NEW DIR,X,Y
 S DIR(0)="LO^1:4"
 S DIR("A")="Select number or return to quit"
 S DIR("A",1)="1.  Refresh Current information"
 S DIR("A",2)="2.  Check DTS and Enable if Available"
 S DIR("A",3)="3.  Turn off the DTS Link"
 S DIR("A",4)="4.  Edit Server Settings"
 D ^DIR
 I X="" G SRV
 I $G(DTOUT)!($G(DUOUT)) G SRV
 I X=1 G DSP
 ;
 I X=2 D  G DSP
 . I DTSON="" D CHK Q
 . S BSTUP(9002318.2,SERV_",",.13)="@"
 . S BSTUP(9002318.2,SERV_",",3)="@"
 . D FILE^DIE("","BSTUP","ERROR")
 . D ELOG^BSTSVOFL($$GET1^DIQ(200,DUZ_",",".01","E")_" turned on DTS link from BSTS STS option")
 . D CHK
 ;
 I X=3 D  G DSP
 . NEW DIR
 . S DIR("A")="Turn off the DTS link until"
 . S DIR("A",1)="Enter a date and time more than 10 mins in the future. "
 . S DIR("A",2)="    [Current date and time is "_$$FMTE^XLFDT($$NOW^XLFDT())_"]"
 . S DIR(0)="D^"_$$FMADD^XLFDT($$NOW^XLFDT(),"","",10)_":"_$$FMADD^XLFDT(DT,7)_".2359:ERTX"
 . D ^DIR I $G(DTOUT)!($G(DUOUT)) Q
 . S BSTUP(9002318.2,SERV_",",.13)=Y
 . D FILE^DIE("","BSTUP","ERROR")
 . D ELOG^BSTSVOFL($$GET1^DIQ(200,DUZ_",",".01","E")_" turned off DTS link from BSTS STS option")
 ;
 I X=4 D  G DSP
 . NEW DIE,DA,DR
 . S DIE="^BSTS(9002318.2,",DA=SERV,DR=".14;.12;.15;.05"
 . D ^DIE
 Q
 ;
CHK ;EP - Check the server status
 NEW STS,BSTUP
 S STS=$$CALL^BSTSTST(SERV,"COMMON COLD","")
 Q
 ;
FRMT(VALUE) ;EP - Format the data
 S VALUE=$E(" ",$L(VALUE))_VALUE
 Q VALUE
