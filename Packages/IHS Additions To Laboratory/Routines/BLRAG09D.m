BLRAG09D ; IHS/MSC/SAT - SUPPORT FOR LABORATORY ACCESSION GUI RPCS ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1031,1034**;NOV 01, 1997;Build 88
 ;
 ;screen formatted text for manifest display
DEVT(BLRTXT,LA7SCFG,LA7SM,BLRIOM,BLRIOSL) ; collect manifest text for terminal display
 ;INPUT:
 ; LA7SCFG = Shipping Configuration pointer to file 62.9
 ; LA7SM   = Manifest pointer to file 62.8
 ; BLRIOM  = page width character count; defaults to 132
 ; BLRIOSL = page line count; defaults to 51
 ;RETURNS:
 ; Array of Text of Manifest display. Each line is an entry in the array.
 ;  BLRMTXT(COUNT)=TEXT
 N BLRI,BLRY
 S BLRI=0
 S BLRY=0
 S LA7SM(0)=$G(^LAHM(62.8,+LA7SM,0))
 S LA7SM=LA7SM_U_$P(LA7SM(0),U,1)
 Q:LA7SM(0)=""
 K ^TMP("BLRSM",$J) ;SAT NOV 16, 2012
 S:$P(LA7SM,U,2)'="" LA7SM=+LA7SM_U_$P(LA7SM(0),U,1)
 S LA7SCFG=+$P(LA7SM(0),"^",2),LA7SCFG(0)=$G(^LAHM(62.9,+$G(LA7SCFG),0))
 S (LA7DC,LA7EXIT,LA7END,LA7ITEM,LA7PAGE,LA7SMR,LA760,LA762801)=0
 S (LA7FSITE,LA7TSITE)=""
 D INIT^BLRAG09E
 S:'$G(BLRIOM) BLRIOM=132  ;default to 132 columns
 S:'$G(BLRIOSL) BLRIOSL=51
 ; Determine if bar codes on manifest
 S LA7SBC=$$GET1^DIQ(62.9,+LA7SCFG_",",.09,"I")
 ; If not in shipping status then don't print, save paper
 I $P($G(^LAHM(62.8,+LA7SM,0)),"^",3)<4 S LA7SBC=0
 ;
 ; Get collecting site's names and station numbers
 D GETSITE($P(LA7SCFG(0),"^",2),$P(LA7SCFG(0),"^",3),.LA7FSITE,.LA7TSITE)
 ;
 ; Flag - skip if accession deleted
 S LA7SKIP=0
 ; Check manifest for missing info.
 I $G(LA7CHK)="" S LA7CHK=1
 ;
 S LA7NOW=$$HTE^XLFDT($H,"1M")
 ; Manifest status
 S LA7SMST=$P(LA7SM(0),"^",3)
 I LA7SMST=4 D
 . ; Get shipping date
 . S LA7SDT=$$SMED^LA7SMU(LA7SM,"SM05")
 . ; Flag to print receipt.
 . ;I IOST["P-" S LA7SMR=$P(LA7SCFG(0),"^",10)
 ;
 ; Set barcode flag to "off"
 ;I LA7SBC,IOST'["P-" S LA7SBC=0
 ;
 S $P(LA7SMST,"^",2)=$$EXTERNAL^DILFD(62.8,.03,"",LA7SMST)
 S LA7LINE="",$P(LA7LINE,"-",80)=""
 S LA7SVIA=$S($P(LA7SM(0),"^",4):$$GET1^DIQ(62.92,$P(LA7SM(0),"^",4)_",",.01),1:"None Specified")
 ;
 F  S LA762801=$O(^LAHM(62.8,+LA7SM,10,LA762801)) Q:'LA762801  D
 . F I=0,1,2 S LA762801(I)=$G(^LAHM(62.8,+LA7SM,10,LA762801,I))
 . I $P(LA762801(0),"^",8)=0 Q  ; Test previously "removed".
 . S LA7SKIP=$$CHKTST^LA7SMU(+LA7SM,LA762801)
 . I LA7SKIP,LA7SKIP<3 Q  ; Accession/test deleted
 . I $G(LA7CHK) D CHKREQI^LA7SM2(+LA7SM,LA762801)
 . ;S ^TMP("BLRSM",$J,+$P(LA762801(0),"^",7),+$P(LA762801(0),"^",9),$P(LA762801(0),"^",5),LA762801)=""  ;ihs/cmi/maw 8/4/2010 orig line
 . S ^TMP("BLRSM",$J,+$P(LA762801(0),"^",7),+$P(LA762801(0),"^"),$P(LA762801(0),"^",5),LA762801)=""  ;ihs/cmi/maw 8/4/2010 changed sort to LRDFN from Packaging container
 . ;S ^TMP("BLRSM",$J,+$P(LA762801(0),"^",7),+$P(LA762801(0),"^"),$$GETORDA^LA7VORM1($P(LA762801(0),"^",5)),LA762801)=""  ;ihs/cmi/maw 8/4/2010 changed sort to LRDFN from Packaging container
 . D BUILDRI^LA7SM2
 ;
 S (LA7SCOND,LA7SCONT,LA7PROV,LA7UID)=""
 ;
 I '$D(^TMP("BLRSM",$J)) D
 . D HED^BLRAG09E
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$CJ^XLFSTR("No entries to print",BLRIOM)
 ;
 S BLRS3="" F  S BLRS3=$O(^TMP("BLRSM",$J,BLRS3)) Q:BLRS3=""  D  Q:LA7EXIT
 .S BLRS4="" F  S BLRS4=$O(^TMP("BLRSM",$J,BLRS3,BLRS4)) Q:BLRS4=""  D  Q:LA7EXIT
 ..S BLRS5="" F  S BLRS5=$O(^TMP("BLRSM",$J,BLRS3,BLRS4,BLRS5)) Q:BLRS5=""  D  Q:LA7EXIT
 ...S BLRS6="" F  S BLRS6=$O(^TMP("BLRSM",$J,BLRS3,BLRS4,BLRS5,BLRS6)) Q:BLRS6=""  D  Q:LA7EXIT
 ....I LA7EXIT Q
 ....I $L(LA7UID),LA7UID'=BLRS5 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=LA7LINE
 ....I LA7SCOND'=BLRS3!(LA7SCONT'=BLRS4) D  Q:LA7EXIT
 .....I $L(LA7UID),LA7UID=BLRS5 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=LA7LINE
 .....I LA7PAGE,+LA7SMST'=4 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="" D WARN^BLRAG09E
 .....S LA7SCOND=BLRS3,LA7SCONT=BLRS4
 .....D HED^BLRAG09E S LA7UID=""
 ....S LA762801=BLRS6
 ....F I=0,.1,2,5 S LA762801(I)=$G(^LAHM(62.8,+LA7SM,10,LA762801,I))
 ....S LA760=+$P(LA762801(0),"^",2) ; File #60 test ien
 ....I LA7UID'=BLRS5 D  Q:LA7EXIT
 .....S LA7UID=BLRS5
 .....Q:'+$G(LA762801(0))
 .....S LRDFN=+LA762801(0) D PTID^LA7SMP0
 .....S BLRC3=LA7UID
 .....S BLRC4="" F  S BLRC4=$O(^LRO(68,"C",BLRC3,BLRC4)) Q:BLRC4=""  D
 ......S BLRC5="" F  S BLRC5=$O(^LRO(68,"C",BLRC3,BLRC4,BLRC5)) Q:BLRC5=""  D
 .......S BLRC6="" F  S BLRC6=$O(^LRO(68,"C",BLRC3,BLRC4,BLRC5,BLRC6)) Q:BLRC6=""  D
 ........I LA7UID'=BLRC3 S LA7SKIP=1 ; Skip - UID missing.
 ........S LA7AA=+BLRC4,LA7AD=+BLRC5,LA7AN=+BLRC6
 ........S LA7SKIP=$$CHKTST^LA7SMU(+LA7SM,LA762801)
 ........I LA7SKIP,LA7SKIP<3 Q  ; Skip - accession/test deleted.
 ........S LA7ACC=$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,.2),"Accession not available"),"^")
 ........S X=$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,0),"Not available"),U,8)
 ........S LA7PROV=$S(X>0:X,1:"")_"^"_$S(X>0:$$PRAC^LRX(X),1:X)
 ........S LA7CDT=$P($G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,3),"Not available"),U,1)
 ........S LA7SPEC=$G(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,5,1,0),"Not available")
 ........I LA7SPEC S LA7SPEC(0)=$G(^LAB(61,+LA7SPEC,0))
 ........E  S LA7SPEC(0)="Specimen info not assigned"
 ........S LA762=$P(LA7SPEC,"^",2)
 ........I LA762 S LA762(0)=$G(^LAB(62,LA762,0))
 ........E  S LA762(0)="Collection info not assigned"
 ........S LA7ITEM=LA7ITEM+1
 ........I (BLRY+12)>BLRIOSL D  Q:LA7EXIT
 .........S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 .........I +LA7SMST'=4 D WARN^BLRAG09E
 .........D HED^BLRAG09E
 ........D SH^BLRAG09E
 ....I LA7SKIP,LA7SKIP<3 Q  ; Skip - accession/test deleted.
 ....I (BLRY+6)>BLRIOSL D  Q:LA7EXIT
 .....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=LA7LINE
 .....I +LA7SMST'=4 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="" D WARN^BLRAG09E
 .....D HED^BLRAG09E Q:LA7EXIT
 .....S LA7DC=1 D SH^BLRAG09E
 ....;cmi/maw 7/6/2010 add insurance information here
 ....D PRT(LA7UID)   ;PRT^LA7VQINS
 ....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(10)_$E(LA7LINE,1,41)
 ....S BLRTXT=$$FILL^BLRAGUT(10)_$P($G(^LAB(60,LA760,0)),"^",1)
 ....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=BLRTXT_$$FILL^BLRAGUT(42-$L(BLRTXT))_$S($P($G(LA7SPEC(0)),"^",1)'="":$P(LA7SPEC(0),"^"),1:"")
 ....I +LA7SMST'=4 D
 .....N LA7TCOST
 .....S LA7TCOST=$$GET1^DIQ(60,LA760_",",1,"E") Q:'$L(LA7TCOST)
 .....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 .....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(BLRIOM-15)_" Cost: $"_$FN(LA7TCOST,",",2)
 ....I LA762801(.1)'="" D
 .....K ^UTILITY($J),LA7CMT
 .....S DIWL=1,DIWR=BLRIOM-13,DIWF=""
 .....S X="Relevant clinical information: "_LA762801(.1) D ^DIWP
 .....M LA7CMT=^UTILITY($J,"W",DIWL)
 .....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 .....D CMT^BLRAG09E S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""   ;CMT^LA7SMP0
 ....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 ....D OCMT^BLRAG09E(LA7UID) S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""  ;OCMT^LA7SMP0
 ....I $P(LA7SM(0),"^",5) D  ; Print non-VA test code info
 .....N LA7X,LA7Y,LA7Z
 .....S LA7X=$P($G(^DIC(4,+$P(LA7SCFG(0),"^",3),0),"UNKNOWN"),"^",1)_" Order Code [Name]: "
 .....S BLRTXT=$$FILL^BLRAGUT(10)_LA7X_$S($L($P(LA762801(5),"^")):$P(LA762801(5),"^"),1:"*** None specified ***")_" "
 .....S LA7Y="["_$S($L($P(LA762801(5),"^",2)):$P(LA762801(5),"^",2),1:"*** None specified ***")_"]"
 .....I $L(LA7Y)<(BLRIOM-$L(BLRTXT)) D  Q
 ......S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=BLRTXT_LA7Y
 ......D AO(LA7UID)  ;AO^LA7VQINS
 .....S LA7X=BLRIOM-$L(BLRTXT) S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=BLRTXT_$E(LA7Y,1,LA7X)
 .....;lets try adding ask at order questions here
 .....D AO(LA7UID)   ;AO^LA7VQINS
 .....S LA7Y=$E(LA7Y,LA7X+1,$L(LA7Y)),LA7Z=BLRIOM-11
 .....F  S LA7X=$E(LA7Y,1,LA7Z) Q:LA7X=""  S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(10)_LA7X S LA7Y=$E(LA7Y,LA7Z+1,$L(LA7Y))
 ;
 I LA7EXIT Q
 ;
 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=LA7LINE
 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="End of Shipping Manifest"
 ;
 I +LA7SMST'=4 D
 . I BLRIOM<131 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 . D WARN^BLRAG09E
 ;
 ; Print shipping manifest receipt.
 I LA7SMR D
 . ; Flag that we're now printing receipt
 . S $P(LA7SMR,"^",2)=1
 . D HED^BLRAG09E
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="Number of specimens: "_LA7ITEM
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="Receipted by: "_$$REPEAT^XLFSTR("_",40)
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="   Date/time: "_$$REPEAT^XLFSTR("_",20)
 ;
 ; Print error listing if any.
 I $O(LA7ERR(""))'="" D
 .S $P(LA7SMR,"^",2)=2 ; Flag printing of error listing
 .D HED^BLRAG09E
 .S LA7I=0
 .F  S LA7I=$O(LA7ERR(LA7I)) Q:LA7I=""  D  Q:LA7EXIT
 ..I (BLRY+6)>BLRIOSL D HED^BLRAG09E Q:LA7EXIT
 ..S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=LA7ERR(LA7I)
 ..S BLRS3=LA7I
 ..S BLRS4=$P(LA7SM,"^",1)
 ..S BLRS5="" F  S BLRS5=$O(^TMP("LA7ERR",$J,BLRS3,BLRS4,BLRS5)) Q:BLRS5=""  D  Q:LA7EXIT
 ...S BLRS6="" F  S BLRS6=$O(^TMP("LA7ERR",$J,BLRS3,BLRS4,BLRS5,BLRS6)) Q:BLRS6=""  D  Q:LA7EXIT
 ....I (BLRY+6)>BLRIOSL D HED^BLRAG09E Q:LA7EXIT  S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=LA7ERR(LA7I)_" (Cont'd)"
 ....;S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(9)_"UID: "_BLRS5_"  Test: "_$$GET1^DIQ(60,BLRS6_",",.01)
 ....S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(9)_"UID: "_BLRS5_"  Test: "_$$TESTNAME^BLRAGUT(+BLRS6)
 ...S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 ...S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 ;
 D KILL^LA7SMP0
 K ^TMP("BLRSM",$J)  ;SAT NOV 16, 2012
 Q
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
 D GAR^LA7VQINS(DFN,,,0)
 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(10)_$E(LA7LINE,1,41)  ;put in a dashed line here
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
 .. D MCD^LA7VQINS(IIEN,0)
 . I $P(STR,"~",10)="M" D
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCR^LA7VQINS(IIEN,IEIEN,0)
 . I $P(STR,"~",10)="R" D
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D MCR^LA7VQINS(IIEN,IEIEN,0)
 . I $P(STR,"~",10)="P" D
 .. S IPIEN=$E($P(STR,"~",7),2,99)
 .. S IEIEN=$P($P(STR,"~",11),",",3)
 .. D PI^LA7VQINS(IPIEN,IEIEN,0)
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
 . S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT(10)_$E(LA7LINE,1,41)
 . D DGP(ORI)
 . S CNT=CNT+1
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
 .. S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 .. S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)="ORDER ENTRY QUESTIONS: "
 . S QUES=$P(DATA,U,3)
 . S ANS=$P(DATA,U,4)
 . S RSC=$P(DATA,U,5)
 . D WR("",QUES,11,1)
 . S TB=$L(QUES)+3
 . D WR("   ",ANS,TB)
 K HEAD
 Q
 ;
