AGEVC ; cmi/flag/maw - AGEV Eligibility Check Driver ;  
 ;;7.1;PATIENT REGISTRATION;**2**;JAN 31, 2007
 ;
 ;this routine will act as a trigger for manually sending a 270 message
 ;for eligibility information
 ;
MAIN ;-- this is the main routine driver
 D PAT
 I '$G(AGEVPAT) W !,"No Patient Selected",! Q
 D TYP
 I '$D(AGEVVST) D  Q
 . I $D(AGEVMESS) W !,AGEVMESS,! Q
 . W !,"No Visit Selected",! Q
 Q:$D(DIRUT)
 D INS,EOJ
 Q
 ;
PAT ;-- get the patient
 W !
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ"
 D ^DIC
 KILL DIC
 Q:Y<0
 S (APCDPAT,AGEVPAT)=+Y
 Q
 ;
TYP ;-- select eligibility by which type of action
 S DIR(0)="S^A:Admit Date;V:Visit Date;E:Eligibility Date"
 S DIR("A")="Send Eligibility Request by "
 S DIR("B")="E"
 D ^DIR
 Q:$D(DIRUT)
 S AGEVET=Y
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Would you like to override previous eligibility checks "
 D ^DIR
 S AGEVOELG=+Y
 K DIR
 I AGEVET="A" S (AGEV("DTP012100C"),AGEV("DTP012100D"))="435"
 I AGEVET="V" S (AGEV("DTP012100C"),AGEV("DTP012100D"))="472",AGEVET="A"
 D @AGEVET
 Q
 ;
A ;-- admit/visit date
 S APCDLOOK="",APCDVSIT=""
 KILL APCDVLK
 D ^APCDVLK
 Q:'$G(APCDVSIT)
 KILL APCDLOOK
 S AGEVVST=$G(APCDVSIT)
 S AGEVVSDT=$$VALI^XBDIQ1(9000010,AGEVVST,.01)
 I $$ECHK(AGEVPAT,AGEVVSDT,$G(AGEVOELG)) D  Q
 . S AGEVMESS="Eligibility already checked within last 30 days"
 .Q
 S (AGEV("DTP032100C"),AGEV("DTP032100D"))=$$DATE^INHUT(AGEVVSDT)
 Q
 ;
E ;-- send by eligibility date
 S %DT="AE",%DT("A")="Check which date for eligibility:  "
 S %DT("B")=$$FMTE^XLFDT(DT)
 D ^%DT
 Q:Y<0
 S AGEVVSDT=+Y
 I $$ECHK(AGEVPAT,AGEVVSDT,$G(AGEVOELG)) D  Q
 . S AGEVMESS="Eligibility already checked within last 30 days"
 .Q
 D E1(AGEVVSDT)
 Q
 ;
E1(AGEVVSDT) ;EP - for setting up necessary elig date vars
 S AGEVVST="0"
 S (AGEV("DTP032100C"),AGEV("DTP032100D"))=$$DATE^INHUT(AGEVVSDT)
 S (AGEV("DTP012100C"),AGEV("DTP012100D"))="307"
 Q
 ;
INS ;-- which type of insurance should be checked?
 S DIR(0)="S^MR:Medicare;MC:Medicaid;PI:Private Insurance;RR:Railroad"
 S DIR(0)=DIR(0)_";AL:All"
 S DIR("A")="Check which insurance for eligibility "
 S DIR("B")="AL"
 D ^DIR
 Q:$D(DIRUT)
 S AGEVINS=Y
 ;D @AGEVINS(AGEVPAT,AGEVVST)  ;THIS PRODCUES AN UNDEFINED ERROR BECAUSE THE INDIRECTION TRIES TO TAKE THE VALUE FROM THE ARRAY AGEVINS(AGEVPAT,AGEVVST) 
 S TAGCALL=AGEVINS_"("_AGEVPAT_","_AGEVVST_")"  ;SET UP VARIABLE CALL INSTR
 D @TAGCALL   ;DO THE CALL
 K TAGCALL
 ;
 Q
 ;
