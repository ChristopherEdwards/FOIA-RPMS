APCHPWHM ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;  
 ;;2.0;IHS PCC SUITE;**2,5,7**;MAY 14, 2009;Build 1
 ;
MEDSACT ;EP - medications (active) component
 S APCHACTO=1
 D MEDS
 K APCHACTO
 Q
 ;
MEDS ;EP - medications component
 ;get all meds in the past year +30 days
 ;NEW APCHMEDS,APCHMED,X,M,I,N,D,APCHKEEP,APCHM,APCHRXN,APCHRXO,APCHRX0,APCHSREF,APCHSTAT,C,APCHN,APCHI,APCHD,APCHC
 NEW X,M,D,N,C,Z,P,I,EXPDT
 ;
 ;use VA API from Phil
 ;exclude discontinued and expired
 ;store each drug by NAME, inverse date, get date filled, # of refills, rx #, sig and comments for hold
 NEW APCHMED,APCHALL,LINDEX
 D GETRXS  ;all outpatient, nva
 D GETVMEDE
 I '$G(APCHACTO) D GETEXP
 D DISP
 Q
 ; RPC: BEHORXFN GETRXS
 ; Fetch list of current prescriptions
 ;  DFN = Patient IEN
 ;  DAYS= # days to include in search (default = 365)
 ;  DATA returned as a list in the format for each script:
 ;
 ;   ~Type[1] ^ PharmID[2] ^ Drug[3] ^ InfRate[4] ^ StopDt[5] ^ RefRem[6] ^
 ;    TotDose[7] ^ UnitDose[8] ^ OrderID[9] ^ Status[10] ^ LastFill[11] ^
 ;    Days Supply[12] ^ Quantity[13] ^ Chronic[14] ^ Issued[15] ^
 ;    Rx #[16] ^ Provider IEN~Name[17] ^ Status Reason[18] ^ DEA Handling[19] ^
 ;    Pharmacy Site[20] ^ Indication ICD~Text[21] ^ DAW[22]
 ;
 ;   <"\" or " "><Instruction Text>  where "\" indicates a new line
