BIVISIT2 ;IHS/CMI/MWR - DELETE VISITS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO DELETE V FILE VISITS, TRIGGER EVENT FOR DELETE IMM.
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
 N BIGBL,D,DA,DIK
 S BIGBL=$S(BIVTYPE="I":"^AUPNVIMM(",1:"^AUPNVSK(")
 S DA=BIDA,DIK=BIGBL,BIGBL=BIGBL_DA_",0)"
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
 ;---> Delete the V File entry (and decrement the
 ;---> Dependent Entry Count of the parent Visit).
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