WR(CAP,VAL,TAB,NL) ;-- write out the line
 I $G(NL) S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=""
 S BLRI=BLRI+1,BLRY=BLRY+1 S BLRTXT(BLRI)=$$FILL^BLRAGUT($S(+$G(TAB):TAB-1,1:""))_$G(CAP)_$G(VAL)
 Q
 ;
DGP(ORI) ;
 N BDA,DX,DXE,DXEE,CNT
 S CNT=0
 S BDA=0 F  S BDA=$O(^BLRRLO(ORI,1,BDA)) Q:'BDA  D
 . S CNT=CNT+1
 . S DX=$P($G(^BLRRLO(ORI,1,BDA,0)),U)
 . S DXE=$P($G(^ICD9(DX,0)),U)
 . ; S DXEE=$E($P($G(^ICD9(DX,0)),U,3),1,39)
 . S DXEE=$E($$DIAGICD^BLRAG07(DX),1,39)    ; IHS/MSC/MKK - LR*5.2*1034
 . D WR("Diagnosis: ",DXE,11,1)
 . D WR("Description: ",DXEE,30)
 Q
 ;
GETSITE(LA7X,LA7Y,LA7FS,LA7TS) ; Setup variables for ordering and host sites
 ;
 ; Call with  LA7X = File #4 ordering site ien
 ;            LA7Y = File #4 host site ien
 ;            LA7FS = array to return collecting site info
 ;            LA7TS = array to return host site info
 ;
 ; Get ordering site's names and station numbers
 S LA7FS=$$GET1^DIQ(4,LA7X_",",.01)
 I LA7FS="" S LA7FS="UNKNOWN:Entry #"_+LA7X
 S LA7FS(99)=$$RETFACID^LA7VHLU2(LA7X,2,1)
 I LA7FS(99)="" S LA7FS(99)="UNK: #"_+LA7X
 ;
 ; Get host site's names and station numbers
 S LA7TS=$$GET1^DIQ(4,LA7Y_",",.01)
 I LA7TS="" S LA7TS="UNKNOWN:Entry #"_+LA7Y
 S LA7TS(99)=$$RETFACID^LA7VHLU2(LA7X,1,1)
 I LA7TS(99)="" S LA7TS(99)="UNK: #"_+LA7Y
 Q