MR(AGEVPAT,AGEVVST) ;EP - get the medicare entry
 Q:'$O(^AUPNMCR("B",AGEVPAT,0))
 D KILL
 NEW AGEVPOLH,AGEVPOLL,AGEVPOLF,AGEVPOLM
 S INDA(9000003,1)=AGEVPAT
 S AGEVIPI=$$VALI^XBDIQ1(9000003,AGEVPAT,.02)
 S AGEVIPE=$$GET1^DIQ(9000003,AGEVPAT,.02)
 S AGEV("NM1032100A")=AGEVIPE
 I AGEVIPI'="" D
 . S AGEV("NM1092100A")=$$GET1^DIQ(9999999.18,AGEVIPI,.07)
 . I AGEV("NM1092100A")="" S AGEV("NM1092100A")="00"
 .Q
 S AGEVPOLH=$$GET1^DIQ(9000003,AGEVPAT,.01)
 S AGEVPOLL=$P(AGEVPOLH,",")
 S AGEVPOLF=$P($P(AGEVPOLH,",",2)," ")
 S AGEVPOLM=$P($P(AGEVPOLH,",",2)," ",2)
 S AGEV("NM1032100C")=$G(AGEVPOLL)
 S AGEV("NM1042100C")=$G(AGEVPOLF)
 S AGEV("NM1052100C")=$G(AGEVPOLM)
 S AGEVMCRN=$$GET1^DIQ(9000003,AGEVPAT,.03)
 S AGEVMCRS=$$GET1^DIQ(9000003,AGEVPAT,.04)
 S AGEV("NM1092100C")=AGEVMCRN_AGEVMCRS
 S AGEV("N3012100C")=$$GET1^DIQ(2,AGEVPAT,.111)
 ;S AGEV("N4012100C")=$$GET1^DIQ(2,AGEVPAT,.114)
 S AGEV("N4012100C")=$$GET1^DIQ(9000001,AGEVPAT,1118)
 S AGEVRRS=$$VALI^XBDIQ1(9000001,AGEVPAT,1117) I AGEVRRS'="" D
 . S AGEVCSTI=$$VALI^XBDIQ1(9999999.05,AGEVRRS,.03)
 . I AGEVCSTI'="" S AGEV("N4022100C")=$$GET1^DIQ(5,AGEVCSTI,1)
 .Q
 S AGEV("N4032100C")=$$GET1^DIQ(2,AGEVPAT,.116)
 S AGEVDA=0 F  S AGEVDA=$O(^AUPNMCR(AGEVPAT,11,AGEVDA)) Q:'AGEVDA  D
 . Q:$G(AGEV("MEDICARE SENT"))  ;only send one message for all medicare
 . S BHLXCT=$P($G(^AUPNMCR(AGEVPAT,11,AGEVDA,0)),U,3)
 . S BHLEQ=$S(BHLXCT="A":"MA",1:"MB")
 . S AGEV("EQ042100C")=$G(BHLEQ)
 . S INDA=AGEVPAT,INDA(9000010,1)=AGEVVST,INDA(2,1)=INDA
 . ;S X="BHL SEND X12 270 MESSAGE SUBSCRIBER",DIC=101 D EN^XQOR
 . S AGEVMSG=$$ELGS^BHLEVENT(AGEVPAT,AGEVVST,.AGEV)
 . S AGEV("MEDICARE SENT")=1  ;flag medicare that is sent
 .Q
 Q
 ;
