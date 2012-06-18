ABSPOS ; IHS/FCS/DRS - Table of Contents, etc ;        
 ;;1.0;PHARMACY POINT OF SALE;**11**;JUN 21, 2001
 ;---------------------------------------------------------
 ;IHS/SD/lwj 10/05/04 patch 11
 ; the location of the status field within the prescription
 ; file was moved in Outpatient Pharmacy 7.0.  Altered
 ; the RXDEL subroutine to look for it by Fileman instead
 ; of a direct look up.
 ;---------------------------------------------------------
 ;
 D EN^ABSPOS6A() Q  ; convenient shortcut for programmer mode
VERSION() ;EP
 Q $P($T(+2),";",3)
VARIANT() ;EP
 Q "Base level 1"
TOC N I,X F I=0:1 S X=$P($T(TOC1+I),";",2,9) Q:X="*"  D
 . W X,!
 Q
TOC1 ; Directory of ABSPOS*
 ; ABSPECA* - Build/Parse formatted claim/response packets
 ; ABSPECFM - Formatting (signed numeric overpunch, RJZF, LJBF, etc.)
 ; ABSPECP* - Receipts
 ; ABSPECR* - Development - print NCPDP formats - 9002313.91,9002313.92
 ; ABSPECX* - Low-level 9002313.02 routines, descendant from ABSPOSQ2
 ; ABSPECZ* - ILC A/R claims inquiry routines
 ;            (want to decouple from billing system)
 ; ABSPER*  - Obsolete Reports - to be phased out
 ; ABSPES*  - ILC A/R selection utilities
 ; ABSPMHDR - Menu header
 ; ABSPOS0* - Some fetch utilities for 9002313.02, 9002313.03
 ; ABSPOS1* - none
 ; ABSPOS2# - Insurance auto-selection
 ; ABSPOS2,2x - Manager's Stats & misc. options ScreenMan
 ; ABSPOS3* - The survey routines - probes of RPMS insurance data, etc.
 ; ABSPOS4* - none
 ; ABSPOS5* - none
 ; ABSPOS6* - User's data entry ScreenMan
 ; ABSPOS7* - none
 ; ABSPOS8* - none 
 ; ABSPOS9  - NDC number utilities
 ; ABSPOS9* - none
 ; ABSPOSA* - Modem handling, low-level communications routines
 ; ABSPOSB* - A/R interfaces - post charges to A/R
 ; ABSPOSC# - Certification utilities (sporadic development use only)
 ; ABSPOSCx - Building 9002313.02 claim (ABSPOSQ2->QG->CA->C*)
 ; ABSPOSD* - none
 ; ABSPOSE* - none
 ; ABSPOSF* - new NCPDP forms (in development for future release)
 ; ABSPOSG* - none
 ; ABSPOSH* - none
 ; ABSPOSI* - Data Entry / ScreenMan interface
 ; ABSPOSJ* - none
 ; ABSPOSK* - Winnowing old data
 ; ABSPOSL* - Log file utilities
 ; ABSPOSM* - Report Master file 9002313.61 / Inquire/Report 9002313.57
 ;            (note: ABSPOSMA-ABSPOSMZ are in development for future)
 ; ABSPOSN* - ILC A/R Billing Interface - NCPDP Paper forms print
 ; ABSPOSO* - Data Entry - Override NCPDP Data Dictionary values
 ; ABSPOSP* - ILC A/R Billing Interface - EOB to Payment batches
 ; ABSPOSQ* - Claim processing through the queues
 ; ABSPOSR* - Callable entry points from RPMS Pharm; and
 ;            Background Silent Claim Submitter (monitors ^PSRX indexes)
 ; ABSPOSS* - Setup POS
 ; ABSPOST* - None (some name conflicts in ILC A/R V1 and V2)
 ; ABSPOSU* - Utilities; some from ABSUD0xx series in ILC A/R V1
 ; ABSPOSV* - None
 ; ABSPOSW* - None
 ; ABSPOSX* - Utilties for support usage
 ; ABSPOSY* - None
 ; ABSPOSZ* - Special for upgrades, installations
 ;   Generally, only ABSPOSZ is distributed.
 ;   ABSPOSZ_ are not distributed, and are marked DELETE AT SITE.
 ;*
RXDEL(RXI,RXR) ; EP - $$ is RX deleted?
 ; For refills:  if the refill multiple is gone, it's been "deleted"
 I $G(RXR) Q '$D(^PSRX(RXI,1,RXR,0))
 ; For first fill: look at the STATUS flag
 I '$D(^PSRX(RXI,0)) Q 1 ; shouldn't be missing, but it is
 ;IHS/SD/lwj 10/5/04 patch 11 nxt line rmkd out, following added
 ;N X S X=$P(^PSRX(RXI,0),U,15)    ;IHS/SD/lwj 10/5/04 ptch 11
 N X S X=$$RXSTS(RXI)
 Q X=13 ; if status is DELETED
ZWRITE(%,%A,%B,%C,%D,%E)          ;EP - from many, many places
 I %="%"!(%?1"%"1U) D  Q
 . D IMPOSS^ABSPOSUE("P","TI","Conflict in var names",%,"ZWRITE",$T(+0))
 I '$D(@%) W %," is undefined",! Q
 I $D(@%)#10 W %,"=",@%,!
 F  S %=$Q(@%) Q:%=""  W %,"=",@%,!
 I $D(%A) D ZWRITE(%A)
 I $D(%B) D ZWRITE(%B)
 I $D(%C) D ZWRITE(%C)
 I $D(%D) D ZWRITE(%D)
 I $D(%E) D ZWRITE(%E)
 Q
ZE() ;EP - return value of $ZERROR
 Q $$Z^ZIBNSSV("E")
NOW() ;EP -
 N %,%H,%I,X D NOW^%DTC Q %
NOWEXT() ;EP -
 N %H,%,Y,X S %H=$H D YX^%DTC Q Y
RXSTS(RX)      ; EP - API Return status (patch 11)
 ; 1 is returned if prescription is deleted
 ; 0 if prescription is not deleted
 N IENS,FILE,FLD,FLAG
 S IENS=RX_","
 S FILE=52
 S FLD=100
 S FLAG="I"
 Q $$GET1^DIQ(FILE,IENS,FLD,FLAG)
