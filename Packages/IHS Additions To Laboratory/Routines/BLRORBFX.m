BLRORBFX ;IHS/CIA/PLS - Fix Backdoor Lab orders in Order File;04-Nov-2004 18:51;PLS
 ;;5.2T9;LR;**1018**;Nov 17, 2004
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;
EP ;
 D EN^DDIOL($C(7)_$C(7)_$C(7))         ; Bell/Beep
 D EN^DDIOL("Run from Label ONLY")     ; Failsafe code
 D EN^DDIOL(" ")                       ; Blank line
 Q
 ;
 ; Changes have been made to the original CIAI routine.
 ;  (1) There is now a menu to allow better user input
 ;  (2) There is only a "view" mode and a "repair" mode
 ;  (3) The user CANNOT select a beginning nor ending IEN.
 ;  (4) Counts have been added.
 ;
 ; Original CIAI notes follow:
 ; The following entry point loops thru the Order File
 ; and identifies Lab Orders having Start Date, Stop Date or
 ; Release Date fields set to -1.  This happened due to an
 ; empty VA Patch.
 ;
 ; The pointer to the Lab Order File is used to obtain the correct
 ; FileMan dates. The Order record is then updated.
 ; Input: SIEN - starting IEN (optional)
 ;        EIEN - ending IEN (optional
 ;        VIEW - 0- make changes; 1=view changes that will be made
 ;
 ; ================================ MAIN MENU ================================
PEP ; Private Entry Point for Main Menu
 ; -------------------------------- Variables --------------------------------
 NEW OIEN,LABDAT,ORDAT,EMSG            ; Original CIAI variables line
 NEW BLRFMLA       ; FileMan Line Array
 NEW CNT           ; Orders
 NEW CNTBAD        ; Orders with Date(s) Issue(s)
 NEW CNTFIX        ; Orders with Date(s) Issue(s) - Fixed
 NEW CNTNOFIX      ; Orders with Date(s) Issue(s) - NOT Fixed
 NEW ARRYLN        ; Line Array Line Number
 NEW HEADER        ; Header
 NEW HEADER0       ; Site Name
 NEW HEADER1,HEADER2,HEADER3,HEADER4,HEADER5,HEADER6  ; Heading 1-6
 NEW LINE          ; Menu Line
 NEW MAX           ; Max # of Menu Options
 NEW MMSEL         ; Main Menu SELection
 NEW MMSTR         ; Main Menu STRing
 NEW PRGBEG        ; PRoG BEG time
 NEW PRGEND        ; PRoG END time
 NEW QFLG          ; Quit Flag
 NEW RTN           ; RouTiNe
 NEW STR           ; Temp Variable
 NEW TAB           ; Tab
 NEW TMP           ; Temp Var
 NEW BLRVERN       ; BLR Ver #
 NEW X,Y
 ;
 S PRGBEG=$$NOW^XLFDT()                ; Beg Date/Time
 ;
 D MMDFMS                              ; "Main Menu" Setup
 ;
 F  D  Q:MMSEL'>0                      ; "Infinite loop"
 . S HEADER1="Order Dates Repair"
 . S HEADER2="MAIN MENU"
 . S HEADER3=" "                       ; Blank line
 . K HEADER4,HEADER5,HEADER6           ; "Clear out" potential lines
 . ;
 . D BLRGSHSH                          ; Generic Header
 . ;
 . D EN^DDIOL(.MMSTR)                  ; Display array via FILEMAN call
 . ;
 . D ^XBFMK                            ; Kernel call cleans up FILEMAN vars
 . S DIR("A")="Select"
 . S DIR(0)="NO^1:"_MAX
 . D ^DIR
 . S MMSEL=+Y
 . I MMSEL<1 Q                         ; If nothing selected, Quit
 . ;
 . D ^XBFMK
 . ;
 . S STR=$G(DRTN(MMSEL))               ; Get routine "string"
 . I STR="" Q                          ; If String = Null, just continue
 . ;
 . D @STR                              ; Do procedure
 ;
 D ^XBCLS                              ; Clear screen and home cursor
 ;
 S PRGEND=$$NOW^XLFDT()                ; End Date/Time
 ;
 K BLRFMLA
 S BLRFMLA(1)="Total Time Used:"_$$FMDIFF^XLFDT(PRGEND,PRGBEG,3)
 S BLRFMLA(2)=""
 ;
 D EN^DDIOL(.BLRFMLA)
 ;
 D ^XBFMK
 ;
 Q
 ;
BLROVIEW      ;
 S HEADER2="View Order Dates Issues"
 ;
 D BLRORDRF(,,1)                       ; Call CIAI routine with "view" flag
 Q
 ;
BLROFIX      ;
 S HEADER2="Repair Order Dates Issues"
 ;
 D BLRORDRF(,,0)                       ; Call CIAI routine with "fix" flag 
 Q
 ;
BLRORDRF(SIEN,EIEN,VIEW)     ;
 D BLRORDRI             ; Initialize variables
 ;
 F  S OIEN=$O(^OR(100,OIEN)) Q:'OIEN!(OIEN>EIEN)  D
 .S CNT=CNT+1
 .I $$ISLAB(OIEN) D
 ..I $$NEEDFIX(OIEN) D
 ...S CNTBAD=CNTBAD+1
 ...S LABDAT=$$LABDATES(OIEN)     ; Lab Dates (Draw Time^
 ...S ORDAT=$$ORDATES(OIEN)       ; Order Dates
 ...;
 ...I VIEW D  Q                   ; Just show info
 ....K BLRFMLA                    ; Initialize
 ....;
 ....S $E(BLRFMLA(1),5)=OIEN
 ....S $E(BLRFMLA(2),15)=$P(LABDAT,"^",4)   ; Lab Order Number
 ....;
 ....S $E(BLRFMLA(1),25)="Order"
 ....S $E(BLRFMLA(2),25)="Lab"
 ....D ORDTSETA                   ; Set Lab/Order Dates in array
 ....;
 ....D EN^DDIOL(.BLRFMLA)
 ...;
 ...N FDA
 ...I $P(ORDAT,U)<0 D
 ....S FDA(100,OIEN_",",21)=$P(LABDAT,U)   ; Set Order Start Date
 ....D SSTRRSP(OIEN,$P(LABDAT,U))          ; Set Start Order Dialog item
 ...;
 ...S:$P(ORDAT,U,2)<0 FDA(100,OIEN_",",22)=$P(LABDAT,U,2)  ; Set Order Stop Date
 ...S:$P(ORDAT,U,3)<0 FDA(100,OIEN_",",71)=$P(LABDAT,U,3)  ; Set Results Date
 ...;
 ...D:$D(FDA) FILE^DIE("","FDA","EMSG")     ; Fix it
 ...;
 ...; Reset
 ...S LABDAT=$$LABDATES(OIEN)
 ...S ORDAT=$$ORDATES(OIEN)
 ...;
 ...K BLRFMLA
 ...S BLRFMLA(1)=OIEN
 ...S $E(BLRFMLA(2),10)=$P(LABDAT,"^",4)
 ...S $E(BLRFMLA(1),28)="Order"
 ...S $E(BLRFMLA(2),28)="Lab"
 ...D ORDTSETA
 ...;
 ...I '$D(EMSG) D       ; Order fixed
 ....S $E(BLRFMLA(1),21,23)="YES"
 ....S CNTFIX=CNTFIX+1
 ...;
 ...I $D(EMSG) D        ; Order NOT fixed
 ....S $E(BLRFMLA(1),20,25)="**NO**"
 ....S CNTNOFIX=CNTNOFIX+1
 ...;
 ...D EN^DDIOL(.BLRFMLA)
 ;
 ; Ending message
 K BLRFMLA
 S BLRFMLA(1)=""
 S BLRFMLA(2)="Number of orders analyzed = "_CNT
 S BLRFMLA(3)=""
 ;
 S ARRYLN=3                  ; Initialize Array Line number
 ;
 I $G(CNTBAD)>0 D BLREMSG("Number of orders with -1 Dates = ",CNTBAD)
 ;
 I $G(CNTFIX)>0 D BLREMSG("Number of orders repaired = ",CNTFIX)
 ;
 I $G(CNTNOFIX)>0 D
 . D BLREMSG("Number of orders that COULD NOT be repaired = ",CNTNOFIX)
 ;
 D EN^DDIOL(.BLRFMLA)
 ;
 D BLRGPGR
 ;
 Q
 ;
 ; Initialize variables
BLRORDRI      ;
 S VIEW=$G(VIEW,1)
 S SIEN=$G(SIEN,1)
 S EIEN=$G(EIEN,$O(^OR(100,$C(1)),-1))
 S OIEN=SIEN-.1
 ;
 S (CNT,CNTBAD,CNTFIX,CNTNOFIX)=0      ; Initialize counters
 ;
 K HEADER3,HEADER4,HEADER5,HEADER6
 ;
 S HEADER3=""
 ;
 I VIEW=1 D
 . S $E(HEADER4,5)="Order"
 . S $E(HEADER4,15)="Lab Ord"
 . S $E(HEADER5,5)="Number"
 . S $E(HEADER5,15)="Number"
 ;
 I VIEW=0 D
 . S HEADER4="Order"
 . S $E(HEADER4,10)="Lab Ord"
 . S HEADER5="Number"
 . S $E(HEADER5,10)="Number"
 . S $E(HEADER5,20)="Repair"
 ;
 S $E(HEADER5,35)="Start Date"
 S $E(HEADER5,51)="Stop Date"
 S $E(HEADER5,67)="Results Date"
 ;
 S HEADER6=$TR($J("",80)," ","-")      ; Dashed line
 ;
 D BLRGSHSH                            ; Generic Header
 ;
 Q
 ; Finds the START response and set into FDA Array
SSTRRSP(OIEN,DATE) ;
 N STRIEN
 S OIEN=","_OIEN_","
 S STRIEN=$$FNDRSP(OIEN,"START")
 S OIEN=STRIEN_OIEN
 I STRIEN D
 .S:$$GET1^DIQ(100.045,OIEN,1,"I")=-1 FDA(100.045,OIEN,1)=DATE
 ; Q:$Q STRIEN
 Q
 ;
 ; Return IEN for given Response
FNDRSP(OIEN,RSP) ;
 Q +$$FIND1^DIC(100.045,OIEN,,RSP,"ID")
 ;
 ; Returns boolean based on:
 ;   Order Package = LAB SERVICE
ISLAB(IEN) ;
 Q:'$G(IEN) 0
 Q $$GET1^DIQ(100,IEN,12)="LAB SERVICE"
 ;
 ; Return Lab Order File Info
LRPTR(IEN) ;
 Q $P($$GET1^DIQ(100,IEN,33,"I"),";",2,3)
 ;
 ; Return Lab Dates
 ; Input: ORDER IEN
 ; Output: Collection Date^Stop Date^Result Date
LABDATES(IEN) ;
 N LRPTR,LRSDT,LRRDT,LRORDT,LRSN,ELON
 ; Stop date = Results date
 S LRPTR=$$LRPTR(IEN)
 S LRORDT=$P(LRPTR,";"),LRSN=$P(LRPTR,";",2)
 S LRSDT=$$GET1^DIQ(69.01,LRSN_","_LRORDT_",",10,"I")
 S LRRDT=$$GET1^DIQ(69.01,LRSN_","_LRORDT_",",21,"I")
 ;
 S ELON=""
 I LRORDT'=""&(LRSN'="") S ELON=$P($G(^LRO(69,LRORDT,1,LRSN,.1)),"^",1)
 ;
 Q LRSDT_U_LRRDT_U_LRRDT_U_ELON
 ;
 ; Returns Order Dates
 ; Input: ORDER IEN
 ; Output: Start Date^Stop Date
ORDATES(IEN) ;
 N ORSDT,ORSPDT,ORRDT
 S ORSDT=$$GET1^DIQ(100,IEN,21,"I")
 S ORSPDT=$$GET1^DIQ(100,IEN,22,"I")
 S ORRDT=$$GET1^DIQ(100,IEN,71,"I")
 Q ORSDT_U_ORSPDT_U_ORRDT
 ;
 ; Returns boolean value indicating presence of -1 dates
NEEDFIX(IEN) ;
 N FIX
 S FIX=0
 S FIX=($$GET1^DIQ(100,IEN,21,"I")=-1)  ; Start Date
 S FIX=(FIX!($$GET1^DIQ(100,IEN,22,"I")=-1))  ; Stop Date
 S FIX=(FIX!($$GET1^DIQ(100,IEN,71,"I")=-1))  ; Results Date
 Q FIX
 ;
 ; Lab/Order Dates Set Array for output
ORDTSETA      ;
 S $E(BLRFMLA(1),35)=$P(ORDAT,"^",1)
 S $E(BLRFMLA(1),51)=$P(ORDAT,"^",2)
 S $E(BLRFMLA(1),67)=$P(ORDAT,"^",3)
 ;
 S $E(BLRFMLA(2),35)=$P(LABDAT,"^",1)
 S $E(BLRFMLA(2),51)=$P(LABDAT,"^",2)
 S $E(BLRFMLA(2),67)=$P(LABDAT,"^",3)
 Q
 ;
 ; Set Line Array with "messages" for ending of program
BLREMSG(MSG,CNTR)      ;
 S ARRYLN=ARRYLN+1
 S $E(BLRFMLA(ARRYLN),5)=MSG_CNTR
 S ARRYLN=ARRYLN+1
 S BLRFMLA(ARRYLN)=""
 ;
 Q
 ;
 ; Set up "Main Menu" as an array so as to take advantage of the EN^DDIOL
 ; FILEMAN routine.  There can be no more than 99 menu items
MMDFMS        ;
 ; Set up arrays here -- allows menu to be changed quickly in one area
 K DRTN       ; Initialize "Routines" array
 S LINE=0     ; Initialize Line
 S MAX=0      ; Maximum number of menu items
 K MMSTR      ; Initialize "Main Menu" array
 S TAB=75     ; Initialize Tab
 ;
 ; Use MMSETSUB routine to set the MMSTR and DRTN arrays
 D MMSETSUB("BLROVIEW","View Order Dates Issues")
 D MMSETSUB("BLROFIX","Repair Order Dates Issues")
 ;
 S MMSTR(LINE+1)=$J("",80)   ; Blank line
 ;
 ; Center the Site's Name returned by Kernel Function
 S HEADER0=$$CJ^XLFSTR($$LOC^XBFUNC,80)
 ;
 S BLRVERN="1.00.00"         ; Version number
 Q
 ;
 ;Main Menu Setup Subsets
 ; Parameters are RTN = Mumps routine; MITEM = Menu ITEM
MMSETSUB(RTN,MITEM)      ;
 S MAX=MAX+1                           ; Increment Max # Menu Items
 S DRTN(MAX)=RTN                       ; Set Routine Call
 S TAB=$S(TAB>35:5,TAB<35:45,1:5)      ; Set Tab
 I TAB=5 S LINE=LINE+1                 ; Set Line
 ;
 S $E(MMSTR(LINE),TAB)=$J(MAX,2)_") "_MITEM      ; Set the array
 Q
 ;
 ;Header Information; HEADER1 & HEADER2 must exist
BLRGSHSH      ;
 K HEADER
 S HEADER(1)=HEADER0    ; Site Name
 ;
 K BLRFMLA
 ;
 S BLRFMLA=$$CJ^XLFSTR(HEADER1,80)          ; Center Header string
 S $E(BLRFMLA,1,13)="Date:"_$$NUMDATE($$DT^XLFDT())         ; Today's Date
 S $E(BLRFMLA,65)=$J("Time:"_$$NUMTIME($$NOW^XLFDT()),16)   ; Current Time
 S BLRFMLA=$$TRIM^XLFSTR(BLRFMLA,"R"," ")   ; Trim extra spaces
 ;
 S HEADER(2)=BLRFMLA
 ;
 K BLRFMLA
 ;
 S BLRFMLA=$$CJ^XLFSTR(HEADER2,80)
 S $E(BLRFMLA,70)=$J(BLRVERN,11)  ; Version Number
 S BLRFMLA=$$TRIM^XLFSTR(BLRFMLA,"R"," ")
 S HEADER(3)=BLRFMLA
 ;
 ; Other Header lines as needed
 F J=3:1:8  S STR="HEADER"_J  Q:'$D(@STR)  D
 . S HEADER(J+1)=@STR
 ;
 D ^XBCLS
 D EN^DDIOL(.HEADER)
 ;
 Q
 ;
 ; Generic "Press Any Key" Response
BLRGPGR       ;
 D EN^DDIOL(" ")
 D ^XBFMK
 S DIR(0)="E",(X,Y)=""
 S DIR("A")="Press ANY Key"
 D ^DIR
 I $G(X)="^" S QFLG="Q" Q
 ;
 Q
 ;
 ; Extract Date from FileMan Date into mm/dd/yy string
NUMDATE(FMDATE) ;
 I FMDATE=0 Q " "
 ;
 Q $E(FMDATE,4,5)_"/"_$E(FMDATE,6,7)_"/"_$E(FMDATE,2,3)
 ;
 ; Extract Time from FileMan Date/Time into xx:xx AM/PM string
NUMTIME(X) ;
 NEW Y
 S X=$E($P(X,".",2)_"0000",1,4),Y=X>1159 S:X>1259 X=X-1200 S X=$J(X\100,2)_":"_$E(X#100+100,2,3)_" "_$E("AP",Y+1)_"M"
 Q X
