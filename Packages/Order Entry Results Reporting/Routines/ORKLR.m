ORKLR ; slc/CLA - Order checking support procedure for lab orders ;7/23/96  14:31
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**6,32,51,92,105**;Dec 17, 1997
 Q
DUP(ORKLR,OI,ORDFN,NEWORDT,SPECIMEN) ; return duplicate lab order info
 N ORL,DDT,ODT,ORN,ORNC,LRID,DGIEN,ORPANEL
 ;get lab id from orderable item (OI):
 S LRID=$P(^ORD(101.43,OI,0),U,2) S:$L($G(LRID)) ORL(LRID_";"_SPECIMEN)=""
 ;expand into child-level lab identifiers if children exist for this OI:
 ;if children found, set panel flag to '1':
 S LRID="" F  S LRID=$O(^ORD(101.43,OI,10,"AID",LRID)) Q:LRID=""  S ORL(LRID_";"_SPECIMEN)="",ORPANEL=1
 ;get duplicate date range-beginning date/time for this OI:
 S DDT=$P($$DUPRANGE^ORQOR2(OI,"LR",NEWORDT,ORDFN),U)
 Q:DDT=0  ;if dup range for this OI = zero, don't process dup order oc
 ;
 ;get all lab orders since dup beg d/t:
 S DGIEN=0,DGIEN=$O(^ORD(100.98,"B","LAB",DGIEN))
 K ^TMP("ORR",$J)
 D EN^ORQ1(ORDFN_";DPT(",DGIEN,1,"",DDT,NEWORDT,1,0)
 N J,HOR,SEQ,X S J=1,HOR=0,SEQ=0
 S HOR=$O(^TMP("ORR",$J,HOR)) Q:+HOR<1
 F  S SEQ=$O(^TMP("ORR",$J,HOR,SEQ)) Q:+SEQ<1  D
 .S X=^TMP("ORR",$J,HOR,SEQ),ORN=+$P(X,U),ODT=$P(X,U,4)
 .Q:+$G(ORN)=+$G(ORIFN)  ;quit current order # = dup order #
 .;break into child orders if they exist:
 .I $D(^OR(100,ORN,2,0)) D  ;child orders exist
 ..S ORNC=0 F  S ORNC=$O(^OR(100,ORN,2,ORNC)) Q:ORNC=""  D
 ...Q:+$G(ORNC)=+$G(ORIFN)  ;quit current order # = dup order #
 ...D DUP2(.ORKLR,ORNC,ODT,.ORL,$G(ORPANEL))
 .I '$D(^OR(100,ORN,2,0)) D DUP2(.ORKLR,ORN,ODT,.ORL,$G(ORPANEL))
 K ^TMP("ORR",$J)
 Q
