ACDNOTE3 ;IHS/ADC/EDE/KML - KEY VAR DICTIONARY;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;--------------------------------------
PAK ;Package wide variables
 ;ACDQUIT= Flag saying quit whatever
 ;ACDVER= Present version of software
 ;ACDNM = Name of software
 ;ACDSITE= Site name running software
 ;ACD6DIG= 6 digit code to identify location
 ;ACDUSER= Package user
 ;--------------------------------
ACDPRVA ;PREVENTION ACTION
ACDLOTY ;LOCATION
ACDTRG ;TARGET
ACDNUMR ;NUMBER REACHED
ACDOUTC ;OUTCOME
ACDAY ;DAY OF PREVENTION
ACDPRVC ;PREVENTION ACTIVITY CODE
ACD6DIG ;6digit asufac of the CDMIS SIGN ON USERS SITE
ACDAUF ;6digit not for user but as location of the cdmis record
ACDCLIV ;.01 of record (i.e., printable date)
ACDFAC ;Array holding 6 digit codes if reports run by facility.
ACDAREA ;Array holding 2 digit code if reports run by area.
ACDSU ;Array holding 4 digit code if report run by service unit.
ACDPT ;Array ACDPT(DFN) is used by the client detail reports to specify
 ;showing only certain selected patients. The DFN takes the form
 ;1_ACD6DIG_DFN
ACDP ;(1),(2),(3) array to pass the file number, field number, and set of
 ;codes to routine ^ACDFUNC to convert the internal code to
 ;an external format
ACDPT1 ;Array ACDPT1(DFN) is used by the client service visit duplication
 ;routine ^ACDAUTO1 and holds the names of patients to duplicate
 ;the original client visit for.
ACDPTA ;Array holding 'other problems' belonging to the visit
ACDCOED ;Community Education (Y or N) for preventions
ACDSTA ;Array holding the state codes if reports run by state
ACDTRB ;Array holding the tribe codes if reports run by tribe
ACDCRST ;Array holding the contact types that the user wants to
 ;restrict output to. This is only used when running the reports
 ;from routine ACDWDRV1
ACDSEX ;Client gender
ACDAGE ;Client age
ACDINVR ;Client intervention referral
ACDINVSH ;Client intervention suicide history y/n
ACDINVPP ;Client intervention placement program
ACDINVCT ;Client intervention cost
ACDINVTD ;Client intervention total days treated
ACDINVTC ;Client intervention treatment complete
ACDSTATE ;STATE CODE (3 DIG)
ACDTRIB ;TRIBE CODE (3 DIG)
ACDVET ;Client vet status Y or N or Unknown