GETRXS ;
 ;D CLNNVA
 N INDEX,ILST,DAT
 K ^TMP("PS",$J)
 S DAYS=395
 D OCL^PSOORRL(APCHSDFN,$$FMADD^XLFDT(DT,-DAYS),"")
 S ILST=0,INDEX="",LINDEX=""
 F  S INDEX=$O(^TMP("PS",$J,INDEX),-1) Q:'INDEX  S LINDEX=INDEX D
 .N INSTRUCT,COMMENTS,FIELDS,NVSDT,TYPE,IND,CMF,RXN,PRV,REASON,DEA,IFN,DAW,J,K,X,APCHMEDS,DRUGNAME,DRUGND,L,APCHSRX,APCHSREF
 .S (INSTRUCT,COMMENTS,IND,CMF,RXN,REASON,DEA,DAW)="",FIELDS=^TMP("PS",$J,INDEX,0),PRV=$TR($G(^("P",0)),U,"~")
 .Q:$P(FIELDS,U,9)="DISCONTINUED"  ;not on PWH
 .Q:$P(FIELDS,U,9)="EXPIRED"  ;not on pwh
 .S IFN=+$P(FIELDS,U,8),X=$O(^OR(100,IFN,4.5,"ID","DRUG",0))
 .S:X X=+$G(^OR(100,IFN,4.5,X,1))
 .S:X DEA=$P($G(^PSDRUG(X,0)),U,3)
 .;S:$D(^OR(100,IFN,8,"C","XX")) $P(^(0),U,2)="*"_$P(^TMP("PS",$J,INDEX,0),U,2)
 .S TYPE=$S($P($P(FIELDS,U),";",2)="O":"OP",1:"UD")
 .I TYPE="OP",$P(FIELDS,";")["N" S TYPE="NV"
 .S:$O(^TMP("PS",$J,INDEX,"A",0))>0 TYPE="IV"
 .S:$O(^TMP("PS",$J,INDEX,"B",0))>0 TYPE="IV"
 .Q:$G(IFN)&$D(^TMP("PS",$J,"X",TYPE,IFN))  S ^(IFN)=""  ; OCL^PSOORRL can return dups
 .I TYPE="OP" D
 ..S (DRUGNAME,DRUGND)=$P(FIELDS,U,2)
 ..Q:$D(APCHALL(DRUGNAME))
 ..S APCHALL(DRUGNAME)=""
 ..S:$L($P(FIELDS,U,12)) DRUGND=DRUGND_"  Qty: "_$P(FIELDS,U,12)
 ..S:$L($P(FIELDS,U,11)) DRUGND=DRUGND_" for "_$P(FIELDS,U,11)_" days"
 ..S APCHMED(DRUGNAME,INDEX)=DRUGND
 ..D OPINST(.INSTRUCT)
 ..S $P(APCHMED(DRUGNAME,INDEX),U,5)=$G(INSTRUCT)
 ..S J=$P($P(FIELDS,U),";")
 ..I J["R" D
 ...S RXN=$P($G(^PSRX(+J,0)),U)
 ...S $P(APCHMED(DRUGNAME,INDEX),U,3)="Rx #: "_RXN
 ...S H=$G(^PSRX(+J,2)),K=+$G(^PSRX(+J,"STA"))
 ...S L=$P($G(^PSRX(+J,3)),U,1)  ;last dispensed date
 ...I L="" S L=$O(^PSRX(I,1,"B",9999999),-1)
 ...I L="" S L=$P($G(^PSRX(I,2)),U,2)
 ...I L="" S L=$P(^PSRX(I,0),U,13)
 ...S $P(APCHMED(DRUGNAME,INDEX),U,2)=L
 ...S APCHSRX=+J,APCHSREF=0 D REF^APCHS7O S $P(APCHMED(DRUGNAME,INDEX),U,4)=APCHSREF
 ...I K<12,'$P(J,U,13),$P(J,U,15) S $P(APCHMED(DRUGNAME,INDEX),U,7)="Not Picked Up^",REASON="Returned to stock on "_$$FMTE^XLFDT($P(J,U,15))
 .E  I TYPE="NV" D
 ..S DRUGNAME=$P(FIELDS,U,2)
 ..Q:$D(APCHALL(DRUGNAME))
 ..S APCHMED(DRUGNAME,INDEX)=DRUGNAME
 ..D NVINST(.INSTRUCT)
 ..S $P(APCHMED(DRUGNAME,INDEX),U,5)=$G(INSTRUCT)
 ..D NVREASON(.REASON,.NVSDT)
 ..S $P(APCHMED(DRUGNAME,INDEX),U,6)=$G(REASON)
 ..S $P(APCHMED(DRUGNAME,INDEX),U,2)=$G(NVSDT)
 ..D SETMULT(.COMMENTS,"SIO")
 ..S $P(APCHMED(DRUGNAME,INDEX),U,6)=$P(APCHMED(DRUGNAME,INDEX),U,6)_$S(COMMENTS]"":"  Comments: "_COMMENTS,1:"")
 .;S:$D(COMMENTS(1)) COMMENTS(1)="\"_COMMENTS(1)
 .S:$P(FIELDS,U,9)="HOLD" REASON=$$HLDRSN(IFN) D
 ..Q:REASON=""
 ..S $P(APCHMED(DRUGNAME,INDEX),U,8)=$P(APCHMED(DRUGNAME,INDEX),U,8)_"  "_$G(REASON)
 K ^TMP("PS",$J)
 Q
 ; Assembles instructions for an outpatient prescription
OPINST(Y) ;
 N I,X
 D SETMULT(.Y,"SIG")
 I Y="" D
 .D SETMULT(.Y,"SIO")
 .D SETMULT(.Y,"MDR")
 .D SETMULT(.Y,"SCH")
 ;S Y="Directions: "_Y
 Q
 ; Assembles instructions for a home med
NVINST(Y) ;
 N I
 D SETMULT(.Y,"SIG")
 I Y="" D
 .D SETMULT(.Y,"SIO")
 .D SETMULT(.Y,"MDR")
 .D SETMULT(.Y,"SCH")
 Q
 ; Assembles start date and reasons for a home med
NVREASON(Y,NVSDT) ;
 N ORN
 S ORN=+$P(FIELDS,U,8)
 I $D(^OR(100,ORN,0)) D
 .S NVSDT=$P(^OR(100,ORN,0),U,8)
 .D WPVAL(.Y,ORN,"STATEMENTS")
 Q
 ;  Return word processing value
WPVAL(Y,ORN,ID) ;
 N DA,I,J
 S DA=+$O(^OR(100,ORN,4.5,"ID",ID,0)),(I,J)=0
 F  S I=$O(^OR(100,ORN,4.5,DA,2,I)) Q:'I  S Y=Y_^(I,0)
 Q
 ; Appends the multiple at the subscript to Y
SETMULT(Y,SUB) ;
 N I
 S I=0
 F  S I=$O(^TMP("PS",$J,INDEX,SUB,I)) Q:'I  D
 .S Y=Y_^TMP("PS",$J,INDEX,SUB,I,0)
 Q
 ; Return hold reason
HLDRSN(ORIFN) ;
 N RSN,PSIFN,X
 S X=$O(^OR(100,+ORIFN,8,"C","HD",""),-1)
 S:$O(^OR(100,+ORIFN,8,"C","RL",X)) X=""
 S RSN=$S('X:"",1:$G(^OR(100,+ORIFN,8,X,1)))
 S PSIFN=$$GETPSIFN(ORIFN)
 I PSIFN=+PSIFN D
 .S X=$$GET1^DIQ(52,PSIFN,99.1)
 .S:'$L(X) X=$$GET1^DIQ(52,PSIFN,99),X=$S($E(X,1,5)="OTHER":"",1:X)
 .S:$L(X) RSN=X
 Q "Hold Reason:  "_$S($L(RSN):RSN,1:"Not specified")
 ; Return chronic med flag from order IFN
GETCMF1(ORIFN) ;EP
 N PSIFN
 S PSIFN=$$GETPSIFN(ORIFN)
 Q:PSIFN=+PSIFN $$GET1^DIQ(52,PSIFN,9999999.02)["Y"
 Q $$VALUE^ORCSAVE2(+ORIFN,"CMF")["Y"
 ; Get pharmacy IFN from order IFN
GETPSIFN(ORIFN) ;
 N PKG,PSIFN
 S PKG=+$P($G(^OR(100,+ORIFN,0)),U,14),PSIFN=$P($G(^(4)),U)
 Q $S('PSIFN!(PKG'=$O(^DIC(9.4,"C","PSO",0))):"",1:PSIFN)
 Q
GETVMEDE ;NOW GET OUTSIDE MEDS DEFINED AS ANY WITH 1108 FIELD OR EVENT VISIT SERVICE CATEGORY
 K APCHMEDS,APCHM
 D GETMEDS^APCHSMU1(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT,,,,,.APCHMEDS)
 ;store each drug by inverse date
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X  D
 .S M=$P(APCHMEDS(X),U,4)
 .S V=$P(^AUPNVMED(M,0),U,3)
 .I $P(^AUPNVSIT(V,0),U,7)'="E" Q
 .Q:$P($G(^AUPNVMED(M,11)),U,8)]""  ;GOT THESE IN NVA
 .Q:$P(^AUPNVMED(M,0),U,8)  ;discontinued
 .S D=$P(^AUPNVMED(M,0),U,1)
 .S N=$S($P(^AUPNVMED(M,0),U,4)]"":$P(^AUPNVMED(M,0),U,4),1:$P(^PSDRUG(D,0),U,1))
 .Q:$D(APCHALL(N))  ;already have this drug
 .S LINDEX=LINDEX+1
 .S APCHMED(N,LINDEX)=N_U_$P(APCHMEDS(X),U,1)_U_U_$P(^AUPNVMED($P(APCHMEDS(X),U,4),0),U,5)
 Q
 ;
GETEXP ;get expired chronic meds in past 120 days
 ;GET ALL PRESCRIPTIONS IN PHARMACY PATIENT FILE FOR -395 TO TODAY BY EXPIRATION DATE IN PS(55
 K APCHALL,APCHKEEP
 S EXPDT=$$FMADD^XLFDT(DT,-395)
 F  S EXPDT=$O(^PS(55,APCHSDFN,"P","A",EXPDT)) Q:EXPDT'=+EXPDT  D
 .S I=0 F  S I=$O(^PS(55,APCHSDFN,"P","A",EXPDT,I)) Q:I'=+I  D
 ..Q:'$D(^PSRX(I,0))
 ..S D=$P(^PSRX(I,0),U,6)
 ..I '$D(^PSDRUG(D,0)) Q  ;no drug
 ..S N=$P(^PSDRUG(D,0),U)
 ..Q:$D(APCHALL(N))  ;already got this drug
 ..S P=$P(^PSRX(I,0),U,2)
 ..I P'=APCHSDFN Q  ;oops, bad data
 ..S L=$P($G(^PSRX(I,3)),U,1)  ;last dispensed date
 ..I L="" S L=$O(^PSRX(I,1,"B",9999999),-1)
 ..I L="" S L=$P($G(^PSRX(I,2)),U,2)
 ..I L="" S L=$P(^PSRX(I,0),U,13)
 ..Q:L=""
 ..S L=9999999-L
 ..S S=$P($G(^PSRX(I,"STA")),U,1)
 ..Q:S'=11
 ..S APCHALL(N,D,L,I)=S
 ;now kill off all except the latest one
 K APCHKEEP
 S N="" F  S N=$O(APCHALL(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHALL(N,D)) Q:D=""  D
 ..Q:$D(APCHKEEP(N,D))
 ..S L=$O(APCHALL(N,D,0))
 ..S I=$O(APCHALL(N,D,L,0))
 ..S APCHKEEP(N,D,L,I)=APCHALL(N,D,L,I)
 ;now go through and group them
 S N="" F  S N=$O(APCHKEEP(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHKEEP(N,D)) Q:D=""  D
 ..S L=0 F  S L=$O(APCHKEEP(N,D,L)) Q:L=""  D
 ...S I=0 F  S I=$O(APCHKEEP(N,D,L,I)) Q:I'=+I  D
 ....S S=APCHKEEP(N,D,L,I)
 ....I S=11 D GRP2 Q
 Q
GRP2 ;
 Q:'$D(^PS(55,APCHSDFN,"P","CP",I))  ;CHRONIC ONLY
 S C=$S(I:$D(^PS(55,APCHSDFN,"P","CP",I)),1:0)
 S Y=$S(C:120,1:14)
 Q:$$FMDIFF^XLFDT(DT,$P($G(^PSRX(I,2)),U,6))>Y
 S LINDEX=LINDEX+1
 S APCHMED(N,D)=N_U_(9999999-L)_U_$P(^PSRX(I,0),U)
 I $O(^PSRX(I,"SIG1",0)) D
 .S S="" S APCHP=0 F  S APCHP=$O(^PSRX(I,"SIG1",APCHP)) Q:APCHP'=+APCHP  S S=S_^PSRX(I,"SIG1",APCHP,0)_" "
 I S="" S S=$P($G(^PSRX(I,"SIG")),U,1)
 S $P(APCHMED(N,LINDEX),U,5)=S
 S APCHSRX=I,APCHSREF=0 D REF^APCHS7O S $P(APCHMED(N,LINDEX),U,4)=APCHSREF
 S $P(APCHMED(N,LINDEX),U,10)=$P($G(^PSRX(I,2)),U,6)  ;expiration date
 Q
DISP ;display them now, this was a pain
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("MEDICATIONS - This is a list of medications and other items you are")
 D S^APCHPWH1("taking including non-prescription medications, herbal, dietary, and")
 D S^APCHPWH1("traditional supplements.  Please let us know if this list is not ")
 D S^APCHPWH1("complete.  If you have other medications at home or are not sure if")
 D S^APCHPWH1("you should be taking them, call your health care provider to be safe.")
 I '$D(APCHMED) D S^APCHPWH1("No medications are on file.  Please tell us if there are any that we missed.",1) Q
 S APCHC=0
 S APCHN=""
 F  S APCHN=$O(APCHMED(APCHN)) Q:APCHN=""  D
 .S APCHI=0 F  S APCHI=$O(APCHMED(APCHN,APCHI)) Q:APCHI=""  D
 ..S APCHZ=APCHMED(APCHN,APCHI)
 ..S APCHC=APCHC+1
 ..S X="",$E(X,1)=APCHC_"."
 ..S $E(X,7)=$P(APCHZ,U,1) D S^APCHPWH1(X,1)
 ..S X="" I $P(APCHZ,U,3)]""!($P(APCHZ,U,4)]"") S $E(X,7)=$P(APCHZ,U,3)_"     "_$S($P(APCHZ,U,4)]"":"Refills left: "_$P(APCHZ,U,4),1:"") I X]"" D S^APCHPWH1(X)
 ..;attempt to wrap directions 58 characters
 ..K ^UTILITY($J,"W") S X=$P(APCHZ,U,5),DIWL=0,DIWR=58 D ^DIWP
 ..S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ..I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ..K ^UTILITY($J,"W")
 ..;I $P(Z,U,11)]"" D S^APCHPWH1("      Ordered but not dispensed: "_$P(Z,U,11))
 I '$G(APCHACTO),$D(APCHMEDE) D
 .D S^APCHPWH1("==========",1)
 .D S^APCHPWH1("Your prescription for these medications has expired.  You need to talk")
 .D S^APCHPWH1("with your prescriber to get a new prescription for these medications.")
 .D S^APCHPWH1(" ")
 .S APCHN="" F  S APCHN=$O(APCHMED(2,APCHN)) Q:APCHN=""  D
 ..S APCHI=0 F  S APCHI=$O(APCHMED(2,APCHN,APCHI)) Q:APCHI'=+APCHI  D
 ...S APCHD=0 F  S APCHD=$O(APCHMED(2,APCHN,APCHI,APCHD)) Q:APCHD'=+APCHD  D
 ....S APCHZ=APCHMED(2,APCHN,APCHI,APCHD)
 ....S APCHC=APCHC+1
 ....S X="",$E(X,1)=APCHC_".",$E(X,7)=APCHN,$E(X,47)=$S($P(APCHZ,U,6)]"":"Rx#: "_$P(APCHZ,U,6),1:""),$E(X,61)=$S($P(APCHZ,U,7)]"":"Refills left: "_$P(APCHZ,U,7),1:"") D S^APCHPWH1(X,1)
 ....;S X="",$E(X,7)="Directions: "_$P(Z,U,8) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W") S X=$P(APCHZ,U,8),DIWL=0,DIWR=58 D ^DIWP
 ....S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ....I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W")
 ....S X="",$E(X,7)="Last date filled: "_$$FMTE^XLFDT((9999999-APCHD))_"     Expired on: "_$$FMTE^XLFDT($P(APCHZ,U,10)) D S^APCHPWH1(X)
 Q
 ;
SET1 ;
 S $P(APCHMED(Z,N,D,X),U,6)=$P($G(^AUPNVMED(M,11)),U,2)
 S $P(APCHMED(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 S $P(APCHMED(Z,N,D,X),U,7)=$P($G(^AUPNVMED(M,11)),U,7)
 Q
SET ;
 S $P(APCHMED(Z,N,D,X),U,6)=$P(^PSRX(APCHRXN,0),U)
 S $P(APCHMED(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 S APCHSRX=APCHRXN,APCHSREF=0 D REF^APCHS7O S $P(APCHMED(Z,N,D,X),U,7)=APCHSREF
 Q
HOLD(S) ;EP - is this prescription on hold?
 NEW X
 S X=$P($G(^PSRX(S,"STA")),U,1)
 I X=3 Q 1
 ;I X=5 Q 1
 ;I X=16 Q 1
 ;version 6
 S X=$P($G(^PSRX(S,0)),U,15)
 I X=3 Q 1
 ;I X=5 Q 1
 ;I X=16 Q 1
 Q 0
