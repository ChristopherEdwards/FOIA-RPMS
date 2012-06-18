BLRUTIL2 ;IHS/OIT/MKK - MISC IHS LAB UTILITIES (Cont) ;December 16, 2010 1:45 PM
 ;;5.2;IHS LABORATORY;**1020,1022,1024,1027,1028,1030**;NOV 01, 1997
 ;
 ; Cloned from ACTIVE^XUSER -- VA Code
ACTIVE(XUDA) ; EP - Get if a user is active.
 N %,X1,X2
 S X1=$G(^VA(200,+$G(XUDA),0)),X2=$S(X1="":"",1:0)
 I $L($P(X1,U,3)) S X2="1^"_$S($L($P($G(^VA(200,XUDA,.1)),U,2)):"ACTIVE",1:"NEW")
 S:$P(X1,U,7)=1 X2="0^DISUSER"
 S:X2["ACTIVE" $P(X2,U,3)=$P($G(^VA(200,XUDA,1.1)),U) ;Return last sign-on
 S %=$P(X1,U,11) I %>0,%<DT S X2="0^TERMINATED^"_%
 ; Q X2
 ; 
 I $P(X2,"^",1)=1 Q X2                      ; If active, then OK.
 ;
 ; IHS addition; at this point the VA Code believes person INACTIVE
 NEW PROVINFO,WRIORDRS,INACTDT
 S PROVINFO=$G(^VA(200,+$G(XUDA),"PS"))     ; Provider Info
 S WRIORDRS=$P(PROVINFO,"^",1)              ; Write Orders? (1=Yes)
 S INACTDT=+$P(PROVINFO,"^",4)              ; Inactive Date
 ;
 I WRIORDRS'=1 Q X2                         ; If cannot write orders, Quit
 ;
 ;If Inactive date < Today, then Quit with error
 I INACTDT>0&(INACTDT<DT) Q "0^TERMINATED^"_INACTDT
 ;
 ; Can write orders AND INACTDT>=DT => OK
 Q "1^ACTIVE"      ; OK
 ;
BLRHEADR(LINE1,LINE2,LINE3) ; EP -- Generic HEADER array
 NEW TMPLN
 ; W $$CJ^XLFSTR($$LOC^XBFUNC,IOM)                  ; Location
 W $$CJ^XLFSTR($$LOC^XBFUNC,IOM),!                  ; Location -- LR*5.2*1030
 ;
 S TMPLN=$$CJ^XLFSTR(LINE1,IOM)
 S $E(TMPLN,1,13)="Date:"_$$HTE^XLFDT($H,"2DZ")   ; Today's Date
 S $E(TMPLN,IOM-15)=$J("Time:"_$$NOWTIME,16)      ; Current Time
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")             ; Trim extra spaces
 W TMPLN,!
 ;
 I $G(LINE2)="" Q
 ;
 W $$CJ^XLFSTR(LINE2,IOM),!
 ;
 I $G(LINE3)="" Q
 ;
 W $$CJ^XLFSTR(LINE3,IOM),!
 ;
 Q
 ;
NOWTIME()          ; EP - return NOW TIME in xx:xx AM/PM format
 NEW X
 S X=$$HTE^XLFDT($H,"2MPZ")      ; MM/DD/YY HH:MM am/pm format
 S X=$P(X," ",2,3)               ; Get HH:MM am/pm
 S X=$$UP^XLFSTR(X)              ; Uppercase am/pm to AM/PM
 Q X
 ;
NOW24TIM()         ; EP -- return NOW TIME in military format: HHMM
 Q $P($$HTE^XLFDT($H,"2MZ"),"@",2)
 ;
 ; Troubleshooting routine -- look at TaskMan and determine if any
 ; tasks have been rescheduled due to a "BUSY DEVICE" error.  Produce
 ; a report of all occurrences.
CHKTHL7 ; EP
 NEW CNT,CNTTSK,TSK,ONE,ZERO,HEADER,STR,SDATE,STIME
 ;
 S (CNT,CNTTSK,TSK)=0
 S HEADER(1)="HLZTCP Cannot Start Issue"
 S HEADER(2)="'BUSY DEVICE' Tasks"
 S HEADER(3)=" "
 S $E(HEADER(4),1)="Task #"
 S $E(HEADER(4),13)="Date"
 S $E(HEADER(4),21)="Time"
 S $E(HEADER(4),31)="Routine"
 S $E(HEADER(4),41)="Description"
 ;
 F  S TSK=$O(^%ZTSK(TSK))  Q:TSK=""!(TSK'?.N)  D
 . S CNTTSK=CNTTSK+1
 . S ONE=$$UP^XLFSTR($G(^%ZTSK(TSK,.1)))
 . I ONE'["RESCHEDULED FOR BUSY DEVICE"  Q
 . ;
 . S ZERO=$G(^%ZTSK(TSK,0))
 . S SDATE=$$UP^XLFSTR($$HTE^XLFDT($P(ZERO,"^",5),"2PMZ"))
 . S STIME=$P(SDATE," ",2,3)
 . S SDATE=$P(SDATE," ",1)
 . ;
 . I CNT<1 D BLRGSHSH^BLRGMENU
 . W TSK
 . W ?10,SDATE,$J(STIME,9)
 . W ?30,$P(ZERO,"^",2)
 . W ?40,$E($G(^%ZTSK(TSK,.03)),1,40)
 . W !
 . S CNT=CNT+1
 ;
 W:CNT>0 !!,"Number of tasks that were rescheduled = ",CNT,!!
 W:CNT<1 !!,"Number of tasks that were examined = ",CNTTSK,!!
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK MODIFCATION -- LR*5.2*1022
ERRTRAPR ; EP -- Quick & Dirty Error Trap Report
 NEW ETD                 ; Error Trap Date
 NEW ETN                 ; Error Trap Number
 NEW MAXERRPD            ; Maximum Errors Per Day
 NEW NERRSPD             ; Number of Errors Per Day
 NEW CNT                 ; Temporary Count variable
 NEW HEADER              ; Header Information Array
 ;
 S HEADER(1)="ERROR TRAP REPORT"
 S HEADER(2)="Maximum 15 Errors Per Day"
 S HEADER(3)=" "
 S HEADER(4)="----Error Date----"
 S $E(HEADER(4),26)="Err"
 S HEADER(5)=" $H"
 S $E(HEADER(5),11)="External"
 S $E(HEADER(5),26)="Num"
 S $E(HEADER(5),31)="Routine"
 S $E(HEADER(5),51)="Error"
 ;
 D BLRGSHSH^BLRGMENU
 ;
 S MAXERRPD=15
 S ETD="A"
 F  S ETD=$O(^%ZTER(1,ETD),-1)  Q:ETD=""!(ETD'?.N)!(ETD<1)  D
 . W ETD
 . W ?10,$$HTE^XLFDT(ETD,"2DZ")
 . S (CNT,ETN)=0
 . F  S ETN=$O(^%ZTER(1,ETD,1,ETN))  Q:ETN=""!(ETN'?.N)!(ETN>MAXERRPD)  D
 .. S CNT=CNT+1
 .. W ?25,$J(ETN,3)                                    ; Error Trap #
 .. W ?30,$P($G(^%ZTER(1,ETD,1,ETN,"ZE")),"^",2)       ; Routine Name
 .. W ?50,$P($G(^%ZTER(1,ETD,1,ETN,"ZE")),">",1),">"   ; Error
 .. W !
 . I CNT=0 W !
 . W !
 ;
 Q
 ;
 ; LAB REPORTS HEADER routine
 ; If and only if the entries in the BLR MASTER CONTROL File are filled
 ; in, use those as the address of the site.  Otherwise, use default
 ; Lab calls.    IHS/OIT/MKK LR*5.2*1022 addition
LABHDR ; EP -- Display Header for Lab Report(s)
 I $$GET1^DIQ(9009029,+$G(DUZ(2))_",3","INTERIM REPORT LINE 1")'="" D HDRBLREN  Q
 ;
 D NOBLRENT
 Q
 ;
HDRBLREN ; EP -- Header if BLR MASTER FILE address fields ARE NOT blank
 NEW INSTNUM                                     ; Institution Number
 NEW INTRPTH2                                    ; Header Line 2
 NEW STR
 ;
 S INSTNUM=+$G(DUZ(2))                           ; Set the variable
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
 ; BLR MASTER CONTROL FILE field
 ; S STR=$$CJ^XLFSTR($$GET1^DIQ(9009029,INSTNUM_",3","INTERIM REPORT LINE 1"),IOM)
 S STR=$$GET1^DIQ(9009029,INSTNUM_",3","INTERIM REPORT LINE 1")
 ;I $L(STR)>59 D
 ;. W "Printed at:"
 ;. W ?70,"Page "_LRPG
 ;. W !
 ;. S STR=$$CJ^XLFSTR(STR,IOM)
 ;I $L(STR)<60 D
 ;. S STR=$$CJ^XLFSTR(STR,IOM)
 ;. S $E(STR,1,11)="Printed at:"
 ;. S $E(STR,70)="Page "_LRPG
 ;. S STR=$$TRIM^XLFSTR(STR,"R"," ")
 ; ----- END IHS/OIT/MKK - LR*5.2*1027
 S STR=$$CJ^XLFSTR(STR,IOM)       ; IHS/OIT/MKK - LR*5.2*1028
 ; W STR,!
 W !,STR,!                        ; IHS/OIT/MKK - LR*5.2*1030
 ;
 S INTRPTH2=$$GET1^DIQ(9009029,INSTNUM_",3","INTERIM REPORT LINE 2")
 W:$G(INTRPTH2)'="" $$CJ^XLFSTR(INTRPTH2,IOM)
 ;
 W !
 ;
 Q
 ;
NOBLRENT ; EP -- Header if the BLR MASTER FILE address fields ARE blank
 NEW STR,STRA1,STRA2,STRN,INSTHDR,INSTNUM,STRO,STRT
 NEW CITY,STATE,ZIP
 ;
 S INSTNUM=+$G(DUZ(2))                 ; "Institution" Number from DUZ(2)
 ;
 ; If there is no Institution Number from DUZ(2), try the DEFAULT
 ; INSTITUTION entry in the KERNEL SYSTEM PARAMETERS file.
 I INSTNUM<1 S INSTNUM=+$$KSP^XUPARAM("INST")
 ;
 S STRN=$$NAME^XUAF4(INSTNUM)          ; Get Site Name
 ;
 I $TR(STRN," ")="" D  Q               ; If there is no site name, skip
 . W !,$$CJ^XLFSTR("<UNKNOWN INSTITUTION>",IOM),!
 ;
 S STRN=STRN_" ("_INSTNUM_")"          ; Include Number in string
 ;
 ; GET STREET ADDRESS Entries
 D STREETAD
 ;
 ; If there is no address, print Institution name and then quit
 I $TR($TR($G(STRA1),",")," ")="" D  Q
 . W !,$$CJ^XLFSTR(STRN,IOM),!
 ;
 ; At this point, there is some sort of address information -- Print it.
 I ($L(STRA1)+$L(STRN)+8)>IOM D    ; Too wide -- use 2 lines 
 . W !,$$CJ^XLFSTR(STRN,IOM)
 . W !,$$CJ^XLFSTR(STRA1,IOM),!
 ;
 I ($L(STRA1)+$L(STRN)+8)<(IOM+1) D    ; Just use 1 line
 . W !,$$CJ^XLFSTR(STRN_"  "_STRA1,IOM),!
 ;
 Q
 ;
STREETAD ; EP -- Get Street Address
 S STRA1=$$GET1^DIQ(4,INSTNUM,"STREET ADDR. 1")  ; Get the STREET ADDR. 1 entry
 ;
 ; If there is a STREET ADDR. 1 entry, then try to get all of the address
 I $G(STRA1)'="" D
 . S STRA2=$$GET1^DIQ(4,$G(INSTNUM),"STREET ADDR. 2")
 . S CITY=$$GET1^DIQ(4,$G(INSTNUM),"CITY")
 . S STATE=$$GET1^DIQ(4,$G(INSTNUM),"STATE:ABBREVIATION")
 . S ZIP=$$GET1^DIQ(4,$G(INSTNUM),"ZIP")
 ;
 ; If there IS NOT a STREET ADDR. 1 entry, then try to get the address
 ; information from the MAILING address entries.
 I $G(STRA1)="" D
 . S STRA1=$$GET1^DIQ(4,$G(INSTNUM),"STREET ADDR. 1 (MAILING)")
 . S STRA2=$$GET1^DIQ(4,$G(INSTNUM),"STREET ADDR. 2 (MAILING)")
 . S CITY=$$GET1^DIQ(4,$G(INSTNUM),"CITY (MAILING)")
 . S STATE=$$GET1^DIQ(4,$G(INSTNUM),"STATE (MAILING):ABBREVIATION")
 . S ZIP=$$GET1^DIQ(4,$G(INSTNUM),"ZIP (MAILING)")
 ;
 I $G(STRA2)'="" S STRA1=STRA1_" "_STRA2
 ;
 S STRA1=STRA1_"  "_CITY_", "_STATE_" "_ZIP
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK MODIFCATION -- LR*5.2*1024
 ;       Moved here because BLRUTIL was too large
REPORT2(USER) ; EP
 NEW BLRIDS,BLRACCN,CNT
 NEW NOW,ENTRYNUM,LABEL,VARIABLE
 ;
 S CNT=0
 D ^%ZIS Q:POP
 W @IOF
 S (ENTRYNUM,LABEL,NOW,VARIABLE)=""
 F  S NOW=$O(^BLRENTRY(USER,NOW)) Q:NOW=""  D
 . F  S ENTRYNUM=$O(^BLRENTRY(USER,NOW,ENTRYNUM)) Q:ENTRYNUM=""  D
 .. F  S LABEL=$O(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL)) Q:LABEL=""  D
 ... W !,ENTRYNUM,?15,LABEL,?67,NOW
 ... S (BLRIDS,BLRACCN)=""
 ... F  S VARIABLE=$O(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL,VARIABLE)) Q:VARIABLE=""  D
 .... S VALUE=$G(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL,VARIABLE))
 .... I VARIABLE["BLRIDS" S BLRIDS=VALUE
 .... I VARIABLE["BLRACCN" S BLRACCN=VALUE
 ... I BLRIDS'=""!(BLRACCN'="") W !,?20,"BLRIDS:",BLRIDS,"; BLRACCN=",BLRACCN
 ;
 D ^%ZISC
 Q
 ;
REPORT3(VARIABLE) ; EP
 NEW BLRIDS,BLRACCN
 NEW NOW,ENTRYNUM,LABEL,USER
 ;
 NEW HEADER
 ;
 S HEADER(1)="^BLRENTRY TRACE REPORT"
 S HEADER(2)="ALL USERS"
 S HEADER(3)=" "
 S $E(HEADER(4),60)=VARIABLE
 S HEADER(5)="DUZ"
 S $E(HEADER(5),10)="Date/Time"
 S $E(HEADER(5),25)="Num"
 S $E(HEADER(5),30)="Label"
 S $E(HEADER(5),60)="Value"
 ;
 D ^%ZIS Q:POP
 D HEADERDT^BLRGMENU
 S (ENTRYNUM,LABEL,NOW,USER)=""
 F  S USER=$O(^BLRENTRY(USER))  Q:USER=""  D
 . F  S NOW=$O(^BLRENTRY(USER,NOW)) Q:NOW=""  D
 .. F  S ENTRYNUM=$O(^BLRENTRY(USER,NOW,ENTRYNUM)) Q:ENTRYNUM=""  D
 ... F  S LABEL=$O(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL)) Q:LABEL=""  D
 .... S VALUE=$G(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL,VARIABLE))
 .... W USER
 .... W ?9,NOW
 .... W ?24,$J(ENTRYNUM,3)
 .... W ?29,$E(LABEL,1,28)
 .... W ?59,$E(VALUE,1,19)
 .... W !
 ;
 D ^%ZISC
 Q
 ;
 ; ----- END IHS/OIT/MKK MODIFCATION -- LR*5.2*1024
 ;
