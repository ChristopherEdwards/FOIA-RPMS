BIEXPRT3 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: GATHER IMM HISTORIES FOR PATIENTS
 ;;  STORED IN ^BITMP(.
 ;
 ;
 ;----------
HISTORY(BIFMT,BIDE,BIMM,BIFDT,BISKIN,BIDUZ2,BINF) ;EP
 ;---> Gather Immunization History for each patient stored in
 ;---> ^BITMP($J,1 and store data in ^BITMP($J.
 ;---> Parameters:
 ;     1 - BIFMT  (req) Format: 0=ASCII Split, 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     2 - BIDE   (req) Data Elements array (null if HL7)
 ;     3 - BIMM   (req) Array of Vaccine Types
 ;     4 - BIFDT  (opt) Forecast Date (date used to calc Imms due).
 ;                      For when this call is used to pass Imm Hx
 ;                      to ImmServe for forecasting.
 ;     5 - BISKIN (opt) BISKIN=1 if skin tests should be included
 ;                      (ASCII Format only).
 ;     6 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;     7 - BINF   (opt) Array of Vaccine Grp IEN's that should not be forecast.
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 N BI0,BI012,BIDFN,BIVIMM,BIVSKN
 ;
 ;---> Do not include Skin Test in HL7 or Immserve Formats.
 S:BIFMT>1 BISKIN=0 S:'$G(BISKIN) BISKIN=0
 ;
 ;---> Gather Histories for all patients stored in ^BITMP($J,1,BIDFN.
 S BIDFN=0
 F  S BIDFN=$O(^BITMP($J,1,BIDFN)) Q:'BIDFN  D
 .;
 .;---> Gather Immunization History for one patient (BIDFN).
 .S BIVIMM=0
 .F  S BIVIMM=$O(^AUPNVIMM("AC",BIDFN,BIVIMM)) Q:'BIVIMM  D
 ..;
 ..;---> Gather Immunization data for one visit.
 ..;---> If this is an invalid pointer, clean up and quit.
 ..N BIVDATA  S BIVDATA=$G(^AUPNVIMM(BIVIMM,0))
 ..I BIVDATA="" K ^AUPNVIMM("AC",BIDFN,BIVIMM) Q
 ..I $P(BIVDATA,U,2)'=BIDFN K ^AUPNVIMM("AC",BIDFN,BIVIMM) Q
 ..;
 ..;---> Quit if not selecting all Immunization Types and if this
 ..;---> record is not one of the Immunization Types selected.
 ..I '$D(BIMM("ALL")) Q:'$D(BIMM(+BIVDATA))
 ..;
 ..;---> Don't pass this if format is ImmServe and it is HL7=0, "OTHER".
 ..I BIFMT=3 Q:+BIVDATA=137
 ..;
 ..;---> If format=0 or 1, build ASCII record; format=3 build IMM/SERVE rec.
 ..;I BIFMT=1!(BIFMT=3) D HISTORY1(BIVIMM,.BIDE,BIFMT,"I") Q  ;v8.0
 ..I BIFMT'=2 D HISTORY1(BIVIMM,.BIDE,BIFMT,"I") Q
 ..;
 ..;---> If format=2, build HL7 record.
 ..I BIFMT=2 D HISTORY2(BIVIMM) Q
 .;
 .;
 .;---> NEXT SECTION IS ONLY FOR GATHERING PATIENT SKIN TESTS
 .;---> TO RETURN IN ASCII CSV.
 .;---> Quit if not gathering Skin Test history.
 .Q:'BISKIN
 .;
 .;---> Gather Skin Test History for one patient (BIDFN).
 .;
 .;---> If BIDE local array for Data Elements is not passed, set
 .;---> the following Data Elements to be returned by default.
 .;---> The following are IEN's in ^BIEXPDD(.
 .;---> IEN PC  DATA
 .;---> --- --  ----
 .;--->     1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 .;---> 24  2 = IEN, V File Visit.
 .;---> 26  3 = Location (or Outside Location) of Visit.
 .;---> 29  4 = Date of Visit (DD-Mmm-YYYY @HHMM).
 .;---> 38  5 = Skin Test Result.
 .;---> 39  6 = Skin Test Reading.
 .;---> 40  7 = Skin Test date read.
 .;---> 41  8 = Skin Test Name.
 .;---> 42  9 = Skin Test Name IEN.
 .;
 .D:'$D(BIDE)
 ..N I F I=24,26,29,38,39,40,41 S BIDE(I)=""
 .;
 .S BIVSKN=0
 .F  S BIVSKN=$O(^AUPNVSK("AC",BIDFN,BIVSKN)) Q:'BIVSKN  D
 ..;
 ..;---> Gather Skin Test data for one visit.
 ..;---> If this is an invalid pointer, clean up and quit.
 ..I '$D(^AUPNVSK(BIVSKN,0)) K ^AUPNVSK("AC",BIDFN,BIVSKN) Q
 ..I $P(^AUPNVSK(BIVSKN,0),U,2)'=BIDFN K ^AUPNVSK("AC",BIDFN,BIVSKN) Q
 ..;
 ..;---> If format=1, build ASCII record.
 ..D HISTORY1(BIVSKN,.BIDE,BIFMT,"S") Q
 ;
 ;---> If format=HL7, call HL7 generator to populate ^BITMP($J,2.
 ;I BIFMT=2 S BIHMH=0 D ^BIHIM Q
 ;
 ;---> If format=IMM/SERVE, call ^BIEXPRT5 to populate ^BITMP($J,2
 ;---> with Patient Imm History in ImmServe format.
 I BIFMT=3 D IMMSERV^BIEXPRT5(BIFDT,$G(BIDUZ2),.BINF)
 ;
 Q
 ;
 ;
 ;----------
HISTORY1(BIVIEN,BIDE,BIFMT,BIVTYPE,BIDATA,BIERR,BISTOR) ;EP
 ;---> Build a record from one Imm Visit for ASCII export
 ;---> and set in ^BITMP($J,1/2,.
 ;---> NOTE: Might actually build TWO/more records if splitting out Combos.
 ;---> Parameters:
 ;     1 - BIVIEN  (req) V FILE IEN for unique subscript in ^BITMP(.
 ;     2 - BIDE    (req) Array of DATA ELEMENTS to be exported.
 ;     3 - BIFMT   (req) Format: 0=ASCII Split, 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     4 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     5 - BIDATA  (ret) Value of the built record for this visit.
 ;     6 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;     7 - BISTOR  (opt) Store: zero or null=store in ^BITMP; 1=don't.
 ;
 N BI0,BI012,BIDATE,BIVG,BISUB,BITMP,BIVPTR,N,Q,V
 ;---> Set local variables necessary for collection of Data Elements.
 ;---> Set subscripts and delimiters necessary for selected format.
 S BIERR="",BISUB=1,Q="",V=U
 ;S:BIFMT=1 BISUB=2,Q="""",V="""|"""  ;v8.0
 S:(BIFMT=1!(BIFMT=0)) BISUB=2,Q="""",V="""|"""
 ;
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,.BIERR)
 ;
 ;---> BI0=Zero node of V FILE Visit; BI012=12 node of V FILE Visit.
 S:BIVTYPE="I" BI0=$G(^AUPNVIMM(BIVIEN,0)),BI012=$G(^(12))
 S:BIVTYPE="S" BI0=$G(^AUPNVSK(BIVIEN,0)),BI012=$G(^(12))
 I BI0="" D ERRCD^BIUTL2(412,.BIERR) Q
 ;
 ;---> Quit if Format is Immserve and Vaccine is "OTHER" (HL7=0).
 Q:BIFMT=3&($P(BI0,U)=137)
 ;
 ;---> BIDFN=DFN of the patient.
 S BIDFN=$P(BI0,U,2)
 Q:BIDFN'>0
 ;
 ;---> BIVG=Vaccine Group (for grouping).
 D
 .I BIVTYPE="I" S BIVG=$$IMMVG^BIUTL2($P(BI0,U),4) Q
 .;---> If this is not an Immunization (i.e., is a Skin Test),
 .;---> make it last in grouping order.
 .S BIVG=99
 ;
 ;---> BIVPTR=Visit pointer.
 S BIVPTR=$P(BI0,U,3)
 ;
 ;---> Check for valid pointer to Visit.
 ;---> Fixed for v8.1.
 ;I '$G(BIVPTR)!('$D(^AUPNVSIT(BIVPTR,0))) D ERRCD^BIUTL2(412,.BIERR) Q
 I '$G(BIVPTR) D ERRCD^BIUTL2(412,.BIERR) Q
 I '$D(^AUPNVSIT(BIVPTR,0)) D ERRCD^BIUTL2(412,.BIERR) Q
 ;
 ;---> BIDATE=Date of Immunization (for subscript).
 S BIDATE=$P($P(^AUPNVSIT(BIVPTR,0),U),".")
 ;
 ;---> Build record according to selected Data Elements.
 ;S:BIFMT=1 BITMP=Q_BIVTYPE  ;v8.0
 S:(BIFMT=1!(BIFMT=0)) BITMP=Q_BIVTYPE
 S N=0
 F  S N=$O(BIDE(N)) Q:'N  D
 .N X,Y,Z
 .S Z=^BIEXPDD(N,0),Y=""
 .;
 .;---> If this Data Element pertains to this Visit Type (Imm or Skin),
 .;---> then set Y=value; otherwise leave Y null.
 .I BIVTYPE=$P(Z,U,4)!($P(Z,U,4)="A") D
 ..S X=$TR($P(Z,U,2),"~",U) X X
 .;
 .I '$D(BITMP) S BITMP=Q_Y Q
 .S BITMP=BITMP_V_Y
 S BIDATA=BITMP_Q
 ;
 ;---> Get possible components of this immunization.
 N BICOMPS
 D
 .N Y,X,Z S Z=^BIEXPDD(8,0),X=$TR($P(Z,U,2),"~",U) X X
 .S BICOMPS=Y
 ;
 ;---> This Visit data now ready to be returned in BIDATA.
 ;---> Store record in ^BITMP( for export unless BISTOR>0.
 Q:$G(BISTOR)
 ;
 ;---> BISPLIT is a flag that indicates one or more components have been
 ;---> GLBSET; therefore do not GLBSET the combination (at end of this sub).
 N BISPLIT S BISPLIT=0
 ;---> Only split out combos if format requests it (BIFMT)=0.
 D:BIFMT=0
 .N I,Y
 .;---> For each possible component, set a new node in ^BITMP.
 .F I=1:1:6 S Y=$P(BICOMPS,";",I) D:Y
 ..;
 ..N BIDATA1 S BIDATA1=BIDATA
 ..;
 ..;---> If Vaccine Component Name is requested, swap in Component Name.
 ..D:$D(BIDE(4))
 ...N BICOMBNM,J,K S K=0
 ...F J=2:1 S K=$O(BIDE(K)) Q:'K  Q:K=4
 ...S BICOMBNM=$P(BIDATA1,V,J)
 ...S $P(BIDATA1,V,J)=$$VNAME^BIUTL2(Y)_" ("_BICOMBNM_")"
 ..;
 ..;---> If Vaccine Group IEN is requested, swap in Component Group IEN.
 ..D:$D(BIDE(55))
 ...N J,K S K=0
 ...F J=2:1 S K=$O(BIDE(K)) Q:'K  Q:K=55
 ...S $P(BIDATA1,V,J)=$$IMMVG^BIUTL2(Y,2)
 ..;
 ..;---> If Vaccine Group is requested, swap in Component Group.
 ..D:$D(BIDE(27))
 ...N J,K S K=0
 ...F J=2:1 S K=$O(BIDE(K)) Q:'K  Q:K=27
 ...S $P(BIDATA1,V,J)=$$IMMVG^BIUTL2(Y,1)
 ..;
 ..;---> If Vaccine Component CVX Code is requested, insert in Component CVX.
 ..D:$D(BIDE(69))
 ...N J,K S K=0
 ...F J=2:1 S K=$O(BIDE(K)) Q:'K  Q:K=69
 ...S $P(BIDATA1,V,J)=$$CODE^BIUTL2(Y)
 ..;
 ..;---> Now get Vaccine Component Vaccine Group (for collating below).
 ..N BIVG S BIVG=$$IMMVG^BIUTL2(Y,4)
 ..;---> Add a decimal value to each component's Visit IEN for uniqueness.
 ..N BIVIEN1 S BIVIEN1=BIVIEN_"."_I
 ..D GLBSET(BISUB,BIDFN,BIVG,BIDATE,BIVIEN1,BIDATA1)
 ..S BISPLIT=1
 ;
 ;---> If components have not aleady been set, then set this immunization.
 D:'BISPLIT GLBSET(BISUB,BIDFN,BIVG,BIDATE,BIVIEN,BIDATA)
 Q
 ;
 ;
 ;----------
GLBSET(BISUB,BIDFN,BIVG,BIDATE,BIVIEN,BIDATA) ;EP
 ;---> Set this immunization in the ^BITMP global.
 ;---> This was the point where <MXSTR> errors could occur.
 ;---> Allow for Maximum Global Length to be as small as 255.
 ;---> These nodes get picked up in +63^BIEXPRT4.
 ;---> Parameters:
 ;     1 - BISUB  (req) Subnode for storing ASCII versus Immserve.
 ;     2 - BIDFN  (req) Patient IEN.
 ;     3 - BIVG   (req) Volume Group for this vaccine.
 ;     4 - BIDATE (req) Date of immunization.
 ;     5 - BIVIEN (req) V FILE IEN for unique subscript in ^BITMP(.
 ;     6 - BIDATA (req) Data string for this immunization.
 ;
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN)=$E(BIDATA,1,250)
 Q:$L(BITMP)<251
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,1)=$E(BIDATA,251,500)
 Q:$L(BITMP)<501
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,2)=$E(BIDATA,501,750)
 Q:$L(BITMP)<751
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,3)=$E(BIDATA,751,1000)
 Q:$L(BITMP)<1001
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,4)=$E(BIDATA,1001,1250)
 Q:$L(BITMP)<1251
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,5)=$E(BIDATA,1251,1500)
 Q:$L(BITMP)<1501
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,6)=$E(BIDATA,1501,1750)
 Q:$L(BITMP)<1751
 S ^BITMP($J,BISUB,BIDFN,BIVG,BIDATE,BIVIEN,7)=$E(BIDATA,1751,2000)
 Q
 ;
 ;
 ;----------
HISTORY2(BIVIMM) ;EP
 ;---> Build a record for HL7 export and set in ^BITMP($J,1.
 ;---> Parameters:
 ;     1 - BIVIMM (req) V IMM IEN for unique subscript in ^BITMP(.
 ;
 N BI0,BIDFN,Y
 ;
 ;---> BI0=Zero node of V IMM Visit.
 S BI0=$G(^AUPNVIMM(BIVIMM,0))
 Q:BI0=""
 ;
 ;---> BIDFN=DFN of the patient.
 S BIDFN=$P(BI0,U,2)
 Q:BIDFN'>0
 ;
 S Y=$P($P(^AUPNVSIT($P(BI0,U,3),0),U),".") ;   get visit date
 S ^BITMP($J,1,BIDFN,$P(BI0,U),Y,BIVIMM)=""
 Q
