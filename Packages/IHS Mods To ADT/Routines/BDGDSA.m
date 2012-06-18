BDGDSA ;IHS/ITSC/WAR - ENTER/EDIT DAY SURGERY  [ 01/07/2005  5:08 PM ]
 ;;5.3;PIMS;**1001,1003,1004,1005,1010,1011,1012**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/22/2005 PATCH 1003 set DFN properly so entries without zero nodes are not used
 ;IHS/OIT/LJF  08/26/2005 PATCH 1004 search for visit already created but ignore time
 ;             11/09/2005 PATCH 1004 added check in case entry was deleted
 ;             05/04/2006 PATCH 1005 if default visit type not set in one file, check another
 ;cmi/anch/maw 11/20/2008 PATCH 1010 added call to day surgery movement event driver
 ;
 ;This was a rewrite of ADGDSA. Basic logic for this rtn...
 ; DFN is used as a switch for processing, looping or quiting.
 ;If DFN is positive... keep processing
 ;If DFN is negitive... do the main loop (F  Q:'DFN  D)
 ;If DFN is zero... quit this routine
 ;
 ;IHS/ITSC/WAR 4/14/04 IHS/ITSC/WAR 5/4/2004 PATCH #1001 mod for DUZ(2)
 ;I '$$GET1^DIQ(9009020.1,1,.15,"I") D
 ;I '$$GET1^DIQ(9009020.1,$O(^DG(40.8,"C",DUZ(2),0)),.15,"I") D  ;cmi/maw 9/1/09 orig line PATCH 1011
 I '$$GET1^DIQ(9009020.1,$O(^DG(40.8,"AD",DUZ(2),0)),.15,"I") D  ;cmi/maw 9/1/09 mod line PATCH 1011
 .W $C(7)
 .W !!,"You must have a valid Clinic entered in the DAY SURGERY"
 .W !,"HOSP LOCATION, found in the ADT parameters set up",!!!
 .D PAUSE^BDGF
 E  D
 .S DFN=-1
 .S (BDGDSVST,DGA,DGX,DGDFN1,ADGDFN)=""
 .F  Q:'DFN  D
 ..D NAME
 ..I DFN>0 D
 ...S DA=DFN
 ...D EN^ADGPI
 ...I +$G(DUOUT)=1 S DFN=DFN*-1  ;User uphatted out
 ...I DFN>0 D DECEASED
 ...S TRUE=$S(DFN<0:1,1:0)       ;Used by 'FOR' Loop in DSDTLOCK
 ...D DSDTLOCK
 ...I DFN>0 D  ;Creates or edits the DS record
 ....S DIDEL=9009012,DR="[ADGDSADD]",DIE="^ADGDS(",DA=DFN
 ....S DIE("NO^")="" D ^DIE L -^ADGDS(DFN) K DIE("NO^")
 ....;ADD CODE... if record deleted DO DELETE (visit etc)
 ....I '$D(^ADGDS(DFN,"DS",DGDFN1,0)) D  Q  ;cmi/maw PATCH 1010 RQMT 14 delete the visit if they delete day surgery
 ..... D DELETE(DFN,DGDSDT)
 ...I DFN>0 D DSWKSHT  ;DaySurg Worksheet
 ...I DFN>0 D PCCVSIT  ;Create PCC visit
 ...I DFN>0 D MOVE^BDGDSEVT  ;cmi/maw 11/20/2008 PATCH 1010 RQMT 14 added day surgery event driver
 ...I DFN>0 D
 ....I $D(^ADGDS(DFN,"DS",DGDFN1,2)),$P(^(2),U)'="" D DSIC
 D KILL^ADGUTIL K ADGDFN,ADGDFN1,BDGDSVST,DGA,DGX,DGDFN1
 Q
 ;
NAME ;*** Get Pt name
 K DIC,DAT,DFN
 W !! S DIC=9009012,DLAYGO=9009012,DIC(0)="AQEML"
 S DIC("A")="Select Day Surgery Patient: "
 ;set DIC("S") to check for unregistered patients
 S DIC("S")="I $D(^AUPNPAT(+Y,41,DUZ(2),0)),$P(^(0),U,2)'="""""
 D ^DIC K DIC("A")
 ;
 ;IHS/ITSC/LJF 6/22/2005 PATCH 1003 set DFN properly
 S DFN=+Y
 ;I +$G(DFN)=0!(+$G(DUOUT)=1) S DFN=0  ;User wants to quit
 I +$G(DFN)<1!(+$G(DUOUT)=1) S DFN=0  ;User wants to quit
 ;
 Q
 ;
DECEASED ;
 I $D(^DPT(DFN,.35)),$P(^(.35),U)]"" D
 . K DIR S DIR(0)="Y"
 . S DIR("A")="This patient has died.  Sure you want to continue"
 . S DIR("B")="NO" D ^DIR
 .I Y=0 S DFN=DFN*-1
 Q
 ;
DSDTLOCK ;Get DS date and check for locks
 F  Q:TRUE  D
 .K DIC S:'$D(^ADGDS(DFN,"DS",0)) ^(0)="^9009012.01D^^"
 .S DIC="^ADGDS("_DFN_",""DS"",",DLAYGO=9009012,DIC(0)="AEQMZL"
 .S DA(1)=DFN,DA=0,DGA=$P(^ADGDS(DFN,"DS",0),U,3)
 .I DGA'=""!($O(^ADGDS(DFN,"DS",0))) D
 ..S DIC("B")=$S('$D(^ADGDS(DFN,"DS",DGA,2)):DGA,$P(^(2),U)="":DGA,1:"")
 .;
 .L +^ADGDS(DFN,"DS"):3 I '$T D
 ..W !,*7,"SOMEONE IS UPDATING THIS DAY SURGERY PATIENT; TRY AGAIN LATER"
 ..S TRUE=1,DFN=(DFN*-1)
 .I DFN>0 D
 ..D ^DIC L -^ADGDS(DFN,"DS") W !! K DIC,DIC("A")
 ..I Y'>0 D
 ...S TRUE=1,DFN=(DFN*-1)
 ..E  D
 ...S DGDFN1=+Y
 ...S DGDSDT=+$G(^ADGDS(DFN,"DS",DGDFN1,0))  ;cmi/maw 5/15/2009 added for day surgery date to delete stuff with
 .;
 .I DFN>0 D
 ..I 'TRUE,$D(^ADGDS(DFN,"DS",DGDFN1,2)),$P(^(2),U)'="" D
 ...W !?5,*7,"Past day surgeries must be edited in the Edit Past Day Surhery option",!
 ..E  D
 ...L +^ADGDS(DFN):3
 ...I '$T D
 ....W !,*7,"SOMEONE IS UPDATING THIS ENTRY; TRY AGAIN LATER"
 ....S DFN=DFN*-1
 ...E  D
 ....S TRUE=1
 Q
DSWKSHT ;Day Surg worksheet
 K DIR S DIR("A")="Print Day Surgery Worksheet",DIR(0)="Y"
 S DIR("?")="Enter YES to print a worksheet for this patient"
 S DIR("B")="NO" D ^DIR
 I Y=1 D
 .S ADGDFN=DFN,ADGDFN1=DGDFN1 D DS1^ADGCRB0 S DFN=ADGDFN,DGDFN1=ADGDFN1
 Q
 ;
DELETE(DF,DSDT) ;-- delete the day surgery and visit PATCH 1010 RQMT 13
 N BDGDSVST,FOUND
 S (BDGDSVST,FOUND)=0
 F  S BDGDSVST=$O(^AUPNVSIT("AA",DF,DSDT,BDGDSVST)) Q:BDGDSVST=""!(FOUND)  D
 .I $P(^AUPNVSIT(BDGDSVST,0),U,7)="S" D  ;Day Surgery vst
 ..I $P(^AUPNVSIT(BDGDSVST,0),U,6)=DUZ(2) S FOUND=BDGDSVST
 Q:'$G(FOUND)
 Q:$P($G(^AUPNVSIT(FOUND,0)),U,9)  ;don't continue if more dependent entry count is greater than 0
 S APCDVDLT=FOUND
 D ^APCDVDLT
 Q
 ;
PCCVSIT ;***> create visit in PCC for day surgery
 S PKG=$O(^DIC(9.4,"C","PIMS",0))                 ;Get IEN for PIMS pkg
 ;
 ;If OP only site OR 'PASS DATA TO PCC' in PCC MastrCntl file not YES
 ;I $P(^DG(40.8,$O(^DG(40.8,"C",DUZ(2),0)),0),"^",3)!('+$P($G(^APCCCTRL(DUZ(2),11,PKG,0)),U,2)) D  ;cmi/maw 9/1/09 orig line PATCH 1011
 I $P(^DG(40.8,$O(^DG(40.8,"AD",DUZ(2),0)),0),"^",3)!('+$P($G(^APCCCTRL(DUZ(2),11,PKG,0)),U,2)) D  ;cmi/maw 9/1/09 mod line PATCH 1011
 .W !!,"Outpatient only site 'OR' PCC link not setup - visit not created"
 .S DFN=0
 E  D
 .;
 .;IHS/OIT/LJF 11/09/2005 PATCH 1004 prevent error in case of deletions
 .;S APCDALVR("APCDDATE")=+^ADGDS(DFN,"DS",DGDFN1,0)  ;visit date
 .S APCDALVR("APCDDATE")=+$G(^ADGDS(DFN,"DS",DGDFN1,0)) Q:'APCDALVR("APCDDATE")  ;visit date
 .;
 .;check if visit already exists
 .S DGX=APCDALVR("APCDDATE"),DGX1=9999999-$P(DGX,".")_"."_$P(DGX,".",2)
 .;
 .D FINDVST(.DGX1)    ;IHS/OIT/LJF 8/26/2005 PATCH 1004 reset date/time to checked in visit
 .;
 .I $D(^AUPNVSIT("AA",DFN,DGX1)) D
 ..N A  S A=0
 ..F  S A=$O(^AUPNVSIT("AA",DFN,DGX1,A)) Q:A=""!(DFN<0)  D
 ...I $P(^AUPNVSIT(A,0),U,7)="S" S DFN=DFN*-1,BDGDSVST=A  ;visit found
 ...W !!,"Day Surgery VISIT was found..."
 .I DFN>0 D
 ..; Visit not found, so create one
 ..S APCDALVR("APCDADD")=1 D APCDEIN^ADGCALLS  ;initialize PCC variables
 ..W !!,"Day Surgery VISIT being created..."
 ..S APCDALVR("APCDPAT")=DFN,APCDALVR("APCDLOC")=APCDDUZ2
 ..;IHS/ITSC/WAR 4/14/04 Add Hosp Loc
 ..S APCDALVR("APCDHL")=$$GET1^DIQ(9009020.1,1,.15,"I")
 ..;IHS/ITSC/WAR 1/28/04 Mod to handle different types of Facilities
 ..;S APCDALVR("APCDTYPE")="I",APCDALVR("APCDCAT")="S"
 ..S APCDALVR("APCDTYPE")=$$GET1^DIQ(9001001.2,APCDALVR("APCDLOC"),.11,"I"),APCDALVR("APCDCAT")="S"
 ..I APCDALVR("APCDTYPE")="" S APCDALVR("APCDTYPE")=$$GET1^DIQ(9001000,DUZ(2),.04,"I")  ;IHS/OIT/LJF 05/04/2006 PATCH 1005
 ..S APCDALVR("APCDCLN")="DAY SURGERY" D DSCV^ADGCALLS K AUPNSEX
 ..;
 ..S APCDALVR("APCDDATE")=+^ADGDS(DFN,"DS",DGDFN1,0)  ;visit date
 ..;get visit entry
 ..S DGX=APCDALVR("APCDDATE"),DGX1=9999999-$P(DGX,".")_"."_$P(DGX,".",2)
 ..K APCDALVR
 ..S (BDGDSVST,FOUND)=0
 ..F  S BDGDSVST=$O(^AUPNVSIT("AA",DFN,DGX1,BDGDSVST)) Q:BDGDSVST=""!(FOUND)  D
 ...I $P(^AUPNVSIT(BDGDSVST,0),U,7)="S" D  ;Day Surgery vst
 ....I $P(^AUPNVSIT(BDGDSVST,0),U,6)=DUZ(2) S FOUND=BDGDSVST
 ..S BDGDSVST=FOUND
 ..I +BDGDSVST=0 W !!,*7,"VISIT ERROR, Please notify your supervisor!" D
 ...S DFN=0
 .E  D
 ..S DFN=DFN*-1  ; reset the DFN to positive
 Q
 ;
DSIC ;***> create incomplete chart entry
 ;IHS/ITSC/WAR 12/10/03 This section copied from BDGICEVT and modified
 ;
 S (BDGICREC,X)=""
 F  S X=$O(^BDGIC("B",DFN,X)) Q:X=""!(BDGICREC)  D
 .;Check IC Disch date/time v.s. DaySurg Release date/time
 .I $P(^BDGIC(X,0),U,2)=$P(^ADGDS(DFN,"DS",DGDFN1,2),U,1) S BDGICREC=X
 I +BDGICREC=0 D
 .S VST=BDGDSVST
 .S SERV=+$P(^ADGDS(DFN,"DS",DGDFN1,0),U,5)
 .S SRDATE=DGX
 .W !!,"Creating entry in Incomplete Chart file....",! K DIC
 .; make FM call to stuff data
 .S X=DFN,DIC="^BDGIC(",DLAYGO=9009016.1,DIC(0)="L"
 .; 4 slash visit to bypass file screen
 .S DIC("DR")=".03////"_VST_";.04///`"_SERV_";.05///"_(SRDATE\1)
 .L +^BDGIC(0):3 I '$T D
 .. Q:$D(DGQUIET)
 .. W !,*7,"CANNOT ADD TO INCOMPLETE CHART FILE;"
 .. W "BEING UPDATED BY SOMEONE ELSE"
 K DD,DO D FILE^DICN L -^BDGIC(0)
 K APCDALVR
 Q
 ;
LASTDS(BDGDT,DFN)    ;EP; IP AdmDate and Pt being passed to this tag
 ;Get Pt's most recent DaySurg visit as it relates to IP Adm date
 ;Release date from DaySurg will be passed back in DSDATE
 ;If no release date entered yet, Admit date passed back in DSDATE
 S DSDATE=0
 I $G(^ADGDS(DFN,0)) D         ;Pt has at least one entry
 .S BDGDT=$O(^ADGDS(DFN,"DS","AA",BDGDT),-1)
 .I BDGDT'="" D
 ..S IEN=$O(^ADGDS(DFN,"DS","AA",BDGDT,0))        ;Get rec#
 ..I IEN S DSDATE=+$G(^ADGDS(DFN,"DS",IEN,2))  ;Get release date
 ..;Assumption - if NO release date entered yet
 ..I 'DSDATE S DSDATE=BDGDT      ;return DaySurg ADMIT date
 Q DSDATE
 ;
DSPROC(BDGDT,DFN)     ;IP AdmDate and Pt being passed to this tag
 ;Get free text PROCedure (if there)
 S DSPROC=0
 I $G(^ADGDS(DFN,0)) D         ;Pt has at least one entry
 .S BDGDT=$O(^ADGDS(DFN,"DS","AA",BDGDT),-1)
 .I BDGDT'="" D
 ..S IEN=$O(^ADGDS(DFN,"DS","AA",BDGDT,0))          ;Get rec#
 ..I +IEN  D
 ...S DSDATE=+$G(^ADGDS(DFN,"DS",IEN,2))         ;Get release date
 ...S DSPROC=$P($G(^ADGDS(DFN,"DS",IEN,0)),U,2)  ;Get procedure
 Q DSPROC
 ;
DSDISP(DT,DFN)     ;IP AdmDate and Pt being passed to this tag 
 ;Get the DISPosition (if there) - none stored as of 3/4/04 WAR
 S DSDISP=0
 ;
 ;
 Q DSDISP
 ;
 ;IHS/OIT/LJF 8/26/2005 PATCH 1004 new subroutine added
FINDVST(DATE) ; reset date/time to that for a day surgery visit if one exists
 ;temporary fix until day surgery rewrite
 NEW DATE1,IEN,FOUND
 S FOUND=0
 S DATE1=DATE\1    ;take off time
 F  S DATE1=$O(^AUPNVSIT("AA",DFN,DATE1)) Q:'DATE1  Q:((DATE1\1)'=(DATE\1))  Q:FOUND  D
 . S IEN=0 F  S IEN=$O(^AUPNVSIT("AA",DFN,DATE1,IEN)) Q:'IEN  Q:FOUND  D
 .. I $P(^AUPNVSIT(IEN,0),U,7)="S" S FOUND=1,DATE=DATE1
 Q
