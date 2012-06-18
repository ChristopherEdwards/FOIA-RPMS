APSPESLM ;IHS/BWF - Process entries from APSP REFILL REQUEST file ;23-Jun-2009 15:30;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1008**;Sep 23,2004
MAP ; Map data values
 N ITEM,HLMSG,QTY,PROV,DRUG,I,J,K,QUIT,FIL,FLD,FLDDAT,FDAT,FLDLST,RES
 N PAT,INST,DOS,HFIL,HLFDAT,DONE,DIC,SIGIEN,SIEN,Y,X,APSPMSH,APSPPID,APSPORC
 N APSPRXO,APSPRXE,UPD,SCHED,DUR,CONJ,USCHDUR,FLDS,DLM,SCHITEM,MEDUNITS,REFILLS
 N SCHARY,HLECH,INTERVAL,PROVDAT,DUR,TOTDUR,NEXT,SCHUPD,SN,STR,NOUN,POP
 N DOSARY,DIR,SCNT,DSEL,DEFRTE,DEFSCH,SIGDAT,HLOC
 S DLM="|"
 I '$O(@VALMAR@(0)) D BACK^APSPESLP Q
 S ITEM=$$SELITEM^APSPESLP() I 'ITEM!(ITEM["^") D BACK^APSPESLP Q
 ;L +^APSPRREQ(ITEM)
 S HLOC=$$GET1^DIQ(9009033,$G(PSOSITE),317,"I")
 I 'HLOC D ORDLOC,BACK^APSPESLP Q
 ; if the hospital location is defined, then set it into field 1.6 and continue.
 S DR="1.6///^S X=$G(HLOC)",DIE="^APSPRREQ(",DA=ITEM D ^DIE
 I '$$GET1^DIQ(9009033.91,ITEM,1.6,"I") D ORDLOC,BACK^APSPESLP Q
 S HLECH=$P($G(APSPMSH),"|",2) I '$L(HLECH) S HLECH="^~\&"
 F I=1:1:4 D
 .S HLECH(I)=$E(HLECH,I)
 ; Get HL7 data from the file and set up variables for the data
 S HLMSG=$$GHLDAT^APSPESLP(ITEM) D SHLVARS^APSPESLP
 S PAT=$$PATNAME^APSPESLP(APSPPID) I '$L(PAT) S PAT="**UNKNOWN**"
 S QTY=+$P(APSPRXO,DLM,12),PROVDAT=$P(APSPORC,DLM,13),PROV=$P(PROVDAT,HLECH(1),2)_","_$P(PROVDAT,HLECH(1),3)
 S DRUG=$P($P($G(APSPRXO),DLM,2),U,2),INST=$P($P($G(APSPRXO),DLM,7),U,2)
 S STR=$P($G(APSPRXO),DLM,3),UNITS=$P($P($G(APSPRXO),DLM,5),HLECH(1),2),ROUTE=$P($G(APSPRXR),DLM,2)
 S NOUN=$P($G(APSPRXO),DLM,6) I $L(NOUN) S NOUN=$O(^APSPNCP(9009033.7,"B",NOUN,0)),NOUN=$$GET1^DIQ(9009033.7,NOUN,1,"E")
 S USCHDUR=$P($G(APSPORC),DLM,8),MEDUNITS=$P($P($G(APSPRXO),DLM,20),HLECH(1),2)
 S REFILLS=0
 S PHARM=$$GET1^DIQ(9009033.91,ITEM,1.7,"E")
 S SIGDAT=$P($P(APSPRXO,"|",8),"^",2)
 S HFIL=9009033.91
 S HLFDAT(HFIL,1.1)="",HLFDAT(HFIL,1.2)=PAT,HLFDAT(HFIL,1.3)=PROV,HLFDAT(HFIL,1.4)=QTY
 ; Duration is currently not gathered due to
 S HFIL=9009033.912
 S HLFDAT(HFIL,3)=NOUN
 S HLFDAT(HFIL,.01)=MEDUNITS
 S DONE=0
 F I=1:1 D  Q:DONE
 .S SCHITEM=$P(USCHDUR,HLECH(2),I)
 .I '$L(SCHITEM) S DONE=1 Q
 .S SCHUPD=$P(SCHITEM,HLECH(1)) I 'SCHUPD S SCHUPD=1
 .S INTERVAL=$P(SCHITEM,HLECH(1),2),DUR=$P(SCHITEM,HLECH(1),3),CONJ=$P(SCHITEM,HLECH(1),9)
 .S SCHARY(I)=SCHUPD_U_INTERVAL_U_DUR_U_CONJ
 .S TOTDUR=$G(TOTDUR)+DUR
 .; This may be used in the future, but for now it will not.
 .;S HLFDAT(HFIL,I,.01)="",HLFDAT(HFIL,I,1)="",HLFDAT(HFIL,I,.01)=UNITS
 .; FIELD 3 IS NOUN, AND FIELD 8 IS VERB
 .;S HLFDAT(HFIL,I,3)="",HLFDAT(HFIL,I,4)=DUR,HLFDAT(HFIL,I,5)=CONJ
 .;S HLFDAT(HFIL,I,6)=ROUTE,HLFDAT(HFIL,I,7)=INTERVAL,HLFDAT(HFIL,I,8)=""
 S HLFDAT(9009033.91,1.5)=$G(TOTDUR)
 S HFIL=9009033.912
 S HLFDAT(9009033.913,.01)=$P($P(APSPRXO,DLM,8),HLECH(1),2)
 D FULL^VALM1
 D DISPHL7^APSPESLP(PAT,QTY,PROV,DRUG,INST,STR,UNITS,ROUTE,NOUN,.SCHARY,MEDUNITS,REFILLS,PHARM,SIGDAT,.HLFDAT)
 W !
 D BLDARY^APSPESLP(.FLDLST)
