LA7VQINS ;VA/DALOI/DLR - LAB ORM (Order) message builder ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**1027**;NOV 01, 1997;Build 9
INS(STORE,OR) ;Handle insurance
 N ORI,BDA,STR,IIEN,IPIEN,IEIEN
 S ORI=$O(^BLRRLO("B",OR,0))
 I 'ORI S ORI=$O(^BLRRLO("ACC",OR,0))
 Q:'ORI
 I $P($G(^BLRRLO(ORI,0)),U,5)="P"!($P($G(^BLRRLO(ORI,0)),U,5)="C") D  Q
 . S CNT=CNT+1
 . S IN1(48)=$S($P($G(^BLRRLO(ORI,0)),U,5)="P":"P",1:"C")
 . D IN1(.IN1)
 S BDA=0 F  S BDA=$O(^BLRRLO(ORI,2,BDA)) Q:'BDA  D
 . S STR=$G(^BLRRLO(ORI,2,BDA,0))
 . S IIEN=$P($P(STR,"~",11),",")
 . I $P(STR,"~",10)="D" D  Q
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCD(IIEN,STORE)
 . I $P(STR,"~",10)="M" D  Q
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCR(IIEN,IEIEN,STORE)
 . I $P(STR,"~",10)="R" D  Q
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCR(IIEN,IEIEN,STORE)
 . I $P(STR,"~",10)="P" D
 .. S IPIEN=$E($P(STR,"~",7),2,99)
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D PI(IPIEN,IEIEN,STORE)
 Q
 ;
MCR(IEN,PE,ST) ;medicare.
 S CNT=$G(CNT)+1
 N IENS S IENS=IEN_","
 D GETS^DIQ(9000003,IENS,"*","EI","IN")
 S EINS=PE_","_IENS D GETS^DIQ(9000003.11,EINS,"*","EI","IN")
 S INS=$G(IN(9000003,IENS,.02,"I"))_","
 D GETS^DIQ(9999999.18,INS,"*","EI","IN")
 S IN1(4)=$G(IN(9999999.18,INS,.66,"E"))
 S IN1(5)=$G(IN(9999999.18,INS,.01,"E"))
 S IN1(7)=$G(IN(9999999.18,INS,.06,"E"))
 S IN1(16)="MC"
 S IN1(18)=1
 S IN1(17)=$$HLNAME^HLFNC($G(IN(9000003,IENS,.01,"E")),LA7ECH)
 S IN1(37)=$G(IN(9000003,IENS,.03,"I"))
 S IN1(4)=$G(IN(9999999.18,INS,.66,"E"))
 S IN1(9)=$G(IN(9000003.11,IENS,.11,"I"))
 S IN1(9)=$S($G(IN1(9)):$P($G(^AUTNEGRP(IN1(9),0)),U,2),1:"")
 S IN1(10)=$G(IN(9000003,IENS,.06,"E"))
 S IN1(6)=$$ADD()
 S IN1(20)=$$ADD(2)
 S IN1(48)=$S($G(ORD):$P($$ACCT^LA7VQINS(ORD),U,4),1:"")
 Q:'ST
 D IN1(.IN1)
 Q
 ;
