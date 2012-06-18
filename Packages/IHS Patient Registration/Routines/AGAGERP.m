AGAGERP ; VNGT/IHS/DLS - Patient Age Specific Report ; April 29, 2010
 ;;7.1;PATIENT REGISTRATION;**8,9**;AUG 25, 2005
 ;
VAR N TAG,EXCL,EXCLS,AGLINE,AGINS
 K ^TMP("AGAGERP",$J)
 ;
 ;Initialize Variables
 ;
 D INTRO
PLOOP ; For looping back to paremeter menu.
 D GETPARAM
 I '$D(EXCL) G EXIT
 I ($G(EXCL("Elig Date Range"))'="")&($G(EXCL("Alternate Resource"))="") D  G PLOOP
 . W !!," ============================================================================"
 . W !,"  An Alternate Resource  of 'MEDICARE', 'MEDICAID', 'PRIVATE INSURANCE',"
 . W !,"  'SPECIFIC INSURER', 'WORKMEN'S COMP', 'PRIVATE & WORKMEN'S COMP', or 'CHIP'"
 . W !,"  must be selected when entering a Point in Time date. Patients with eligibil-"
 . W !,"  ity up to 3 years before the date entered will be included in the selection"
 . W !,"  process."
 . W !," ============================================================================",!
 . K DIR D RTRN^AG
DEV ;
 S %ZIS="QA"
 D ^%ZIS
 I POP N IOP S IOP=ION D ^%ZIS Q
 I $G(IO("Q")) D QUE D HOME^%ZIS Q
 U IO
 D GO
 D ^%ZISC
 D HOME^%ZIS
 Q
GO ; Proceed with processing
 D GETDATA^AGAGERP1
 D PRINT^AGAGERP2
 G EXIT
 Q
 ;
INTRO ; Introduction Screen
 W !!!,"   NOTE: To run this report you must select at least one parameter."
 W !,"         If no parameters are selected, you will return to the reports menu.",!
 D RTRN^AG
 Q
 ;
GETPARAM ; Main Report Driver
 W @IOF
 I $D(EXCL) D EXCLIST
 N TAG,X,Y
 K DIR
 S DIR("A")="     Select ONE or MORE of the above EXCLUSION PARAMETERS"
 S DIR(0)="SO^1:LOCATION;2:ALTERNATE RESOURCE;3:DATE;4:AGE RANGE;5:ELIGIBILITY STATUS"
 S DIR("L",1)="     Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="          1        LOCATION"
 S DIR("L",4)="          2        ALTERNATE RESOURCE"
 S DIR("L",5)="          3        DATE RANGE"
 S DIR("L",6)="          4        AGE RANGE"
 S DIR("L")="          5        ELIGIBILITY STATUS"
 D ^DIR K DIR
 Q:Y=""
 I Y["^" K EXCL Q
 S TAG="ASK"_$E(Y(0),1,3)
 D @TAG
 K TAG
 D GETPARAM
 Q
 ;
EXCLIST ; List Exclusion Paramenters selected so far.
 W !!!
 W "    EXCLUSION PARAMETERS Currently in Effect for RESTRICTING the EXPORT to:"
 W !,"    ======================================================================="
 N EXCLS,AGDOTS,AGDOTLN
 S EXCLS="" F  S EXCLS=$O(EXCL(EXCLS)) Q:EXCLS=""  D
 . W !,"     - ",EXCLS
 . S AGDOTS=22-$L(EXCLS)
 . S AGDOTLN=""
 . S $P(AGDOTLN,".",AGDOTS)=""
 . W AGDOTLN,": ",$P($G(EXCL(EXCLS)),U,2)
 . I EXCLS="Visit Date Range" W " - ",$P($G(EXCL(EXCLS)),U,4)
 . I EXCLS="Elig Date Range" W " - ",$P($G(EXCL(EXCLS)),U,4)
 Q
 ;
ASKLOC ; Prompts to get location
 K DIR
 S DIR(0)="PO^9999999.06,DUZ(2),:AEM"
 S DIR("A")=" Enter a location"
 S:$D(EXCL("Location")) DIR("B")=$P(EXCL("Location"),U,2)
 D ^DIR K DIR
 I X["@" K EXCL("Location") Q
 Q:(X="")!(X["^")
 S EXCL("Location")=+Y_U_$$GET1^DIQ(4,+Y,.01)
 Q
 ;
ASKALT ; Prompts to get Alt Resource
 N X,Y
 K DIR
 S DIR("A")=" Select TYPE of ALTERNATE RESOURCE to Display"
 S:$D(EXCL("Alternate Resource")) DIR("B")=$P(EXCL("Alternate Resource"),"^",2)
 S DIR(0)="SO^1:MEDICARE;2:MEDICAID;3:PRIVATE INSURANCE;4:SPECIFIC INSURER;5:SPECIFIC PATIENT;6:WORKMEN'S COMP;7:PRIVATE + WORKMEN'S COMP;8:CHIP;9:NO RESOURCES"
 S DIR("L",1)="     Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="          1        MEDICARE"
 S DIR("L",4)="          2        MEDICAID"
 S DIR("L",5)="          3        PRIVATE INSURANCE"
 S DIR("L",6)="          4        SPECIFIC INSURER"
 S DIR("L",7)="          5        SPECIFIC PATIENT"
 S DIR("L",8)="          6        WORKMEN'S COMP"
 S DIR("L",9)="          7        PRIVATE + WORKMEN'S COMP"
 S DIR("L")="          8        CHIP"
 D ^DIR K DIR
 I X=4 S EXCL("Alternate Resource")="4^SPECIFIC INSURER" D ASKINS Q
 I X=5 D ASKPNT Q
 I X["@" K EXCL("Alternate Resource") Q
 Q:(X="")!(X["^")
 S EXCL("Alternate Resource")=Y_U_Y(0)
 Q
 ;
ASKDAT ; Prompts to get date type
 N TAG
 K DIR
 S DIR("A")=" Select type of Date Desired"
 S DIR(0)="SO^1:Visit Date;2:Point in Time"
 S DIR("L",1)="          1        Visit Date"
 S DIR("L")="          2        Point in Time"
 D ^DIR K DIR
 Q:(X="")!(X["^")!(X["@")
 S TAG="ASK"_$E(Y(0),1,3)
 I Y=1 S TAG="ASKVIS"
 I Y=2 S TAG="ASKPOI"
 D @TAG
 K TAG
 Q
 ;
ASKVIS ; Prompts to get Visits within date range
 K DIR
 K EXCL("Elig Date Range")
 N Y1,Y2,Y3,Y4
 W !!," ============ Entry of VISIT DATE Range ===========",!
 S DIR("A")=" Enter STARTING VISIT DATE for the Report"
 S:$D(EXCL("Visit Date Range")) DIR("B")=$P(EXCL("Visit Date Range"),"^",2)
 S DIR(0)="DO"
 D ^DIR K DIR
 I X["@" K EXCL("Visit Date Range") Q
 Q:(X="")!(X["^")!(X["@")
 W "// ",Y(0)
 S Y1=Y
 I $G(Y1)]"" S Y=Y1 D DD^%DT S Y2=Y
 S DIR("A")=" Enter ENDING DATE for the Report"
 S:$D(EXCL("Visit Date Range")) DIR("B")=$P(EXCL("Visit Date Range"),"^",4)
 S DIR(0)="DO"
 D ^DIR K DIR
 I X["@" K EXCL("Visit Date Range") Q
 Q:(X="")!(X["^")!(X["@")
 W "// ",Y(0)
 S Y3=Y D DD^%DT S Y4=4
 I Y3<Y1 D  Q
 . W !!," To Date must be after From Date. Please try again."
 . K EXCL("Visit Date Range")
 . D ASKVIS
 I $G(Y3)]"" S Y=Y3 D DD^%DT S Y4=Y
 S EXCL("Visit Date Range")=$G(Y1)_U_$G(Y2)_U_$G(Y3)_U_$G(Y4)
 Q
 ;
ASKPOI ; Prompt for Elig date
 K DIR
 K EXCL("Visit Date Range")
 N Y1,Y2,Y3,Y4
 W !!," =========== Point in Time Date for Alternate Resource Eligibility:============"
 W !,"  An Alternate Resource  of 'MEDICARE', 'MEDICAID', 'PRIVATE INSURANCE',"
 W !,"  'SPECIFIC INSURER', 'WORKMEN'S COMP', 'PRIVATE & WORKMEN'S COMP', or 'CHIP'"
 W !,"  must be selected when entering a Point in Time date. Patients with eligibil-"
 W !,"  ity up to 3 years before the date entered will be included in the selection"
 W !,"  process."
 W !," ===============================================================================",!
 S DIR("A")=" Enter Point in Time DATE for the Report"
 S:$D(EXCL("Elig Date Range")) DIR("B")=$P(EXCL("Elig Date Range"),"^",4)
 S DIR(0)="DO"
 D ^DIR K DIR
 I X["@" K EXCL("Elig Date Range") Q
 Q:(X="")!(X["^")
 W "// ",Y(0)
 S Y1=Y,Y2=Y1-30000
 I $G(Y1)]"" S Y=Y1 D DD^%DT S Y3=Y
 I $G(Y2)]"" S Y=Y2 D DD^%DT S Y4=Y
 S EXCL("Elig Date Range")=$G(Y2)_U_$G(Y4)_U_$G(Y1)_U_$G(Y3)
 Q
 ;
ASKAGE ; Prompts to get Age Range
 K DIR
 S DIR("A")=" Select age range desired"
 S:$D(EXCL("Age Range")) DIR("B")=$P(EXCL("Age Range"),"^",2)
 S DIR(0)="SO^1:0-17;2:18-64;3:65-95"
 S DIR("L",1)="     Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="          1        0-17"
 S DIR("L",4)="          2        18-64"
 S DIR("L")="          3        65-95"
 D ^DIR K DIR
 I X["@" K EXCL("Age Range") Q
 Q:(X="")!(X["^")
 S EXCL("Age Range")=Y_"^"_Y(0)
 Q
 ;
ASKELI ; Prompts to get eligibility status
 K DIR
 S DIR("A")=" Select the PATIENT ELIGIBILITY STATUS"
 S:$D(EXCL("Eligibility Status")) DIR("B")=$P(EXCL("Eligibility Status"),"^",2)
 S DIR(0)="SO^1:INDIAN BENEFICIARY PATIENTS;2:NON-BENEFICIARY PATIENTS"
 S DIR("L",1)="     Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="          1        INDIAN BENEFICIARY PATIENTS"
 S DIR("L")="          2        NON-BENEFICIARY PATIENTS"
 D ^DIR K DIR
 I X["@" K EXCL("Eligibility Status") Q
 Q:(X="")!(X["^")
 S EXCL("Eligibility Status")=Y_U_Y(0)
 Q
 ;
ASKPNT ; Get Patient Information for one patient
 K DIR
 S DIR(0)="PO^9000001,:AEM"
 S DIR("A")=" Enter a Patient Name"
 S:$D(EXCL("Specific Patient")) DIR("B")=$P(EXCL("Specific Patient"),U,2)
 D ^DIR K DIR
 I (X="")!(X["^") K EXCL("Alternate Resource") Q
 I X["@" K EXCL("Specific Patient"),EXCL("Alternate Resource") Q
 N PNAME
 S PNAME=$$GET1^DIQ(2,+Y,.01)
 I PNAME'="" S EXCL("Specific Patient")=+Y_U_PNAME
 Q
 ;
ASKINS ; Get Insurer Information
 K DIR
 S DIR(0)="PO^9999999.18,:AEM"
 S DIR("A")=" Enter an Insurer Name"
 S:$D(EXCL("Specific Insurer")) DIR("B")=$P(EXCL("Specific Insurer"),"^",2)
 D ^DIR
 I (X="")!(X["^") K EXCL("Alternate Resource") Q
 I X["@" K EXCL("Specific Insurer"),EXCL("Alternate Resource") Q
 S EXCL("Specific Insurer")=+Y_U_$$GET1^DIQ(9999999.18,+Y,.01) Q
 Q
 ;
EXIT ; Clean up variables and exit
 K TAG,EXCL,DIR,X,Y
 K ^TMP("AGAGERP",$J)
 Q
 ;
QUE ;QUE TO TASKMAN
 K IO("Q")
 S ZTRTN="GO^AGAGERP",ZTDESC="Patient Age Report "
 S ZTSAVE("*")=""
 K ZTSK D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"Report Cancelled!"
 E  W !!?5,"Task # ",ZTSK," queued.",!
 H 3
 Q