MC(AGEVPAT,AGEVVST) ;EP - get the medicaid entry
 Q:'$O(^AUPNMCD("B",AGEVPAT,0))
 D KILL
 NEW AGEVPOLH,AGEVPOLL,AGEVPOLF,AGEVPOLM,AGEVIPI
 S AGEVDA=0
 F  S AGEVDA=$O(^AUPNMCD("B",AGEVPAT,AGEVDA)) Q:'AGEVDA  D
 . S INDA(9000004,1)=AGEVDA
 . S AGEVIPI=$$VALI^XBDIQ1(9000004,AGEVDA,.11)
 . S AGEVIPE=$$GET1^DIQ(9000004,AGEVDA,.11)
 . I AGEVIPI="" S AGEVIPI=$$VALI^XBDIQ1(9000004,AGEVDA,.02)
 . I AGEVIPE="" S AGEVIPE=$$GET1^DIQ(9000004,AGEVDA,.02)
 . S AGEV("NM1032100A")=AGEVIPE
 . I AGEVIPI'="" D
 .. S AGEV("NM1092100A")=$$GET1^DIQ(9999999.18,AGEVIPI,.07)
 ..  I AGEV("NM1092100A")="" S AGEV("NM1092100A")="00"
 ..Q
 . S AGEVPOLH=$$GET1^DIQ(9000004,AGEVDA,.01)
 . S AGEVPOLL=$P(AGEVPOLH,",")
 . S AGEVPOLF=$P($P(AGEVPOLH,",",2)," ")
 . S AGEVPOLM=$P($P(AGEVPOLH,",",2)," ",2)
 . S AGEV("NM1032100C")=$G(AGEVPOLL)
 . S AGEV("NM1042100C")=$G(AGEVPOLF)
 . S AGEV("NM1052100C")=$G(AGEVPOLM)
 . S AGEV("NM1092100C")=$$GET1^DIQ(9000004,AGEVDA,.03)
 . S AGEV("N3012100C")=$$GET1^DIQ(2,AGEVPAT,.111)
 . S AGEV("N4012100C")=$$GET1^DIQ(2,AGEVPAT,.114)
 . S AGEV("N4012100C")=$$GET1^DIQ(9000001,AGEVPAT,1118)
 . S AGEVRRS=$$VALI^XBDIQ1(9000001,AGEVPAT,1117) I AGEVRRS'="" D
 .. S AGEVCSTI=$$VALI^XBDIQ1(9999999.05,AGEVRRS,.03)
 .. I AGEVCSTI'="" S AGEV("N4022100C")=$$GET1^DIQ(5,AGEVCSTI,1)
 ..Q
 . S AGEV("N4032100C")=$$GET1^DIQ(2,AGEVPAT,.116)
 . S AGEV("EQ042100C")="MC"
 .Q
 S INDA=AGEVPAT,INDA(9000010,1)=AGEVVST,INDA(2,1)=INDA
 ;S X="BHL SEND X12 270 MESSAGE SUBSCRIBER",DIC=101 D EN^XQOR
 S AGEVMSG=$$ELGS^BHLEVENT(AGEVPAT,AGEVVST,.AGEV)
 Q
 ;