DUP2(ORKLR,ORN,ODT,ORL,ORPANEL) ;second part of dup lab order check
 N ORS,ORST,ORSI,ORSP,OROI,LRID,LRIDX,LRIDXC,EXDT,INVDT,RCNT,ORY,ORX,ORQ
 S ORS=$$STATUS^ORQOR2(ORN),ORSI=$P(ORS,U),ORST=$P(ORS,U,2)
 ;quit if order status is canceled/discontinued/expired/lapsed/changed/delayed:
 I (ORSI=13)!(ORSI=1)!(ORSI=7)!(ORSI=14)!(ORSI=12)!(ORSI=10) Q
 ;
 ;get specimen for this order:
 S ORSP=$$VALUE^ORCSAVE2(ORN,"SPECIMEN")
 Q:'$L($G(ORSP))  ;quit if no specimen found
 ;get orderable item for this order:
 S OROI=$$OI^ORQOR2(ORN)
 Q:'$L($G(OROI))  ;quit if no orderable item found
 ;get lab id and check against ordered array ORL
 S:$L($G(^ORD(101.43,OROI,0))) LRIDX=$P(^ORD(101.43,OROI,0),U,2)_";"_ORSP I $L($G(LRIDX)) D
 .S LRID="" F  S LRID=$O(ORL(LRID)) Q:LRID=""  I LRID=LRIDX D  ;dup!
 ..;
 ..;quit if order results entered in lab as "cancelled":
 ..D ORDER^ORQQLR(.ORY,ORDFN,ORN)
 ..S ORX=0 F  S ORX=$O(ORY(ORX)) Q:+$G(ORX)<1  D
 ...I ($P(LRID,";")=$P(ORY(ORX),U)),($P(ORY(ORX),U,3)["canc") S ORQ=1
 ..Q:+$G(ORQ)=1  ;quit if lab test cancelled in lab
 ..;
 ..S EXDT=$$FMTE^XLFDT(ODT,"2P"),INVDT=9999999-ODT
 ..;get most recent lab results:
 ..S RCNT=$$LOCLFORM^ORQQLR1(ORDFN,+LRID,ORSP)
 ..;
 ..S ORKLR(INVDT)=ORN_U_$P($$TEXT^ORKOR(ORN,60),U,2)_" "_$G(EXDT)_" ["_$S(ORST="COMPLETE":"COLLECTED",ORST="PENDING":"UNCOLLECTED",1:ORST)_"]"
 ..I +RCNT>0 S ORKLR(INVDT)=ORKLR(INVDT)_"  *Most recent result: "_$P(RCNT,U,2)_"*"
 ;get children lab ids and check against ordered array  ORL
 S LRIDX="" F  S LRIDX=$O(^ORD(101.43,OROI,10,"AID",LRIDX)) Q:LRIDX=""  D
 .S LRIDXC=LRIDX_";"_ORSP
 .S LRID="" F  S LRID=$O(ORL(LRID)) Q:LRID=""  I LRID=LRIDXC D  ;dup!
 ..;
 ..D ORDER^ORQQLR(.ORY,ORDFN,ORN)
 ..S ORX=0 F  S ORX=$O(ORY(ORX)) Q:+$G(ORX)<1  D
 ...I ($P(LRID,";")=$P(ORY(ORX),U)),($P(ORY(ORX),U,3)["canc") S ORQ=1
 ..Q:+$G(ORQ)=1  ;quit if lab test cancelled in lab
 ..;
 ..S EXDT=$$FMTE^XLFDT(ODT,"2P"),INVDT=9999999-ODT
 ..;get most recent lab results:
 ..S RCNT=$S($G(ORPANEL)=1:"",1:$$LOCLFORM^ORQQLR1(ORDFN,+LRID,ORSP))
 ..;
 ..S ORKLR(INVDT)=ORN_U_$P($$TEXT^ORKOR(ORN,60),U,2)_" "_$G(EXDT)_" ["_$S(ORST="COMPLETE":"COLLECTED",ORST="PENDING":"UNCOLLECTED",1:ORST)_"]"
 ..I +RCNT>0 S ORKLR(INVDT)=ORKLR(INVDT)_"  *Most recent result: "_$P(RCNT,U,2)_"*"
 Q
RECNTWBC(ORDFN,ORDAYS) ;extrinsic function to return most recent WBC within <ORDAYS> in format:
 ;test id^result units flag ref range collection d/t
 N BDT,CDT,ORY,ORX,ORZ,X,TEST,ORI,ORJ,WBCRSLT,LABFILE,SPECFILE
 Q:'$L($G(ORDFN)) "0^"
 D NOW^%DTC
 I $L($G(ORDAYS)) S BDT=$$FMADD^XLFDT(%,"-"_ORDAYS,"","","")
 K %
 S:'$L($G(BDT)) BDT=1  ;if no ORDAYS, set BDT to '1' to search all days
 S LABFILE=$$TERMLKUP^ORB31(.ORY,"WBC")
 Q:'$D(ORY) "0^"  ;quit if no link between WBC and local lab test
 Q:$G(LABFILE)'=60 "0^"
 S SPECFILE=$$TERMLKUP^ORB31(.ORX,"BLOOD SPECIMEN")
 Q:'$D(ORX) "0^" ;quit if no link between BLOOD SPECIMEN and local spec
 Q:$G(SPECFILE)'=61 "0^"
 F ORI=1:1:ORY I +$G(WBCRSLT)<1 D
 .S TEST=$P(ORY(ORI),U)
 .Q:+$G(TEST)<1
 .F ORJ=1:1:ORX I +$G(WBCRSLT)<1 D
 ..S SPECIMEN=$P(ORX(ORJ),U)
 ..Q:+$G(SPECIMEN)<1
 ..S ORZ=$$LOCL^ORQQLR1(ORDFN,TEST,SPECIMEN)
 ..Q:'$L($G(ORZ))
 ..S CDT=$P(ORZ,U,7)
 ..I CDT'<BDT S WBCRSLT=1
 Q:+$G(WBCRSLT)<1 "0^"
 Q $P(ORZ,U,3)_U_$P(ORZ,U,3)_" "_$P(ORZ,U,4)_" "_$P(ORZ,U,5)_" ("_$P(ORZ,U,6)_")  "_$$FMTE^XLFDT(CDT,"2P")
 ;
CLOZLABS(ORDFN,ORDAYS,ORCLOZ) ;extrinsic function rtns "1" if clozapine ordered and WBC labs results within past ORDAYS, "0" if not
 ;result format: clozapine/mapped labs flag^recent WBC flag;recent WBC
 ; result^recent ANC flag;recent ANC result^formatted WBC and ANC results
 ;
 N BDT,WBC,WBCSPEC,WBCRSLT,WBCCDT,WBCF,ANC,ANCSPEC,ANCRSLT,ANCCDT,ANCF
 Q:'$L($G(ORDFN)) "0^"
 I $L($G(ORDAYS)) S BDT=$$FMADD^XLFDT($$NOW^XLFDT,"-"_ORDAYS,"","","")
 S:'$L($G(BDT)) BDT=1  ;if no ORDAYS, set BDT to '1' to search all days
 ;
 K LAB
 D EN^PSODRG(ORCLOZ)  ;pharmacy api rtns Lab file ptrs for WBC, ANC
 Q:$G(LAB("NOT"))=0 "0^"  ;medication is not clozapine
 Q:$G(LAB("BAD TEST"))=0 "0^"  ;one or both lab tests aren't mapped
 S WBC=$G(LAB("WBC")),WBCSPEC=$P(WBC,U,2),WBC=$P(WBC,U)
 S ANC=$G(LAB("ANC")),ANCSPEC=$P(ANC,U,2),ANC=$P(ANC,U)
 ;
 S WBCRSLT=$$LOCL^ORQQLR1(ORDFN,WBC,WBCSPEC)
 S WBCCDT=$P(WBCRSLT,U,7)
 S WBC=$P(WBCRSLT,U,3)
 I $L(WBC) D
 .S WBCRSLT="WBC: "_WBC_" ["_$$FMTE^XLFDT(WBCCDT,"""2P""")_"]"
 E  S WBCRSLT="WBC: no results found"
 I $L(WBC),(WBCCDT>BDT) S WBCF=1
 S:$G(WBCF)'=1 WBCF=0
 ;
 S ANCRSLT=$$LOCL^ORQQLR1(ORDFN,ANC,ANCSPEC)
 S ANCCDT=$P(ANCRSLT,U,7)
 S ANC=$P(ANCRSLT,U,3)
 I $L(ANC),(ANCCDT=WBCCDT) D  ;ANC from same collection d/t as WBC
 .S ANC=(WBC*ANC)/100
 .S ANCRSLT="ANC: "_ANC_" ["_$$FMTE^XLFDT(ANCCDT,"""2P""")_"]"
 E  S ANCRSLT="ANC: no results found"
 I $L(ANC),(ANCCDT>BDT) S ANCF=1
 S:$G(ANCF)'=1 ANCF=0
 ;
 K LAB
 Q "1^"_WBCF_";"_WBC_"^"_ANCF_";"_ANC_"^"_WBCRSLT_"  "_ANCRSLT
