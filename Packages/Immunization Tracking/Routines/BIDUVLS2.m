BIDUVLS2 ;IHS/CMI/MWR - VIEW DUE LIST VIEW.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  LIST TEMPLATE CODE FOR VIEWING PATIENTS DUE, SET LINES FOR
 ;;  INDIVIDUAL PATIENTS.
 ;
 ;
 ;----------
PATIENT(BILINE,BIDFN,BINFO,BIDASH,BIMMRF,BIMMLF) ;EP
 ;---> Set line in Listman display global.
 ;---> Parameters:
 ;     1 - BILINE (req) Line Number in display area.
 ;     2 - BIDFN  (req) Patient DFN.
 ;     3 - BINFO  (req) Array of Additional Info elements.
 ;     4 - BIDASH (opt) 1=Omit Dash line between records; 0=include it.
 ;     5 - BIMMRF (opt) Imms Received Filter array (subscript=CVX's included).
 ;     6 - BIMMLF (opt) Lot Number Filter array (subscript=lot number text).
 ;
 Q:$G(BILINE)=""
 N BIPLIN,BIPLIN1,X
 ;
 ;---> Patient demographic line.
 S X="  "_$E($$NAME^BIUTL1(BIDFN),1,19)
 S X=$$PAD^BIUTL5(X,22)_$$PAD^BIUTL5($$HRCN^BIUTL1(BIDFN,DUZ(2)),8)
 ;S X=X_"  "_$$DOBF^BIUTL1(BIDFN,,,1)_"  "_$$SEX^BIUTL1(BIDFN)  vvv83
 S X=X_"  "_$$DOBF^BIUTL1(BIDFN,$G(BIFDT),,1)
 S X=$$PAD^BIUTL5(X,54)_$$SEX^BIUTL1(BIDFN)
 S X=$$PAD^BIUTL5(X,58)_$E($$CURCOM^BIUTL11(BIDFN,1),1,21)
 D:'$G(BIDASH) WRITE(.BILINE)
 D WRITE(.BILINE,X) K X
 ;---> Preserve line number of Patient demographic line, for record
 ;---> line count and for address and phone lines below.
 S BIPLIN=BILINE-1,BIPLIN1=BILINE+1
 ;
 ;---> Next section: Write specifed Additional Information in BINFO.
 ;
 ;--> Check if BINFO("ALL") exists.  If so, set BIALL=1 and display all Info.
 N BIALL S BIALL=0
 S:$D(BINFO("ALL")) BIALL=1
 ;
 ;---> First, build Data String, BINFODS, of Add Info elements (2nd piece of
 ;---> BI TABLE ADD INFO File #9002084.82).
 N BINFODS
 D
 .N N S N=0
 .F  S N=$O(BINFO(N)) Q:'N  D
 ..S BINFODS=$G(BINFODS)_$P($G(^BIADDIN(N,0)),U,2)_"^"
 .S:'$G(BINFODS) BINFODS=0
 ;
 ;---> Forecast.
 D:((BINFODS[15)!BIALL) WRITE(.BILINE),FORECAST(.BILINE,BIDFN,$G(BIFDT))
 ;
 ;---> Address.
 D:((BINFODS[12)!BIALL)
 .N X S X="Address..: "_$E($$STREET^BIUTL1(BIDFN),1,38)
 .S BIPLIN1=BIPLIN1+1
 .D APPEND(BIPLIN1,X,.BILINE)
 .S X="           "_$$CTYSTZ^BIUTL1(BIDFN),BIPLIN1=BIPLIN1+1
 .D APPEND(BIPLIN1,X,.BILINE)
 ;
 ;---> Phone Number.
 D:((BINFODS[11)!BIALL)
 .N X S X="Phone....: "_$$HPHONE^BIUTL1(BIDFN),BIPLIN1=BIPLIN1+1
 .D APPEND(BIPLIN1,X,.BILINE)
 ;
 ;---> Parent/Guardian.
 D:((BINFODS[17)!BIALL)
 .N X S X="Parent...: "_$$PARENT^BIUTL1(BIDFN),BIPLIN1=BIPLIN1+1
 .D APPEND(BIPLIN1,X,.BILINE)
 ;
 ;---> Case Manager.
 D:((BINFODS[18)!BIALL)
 .N X S X="Case Mgr.: "_$$CMGR^BIUTL1(BIDFN,1,1),BIPLIN1=BIPLIN1+1
 .D APPEND(BIPLIN1,X,.BILINE)
 ;
 ;---> Reason Inactivated.
 D:((BINFODS[19)!BIALL)
 .Q:('$$INACT^BIUTL1(BIDFN))
 .N X S X="Inactive.: "_$$INACTRE^BIUTL1(BIDFN),BIPLIN1=BIPLIN1+1
 .D APPEND(BIPLIN1,X,.BILINE)
 ;
 ;---> Immunization History.
 I (BINFODS[13)!(BINFODS[14)!(BINFODS[20)!(BINFODS[22)!(BINFODS[25)!BIALL D
 .;---> Write either History or History w/Lot#'s, VFC, with or without Skin Tests.
 .N X D
 ..I (BINFODS[14)&(BINFODS'[25) S X=2 Q
 ..I (BINFODS'[14)&(BINFODS[25) S X=5 Q
 ..I (BINFODS[14)&(BINFODS[25) S X=7 Q
 ..S X=1
 .;
 .;---> Include location where shot was given.
 .N Y S Y=$S(BINFODS[22:1,1:0)
 .N Z S Z=1
 .D:(BINFODS[20)
 ..I ((BINFODS'[13)&(BINFODS'[14)&(BINFODS'[25)) S Z=2 Q
 ..S Z=0
 .D WRITE(.BILINE),WRITE(.BILINE,"     History:")
 .D HISTORY1^BILETPR1(.BILINE,BIDFN,X,,"BIDULV",,,Z,Y,.BIMMRF,.BIMMLF)
 ;
 ;
 ;---> Refusals.
 D:((BINFODS[23)!BIALL)
 .N A,X1,X2,X3 S (X1,X2,X3)=""
 .D CONTRA^BIUTL11(BIDFN,.A,1,1)
 .Q:('$D(A))
 .D WRITE(.BILINE)
 .S X1="     Refusals: "
 .N N,M S N=0,M=0
 .F  S N=$O(A(N)) Q:'N  D
 ..N X S M=M+1
 ..S X=$$VNAME^BIUTL2($$HL7TX^BIUTL2(N))_" ("_$$SLDT2^BIUTL5($P(A(N),U,2),1)_")"
 ..S:"235689"[M X=", "_X
 ..I M<4 S X1=X1_X Q
 ..I M<7 S:M=4 X2="               ",X1=X1_"," S X2=X2_X Q
 ..S:M=7 X3="               ",X2=X2_"," S X3=X3_X Q
 .I X1]"" D WRITE(.BILINE,X1)
 .I X2]"" D WRITE(.BILINE,X2)
 .I X3]"" D WRITE(.BILINE,X3)
 ;
 ;---> Next Appointment.
 D:((BINFODS[21)!BIALL)
 .;---> Write either Patient's Next Appointment if there is one.
 .N X S X=$$NEXTAPPT^BIUTL11(BIDFN)
 .D:X]""
 ..S X="     Next Appointment: "_$E(X,1,57)
 ..D WRITE(.BILINE),WRITE(.BILINE,X)
 ;
 ;---> Directions to House.
 D:((BINFODS[16)!BIALL)
 .Q:'$O(^AUPNPAT(BIDFN,12,0))
 .D WRITE(.BILINE)
 .N X S X="  Directions to the home of "_$$NAME^BIUTL1(BIDFN,1)_":"
 .D WRITE(.BILINE,X)
 .N N S N=0
 .F  S N=$O(^AUPNPAT(BIDFN,12,N)) Q:'N  D
 ..S X=$G(^AUPNPAT(BIDFN,12,N,0))
 ..D WRITE(.BILINE,"  "_X)
 ;
 D:'$G(BIDASH) WRITE(.BILINE,"  "_$$SP^BIUTL5(73,"-"))
 ;---> Mark the top line of this record with the total lines in it.
 D MARK^BIW(BIPLIN,BILINE-BIPLIN,"BIDULV")
 Q
 ;
 ;
 ;----------
FORECAST(BILINE,BIDFN,BIFDT) ;EP
 ;---> Retrieve and store Imm Forecast in WP ^TMP global.
 ;---> Parameters:
 ;     2 - BILINE (ret) Last line written into ^TMP array.
 ;     3 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     4 - BIFDT  (opt) Forecast Date.
 ;
 Q:'$D(BILINE)  Q:'$G(BIDFN)
 ;
 ;---> If Patient is deceased, display date instead of forecast.
 N X S X=$$DECEASED^BIUTL1(BIDFN,1)
 I X D WRITE(.BILINE),WRITE(.BILINE,"     DECEASED: "_$$TXDT^BIUTL5(X)) Q
 ;
 ;---> If Forecast Date not provided, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> RPC to gather Immunization History.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BIRETVAL,BIRETERR S BIRETVAL=""
 ;---> Next line: 4th param=1 to not call Immserve because forecast
 ;---> just got updated in retrieving patients: +225^BIDUR.
 D IMMFORC^BIRPC(.BIRETVAL,BIDFN,BIFDT,1)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D  Q
 .D WRITE(.BILINE),WRITE(.BILINE,"     "_BIRETERR),WRITE(.BILINE)
 ;
 ;---> Set BIFDTORC=to the Immunization Forecast for this patient.
 N BIFDTORC,I,V S V="|",BIFDTORC=$P(BIRETVAL,BI31,1)
 ;
 ;---> Loop through "^"-pieces of Imm Forecast, getting data.
 F I=1:1 S Y=$P(BIFDTORC,U,I) Q:Y=""  D
 .N X,Z S X=$S(I=1:"     Needs: ",1:"            ")
 .;---> If the forecast for this vaccine contains an error,
 .;---> write Vaccine Group Name Error, such as, $P("DTP ERROR:",":").
 .S Z=$P(Y,V),Z=X_$P(Z,":")
 .D WRITE(.BILINE,Z)
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL) ;EP
 ;---> Write a line to the ^TMP global for WP or Listman.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# in the WP ^TMP global.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 S:$G(BIVAL)="" BIVAL=" "
 S BILINE=BILINE+1,^TMP("BIDULV",$J,BILINE,0)=BIVAL
 Q
 ;
 ;
 ;----------
APPEND(BIPLIN1,BIVAL,BILINE) ;EP
 ;---> Append BIVAL to existing line or create new line.
 ;---> Parameters:
 ;     1 - BIPLIN1 (ret) Line down from demog line to be added to.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BILINE (ret) Last line# in the WP ^TMP global.
 ;
 Q:'$D(BILINE)
 Q:$G(BIVAL)=""
 ;
 ;---> If line already exists, append to it.
 N X
 I $D(^TMP("BIDULV",$J,BIPLIN1,0)) S X=^(0) D  Q
 .S X=$$PAD^BIUTL5(X,32)_BIVAL
 .S ^TMP("BIDULV",$J,BIPLIN1,0)=X
 ;
 ;---> If line doesn't exist, create it.
 D WRITE(.BILINE,$$SP^BIUTL5(32)_BIVAL)
 Q
