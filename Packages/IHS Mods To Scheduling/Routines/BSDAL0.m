BSDAL0 ; IHS/ANMC/LJF - IHS APPT LIST - CONTINUED ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;IHS version of SDAL0
 ;
START ;EP; called by list template INIT^BSDALL
 NEW SC,BSDCN
 S BSDCN=0
 F  S BSDCN=$S(VAUTC:$O(^SC("B",BSDCN)),1:$O(VAUTC(BSDCN))) Q:BSDCN=""  D
 . S SC=0
 . F  S SC=$O(^SC("B",BSDCN,SC)) Q:'SC  D CLINIC
 Q
 ;
CLINIC ; called for each clinic
 NEW BSDACT,BSD,IEN,FIRST
 ; check if clinic is active and not cancelled for date
 I $$CHECK(SC,BSDD),$$ACTIVITY(SC,BSDD) D
 . W !
 . I $G(BSDION)]"" W "@@@@@"  ;top of page marker for paper print
 . W "Appointments for  ",$$GET1^DIQ(44,SC,.01)," clinic on  ",$$FMTE^XLFDT(BSDD)
 . I $G(BSDION)="" W !,$$REPEAT^XLFSTR("=",80)
 . ;
 . ;get each appt time for date and clinic
 . S BSDACT=0,BSD=BSDD
 . F  S BSD=$O(^SC(SC,"S",BSD)) Q:'BSD!(BSD\1>BSDD)  D
 .. ;  find each appt at date/time then call APPTLN to print info
 .. S IEN=0,FIRST=1
 .. F  S IEN=$O(^SC(SC,"S",BSD,1,IEN)) Q:'IEN  D
 ... Q:$P($G(^SC(SC,"S",BSD,1,IEN,0)),U,9)="C"     ;cancelled
 ... D APPTLN(SC,BSD,IEN)                          ;print appt data line
 . ;
 . I 'BSDACT D
 .. S BSDACT="No appointment activity found for this clinic date!"
 .. W !!?(IOM-$L(BSDACT)\2),BSDACT
 . ;
 . W ! I BSDCR D CCLK(SC,BSDD)   ;print chart requests at end of list
 ;
 Q
 ;
APPTLN(CLN,DATE,IEN) ; -- for each individual appt, print patient data
 NEW NODE,DFN,BSDOI,DATA,X,VA,VADM,BSDZ,SPACE,Z,VAPA
 S NODE=^SC(CLN,"S",DATE,1,IEN,0),DFN=+NODE,BSDOI=$P(NODE,U,4)
 I BSDWI=0,$$WALKIN^BSDU2(DFN,DATE) Q    ;quit if excluding walk-ins
 S DATA=$G(^DPT(DFN,"S",DATE,0)) Q:$P(DATA,U,2)["C"   ;cancelled
 D DEM^VADPT
 ;
 ; -- build display line
 ;
 ; line 1: appt time, walkin, checkin, out vs inpt
 I FIRST S FIRST=0,X=DATE D TM^SDROUT0 W !,$J(X,8)    ;appt time
 I $X>15 W !!
 I $P(DATA,U,7)=4 W ?12,"Walk-in "                    ;walk-in
 E  S X=$P($G(^SC(SC,"S",DATE,1,IEN,"C")),U) I X]"" D
 . D TM^SDROUT0 W ?12,"Checked in at ",X              ;checkin time
 I ($P(DATA,U,2)="N")!($P(DATA,U,2)="NA") W ?12,"No-Show"  ;no-show
 S X=$$INPT1^BDGF1(DFN,DATE)                          ;inpatient?
 I X]"" W ?40,"Admitted "_X_"  "                      ;admit date
 W ?40,"(",$S($G(^DPT(DFN,.1))]"":^(.1),1:"Outpatient"),")"
 ;
 ; -- line 2: name, chart #, dob, age, lab/x-ray/ekg times
 I $$DEAD^BDGF2(DFN) W !?12,"** PATIENT DIED ON ",$$DOD^BDGF2(DFN)," **"
 ;
 W !?5,$S($D(^SC(SC,"S",DATE,1,IEN,"OB")):"*",1:"")   ;* if overbook
 W ?7,$E(VADM(1),1,18)                               ;patient name
 W ?30,"#",VA("PID")                                  ;pat id
 W ?39,$$FMTE^XLFDT(+VADM(3),5)," (",VADM(4),")"      ;dob(age)
 ;
 S (BSDZ(3),BSDZ(4),BSDZ(5))=""                       ;lab/xray/ekg
 F X=3,4,5 S BSDZ(X)=$P(DATA,U,X)                     ;test date/times
 S SPACE=0 F Z=3,4,5 S X=BSDZ(Z) D:X]"" TM^SDROUT0 S SPACE=Z#3*8+3 W ?48+SPACE,$J(X,8) W:SPACE<16 "  "
 ;
 ; line 3: insurance coverage and other info
 W !?9,$$INSUR^BDGF2(DFN,DATE) W:BSDOI]"" ?18,BSDOI
 ;
 ; line 4: patient phone and apt made by
 I BSDPH!BSDAMB W !
 I BSDPH K VAPA D ADD^VADPT W ?5,"Phone: ",VAPA(8)    ;pat home phone
 I BSDAMB D                                           ;appt made by
 . NEW X,Y,Z
 . S X=$P(NODE,U,6),Y=$P(NODE,U,7) Q:X=""
 . W ?25,"Made by ",$$GET1^DIQ(200,X,.01),"  on ",$$FMTE^XLFDT(Y,"2")
 . S Z=$$GET1^DIQ(200,X,.132) W:Z]"" ?63," (",Z,")"  ;user's phone
 ;
 ; line 5: primary care provider info
 NEW BSDARR,I
 I BSDPCMM S BSDARR="BSDARR" D PCP^BSDU1(DFN,.BSDARR)
 I $D(BSDARR(1))  W !?20,"PCP: ",$P(BSDARR(1),"/",1,2)
 ;
 S BSDACT=BSDACT+1 W !
 Q
 ;
 ;
