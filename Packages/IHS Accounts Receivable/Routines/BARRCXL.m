BARRCXL ; IHS/SD/LSL - Cancelled Bills Report - Driver ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/PKD - 05/07/10 - BAR*1.8.19
 ;    Mirror questions asked in 3rd Party Billing CXL report
 ; IHS/SD/LSL - 03/06/03 - Routine created
 ;
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR,BARP
 S BARP("RTN")="BARRCXL"  ; Default to Visit
 S BAR("PRIVACY")=1                   ; Privacy act applies
 D:'$D(BARUSR) INIT^BARUTL            ; Set A/R basic variable
 S BAR("LOC")="VISIT"                 ; Location always VISIT
 ; BEGIN BAR*1.8*19 - chgs to questions asked in Cancellation rpt.  PKD 5/07/10
 ;D ASKQUES                         ; Ask user questions
 D ASKAGAIN^BARRSEL
 Q:$D(DTOUT)!$D(DUOUT)
 ; date range no longer required for ALL bills BAR*1.8*19
 ; I '+BARY("OBAL"),'$D(BARY("DT",1)) Q   
 D PROCEED                            ; Ask proceed
 Q:'+BAROK                            ; User chose not to continue
 D SETHDR
 S BARQ("RC")="COMPUTE^BARRCXL1"    ; Compute routine
 S BARQ("RP")="PRINT^BARRCXL2"      ; Print routine
 S BARQ("NS")="BAR"                   ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"          ; Clean-up routine
 D ^BARDBQUE                          ; Double queuing
 I $G(X)'="^" D PAZ^BARRUTL  ; pause if not ^
 Q
 ; ********************************************************************
 ; 
 ;ASKQUES ;  No longer in use:  BAR/SD/PKD 1.8*19  5/10/10
 ; Ask user questions
 D MSG^BARRSEL                        ; Message about BILL/VIS loc
 D LOC^BARRSL1                        ; Ask loc - return BARY("LOC")
 Q:$D(DTOUT)!($D(DUOUT))              ; Q if time or "^" out
 W:'$D(BARY("LOC")) "ALL"
 D OBAL                               ; Ask open balance only
 Q:($D(DUOUT)!$D(DTOUT))
 I '+BARY("OBAL") D ASKDATE  Q:'$D(BARY("DT",1))
 D RTYPE
 Q
 ; ********************************************************************
 ;
OBAL ;
 ; Ask bills w/open balance only
 W !
 K DIR
 S DIR("A")="Include ONLY bills with an open balance"
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 Q:($D(DUOUT)!$D(DTOUT))
 S BARY("OBAL")=Y                     ; 1=YES ; 0=NO
 I +BARY("OBAL") D
 . W ?51,"ONLY BILLS W/OPEN BALANCE",!
 . S BARY("STCR")=1              ; Needed to loop OBAL x-ref in BARRUTL
 E  W ?51,"ALL BILLS"
 Q
 ; ********************************************************************
 ;
 ;ASKDATE ;No longer in use:  BAR/SD/PKD 1.8*19  5/10/10
 ; Ask type of date and date range
 K DIR
 S DIR(0)="SO^1:Approval Date;2:Visit Date"
 S DIR("A")="Select TYPE of DATE Desired"
 S DIR("B")=1
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)
 S BARTYP=Y
 ;
BEGDATE ; EP
 ; Ask date range
 W !
 K BARY("DT")
 K DIR
 S BARY("DT")=$S(BARTYP=1:"A",1:"V")
 S BARDTYP=$S(BARTYP=1:"APPROVAL",1:"VISIT")_" Date"
 S DIR(0)="DOE"
 S DIR("A")="Enter beginning "_BARDTYP
 D ^DIR
 G ASKDATE:$D(DIRUT)
 S BARY("DT",1)=Y
 W ?45,$$SDT^BARDUTL(BARY("DT",1))
 ;
 W !
 K DIR
 S DIR(0)="DOE"
 S DIR("A")="   Enter ending "_BARDTYP
 D ^DIR
 K DIR
 G BEGDATE:$D(DIRUT)
 S BARY("DT",2)=Y
 W ?45,$$SDT^BARDUTL(BARY("DT",2))
 I BARY("DT",1)>BARY("DT",2) D  G BEGDATE
 . W !!,*7,$$EN^BARVDF("RVN")
 . W "INPUT ERROR:"
 . W $$EN^BARVDF("RVF")
 . W " Start Date is Greater than the End Date, TRY AGAIN!"
 Q
 ; ********************************************************************
 ;
RTYPE ;
 ; Ask Report Type
 K DIR,BARY("RTYP")
 S DIR(0)="SO^1:Detail;2:Summary"
 S DIR("A")="Select TYPE of REPORT desired"
 S DIR("B")=1
 D ^DIR
 K DIR
 Q:$D(DUOUT)!$D(DTOUT)
 S BARY("RTYP")=Y
 S BARY("RTYP","NM")=Y(0)
 Q
 ; ********************************************************************
 ;
PROCEED ;
 ; Tell user what they selected and ask proceed
 K DIR,BARHDR1,BARHDR2
 S BARHDR1="For "_$S('$D(BARY("LOC")):"ALL",1:BARY("LOC","NM"))_" Visit Locations"
 I +BARY("OBAL") D
 . S BARHDR2="containing ONLY bills with an Open Balance."
 E  S BARHDR2=""  I $D(BARY("DT")) D
 . S BARHDR2="containing ALL bills within "  ;_BARDTYP_"s of "
 . S BARHDR2=BARHDR2_$$SDT^BARDUTL(BARY("DT",1))_" to "_$$SDT^BARDUTL(BARY("DT",2))
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 W ?7,"You have selected to produce a "_BARY("RTYP","NM")_" Cancelled Bills Report"
 W !?7,BARHDR1
 W !?7,BARHDR2,!
 S DIR(0)="Y"
 S DIR("A")="Proceed"
 S DIR("B")="YES"
 D ^DIR
 I '+Y S BAROK=0
 E  S BAROK=1
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Set header Array
 S BAR("HD",0)=""
 S BAR("TXT")=BARY("RTYP","NM")_" Cancelled Bills Report"
 S BAR("LVL")=0
 S BAR("CONJ")=""
 D CHK^BARRHD                         ; Line 1 of Report header
 F I=1:1:2 D
 . S BAR("LVL")=BAR("LVL")+1
 . S BAR("HD",BAR("LVL"))=""
 . S BAR("TXT")=@("BARHDR"_I)
 . D CHK^BARRHD                       ; Line 2 and 3 of Report header
 Q