MCD(IEN,ST) ;medicaid
 S CNT=$G(CNT)+1
 N IENS
 S IENS=IEN_","
 D GETS^DIQ(9000004,IENS,"*","EI","IN")
 S INS=$G(IN(9000004,IENS,.02,"I"))_","
 D GETS^DIQ(9999999.18,INS,"*","EI","IN")
 S IN1(4)=$G(IN(9999999.18,INS,.66,"E"))
 S IN1(5)=$G(IN(9999999.18,INS,.01,"E"))
 S IN1(6)=$$ADD()
 S IN1(7)=$G(IN(9999999.18,INS,.06,"E"))
 S IN1(16)="MD"
 S IN1(17)=$$HLNAME^HLFNC($G(IN(9000004,IENS,.05,"E")),LA7ECH)
 S IN1(18)=1
 S PE=$G(IN(9000004,IENS,.06,"I"))
 S IN1(18)=+$P($G(^AUTTRLSH(+PE,0)),U,3)
 S IN1("18E")=$P($G(^AUTTRLSH(+PE,0)),U)
 S IN1(18)=$S(IN1(18)=2:2,IN1(18)=1:1,IN1(18)=0:1,1:8)
 S IN1(37)=$G(IN(9000004,IENS,.03,"I"))
 S IN1(9)=$G(IN(9000004,IENS,.17,"I"))
 S IN1(9)=$S($G(IN1(9)):$P($G(^AUTNEGRP(IN1(9),0)),U,2),1:"")
 S IN1(48)=$P($$ACCT^LA7VQINS(ORD),U,4)
 S IN1(20)=$$ADD(2)
 Q:'ST
 D IN1(.IN1)
 Q
 ;
PI(IEN,PE,ST) ;private insurance
 S CNT=$G(CNT)+1
 N IENS
 S IENS=IEN_","
 D GETS^DIQ(9000003.1,IENS,"*","EI","IN")
 S INS=$G(IN(9000003.1,IENS,.03,"I"))_","
 D GETS^DIQ(9999999.18,INS,"*","EI","IN")
 S IN1(4)=$G(IN(9999999.18,INS,.66,"E"))
 S IN1(5)=$G(IN(9999999.18,INS,.01,"E"))
 S IN1(6)=$$ADD()
 S IN1(7)=$G(IN(9999999.18,INS,.06,"E"))
 S IN1(9)=$G(IN(9000003.1,IENS,.06,"I"))
 S IN1(9)=$S($G(IN1(9)):$P($G(^AUTNEGRP(IN1(9),0)),U,2),1:"")
 S IN1(10)=$G(IN(9000003.1,IENS,.06,"E"))
 S IN1(16)=$S($G(IN(9999999.18,INS,.21,"I"))="H":"HM",1:"PI")
 S IN1(17)=$$HLNAME^HLFNC($G(IN(9000003.1,IENS,.01,"E")),LA7ECH)
 ;S IN1(18)=$G(IN(9000006.11,IENS,.05,"E"))
 S IN1(20)=$$ADD(9000003.1)
 S IN1(37)=$G(IN(9000003.1,IENS,.04,"E"))
 S IN1(48)=$S($G(ORD):$P($$ACCT^LA7VQINS(ORD),U,4),1:"")
 S IN1(18)=+$P($G(^AUTTRLSH(+$P($G(^AUPNPRVT(DFN,11,+PE,0)),U,5),0)),U,3)
 S IN1(18)=$S(IN1(18)=2:2,IN1(18)=1:1,IN1(18)=0:1,1:8)
 S IN1("18E")=$S(IN1(18)=1:"SELF",IN1(18)=2:"SPOUSE",1:"OTHER")  ;$P($G(^AUTTRLSH(+$P($G(^AUPNPRVT(DFN,11,+PE,0)),U,5),0)),U)
 Q:'ST
 D IN1(.IN1)
 Q
RR ;-- get railroad insurance
 Q
 ;