REPORT4(LABEL) ; EP -- Only print certain "LABELS"
 NEW BLRIDS,BLRACCN
 NEW NOW,ENTRYNUM,LABEL,USER
 ;
 NEW HEADER
 ;
 S HEADER(1)="^BLRENTRY TRACE REPORT"
 S HEADER(2)="ALL USERS"
 S HEADER(3)=$$CJ^XLFSTR(LABEL)
 S HEADER(4)=""
 S HEADER(5)="DUZ"
 S $E(HEADER(5),10)="Date/Time"
 S $E(HEADER(5),25)="Num"
 S $E(HEADER(5),30)="Variable"
 S $E(HEADER(5),40)="Value"
 ;
 D ^%ZIS Q:POP
 D HEADERDT^BLRGMENU
 S (ENTRYNUM,LABEL,NOW,USER)=""
 F  S USER=$O(^BLRENTRY(USER))  Q:USER=""  D
 . F  S NOW=$O(^BLRENTRY(USER,NOW)) Q:NOW=""  D
 .. F  S ENTRYNUM=$O(^BLRENTRY(USER,NOW,ENTRYNUM)) Q:ENTRYNUM=""  D
 ... F  S VARIABLE=$O(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL,VARIABLE)) Q:VARIABLE=""  D
 .... S VALUE=$G(^BLRENTRY(USER,NOW,ENTRYNUM,LABEL,VARIABLE))
 .... W USER
 .... W ?9,NOW
 .... W ?24,$J(ENTRYNUM,3)
 .... W ?29,VARIABLE
 .... W ?39,$E(VALUE,1,40)
 .... W !
 ;
 D ^%ZISC
 Q
 ;
 ; Purge BLRENTRY global of ALL entries up to (but NOT including) today
PURGBLRE ; EP
 NEW DTT,TODAY,WHO
 ;
 S TODAY=$P($$NOW^XLFDT,".")
 ;
 W !!,"Purging BLRENTRY global",!,?5
 ;
 S WHO=0
 F  S WHO=$O(^BLRENTRY(WHO))  Q:WHO<1  D
 . S DTT=0
 . F  S DTT=$O(^BLRENTRY(WHO,DTT))  Q:DTT<1  D
 .. I +$P(DTT,".")'<TODAY W "."
 .. I +$P(DTT,".")<TODAY D
 ... K ^BLRENTRY(WHO,DTT)
 ... W "*"
 .. W:$X>70 !,?5
 ;
 Q
