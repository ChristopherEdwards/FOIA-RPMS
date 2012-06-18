ACDNOTE2 ;IHS/ADC/EDE/KML - CDMIS KEY VAR DICTIONAR;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
ACDRPTS ;Holds reports to run (i.e., 1,2,3-6,7,9,8)
ACDPG ;Program free text name
ACDPROV ;Provider name
ACDPROVA ;Provider array of providers
ACDDFN ;Patient name in external format used for printing and sorting
ACDDFNP ;Patient pointer to file ^DPT
 ;form taken is 1_ACD6DIG_DFN
ACDCOMC ;Component code
ACDCOMT ;Component type
ACDCONT ;Contact type
ACDAGER ;Client age range
ACDTO ;To visit date for reports
ACDFR ;From visit date for reports
ACDDA ;Internal DA passed to utilities for local file sets
ACDPROBP ;Primary problem
ACDPROBS ;Secondary problem
ACDCIT ;Client in treatment
ACDDUA ;Days used alcohol
ACDDUD ;Days used drugs
 ;or '999' for unknown
ACDDH ;Days hospitalized
 ;or '999' for unknown
ACDAAR ;Alcohol and drug related arrests
 ;or '999' for unknown
ACDSUS ;Substance stage
ACDPS ;Physical stage
ACDES ;Emotional stage
ACDSS ;Social stage
ACDCS ;Cultural stage
ACDBS ;Behavioral stage
ACDPLAR ;Recommended placement (component)
ACDPLAR1 ;Recommended placement (type)
ACDPLAA ;Actual placement (component)
ACDPLAA1 ;Actual placement (type)
ACDDIF ;Difference reason
 ;
 ;---------------------------------------------------------
ACDH ;Report header variables
 ;(0)=Report name and location
 ;(1)=line 79 characters long
 ;(2)=Date range reports run for
 ;(3)=Page count
 ;(4)=Who printed report and when
 ;(6)="#CLIENTS" constant
 ;(7)="#VISITS" constant
 ;(8)="AVE V/C" constant
 ;(9)="CONTACT TYPE" constant
 ;(10)="ACTUAL PLACEMENT" constant
 ;(11)="RECOMMENDED PLACEMENT" constant
 ;(12)="AVE DAYS USED DRUGS" constant
 ;(13)="AVE DAYS USED ALCOHOL" constant
 ;(14)="DIFFERENCE REASON" constant
 ;(15)="NUMBER SERVED"
 ;(16)="LOCATION"
 ;(17)="TARGET"
 ;(18)="OUTCOME"
 ;(19)="ACTIVITY"
 ;(20)="COMPONENT/TYPE"
 ;(21)="AGE RANGE"
 ;(22)="AVE NS/V"
 ;(50)="SEARCH CRITERIA IS: "
 ;(51)="PRIMARY PROBLEM"
 ;(52)="OTHER PROBLEM"
 ;(53)="SEX"
 ;(54)="COMPONENT"
 ;(55)="COMPONENT/CODE TYPE"
 ;(56)="AVE CLIENT STAGE"
 ;(57)="AVE ARREST PER CLIENT"
 ;(58)="AVE DAYS PER CLIENT"
 ;(59)="UNIQ CLIENTS"
 ;(60)="TOTAL ARREST"
 ;(61)="TOTAL HOSPITAL DAYS"
 ;
 ;--------------------------------------------------
ACDP1 ;First variable subscript for report generator
ACDP2 ;Second variable subscript for report generator
ACDP3 ;Third variable subscript for report generator
ACDP4 ;Fourth variable subscript for report generator
ACDP5 ;Fifth variable subscript for report generator
 ;-----------------------------------------------------------
 ;
ACDC ;Column header values
 ;(1)=First
 ;(2)=Second
 ;(3)=Third
 ;(4)=Fourth
 ;(5)=Fifth
 ;--------------------------------------------------------------
 ;
ACDTDCR ;Transfer discharge close reason
ACDDAP ;Discharge after plan
ACDGA ;Goal attainment
ACDID ;Inpatient days
ACDDTA ;Array holding drug types client are on. This way I can report which
 ;drugs there are no clients on for the 2 drug type reports
 ;This variable MUST be killed at the top of RTN ACDDIIF,ACDTDC
ACDCODR ;Array holding clients and all drugs they are on. This way I
 ;can determine which clients are on combination drugs
ACDCBO ;Component code concatenates with component type
ACDIFCNT ;Number of clients with a difference reason
ACDSCNT ;Number of clients with no difference reason
 ;
 ;------------------------------------------------------
ACDNW ;Array to hold report predefinition values
 ;(1)=Stop date of report
 ;(2)=Start date of report
 ;(3)=Site location
 ;(4)=List of various reports to run
 ;
 ;--------------------------------------
 ;^ACDVTMP -Visit data transmission global
 ;^ACDPTMP-Program data transmission global
 ;^ACDV1TMP-Global flag to indicate corruption in location file
 ;^ACDP1TMP-Global flag to indicate corruption in location file
 ;^ACDVTMP4-Global audit to prevent duplicate data importing
ACDPCHRS ;Providers to credit hours for prevention portion
 ;of the staff report
ACDOTHRS ;This is the hours for an 'OT' contact type
ACDOTDIS ;Disposition for 'OT' contact type
ACDTRIB ;Client tribe
ACDFOLL ;Follow up months