CCLK(CLN,DATE) ; -- list chart requests for this clinic and date
 NEW BSDC,DFN,IEN,BSDN
 I $O(^SC(CLN,"C",DATE,1,0)) W !,"CHART REQUESTS for ",$$FMTE^XLFDT(DATE),":"
 S IEN=0 F  S IEN=$O(^SC(CLN,"C",DATE,1,IEN)) Q:'IEN  D
 . S DFN=$G(^SC(CLN,"C",DATE,1,IEN,0)) Q:'DFN
 . S BSDN=$G(^SC(CLN,"C",DATE,1,IEN,9999999))
 . W !,$E($$GET1^DIQ(2,DFN,.01),1,20)
 . W ?23,"#",$$HRCN^BDGF2(DFN,DUZ(2))
 . W ?35,$E($P(BSDN,U,3),1,33)
 . Q:'BSDAMB
 . W !?35,"Made by ",$E($$GET1^DIQ(200,+$P(BSDN,U,2),.01),1,15)
 . W " on ",$$FMTE^XLFDT(+BSDN,"D")
 Q
 ;
 ;
CHECK(CLN,APDT) ;check if clinic for this division and not cancelled or inactive
 I $$GET1^DIQ(44,CLN,2,"I")'="C" Q 0                   ;not a clinic
 I 'VAUTD,'$D(VAUTD(+$$GET1^DIQ(44,CLN,3.5,"I"))) Q 0  ;wrong division
 I '$$ACTV^BSDU(CLN,APDT) Q 0                          ;not active
 I $G(^SC(CLN,"ST",APDT,1))="" Q 0                     ;no schedule
 I $G(^SC(CLN,"ST",APDT,1))["**CANCELLED" Q 0          ;cancelled
 Q 1
 ;
 ;
ACTIVITY(CLN,APDT) ;Determine if clinic has activity to print for appt date
 I BSDCR,$O(^SC(CLN,"C",APDT,0)) Q 1  ;chart request list
 NEW DATE,FOUND,N
 S FOUND=0,DATE=APDT
 F  S DATE=$O(^SC(CLN,"S",DATE)) Q:'DATE  Q:(DATE\1>APDT)  Q:FOUND  D
 .S N=0 F  S N=$O(^SC(CLN,"S",DATE,1,N)) Q:'N!FOUND  D
 .. I $P(^SC(CLN,"S",DATE,1,N,0),U,9)'["C" S FOUND=1
 Q FOUND
 ;