PI(AGEVPAT,AGEVVST) ;EP - get the private insurance entries
 Q:'$O(^AUPNPRVT("B",AGEVPAT,0))
 D KILL
 NEW AGEVPOLH,AGEVPOLL,AGEVPOLF,AGEVPOLM
 S INDA(9000006,1)=AGEVPAT
 S AGEVPOLH=$$GET1^DIQ(9000006,AGEVPAT,.01)
 S AGEVPOLL=$P(AGEVPOLH,",")
 S AGEVPOLF=$P($P(AGEVPOLH,",",2)," ")
 S AGEVPOLM=$P($P(AGEVPOLH,",",2)," ",2)
 S AGEVDA=0
 F  S AGEVDA=$O(^AUPNPRVT(AGEVPAT,11,AGEVDA)) Q:'AGEVDA  D
 . S AGEVPOLP=$P($G(^AUPNPRVT(AGEVPAT,11,AGEVDA,0)),U,8)
 . Q:'$G(AGEVPOLP)
 . I AGEVPOLP'="" S AGEVPLPP=$$VALI^XBDIQ1(9000003.1,AGEVPOLP,.02)
 . S AGEV("INS022100D")="19"
 . S AGEVRELI=$P($G(^AUPNPRVT(AGEVPAT,11,AGEVDA,0)),U,5)
 . I AGEVRELI'="" D
 .. S AGEVRELC=$$VALI^XBDIQ1(9999999.36,AGEVRELI,.02)
 .. I AGEVRELC="02" S AGEV("INS022100D")="01"
 ..Q
 . I AGEVPLPP=AGEVPAT S AGEVSUBS=1
 . I AGEVPOLP'="" D
 .. S AGEVIPI=$$VALI^XBDIQ1(9000003.1,AGEVPOLP,.03)
 .. S AGEVIPE=$$GET1^DIQ(9000003.1,AGEVPOLP,.03)
 .. ;AG*7.1*2 ADDED NEXT TWO LINES BECAUSE SOMETIMES THE INS PTR IS NOT
 .. ;ALWAYS POPULATED IN THE POLICY HOLDER FILE
 .. S:AGEVIPI="" AGEVIPI=$$GET1^DIQ(9000006.11,AGEVDA_","_AGEVPAT_",",.01,"I")
 .. S:AGEVIPE="" AGECIPE=$$GET1^DIQ(9000006.11,AGEVDA_","_AGEVPAT_",",.01)
 .. S AGEV("REF02")=$$GET1^DIQ(9000003.1,AGEVPOLP,.04)
 ..Q
 . S AGEV("NM1032100A")=AGEVIPE
 . I AGEVIPI'="" D
 .. S AGEV("NM1092100A")=$$GET1^DIQ(9999999.18,AGEVIPI,.07)
 .. I AGEV("NM1092100A")="" S AGEV("NM1092100A")="00"
 ..Q
 . Q:'$$VALI^XBDIQ1(9999999.18,AGEVIPI,.32)  ;insurer chekd for elg?
 . S AGEV("NM1032100C")=$G(AGEVPOLL)
 . S AGEV("NM1042100C")=$G(AGEVPOLF)
 . S AGEV("NM1052100C")=$G(AGEVPOLM)
 . S AGEV("NM1092100C")=$$GET1^DIQ(9000003.1,AGEVPOLP,.04)
 . S AGEV("N3012100C")=$$GET1^DIQ(9000003.1,AGEVPOLP,.09)
 . S AGEV("N4012100C")=$$GET1^DIQ(9000003.1,AGEVPOLP,.11)
 . S AGEVPRRS=$$VALI^XBDIQ1(9000003.1,AGEVPOLP,.12)
 . I AGEVPRRS'="" S AGEV("N4022100C")=$$GET1^DIQ(5,AGEVPRRS,1)
 . S AGEV("N4032100C")=$$GET1^DIQ(9000003.1,AGEVPOLP,.13)
 . S AGEV("EQ042100C")="GP"
 . S AGEVPPLH=$$GET1^DIQ(2,AGEVPAT,.01)
 . S AGEVPPLL=$P(AGEVPPLH,",")
 . S AGEVPPLF=$P($P(AGEVPPLH,",",2)," ")
 . S AGEVPPLM=$P($P(AGEVPPLH,",",2)," ",2)
 . S AGEV("NM1032100D")=$G(AGEVPPLL)
 . S AGEV("NM1042100D")=$G(AGEVPPLF)
 . S AGEV("NM1052100D")=$G(AGEVPPLM)
 . S AGEV("NM1092100D")=""
 . S AGEV("N3012100D")=$$GET1^DIQ(2,AGEVPAT,.111)
 . S AGEV("N4012100C")=$$GET1^DIQ(9000001,AGEVPAT,1118)
 . S AGEVRRS=$$VALI^XBDIQ1(9000001,AGEVPAT,1117) I AGEVRRS'="" D
 .. S AGEVCSTI=$$VALI^XBDIQ1(9999999.05,AGEVRRS,.03)
 .. I AGEVCSTI'="" S AGEV("N4022100C")=$$GET1^DIQ(5,AGEVCSTI,1)
 ..Q
 . S AGEV("N4032100D")=$$GET1^DIQ(2,AGEVPAT,.116)
 . S AGEV("EQ042100D")="GP"
 . S INDA=AGEVPAT,INDA(9000010,1)=AGEVVST,INDA(2,1)=INDA
 . I $G(AGEVSUBS) D  Q
 .. S AGEVMSG=$$ELGS^BHLEVENT(AGEVPAT,AGEVVST,.AGEV)
 .. ;S X="BHL SEND X12 270 MESSAGE SUBSCRIBER",DIC=101 D EN^XQOR
 .. K AGEVSUBS
 ..Q
 . ;S X="BHL SEND X12 270 MESSAGE",DIC=101 D EN^XQOR
 . S AGEVMSG=$$ELG^BHLEVENT(AGEVPAT,AGEVVST,.AGEV)
 .Q
 Q
 ;