ADD(FILE) ;
 ;set address component
 I '$G(FILE) S FILE=9999999.18
 N LINE S LINE=".02^999^.03^.04^.05"
 I FILE[3 S LINE=".09^999^.11^.12^.13"
 I FILE=2 S LINE=".111^.112^.114^.115^.116"
 N X,I S X=""
 F I=1:1:5 S X=X_$G(IN(FILE,$S(FILE[3:IENS,1:INS),$P(LINE,U,I),"E"))_$E(LA7ECH)
 S $P(X,$E(LA7ECH),4)=$P($G(^DIC(5,+$G(IN(FILE,$S(FILE[3:IENS,1:INS),$P(LINE,U,4),"I")),0)),U,2)
 Q X
IN1(IN1) ;
 ;
 K LA7BLG(0)
 S LA7BLG(0)="IN1"_LA7FS_$G(CNT,1)
 ;F I=0:0 S I=$O(IN1(I)) Q:'I  S $P(LA7BLG(0),LA7FS,I)=IN1(I)
 S I=0 F  S I=$O(IN1(I)) Q:'I  I I'="18E" S $P(LA7BLG(0),LA7FS,I)=IN1(I)  ;ihs/cmi/maw 3/7/11 added for external relationship filter
 D FILESEG^LA7VHLU(GBL,.LA7BLG)
 D FILE6249^LA7VHLU(LA76249,.LA7BLG)
 Q
GAR(DFN,REL,PAT,ST) ;SELF AS GUARANTOR
 Q:$G(LA7GUAR)
 N DFN1 S DFN1=$G(DFN)
 I '$G(PAT) S PAT=$G(DFN)
 K GT1
 S I=$O(^AUPNGUAR(PAT,1,"A"),-1) I I S DFN=+$G(^(I,0)) I DFN'=DFN1 K REL
 S INS=DFN_","
 D GETS^DIQ(2,INS,".01;.09;.111;.112;.113;.114;.115;.116;.117;.131;.3111","EI","IN")
 S GT1(4)=$$HLNAME^HLFNC($G(IN(2,INS,.01,"E")),$E(LA7ECH))
 S GT1(6)=$$ADD(2)
 S GT1(7)=$G(IN(2,INS,.131,"I"))
 S GT1(12)=$S($G(REL):REL,1:1)
 S GT1(13)=$G(IN(2,INS,.09,"I"))
 I $G(GT1(17))="" S GT1(17)=$G(IN(2,INS,.3111,"E"))
 Q:'ST
 D GT1(.GT1)
 S LA7GUAR=1
 Q
GT1(GT1) ;
 Q:$G(LA7GUAR)
 S LA7BLG(0)="GT1"_LA7FS_"1"
 S GT1(7)=$TR($G(GT1(7)),"- ()")
 F I=0:0 S I=$O(GT1(I)) Q:'I  S $P(LA7BLG(0),LA7FS,I)=GT1(I)
 D FILESEG^LA7VHLU(GBL,.LA7BLG)
 D FILE6249^LA7VHLU(LA76249,.LA7BLG)
 Q
DG1(UID) ;
 N BDA,ORI,DX,DXE,CNT
 S CNT=0
 S ORI=$O(^BLRRLO("B",UID,0))
 Q:'ORI
 S BDA=0 F  S BDA=$O(^BLRRLO(ORI,1,BDA)) Q:'BDA  D
 . S CNT=CNT+1
 . S DX=$P($G(^BLRRLO(ORI,1,BDA,0)),U)
 . S DXE=$P($G(^ICD9(DX,0)),U)
 . S LA7BLG(0)="DG1"_LA7FS_CNT_LA7FS_"I9"_LA7FS_$G(DXE)
 . D FILESEG^LA7VHLU(GBL,.LA7BLG)
 . D FILE6249^LA7VHLU(LA76249,.LA7BLG)
 S LA7DGQ=1
 Q
 ;
ACCT(OR) ;-- get the account number and billing type string
 N ORI,ACCT,BTP,DATA
 S ORI=$O(^BLRRLO("B",OR,0))
 I '$G(ORI) Q ""
 S DATA=$G(^BLRRLO(ORI,0))
 S ACCT=$P(DATA,U,3)
 S BTP=$P(DATA,U,5)
 Q ACCT_U_U_U_BTP
 ;
SFMAP(MNE) ;-- get sliding fee scale if mnemonic is Labcorp sliding scale
 I '$G(MNE) Q ""
 I $G(MNE)=">0" Q "S10"
 I $G(MNE)=">1" Q "S15"
 I $G(MNE)="L2" Q "S20"
 I $G(MNE)=">2" Q "S25"
 I $G(MNE)="L3" Q "S30"
 I $G(MNE)=">3" Q "S35"
 I $G(MNE)="L4" Q "S40"
 I $G(MNE)=">4" Q "S45"
 I $G(MNE)="L5" Q "S50"
 I $G(MNE)=">5" Q "S55"
 I $G(MNE)="L6" Q "S60"
 I $G(MNE)=">6" Q "S65"
 I $G(MNE)="L7" Q "S70"
 I $G(MNE)=">7" Q "S75"
 I $G(MNE)="L8" Q "S80"
 I $G(MNE)=">8" Q "S85"
 I $G(MNE)="L9" Q "S90"
 I $G(MNE)=">9" Q "S95"
 I $G(MNE)="L1" Q "SXN"
 I $G(MNE)="03" Q "SSC"
 I $G(MNE)="00" Q "S00"
 Q ""
 ;
PRT(UID) ;EP -- print out insurance information on manifest
 N ORI,STR,IIEN,IEIEN,IPIEN,BTP,ORD,NINS,CNT
 S NINS=$S($P($G(^BLRSITE(DUZ(2),"RL")),U,23):$P($G(^BLRSITE(DUZ(2),"RL")),U,23),1:99)  ;number of insurances to print
 S LA7ECH="^~&\"
 S ORI=$O(^BLRRLO("ACC",UID,0))
 Q:'ORI
 S ORD=$$GET1^DIQ(9009026.3,ORI,.01,"I")
 Q:$G(^TMP($J,"LA7SMP",ORD))  ;already printed once
 S ^TMP($J,"LA7SMP",ORD)=UID
 S BTP=$$GET1^DIQ(9009026.3,ORI,.05,"I")
 D GAR(DFN,,,0)
 W !,?11,$E(LA7LINE,1,41)  ;put in a dashed line here
 D WR("Account Number: ",$$GET1^DIQ(9009026.3,ORI,.03),11,1)
 D WR("Bill Type: ",BTP,11,1)
 I $P($G(^BLRRLO(ORI,0)),U,5)="P" D  Q
 . D WR("Guarantor: ",$TR(GT1(4),"^"," "),11,1)
 . D WR("Telephone: ",GT1(7),55)
 . D WR("Guarantor Address: ",$TR(GT1(6),"^"," "),11,1)
 S CNT=0
 S BDA=0 F  S BDA=$O(^BLRRLO(ORI,2,BDA)) Q:'BDA  D
 . Q:CNT>$G(NINS)
 . S STR=$G(^BLRRLO(ORI,2,BDA,0))
 . S IIEN=$P($P(STR,"~",11),",")
 . I $P(STR,"~",10)="D" D
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCD(IIEN,0)
 . I $P(STR,"~",10)="M" D
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCR(IIEN,IEIEN,0)
 . I $P(STR,"~",10)="R" D
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCR(IIEN,IEIEN,0)
 . I $P(STR,"~",10)="P" D
 .. S IPIEN=$E($P(STR,"~",7),2,99)
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D PI(IPIEN,IEIEN,0)
 . D WR("Insurer ID: ",IN1(4),11,1)
 . I $P(STR,"~",10)="P" D
 .. D WR("Group: ",$G(IN1(9)),59)  ;ihs/cmi/maw 04/04/2011 added group to manifest
 . D WR("Insurer Name: ",$TR(IN1(5),"^"," "),11,1)
 . D WR("Telephone: ",IN1(7),55)
 . D WR("Insurer Address: ",$TR(IN1(6),"^"," "),11,1)
 . D WR("Insured Name: ",$TR(IN1(17),"^"," "),11,1)
 . D WR("Relationship: ",$S($G(IN1("18E"))]"":IN1("18E"),1:"Self"),52)
 . D WR("Insured Address: ",$TR(IN1(20),"^"," "),11,1)
 . D WR("Guarantor: ",$TR(GT1(4),"^"," "),11,1)
 . D WR("Telephone: ",GT1(7),55)
 . D WR("Guarantor Address: ",$TR(GT1(6),"^"," "),11,1)
 . D WR("Insured ID: ",IN1(37),11,1)
 . W !,?11,$E(LA7LINE,1,41)
 . D DGP(ORI)
 . S CNT=CNT+1
 Q
 ;
WR(CAP,VAL,TAB,NL) ;-- write out the line
 I $G(NL) W !
 W ?TAB,CAP,VAL
 Q
 ;
DGP(ORI) ;
 N BDA,DX,DXE,DXEE,CNT
 S CNT=0
 S BDA=0 F  S BDA=$O(^BLRRLO(ORI,1,BDA)) Q:'BDA  D
 . S CNT=CNT+1
 . S DX=$P($G(^BLRRLO(ORI,1,BDA,0)),U)
 . S DXE=$P($G(^ICD9(DX,0)),U)
 . S DXEE=$E($P($G(^ICD9(DX,0)),U,3),1,39)
 . D WR("Diagnosis: ",DXE,11,1)
 . D WR("Description: ",DXEE,30)
 Q
 ;
AO(UID) ;-- print ask at order questions/responses
 N ORI,HEAD,TB
 S ORI=$O(^BLRRLO("ACC",UID,0))
 Q:'ORI
 N ODA,DATA,ACC,QUES,ANS,RSC,LA7OBX
 S ODA=0 F  S ODA=$O(^BLRRLO(ORI,4,ODA)) Q:'ODA  D
 . S DATA=$G(^BLRRLO(ORI,4,ODA,0))
 . S ACC=$P(DATA,U,2)
 . Q:ACC'=UID
 . I '$G(HEAD) D
 .. S HEAD=1
 .. W !!,"ORDER ENTRY QUESTIONS: "
 . S QUES=$P(DATA,U,3)
 . S ANS=$P(DATA,U,4)
 . S RSC=$P(DATA,U,5)
 . D WR("",QUES,11,1)
 . S TB=$L(QUES)+3
 . D WR("   ",ANS,TB)
 K HEAD
 Q
 ;
OBX(ORD,UI) ;-- build the OBX segment for ask at order questions
 N OR
 S OR=$O(^BLRRLO("B",ORD,0))
 Q:'OR
 N ODA,DATA,ACC,QUES,ANS,RSC,LA7OBX
 S ODA=0 F  S ODA=$O(^BLRRLO(OR,4,ODA)) Q:'ODA  D
 . S DATA=$G(^BLRRLO(OR,4,ODA,0))
 . S ACC=$P(DATA,U,2)
 . Q:ACC'=UI
 . S QUES=$P(DATA,U,3)
 . S ANS=$P(DATA,U,4)
 . S RSC=$P(DATA,U,5)
 . S LA7OBX(2)="ST"
 . ;lets add code here so if quest add 3 component separators to obx if not then it goes it first piece
 . S LA7OBX(3)=U_U_U_RSC_U_QUES ; ask at order question and code
 . S LA7OBX(5)=ANS ; ask at order value/response
 . D GEN
 Q
 ;
GEN ;--  generate the OBX segment
 N LA7DATA
 ;
 S LA7OBX(0)="OBX"
 ; OBX segment id
 S LA7OBX(1)=$$OBX1^LA7VOBX(.LA7OBXSN)
 ;S LA7OBX(11)="F"
 ; Facility that performed the testing
 ;S LA7OBX(15)=$$OBX15^LA7VOBX(LA74,LA7FS,LA7ECH)
 ;
 D BUILDSEG^LA7VHLU(.LA7OBX,.LA7DATA,LA7FS)
 D FILESEG^LA7VHLU(GBL,.LA7DATA)
 D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 Q