OITEM ; Orderable item
 N DONE
 S (POP,DONE)=0
 S FILOI=$$GET1^DIQ(9009033.91,ITEM,1.1,"E")
 S ORDDEF=$S(FILOI]"":FILOI,1:HLFDAT(9009033.91,1.1))
 S ORDITEM=$$DIR^APSPUTIL("Pr^101.43:AEMQ,","Medication",ORDDEF,,.POP) I POP D BACK^APSPESLP Q
 S DR="1.1///^S X=+ORDITEM",DIE="^APSPRREQ(",DA=ITEM D ^DIE
 ; update the status to reflect that the mapping process has begun.
 S FDA(9009033.91,ITEM_",",.03)=4 D FILE^DIE(,"FDA") K FDA
 S CDOSE=$$DIRYN^APSPUTIL("Complex Dose","NO",,.POP)
 ; if complex dose is indicated as no, check the multiple for more than one entry. if there is more than one, deal with it
 I 'CDOSE D
 .S I=0 F  S I=$O(^APSPRREQ(ITEM,2,I)) Q:'I  D
 ..S SCNT=$G(SCNT)+1
 .I $G(SCNT)>1 D
 ..W !,"There is more than one dose defined."
 ..S DELDOSES=$$DIRYN^APSPUTIL("Delete existing Dosing information","NO",,.POP)
 ..I DELDOSES D  Q
 ...S J=0 F  S J=$O(^APSPRREQ(ITEM,2,J)) Q:'J  D
 ....S FDA(9009033.912,J_","_ITEM_",",.01)="@"
 ...D FILE^DIE(,"FDA")
 ..S CDOSE=1
 ; If complex dose is indicated, loop and allow for multiple dosing instructions.
 I POP D BACK^APSPESLP Q
 I CDOSE D
 .F I=0:0 D  Q:POP!(DONE)
 ..S (J,CNT)=0 F  S J=$O(^APSPRREQ(ITEM,2,J)) Q:'J  D
 ...S CNT=CNT+1,DOSARY(CNT)=$P($G(^APSPRREQ(ITEM,2,J,0)),U)_U_J
 ..S CNT=CNT+1,DOSARY(CNT)="<enter more>"
 ..S L=0 F  S L=$O(DOSARY(L)) Q:'L  D
 ...W !,L_".",?5,$P($G(DOSARY(L)),U)
 ..S MAX=$O(DOSARY(999999),-1)
 ..S DSEL=$$DIR^APSPUTIL("NO^1:"_MAX,"Select entry or <return> to continue",,,.POP) Q:POP
 ..I 'DSEL S DONE=1 Q
 ..S DIEN=$P(DOSARY(DSEL),U,2) K DOSARY
 ..S DFSTAT=$$CDOSE(ITEM,DIEN,.HLFDAT,DSEL) I 'DFSTAT S POP=1 Q
 ; If this is not a complex dose, only prompt for dosing instructions one time.
 I POP D BACK^APSPESLP Q
 E  D
 .I 'DONE S SDOSRES=$$CDOSE(ITEM,,.HLFDAT)
 ; stuff the sig information into the SIG multiple
 I '$D(^APSPRREQ(ITEM,3,"B",$E(SIGDAT,1,30))) D
 .K FDA S FDA(9009033.913,"+1,"_ITEM_",",.01)=$G(SIGDAT) D UPDATE^DIE(,"FDA") K FDA
 ;W !!,"Patient Instructions: "_SIGDAT
 ;S PIISIG=$$DIRYN^APSPUTIL("Include Patient Instructions in SIG","YES",,.POP) I POP D BACK^APSPESLP Q
 ;I PIISIG D
 ;.I $D(^APSPRREQ(ITEM,3,"B",SIGDAT)) Q
 ;.K FDA S FDA(9009033.913,"+1,"_ITEM_",",.01)=$G(SIGDAT) D UPDATE^DIE(,"FDA")
 S FILDAYS=$$GET1^DIQ(9009033.91,ITEM,1.5,"E")
 ; display days supply
 I $L(FILDAYS) W !,"Days Supply "_FILDAYS_" (no editing)"
 E  D
 .S DAYSSUP=$$DIR^APSPUTIL("9009033.91,1.5","Days Supply",+$G(TOTDUR),,.POP) I POP D BACK^APSPESLP Q
 .I $L(DAYSSUP) S DR="1.5///^S X=$G(DAYSSUP)",DIE="^APSPRREQ(",DA=ITEM D ^DIE
 S CHKQTY=$$GET1^DIQ(9009033.91,ITEM,1.4,"E")
 I CHKQTY D
 .W !,"Quantity "_CHKQTY_"// (no editing)"
 E  D
 .S DOSQTY=$$DIR^APSPUTIL("9009033.912,4","Quantity",$G(HLFDAT(9009033.91,1.4)),,.POP) Q:POP
 .I DOSQTY S DR="1.4///^S X=$G(DOSQTY)",DIE="^APSPRREQ(",DA=ITEM D ^DIE
 Q:POP
 ; prompt for patient and provider
 S DR="1.2;1.3",DA=ITEM,DIE="^APSPRREQ(" D ^DIE
 ; first display sig info
 W !!,"Current Sig Data:"
 S I=0 F  S I=$O(^APSPRREQ(ITEM,3,I)) Q:'I  D
 .W !,$G(^APSPRREQ(ITEM,3,I,0))
 W ! S DONE=0
 F  D  I DONE D BACK^APSPESLP Q
 .S DIC="^APSPRREQ("_ITEM_",3,",DIC(0)="AEMQL",DA(1)=ITEM D ^DIC
 .I Y<0,X=""!$G(DUOUT) S DONE=1 Q
 .S SIGIEN=+Y
 .S DIE="^APSPRREQ("_ITEM_",3,",DA(1)=ITEM,DA=SIGIEN,DR=.01 D ^DIE
 D BACK^APSPESLP
 Q
 ;
 ; INPUT - IEN  : IEN for the top level file entry
 ;         DIEN : IEN of the dose instructions subfile (if applicable)
 ;         ARY  : Contains all data from the HL7 message subscripted by HLFDAT(FILE #,FIELD #)
 ;         SEL  ; OPTIONAL - Selection from list of current doses
 ;
CDOSE(IEN,DIEN,ARY,SEL) ;
 N CURDOSE,DOSIEN,QT,NEWIEN,DUOUT,DIC,DEF,DEF,DEFRTE,DEFNODE
 ; set up DOSIEN which will hold the subfile IEN if it exists. This allows for tracking of which entry is being edited,
 ; or if a new entry is being added.
 S (DOSIEN,QT)=0,DEF=""
 I $G(DIEN) S DEF=$P($G(^APSPRREQ(IEN,2,DIEN,0)),U)
 I '$G(DIEN),$O(^APSPRREQ(IEN,2,0)) S DEFNODE=$O(^APSPRREQ(IEN,2,0)),DEF=$P($G(^APSPRREQ(IEN,2,DEFNODE,0)),U)
 S CURDOSE=$$DIR^APSPUTIL("9009033.912,.01","Dose",DEF,,.POP)
 Q:POP!'$L(CURDOSE) 0
 I X["@" D  Q 1
 .D DIRYN^APSPUTIL("Are you sure you wish to delete this entry?","YES",,.POP)
 .S FDA(9009033.912,DIEN_","_IEN_",",.01)="@" D FILE^DIE(,"FDA")
 Q:POP 0
 I '$D(^APSPRREQ(IEN,2,"B",CURDOSE)) D
 .K FDA S FDA(9009033.912,"+1,"_IEN_",",.01)=CURDOSE D UPDATE^DIE(,"FDA","NEWIEN","ERR")
 I $D(NEWIEN) S DIEN=$G(NEWIEN(1))
 ; If the user has entered the @ for delete, check to see if the entry exists, delete, then quit
 I $D(^APSPRREQ(IEN,2,"B",CURDOSE)) S DIEN=$O(^APSPRREQ(IEN,2,"B",CURDOSE,0))
 I $D(^APSPRREQ(9009033.91,2,"B",CURDOSE)) S DOSIEN=$O(^APSPRREQ(9009033.91,2,"B",CURDOSE,0))
 ; prompt for and file ROUTE
 S DEFRTE=$$GET1^DIQ(9009033.912,DIEN_","_IEN_",",6,"E")
 I '$L(DEFRTE) S DEFRTE=$G(ARY(9009033.912,6))
 S DOSRTE=$$DIR^APSPUTIL("9009033.912,6","Route",DEFRTE,,.POP) I POP Q:0
 I +DOSRTE S DR="6///^S X=+DOSRTE",DIE="^APSPRREQ("_ITEM_",2,",DA=DIEN D ^DIE
 ; check to see if there is a default value for schedule (from HL7), if so, file and display, but do not allow editing
 S DEFSCH=$$GET1^DIQ(9009033.912,DIEN_","_IEN_",",7,"E")
 S DOSSCH=$$DIR^APSPUTIL("9009033.912,7","Schedule",DEFSCH,,.POP) I POP Q:0
 I $L(DOSSCH) S DR="7///^S X=$G(DOSSCH)",DIE="^APSPRREQ("_ITEM_",2,",DA=DIEN D ^DIE
 ; If the duration already exists, display it, but do not allow user to edit the value.
 S FILEDUR=$$GET1^DIQ(9009033.912,DIEN_","_IEN,4,"E")
 I FILEDUR]"" D
 .W !,"How long "_FILEDUR_"// (no editing)"
 E  D
 .S DOSDUR=$$DIR^APSPUTIL("9009033.912,4","How Long",$G(HLFDAT(9009033.912,4)),,.POP) I POP Q:0
 .I $L(DOSDUR) S DR="4///^S X=$G(DOSDUR)",DIE="^APSPRREQ("_ITEM_",2,",DA=DIEN D ^DIE
 I POP Q 0
 S DEFCON=$$GET1^DIQ(9009033.912,DIEN_","_IEN_",",5,"E")
 S DOSCON=$$DIR^APSPUTIL("9009033.912,5","And/then/except",DEFCON,,.POP) I POP Q:0
 I $L(DOSCON) S DR="5///^S X=$G(DOSCON)",DIE="^APSPRREQ("_ITEM_",2,",DA=DIEN D ^DIE
 Q 1
ORDLOC ;
 N QQ
 D FULL^VALM1
 W !,"The default ordering location is not defined, inactive, or not properly configured."
 W !,"Please check the location in your APSP CONTROL file and try again."
 S QQ=$$DIR^APSPUTIL("FO","Press <return> to continue.")
 Q
