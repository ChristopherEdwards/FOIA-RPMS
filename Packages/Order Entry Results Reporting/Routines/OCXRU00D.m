OCXRU00D ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC ROUTINES ;MAY 9,2000 at 13:44
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,74**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 D DOT^OCXRULE
 ;
 ;
 K REMOTE,LOCAL,OPCODE,REF
 F LINE=1:1:500 S TEXT=$P($T(DATA+LINE),";",2,999) Q:TEXT  I $L(TEXT) D  Q:QUIT
 .S ^TMP("OCXRULE",$J,$O(^TMP("OCXRULE",$J,"A"),-1)+1)=TEXT
 ;
 G ^OCXRU00E
 ;
 Q
 ;
DATA ;
 ;
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^CONTAINS ELEMENT IN SET
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^COUMADIN,WARFARIN,DISULFIRAM,PHENELZINE,TRANYLCYPROMINE,PARNATE
 ;;R^"860.3:","860.31:3",.01,"E"
 ;;D^3
 ;;R^"860.3:","860.31:3",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:3",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:3",3,"E"
 ;;D^NW,SN
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^INPATIENT
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^LOGICAL TRUE
 ;;EOR^
 ;;KEY^860.3:^NEW SITE FLAGGED ORDER
 ;;R^"860.3:",.01,"E"
 ;;D^NEW SITE FLAGGED ORDER
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^SITE FLAGGED ORDER
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^LOGICAL TRUE
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:2",3,"E"
 ;;D^NW,SN
 ;;EOR^
 ;;KEY^860.3:^OUTPATIENT
 ;;R^"860.3:",.01,"E"
 ;;D^OUTPATIENT
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^INPT/OUTPT
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^"O"
 ;;EOR^
 ;;KEY^860.3:^SITE FLAGGED FINAL CONSULT RESULT
 ;;R^"860.3:",.01,"E"
 ;;D^SITE FLAGGED FINAL CONSULT RESULT
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^FILLER
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^GMRC
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^REQUEST STATUS (OBR)
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:2",3,"E"
 ;;D^F,C
 ;;R^"860.3:","860.31:3",.01,"E"
 ;;D^3
 ;;R^"860.3:","860.31:3",1,"E"
 ;;D^SITE FLAGGED RESULT
 ;;R^"860.3:","860.31:3",2,"E"
 ;;D^LOGICAL TRUE
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:4",3,"E"
 ;;D^RE
 ;;EOR^
 ;;KEY^860.3:^SITE FLAGGED FINAL IMAGING RESULT
 ;;R^"860.3:",.01,"E"
 ;;D^SITE FLAGGED FINAL IMAGING RESULT
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^REQUEST STATUS (OBR)
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^F,C
 ;;R^"860.3:","860.31:2",.01,"E"
 ;;D^2
 ;;R^"860.3:","860.31:2",1,"E"
 ;;D^SITE FLAGGED RESULT
 ;;R^"860.3:","860.31:2",2,"E"
 ;;D^LOGICAL TRUE
 ;;R^"860.3:","860.31:3",.01,"E"
 ;;D^3
 ;;R^"860.3:","860.31:3",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:3",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:3",3,"E"
 ;;D^RE
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^FILLER
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^EQ FREE TEXT
 ;;R^"860.3:","860.31:4",3,"E"
 ;;D^RA
 ;;EOR^
 ;;KEY^860.3:^SITE FLAGGED FINAL LAB RESULT
 ;;R^"860.3:",.01,"E"
 ;;D^SITE FLAGGED FINAL LAB RESULT
 ;;R^"860.3:",.02,"E"
 ;;D^GENERIC HL7 MESSAGE ARRAY
 ;;R^"860.3:","860.31:1",.01,"E"
 ;;D^1
 ;;R^"860.3:","860.31:1",1,"E"
 ;;D^RESULT STATUS (OBX)
 ;;R^"860.3:","860.31:1",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:1",3,"E"
 ;;D^F,C
 ;;R^"860.3:","860.31:3",.01,"E"
 ;;D^3
 ;;R^"860.3:","860.31:3",1,"E"
 ;;D^SITE FLAGGED RESULT
 ;;R^"860.3:","860.31:3",2,"E"
 ;;D^LOGICAL TRUE
 ;;R^"860.3:","860.31:4",.01,"E"
 ;;D^4
 ;;R^"860.3:","860.31:4",1,"E"
 ;;D^CONTROL CODE
 ;;R^"860.3:","860.31:4",2,"E"
 ;;D^EQUALS ELEMENT IN SET
 ;;R^"860.3:","860.31:4",3,"E"
 ;;D^RE
 ;;R^"860.3:","860.31:5",.01,"E"
 ;;D^5
 ;;R^"860.3:","860.31:5",1,"E"
 ;;D^FILLER
 ;;R^"860.3:","860.31:5",2,"E"
 ;;D^STARTS WITH
 ;;R^"860.3:","860.31:5",3,"E"
 ;;D^LR
 ;;EOR^
 ;;EOF^OCXS(860.3)^1
 ;;SOF^860.2  ORDER CHECK RULE
 ;;KEY^860.2:^CLOZAPINE
 ;;R^"860.2:",.01,"E"
 ;;D^CLOZAPINE
 ;;R^"860.2:","860.21:2",.01,"E"
 ;;D^NO WBC W/IN 7 DAYS
 ;;R^"860.2:","860.21:2",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:2",1,"E"
 ;;D^CLOZAPINE NO WBC W/IN 7 DAYS
 ;;R^"860.2:","860.21:3",.01,"E"
 ;;D^WBC < 3.0
 ;;R^"860.2:","860.21:3",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:3",1,"E"
 ;;D^CLOZAPINE WBC < 3.0
 ;;R^"860.2:","860.21:4",.01,"E"
 ;;D^ANC < 1.5
 ;;R^"860.2:","860.21:4",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:4",1,"E"
 ;;D^CLOZAPINE ANC < 1.5
 ;;R^"860.2:","860.21:5",.01,"E"
 ;;D^3.0 <= WBC < 3.5
 ;;R^"860.2:","860.21:5",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:5",1,"E"
 ;;D^CLOZAPINE WBC >= 3.0 & < 3.5
 ;;R^"860.2:","860.21:6",.01,"E"
 ;;D^NO ANC W/IN 7 DAYS
 ;;R^"860.2:","860.21:6",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:6",1,"E"
 ;;D^CLOZAPINE NO ANC W/IN 7 DAYS
 ;;R^"860.2:","860.21:7",.01,"E"
 ;;D^CLOZAPINE
 ;;R^"860.2:","860.21:7",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:7",1,"E"
 ;;D^CLOZAPINE DRUG SELECTED
 ;;R^"860.2:","860.21:8",.01,"E"
 ;;D^ANC >= 1.5
 ;;R^"860.2:","860.21:8",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:8",1,"E"
 ;;D^CLOZAPINE ANC >= 1.5
 ;;R^"860.2:","860.21:9",.01,"E"
 ;;D^WBC >= 3.5
 ;;R^"860.2:","860.21:9",.02,"E"
 ;;D^SIMPLE DEFINITION
 ;;R^"860.2:","860.21:9",1,"E"
 ;;D^CLOZAPINE WBC >= 3.5
 ;;R^"860.2:","860.22:1",.01,"E"
 ;;D^1
 ;;R^"860.2:","860.22:1",1,"E"
 ;;D^CLOZAPINE AND (WBC < 3.0 OR ANC < 1.5)
 ;;R^"860.2:","860.22:1",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:1",6,"E"
 ;;D^WBC < 3.0 and/or ANC < 1.5 - pharmacy cannot fill clozapine order. Most recent results - |CLOZ LAB RSLTS|
 ;;R^"860.2:","860.22:2",.01,"E"
 ;;D^2
 ;;R^"860.2:","860.22:2",1,"E"
 ;;D^CLOZAPINE AND NO WBC W/IN 7 DAYS
 ;;R^"860.2:","860.22:2",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:2",6,"E"
 ;;D^Clozapine orders require a CBC/Diff within past 7 days.  Please order CBC/Diff with WBC and ANC immediately.  Most recent results - |CLOZ LAB RSLTS|
 ;;R^"860.2:","860.22:3",.01,"E"
 ;;D^3
 ;;R^"860.2:","860.22:3",1,"E"
 ;;D^CLOZAPINE AND 3.0 <= WBC < 3.5 AND NO ANC W/IN 7 DAYS
 ;;R^"860.2:","860.22:3",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:3",6,"E"
 ;;D^|CLOZWBC 30_35 TEXT|  Most recent results - |CLOZ LAB RSLTS|
 ;;R^"860.2:","860.22:4",.01,"E"
 ;;D^4
 ;;R^"860.2:","860.22:4",1,"E"
 ;;D^CLOZAPINE AND 3.0 <= WBC < 3.5 AND ANC >= 1.5
 ;;R^"860.2:","860.22:4",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:4",6,"E"
 ;;D^WBC between 3.0 and 3.5 with ANC >= 1.5 - please repeat CBC/Diff including WBC and ANC immediately and twice weekly.  Most recent results - |CLOZ LAB RSLTS|
 ;;R^"860.2:","860.22:5",.01,"E"
 ;;D^5
 ;;R^"860.2:","860.22:5",1,"E"
 ;;D^CLOZAPINE AND WBC >= 3.5
 ;;R^"860.2:","860.22:5",2,"E"
 ;;D^CLOZAPINE APPROPRIATENESS
 ;;R^"860.2:","860.22:5",6,"E"
 ;;D^Clozapine - most recent results - |CLOZ LAB RSLTS|
 ;;EOR^
 ;;KEY^860.2:^FOOD/DRUG INTERACTION
 ;;R^"860.2:",.01,"E"
 ;;D^FOOD/DRUG INTERACTION
 ;;R^"860.2:","860.21:1",.01,"E"
 ;;D^INPATIENT FOOD DRUG REACTION
 ;1;
 ;