RR(AGEVPAT,AGEVVST) ;EP - get railroad entries      
 Q:'$O(^AUPNRRE("B",AGEVPAT,0))
 D KILL
 S INDA(9000005,1)=AGEVPAT
 S AGEVIPI=$$VALI^XBDIQ1(9000005,AGEVPAT,.02)
 S AGEVIPE=$$GET1^DIQ(9000005,AGEVPAT,.02)
 S AGEV("NM1032100A")=AGEVIPE
 I AGEVIPI'="" S AGEV("NM1092100A")=$$GET1^DIQ(9999999.18,AGEVIPI,.07)
 S AGEVPOLH=$$GET1^DIQ(9000005,AGEVPAT,.01)
 S AGEVPOLL=$P(AGEVPOLH,",")
 S AGEVPOLF=$P($P(AGEVPOLH,",",2)," ")
 S AGEVPOLM=$P($P(AGEVPOLH,",",2)," ",2)
 S AGEV("NM1032100C")=$G(AGEVPOLL)
 S AGEV("NM1042100C")=$G(AGEVPOLF)
 S AGEV("NM1052100C")=$G(AGEVPOLM)
 S AGEV("NM1092100C")=$$GET1^DIQ(9000005,AGEVPAT,.04)
 S AGEV("N3012100C")=$$GET1^DIQ(2,AGEVPAT,.111)
 S AGEV("N4012100C")=$$GET1^DIQ(2,AGEVPAT,.114)
 S AGEVRRS=$$VALI^XBDIQ1(2,AGEVPAT,.115)
 I AGEVRRS'="" S AGEV("N4022100C")=$$GET1^DIQ(5,AGEVRRS,1)
 S AGEV("N4032100C")=$$GET1^DIQ(2,AGEVPAT,.116)
 S AGEV("EQ042100C")="GP"
 S INDA=AGEVPAT,INDA(9000010,1)=AGEVVST,INDA(2,1)=INDA
 ;S X="BHL SEND X12 270 MESSAGE SUBSCRIBER",DIC=101 D EN^XQOR
 S AGEVMSG=$$ELGS^BHLEVENT(AGEVPAT,AGEVVST,.AGEV)
 Q
 ;
AL(AGEVPAT,AGEVVST) ;EP - get all the entries
 D MR(AGEVPAT,AGEVVST),MC(AGEVPAT,AGEVVST),PI(AGEVPAT,AGEVVST)
 D RR(AGEVPAT,AGEVVST)
 D LOG(AGEVPAT)
 D EOJ
 Q
 ;
EOJ ;-- kill variables and quit
 I '$G(AGEVEXT) D EN^XBVK("AGEV")
 D EN^XBVK("APCD")
 D EN^XBVK("BHL")
 Q
 ;
ECHK(PAT,ELGDT,OELG) ;EP - last eligibility update
 I 'ELGDT Q 1
 S AGEVINT=$$GET1^DIQ(9009061,DUZ(2),35)
 I AGEVINT="" S AGEVINT=30
 I '$P($G(^AUPNPAT(PAT,0)),U,38) Q 0
 I $G(OELG) D LOG(PAT) Q 0
 NEW X
 S X2=ELGDT,X1=$P($G(^AUPNPAT(PAT,0)),U,38)
 D ^%DTC
 I X<AGEVINT Q 1
 Q 0
 ;
VSDT(VST) ;-- return visit date
 S AGEVVSDT=$P($P($G(^AUPNVSIT(VST,0)),U),".")
 Q AGEVVSDT
 ;
LOG(PAT) ;-- set the update array in the patient file
 S DIE="^AUPNPAT(",DA=PAT,DR=".38///"_DT
 D ^DIE
 Q
 ;
KILL ;-- kill off array
 KILL INDA(9000003),INDA(9000004),INDA(9000005),INDA(9000003.1)
 KILL AGEV(9000003),AGEV(9000004),AGEV(9000005),AGEV(9000003.1)
 Q
 ;