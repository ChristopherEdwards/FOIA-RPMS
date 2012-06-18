ACRFTR ;IHS/OIRM/DSD/THL,AEF - TRAINING REPORTS;  [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;UTILITY TO SELECT AND PRINT VARIOUS TRAINING SUMMARY REPORTS
EN ;EP;
 F  D EN1 Q:$D(ACRQUIT)!$D(ACROUT)
EXIT ;EP
 K ACR,ACRFOR,ACRDFN,ACRXREF,ACRBEGIN,AC,TREND,ACRTYPE,ACRDC,ACRTOTD,ACRTRNG,ACRY,ACRRTN,ACRNVAL,ACRLOC,ACRPOZ,ACRFOR,ACRLOC,ACRTRNEE,ACRGRD,ACRTITLE,ACRTUIT,ACRBOOKS,ACR1,ACR2,ACR3,ACRDUTHR,ACRNDHR,ACRTOTD,ACRTOTND,ACRTTUIT,ACRTBOOK,ACRT1
 K ACRT2,ACRT3,ACRT4,ACRT5,ACRT6,ACRDOC0,ACRTRNG,ACRTRNG3,ACRTRNG4,ACRCME,ACRDUZ,ACRFROM,ACRTO,ACRDATES,ACRNVAL,ACR4,ACR5,ACR6,ACRTGNO,ACROUT,ACRTYPE,ACRTYPET,ACRXT,ACRAREA,ACRCAN,ACRSG,ACRTT
 Q
EN1 W @IOF
 D EXIT
 W !?10,"TRAINING SUMMARY REPORTS"
 S DIR(0)="SO^1:Individual Employee;2:Department;3:Location Code;4:Purchasing Office;5:Area Office;6:CAN No.;7:Series/Grade;8:Training Type"
 S DIR("A")="Which one"
 D DIR^ACRFDIC
 Q:+Y<1
 S ACRTYPE=Y
 S ACRXREF=$S(Y=1:"F",Y=2:"M",1:"REF")
 I ACRTYPE=1 D IND
 I ACRTYPE=2 D DEPT
 I ACRTYPE=3 D LOCATION
 I ACRTYPE=4 D PO
 I ACRTYPE=5 D AREA
 I $D(ACRQUIT) K ACRQUIT Q
 I ACRTYPE=6 D CAN(.ACRDFN,.ACRFOR,.ACRCAN,.ACRQUIT)
 I $D(ACRQUIT) K ACRQUIT Q
 I ACRTYPE=7 D SG(.ACRDFN,.ACRFOR,.ACRSG,.ACRQUIT)
 I $D(ACRQUIT) K ACRQUIT Q
 I ACRTYPE=8 D TT(.ACRDFN,.ACRFOR,.ACRTT,.ACRQUIT)
 I $D(ACRQUIT) K ACRQUIT Q
 K ACRTYPE
 D DATES
 I $D(ACRQUIT) K ACRQUIT Q
 D TE
 I $D(ACRQUIT) K ACRQUIT Q
 D TYPE
 I $D(ACRQUIT) K ACRQUIT Q
 I ACRTYPE=8 S ACRSMRY=""
 E  D SUMMARY
 I $D(ACRQUIT) K ACRQUIT Q
 D ZIS,EXIT
 Q
ZIS S ACRRTN="START^ACRFTR1"
 S ZTDESC=$S(ACRTYPE=1:"INDIVIDUAL",ACRTYPE=2:"DEPARTMENT",ACRTYPE=3:"LOCATION CODE",1:"PURCHASING OFFICE")_" TRAINING REPORT"
 D ^ACRFZIS
 Q
IND S DIR(0)="PO^200:AEMNQZ"
 S DIR("A")="Employee Name."
 S DIR("?",1)="Enter the name of the employee for whom you want to print a training summary"
 S DIR("?")="in the format 'LAST,FIRST MI'"
 W !
 D DIR^ACRFDIC
 Q:+Y<1
 S ACRDFN=+Y
 S ACRFOR=Y(0,0)
 Q
DEPT ;
 W !!?21,"Department Training summary"
 S DIR(0)="PO^AUTTPRG(:AEMNQZ"
 S DIR("A")="Department...."
 S DIR("?",1)="Enter the name of the DEPARTMENT for which you want to print a training summary"
 S DIR("?")="in the format 'LAST,FIRST MI'"
 W !
 D DIR^ACRFDIC
 Q:+Y<1
 S ACRDFN=+Y
 S ACRFOR=$P(Y(0),U)
 Q
LOCATION ;
 W !!?21,"Location Code Training summary"
 S DIR(0)="PO^AUTTLCOD(:AEMNQZ"
 S DIR("A")="Location Code."
 S DIR("?")="Enter the name of the LOCATION CODE for which to print a training summary"
 W !
 D DIR^ACRFDIC
 Q:+Y<1
 S ACRLOC=+Y
 S ACRDFN=53
 S ACRFOR=$P(Y(0),U)
 Q
DATES ;
 S DIR(0)="DO^::E"
 S DIR("A")="Beginning Date"
 S DIR("?",1)="Enter the earliest date for which you want to include training for the employee."
 S DIR("?")="Do not enter any date if you want to list all the employee's training."
 W !
 D DIR^ACRFDIC
 Q:$D(ACROUT)
 I +Y<1 D  G DATES
 .W !!,"You must enter a Beginning Date.  Enter '^^' to exit."
 K ACRQUIT
 S ACRBEGIN=+Y
 S ACREND=""
 I ACRBEGIN D  Q:$D(ACRQUIT)
 . S DIR(0)="DO^::E"
 .S DIR("A")="Ending Date..."
 .S DIR("?",1)="Enter the latest date for which you want to include training for the employee."
 .S DIR("?")="Do not enter any date if you want to list all the employee's training."
 .D DIR^ACRFDIC
 .I $E(X)[U S ACRQUIT="" Q
 .K ACRQUIT
 .S ACREND=$S(Y="":DT,1:Y)
 Q
PO ;SELECT PURCHASING OFFICE
 D PO^ACRFPSR
 Q:$D(ACRQUIT)
 S ACRDFN=53
 S ACRFOR=+^ACRPO(ACRPOZ,0)
 S ACRFOR=$P($G(^DIC(4,+ACRFOR,0)),U)
 Q
AREA ;SELECT AREA OFFICE
 I '$O(^ACRSYS(1)) S Y=1
 E  D
 .S DIC="^ACRSYS("
 .S DIC(0)="AEMQZ"
 .S DIC("A")="Training Report for which Area: "
 .S DIC("B")=$P($G(^AUTTAREA(+$G(^ACRSYS(1,0)),0)),U)
 .W !
 .D DIC^ACRFDIC
 I +Y<1 S ACRQUIT="" Q
 S ACRAREA=+Y
 S ACRDFN=53
 S ACRFOR=+^ACRSYS(ACRAREA,0)
 S ACRFOR=$P($G(^AUTTAREA(+ACRFOR,0)),U)
 Q
CAN(ACRDFN,ACRFOR,ACRCAN,ACRQUIT)      ;
 ;----- SELECT CAN NUMBER
 ;
 N DIC,DTOUT,DUOUT,X,Y
 S DIC="^ACRCAN("
 S DIC(0)="AEMQ"
 S DIC("A")="Training Report for which CAN No.: "
 D ^DIC
 I +Y'>0!($D(DTOUT))!($D(DUOUT)) S ACRQUIT="" Q
 S ACRCAN=+Y
 S ACRFOR=$P(^AUTTCAN(+Y,0),U)
 S ACRDFN=53
 Q
SG(ACRDFN,ACRFOR,ACRSG,ACRQUIT)        ;
 ;----- SELECT SERIES/GRADE
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="F^1:4"
 S DIR("A")="Select PERSONNEL SERIES"
 D ^DIR
 I Y']""!($D(DIRUT))!($D(DTOUT))!($D(DUOUT)) S ACRQUIT="" Q
 S ACRSG=Y
 ;
 S DIR(0)="N^1:18"
 S DIR("A")="Select PAY GRADE"
 D ^DIR
 I Y'>0!($D(DIRUT))!($D(DTOUT))!($D(DUOUT)) K ACRSG S ACRQUIT="" Q
 S ACRSG=ACRSG_U_Y
 S ACRFOR="SERIES-GRADE "_$P(ACRSG,U)_"-"_$P(ACRSG,U,2)
 S ACRDFN=53
 Q
TT(ACRDFN,ACRFOR,ACRTT,ACRQUIT)        ;
 ;
 N DIC,DTOUT,DUOUT,X,Y
 S DIC="^ACRTT("
 S DIC(0)="AEMQ"
 S DIC("A")="Training Report for which Training Type: "
 D ^DIC
 I +Y'>0!($D(DTOUT))!($D(DUOUT)) S ACRQUIT="" Q
 S ACRTT=+Y
 S ACRFOR="TRAINING TYPE "_$P(^ACRTT(+Y,0),U)_" ("_$P(^ACRTT(+Y,0),U,2)_")"
 S ACRDFN=53
 Q
TE ;
 S DIR(0)="YO"
 S DIR("A")="Include ONLY 350's WITHOUT completed TRAINING EVALUATION"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)
 S:$G(Y)=1 ACRNVAL=""
 Q
CME ;
 S DIR(0)="SO^1:Continuing MEDICAL Education;2:Continuing NURSING Education;3:All Training"
 S DIR("A")="Which report"
 S DIR("B")="All Training"
 W !
 D DIR^ACRFDIC
 K ACRQUIT
 I $D(ACROUT) S ACRQUIT="" Q
 S ACRCME=+Y
 Q
TYPE ;
 S DIR(0)="SO^1:Purpose of Training;2:Type of Training;3:Source of Training;4:Special Interest Code;5:Skill Code;6:Professional Category;7:All Training;8:All of the Above"
 S DIR("A")="Report for Which of the Above"
 S DIR("B")="All Training"
 W !
 D DIR^ACRFDIC
 K ACRQUIT
 I $D(ACROUT) S ACRQUIT="" Q
 S ACRTYPE=+Y
 S ACRTYPE("G")=$$TTYPE(ACRTYPE)
 Q
SUMMARY ;
 S DIR(0)="SO^1:Summary Only;2:Detailed Report Only;3:Both"
 S DIR("A")="Which report"
 S DIR("B")="Both"
 W !
 D DIR^ACRFDIC
 K ACRQUIT
 I $D(ACROUT) S ACRQUIT="" Q
 I Y=1 S ACRSMRY="" K ACRDTAIL
 I Y=2 S ACRDTAIL="" K ACRSMRY
 I Y=3 S (ACRSMRY,ACRDTAIL)=""
 Q
TTYPE(X) ;EP;FIND GLOBAL REFERENCE FOR REPORT TYPE
 I X=1 S X="^ACRTP(" Q X
 I X=2 S X="^ACRTT(" Q X
 I X=3 S X="^ACRTS(" Q X
 I X=4 S X="^ACRTSI(" Q X
 I X=5 S X="^ACRTSC(" Q X
 I X=6 S X="^ACRCME(" Q X
 Q ""
