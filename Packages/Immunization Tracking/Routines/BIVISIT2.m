BIVISIT2 ;IHS/CMI/MWR - DELETE VISITS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**5**;JUL 01,2013
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO DELETE V FILE VISITS, TRIGGER EVENT FOR DELETE IMM.
 ;;  PATCH 5: TRIGADD EP moved from rtn BIVISIT for Rsize.  TRIGADD+0
 ;
 ;
 ;----------
DELETE(BIDA,BIVTYPE,BIERR) ;EP
 ;---> Delete a V IMMUNIZATION File entry.
 ;---> Called exclusively by ^BIRPC3.
 ;---> Parameters:
 ;     1 - BIDA    (req) IEN of V File entry to be deleted.
 ;     2 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     3 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;
 ;---> If DA not passed, set Error Code and quit.
 I '$G(BIDA) D ERRCD^BIUTL2(404,.BIERR) Q
 ;
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,.BIERR)
 ;
 ;---> DIK kills D.
 N BIGBL,BIGBLK
 S BIGBLK=$S(BIVTYPE="I":"^AUPNVIMM(",1:"^AUPNVSK(")
 S BIGBL=BIGBLK_BIDA_",0)"
 ;
 ;---> If V File Visit doesn't exist, set Error and quit.
 I '$D(@BIGBL) D ERRCD^BIUTL2(411,.BIERR) Q
 ;
 ;---> Save VISIT pointer for this V File entry.
 N APCDVDLT S APCDVDLT=$P(@BIGBL,U,3)
 ;
 ;---> Store Immunization Visit data for Trigger Event in BIDATA.
 N BIDATA
 D:BIVTYPE="I" SAVEDATA(BIDA,.BIDATA)
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Switch to logical deletion of V Immunizations.
 ;---> Note: Edits are also stored and can be reviewed.
 ;
 D:BIVTYPE="I"
 .N BINODE S BINODE=@BIGBL
 .;---> Create an entry in BI PATIENT CONTRAINDICATION DELETED File.
 .N BIERR,BIIEN,BIFLD
 .S BIFLD(.01)=$P(BINODE,U,1)
 .S BIFLD(.02)=$P(BINODE,U,2)
 .S BIFLD(.03)=$P(BINODE,U,3)
 .S BIFLD(2.01)=+$G(DUZ)
 .D NOW^%DTC S BIFLD(2.02)=%
 .D UPDATE^BIFMAN(9002084.118,.BIIEN,.BIFLD,.BIERR)
 .;---> Quit if new entry failed.
 .I BIERR]"" S BIERR=BI31_BIERR Q
 .;---> Quit if new entry IEN bad.
 .I '$D(^BIVIMMD(+BIIEN(1),0)) D  Q
 ..D ERRCD^BIUTL2(450,.BIERR) S BIERR=BI31_BIERR
 .;---> Now copy the rest of the Imm data.
 .S ^BIVIMMD(+BIIEN(1),0)=^AUPNVIMM(BIDA,0)
 .S:($D(^AUPNVIMM(BIDA,1))) ^BIVIMMD(+BIIEN(1),1)=^AUPNVIMM(BIDA,1)
 .S:($D(^AUPNVIMM(BIDA,12))) ^BIVIMMD(+BIIEN(1),12)=^AUPNVIMM(BIDA,12)
 ;
 Q:(BIERR]"")
 ;**********
 ;
 ;---> Delete the V File entry (and decrement the
 ;---> Dependent Entry Count of the parent Visit).
 N D,DA,DIK S DA=BIDA,DIK=BIGBLK
 D ^DIK
 ;
 ;---> If deletion of the V File Visit failed, set Error and quit.
 I $D(@BIGBL) D ERRCD^BIUTL2(428,.BIERR) Q
 ;
 ;---> If the DEPENDENT ENTRY COUNT for parent Visit is 0, then
 ;---> delete the Visit, too.
 S DLAYGO=9000010
 D:'$P(^AUPNVSIT(APCDVDLT,0),U,9) ^APCDVDLT
 ;
 ;---> Trigger Event, call Protocol: BI DELETE IMMUNIZATION.
 D:BIVTYPE="I" TRIGDEL($G(BIDATA))
 ;
 Q
 ;
 ;
 ;----------
SAVEDATA(BIDA,BIDATA) ;EP
 ;---> Save V Immunization data for Trigger Event, return in BIDATA.
 ;---> Parameters:
 ;     1 - BIDA   (req) IEN of V IMMUNIZATION entry.
 ;     2 - BIDATA (ret) String of data returned.
 ;
 Q:'$G(BIDA)
 ;
 ;---> Specify Data Elements to collect.
 ;
 ;---> IEN PC  DATA
 ;---> --- --  ----
 ;---> 4   2 = Vaccine Name, Short.
 ;---> 6   3 = Dose#.
 ;---> 25  4 = Vaccine Code, HL7.
 ;---> 30  5 = Vaccine IEN.
 ;---> 33  6 = Vaccine Lot Number (text).
 ;---> 34  7 = Location IEN.
 ;---> 35  8 = Category of Visit (A,E, or I)
 ;---> 36  9 = Location Other (text).
 ;---> 44 10 = Vaccine Reaction (text).
 ;---> 56 11 = Date of Immunization (Fileman format).
 ;---> 58 12 = Patient DFN.
 ;---> 59 13 = Visit, PCC Type (I,C,6).
 ;
 N BIDE,I
 F I=4,6,25,30,33,34,35,36,44,56,58,59 S BIDE(I)=""
 D GET^BIRPC1(.BIDATA,BIDA,"I",.BIDE)
 ;
 ;---> If an error is passed back, set BIDATA="".
 N BI31 S BI31=$C(31)_$C(31)
 I $P(BIDATA,BI31,2)]"" S BIDATA="" Q
 S BIDATA=$P(BIDATA,BI31)
 Q
 ;
 ;
 ;----------
TRIGDEL(BIDATA) ;EP
 ;---> Immunization Deleted Trigger Event call to Protocol File.
 ;---> V Immunization data of just deleted visit is saved in BIDATA.
 ;---> (Note: Trigger Event for ADD Immunization is in rtn BIVISIT.)
 ;---> Parameters:
 ;     1 - BIDATA (req) String of V Imm data.
 ;
 Q:$G(BIDATA)=""
 ;
 ;---> Local variables available when Delete Event is triggered:
 ;
 ;     BICAT  -  Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;     BIDATE -  Date of Visit (Fileman format).
 ;     BIDFN  -  DFN of patient.
 ;     BIDOSE -  Dose# number for this Immunization.
 ;     BILOC  -  Location of encounter (IEN).
 ;     BILOT  -  Lot number for this Immunization (text).
 ;     BIOLOC -  Other Location of encounter (text).
 ;     BIPTR  -  Vaccine (IEN in IMMUNIZATION File).
 ;     BIREC  -  Vaccine Reaction (text).
 ;     BITYPE -  Type of Visit (PCC Master Control File I,C,6).
 ;     BIVHL7 -  Vaccine HL7 Code.
 ;     BIVISD -  Release/Revision Date of VIS (YYYMMDD).
 ;     BIVNAM -  Vaccine Name, short form.
 ;
 ;---> Parse out Immunization Visit data in local variables.
 N V S V="|"
 ;
 S BICAT=$P(BIDATA,V,8)
 S BIDATE=$P(BIDATA,V,11)
 S BIDFN=$P(BIDATA,V,12)
 S BIDOSE=$P(BIDATA,V,3)
 S BILOC=$P(BIDATA,V,7)
 S BILOT=$P(BIDATA,V,6)
 S BIOLOC=$P(BIDATA,V,9)
 S BIPTR=$P(BIDATA,V,5)
 S BIREC=$P(BIDATA,V,10)
 S BITYPE=$P(BIDATA,V,13)
 S BIVHL7=$P(BIDATA,V,4)
 S BIVNAM=$P(BIDATA,V,2)
 ;
 ;---> Local variables available when Event is triggered:
 ;---> Exclusive New of all variables except those to be available.
 N BISAVE
 S BISAVE="BICAT;BIDATE;BIDFN;BIDOSE;BILOC;BILOT;BIOLOC;BIPTR"
 S BISAVE=BISAVE_";BIREC;BITYPE;BIVHL7;BIVNAM;DIC;X;XQORS"
 ;
 D
 .S DIC=101,X="BI IMMUNIZATION DELETED"
 .D EN^XBNEW("EN^XQOR",BISAVE)
 ;
 Q
 ;
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> TRIGADD EP moved from rtn BIVISIT for Rsize.
 ;----------
TRIGADD ;EP
 ;---> Exclusively called from VFILE+216^BIVISIT.
 ;---> Immunization Added Trigger Event call to Protocol File.
 ;---> Called at the end/bottom of BIVISIT, after new V IMM created.
 ;---> (Note: Trigger Event for DELETE Immunization is in rtn BIVISIT2.)
 ;---> Local variables available when Event is triggered:
 ;
 ;     BIADFN -  IEN of V IMMUNIZATION just created.
 ;     BICAT  -  Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;     BIDATE -  Date of Visit (Fileman format).
 ;     BIDFN  -  DFN of patient.
 ;     BILOC  -  Location of encounter (IEN).
 ;     BILOT  -  Lot Number IEN for this Immunization (text).
 ;     BIOLOC -  Other Location of encounter (text).
 ;     BIPTR  -  Vaccine (IEN in IMMUNIZATION File).
 ;     BIREC  -  Vaccine Reaction (text).
 ;     BITYPE -  Type of Visit (PCC Master Control File I,C,6).
 ;     BIVHL7 -  Vaccine HL7 Code.
 ;     BIVNAM -  Vaccine Name, short form.
 ;     BIVSIT -  IEN of Visit.
 ;
 ;
 N BIVNAM,BIVHL7,BISAVE
 S BIVNAM=$$VNAME^BIUTL2(BIPTR)
 S BIVHL7=$$CODE^BIUTL2(BIPTR,1)
 S BIREC=$$REACTXT^BIUTL6(BIREC)
 S BILOT=$$LOTTX^BIUTL6(BILOT)
 ;
 S BISAVE="BIADFN;BICAT;BIDATE;BIDFN;BILOC;BILOT;BIOLOC;BIPTR"
 S BISAVE=BISAVE_";BIREC;BITYPE;BIVHL7;BIVNAM;BIVSIT;DIC;X;XQORS"
 D
 .S DIC=101,X="BI IMMUNIZATION ADDED"
 .D EN^XBNEW("EN^XQOR",BISAVE)
 ;
 Q
 ;**********
