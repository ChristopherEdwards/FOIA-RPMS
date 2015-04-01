APCLSILI ; IHS/CMI/LAB - ILI surveillance export ; 19 Jun 2013  1:38 PM
 ;;3.0;IHS PCC REPORTS;**22,23,24,25,26,27,28,29**;FEB 05, 1997;Build 35
 ;
 ;
START ;
 ;This report will create a comma delimited output file of all visits on from March 21, 2009
 ;through the date run for which the visit meets this criteria
 ;     clinic is in SURVEILLANCE ILI CLINICS taxonomy
 ;     at least 1 POV is in SURVEILLANCE ILI taxonomy
 ;     visit is AMBULATORY, OBSERVATION, DAY SURGERY OR NURSING HOME (outpatient in service category)
 ;after the file is generated it will call sendto with ZISH SEND PARAMETER SURVEILLANCE ILI SEND
 ;
 D EN^XBVK("APCL")  ;kill all apcl variables
 S D=""
 S X=$O(^APCLCNTL("B","ILI STOP DATE",0))
 I X,$P(^APCLCNTL(X,0),U,3) S D=$P(^APCLCNTL(X,0),U,3)   ;if there is a stop date then use it
 I D,DT>D Q
 ;
 D EXIT
 ;
 ;
PROC ;EP - called from xbdbque
 S APCL1ST=""
 I $E(DT,6,7)="01" S APCL1ST=1
 ;I $P($G(^APCLILIC(1,0)),U,2) S APCL1ST=1  ;need to send data first time through after the patch is installed
 ;if this is between the 15th and 27th then check to see if the user pop export has been run
 ;if it has run since the 1st of the month then run it.
 ;get the 1st of this month
 S APCL1OM=$E(DT,1,5)_"01"
 ;get date last one finished.
 S (X,L)="" F  S X=$O(^APCLILIC(1,11,"B",X)) Q:X'=+X  S L=X
 I 'L S APCL1ST=1  ;hasn't run before after patch 27 so run it
 I 'APCL1ST,$E(DT,6,7)>14,$E(DT,6,7)<27,L<APCL1OM S APCL1ST=1  ;if last time run was before the 1st then run it
 K APCLLOCT,APCLALLT,APCLHTOT,APCLALL1
 K ^TMP($J)
 K ^APCLDATA($J)  ;export global
 S APCLCTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))  ;clinic taxonomy
 S APCLDTAX=$O(^ATXAX("B","SURVEILLANCE ILI",0))  ;dx taxonomy
 S APCLTTAX=$O(^ATXAX("B","SURVEILLANCE ILI NO TMP NEEDED",0))
 I 'APCLCTAX D EXIT Q
 I 'APCLDTAX D EXIT Q
 ;
 ;
 ;I $P($G(^APCLILIC(1,0)),U,2) S APCLSD=3090320.9999,$P(^APCLILIC(1,0),U,2)="" I 1
 I '$P($G(^APCLILIC(1,0)),U,4) S APCLSD=3081231.9999,$P(^APCLILIC(1,0),U,4)=1,APCLBDAT=3090101,APCLFLF=1,APCL1ST=1 I 1
 E  S APCLSD=$$FMADD^XLFDT(DT,-91)_".9999",APCLBDAT=$$FMADD^XLFDT(DT,-90)
 S APCLED=$$FMADD^XLFDT(DT,-1)
 S APCLZHSD=DT
EP1 ;EP - called from on demand option
 I $G(APCLWEXP)="P" G MONUP
 S APCLVTOT=0
 S APCLBT=$H
 F  S APCLSD=$O(^AUPNVSIT("B",APCLSD)) Q:APCLSD'=+APCLSD!($P(APCLSD,".")>APCLED)  D
 .;W:'$D(ZTQUEUED) ".",$$FMTE^XLFDT(APCLSD)
 .S APCLV=0 F  S APCLV=$O(^AUPNVSIT("B",APCLSD,APCLV)) Q:APCLV'=+APCLV  D
 ..Q:'$D(^AUPNVSIT(APCLV,0))
 ..Q:$P(^AUPNVSIT(APCLV,0),U,11)
 ..S DFN=$P(^AUPNVSIT(APCLV,0),U,5)
 ..Q:DFN=""
 ..Q:'$D(^DPT(DFN,0))
 ..Q:$P(^DPT(DFN,0),U)["DEMO,PATIENT"
 ..Q:$$DEMO^APCLUTL(DFN,"E")
 ..S G=0,X=0 F  S X=$O(^BGPSITE(X)) Q:X'=+X  I $P($G(^BGPSITE(X,0)),U,12) I $D(^DIBT($P(^BGPSITE(X,0),U,12),1,DFN)) S G=1
 ..Q:G
 ..S APCLKV=0,APCLH1N1=0,(APCLILI,APCLHVAC,APCLIVAC,APCLADVE,APCLSRD,APCLAVM,APCLAV9)=""
 ..S APCLLOC=$P(^AUPNVSIT(APCLV,0),U,6)  Q:APCLLOC=""
 ..S APCLDATE=$P($P(^AUPNVSIT(APCLV,0),U),".")
 ..S APCLASUF=$P($G(^AUTTLOC(APCLLOC,0)),U,10)
 ..Q:APCLASUF=""  ;NO ASUFAC SO SKIP VISIT
 ..S ^TMP($J,"APCLALL1",APCLASUF,APCLDATE)=""
 ..I "AORS"[$P(^AUPNVSIT(APCLV,0),U,7) S ^TMP($J,"APCLALLT",APCLASUF,APCLDATE)=$G(^TMP($J,"APCLALLT",APCLASUF,APCLDATE))+1   ;total number of visits 
 ..;keep visit?
 ..S G=0 D ILIDX I G S APCLKV=1,APCLILI=G
 ..S G=0 D H1N1DX I G S APCLKV=1,APCLH1N1=G
 ..S APCLHVAC=$$HASVAC(APCLV) I APCLHVAC S APCLKV=1
 ..S APCLIVAC=$$HASIVAC(APCLV) I APCLIVAC S APCLKV=1
 ..S APCLPVAC=$$HASPVAC^APCLSIL4(APCLV) I APCLPVAC S APCLKV=1
 ..I APCLIVAC!(APCLHVAC) S APCLADVE=$$HASADVN6^APCLSIL4(APCLV,$P(APCLIVAC,U,5),$P(APCLHVAC,U,5))  ;this was changed in patch 29 to only put on flu/h1n1 vaccine records
 ..S APCLOVAC="" I APCLADVE!(APCLPVAC) S APCLOVAC=$$OTHVAC^APCLSIL1(DFN,APCLDATE)
 ..S APCLSRD=$$HASSRD7(APCLV) I APCLSRD S APCLKV=1
 ..S APCLAVM=$$HASAVM(APCLV) I APCLAVM S APCLKV=1
 ..;S APCLAV9=$$HASAV9(APCLV) I APCLAV9 S APCLKV=1
 ..S APCLPCVF="" I APCLPVAC S APCLPCVF=$$PCVFEB^APCLSIL4(APCLV,$P(APCLPVAC,U,5))
 ..S APCLPCVE="" I APCLPVAC S APCLPCVE=$$PCVECPEH^APCLSIL4(APCLV,$P(APCLPVAC,U,5))
 ..S APCLPCVA="" I APCLPVAC S APCLPCVA=$$PCVANGIO^APCLSIL4(APCLV,$P(APCLPVAC,U,5))
 ..S APCLPCVS="" I APCLPVAC S APCLPCVS=$$PCVASTH^APCLSIL4(APCLV,$P(APCLPVAC,U,5))
 ..S APCLPCVI="" I APCLPVAC S APCLPCVI=$$PCVIMMUN^APCLSIL4(APCLV,$P(APCLPVAC,U,5))
 ..I 'APCLKV Q  ;not a visit to export
 ..D SETREC^APCLSIL2  ;set record
 ;NOW SET TOTAL IN PIECE 13
 S X=0 F  S X=$O(^APCLDATA($J,X)) Q:X'=+X  D
 .I $P(^APCLDATA($J,X),",",8)="" Q  ;not an ILI visit
 .Q:$P(^APCLDATA($J,X),",",15)="H"  ;not ambulatory
 .S L=$P(^APCLDATA($J,X),",",6),D=$P(^APCLDATA($J,X),",",7)
 .S $P(^APCLDATA($J,X),",",13)=+$G(^TMP($J,"APCLLOCT",L,D))
 .Q
 ;NOW SET TOTAL IN PIECE 20
 S X=0 F  S X=$O(^APCLDATA($J,X)) Q:X'=+X  D
 .Q:$P(^APCLDATA($J,X),",",15)'="H"
 .I $P(^APCLDATA($J,X),",",8)="",$P(^APCLDATA($J,X),U,43)=""  ;not an ILI or H1N1 visit
 .S L=$P(^APCLDATA($J,X),",",6),D=$P(^APCLDATA($J,X),",",7)
 .S $P(^APCLDATA($J,X),",",20)=+$G(^TMP($J,"APCLHTOT",L,D))
 .Q
 ;NOW SET TOTAL IN PIECE 42
 S X=0 F  S X=$O(^APCLDATA($J,X)) Q:X'=+X  D
 .Q:$P(^APCLDATA($J,X),",",15)="H"
 .I $P(^APCLDATA($J,X),",",43)="" Q    ;not an H1N1/ili visit
 .S L=$P(^APCLDATA($J,X),",",6),D=$P(^APCLDATA($J,X),",",7)
 .S $P(^APCLDATA($J,X),",",42)=+$G(^TMP($J,"APCLALLT",L,D))
 .Q
 ;NOW SET A RECORD FOR EACH DATE and populate 13, 20, 42
 ;NOW SEND A RECORD FOR EACH APCLALLT, SET PIECE 42,DATE AND LOCATION ONLY
 ;NOW SET A ZERO FOR EVERY DAY IN THE TIME PERIOD FOR EACH LOCATION IF IT DOESN'T EXIST
 S APCLSD=$$FMADD^XLFDT(APCLBDAT,-1)
 S L="" F  S L=$O(^TMP($J,"APCLALL1",L)) Q:L=""  D
 .S D=APCLSD
 .F  S D=$$FMADD^XLFDT(D,1) Q:D>APCLED  D
 ..I '$D(^TMP($J,"APCLALL1",L,D)) S ^TMP($J,"APCLALL1",L,D)=0
 ;now reorder by date
 S L="" F  S L=$O(^TMP($J,"APCLALL1",L)) Q:L=""  S D="" F  S D=$O(^TMP($J,"APCLALL1",L,D)) Q:D=""  S ^TMP($J,"APCLX",D,L)=^TMP($J,"APCLALL1",L,D)
 S X=0,C=0 F  S X=$O(^APCLDATA($J,X)) Q:X'=+X  S L=X
 S C=L
 S D="" F  S D=$O(^TMP($J,"APCLX",D)) Q:D=""  D
 .S L="" F  S L=$O(^TMP($J,"APCLX",D,L)) Q:L=""  D
 ..S C=C+1
 ..S ^APCLDATA($J,C)="" D
 ...S $P(^APCLDATA($J,C),",",6)=L,$P(^APCLDATA($J,C),",",7)=D
 ...S $P(^APCLDATA($J,C),",",42)=+$G(^TMP($J,"APCLALLT",L,D))
 ...S $P(^APCLDATA($J,C),",",13)=+$G(^TMP($J,"APCLLOCT",L,D))
 ...S $P(^APCLDATA($J,C),",",20)=+$G(^TMP($J,"APCLHTOT",L,D))
 D ILI^APCLSIHL("ILI")  ;parse out the APCLDATA global and create a message from it
 K ^APCLDATA($J),^TMP($J)
MONUP ;monthly user pop if today is the 1st
 I $G(APCL1ST) D
 .;create entry with start date of DT
 . N APCLFDA,APCLIENS,APCLERR
 . S APCLIENS="+2,"_1_","
 . S APCLFDA(9001003.311,APCLIENS,.01)=DT
 . D UPDATE^DIE("","APCLFDA","APCLIENS","APCLERR(1)")
 . ;I $D(APCLERR) S APCLER="0~Add Education Topic" Q
 . S APCLEIEN=$G(APCLIENS(2))
 . D MONUP^APCLSIL1
 . ;ADD END DATE TO MULTIPLE
 . S $P(^APCLILIC(1,11,APCLEIEN,0),U,2)=DT
 D PURGE
 D EXIT
 Q
HASVAC(V) ;EP - get h1n1 vaccine
 NEW C,X,Y,Z,T,L,M
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 CVX CODES",0))
 S C=0,X=0 F  S X=$O(^AUPNVIMM("AD",V,X)) Q:X'=+X!(C)  S Y=$P($G(^AUPNVIMM(X,0)),U) D
 .Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Z=$P(^AUTTIMM(Y,0),U,3)
 .Q:'$D(^ATXAX(T,21,"B",Z))
 .S C=1_U_Z_U_$$VAL^XBDIQ1(9000010.11,X,.05) I $P(^AUPNVIMM(X,0),U,5),$D(^AUTTIML($P(^AUPNVIMM(X,0),U,5),0)) S C=C_U_$$VAL^XBDIQ1(9999999.41,$P(^AUPNVIMM(X,0),U,5),.02)
 .S Z=$$VALI^XBDIQ1(9000010.11,X,1201)
 .S $P(C,U,5)=$S(Z:$P(Z,".",1),1:$$VD^APCLV(V))
 .Q
 I C Q C
 S T=$O(^ATXAX("B","SURVEILLANCE CPT H1N1",0))
 S C=0,X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVCPT(X,0)),U) D
 .Q:'Y
 .Q:'$$ICD^ATXCHK(Y,T,1)
 .S C=1_U_$$VAL^XBDIQ1(9000010.18,X,.01)
 Q C
HASIVAC(V) ;EP - get flu iz
 NEW C,X,Y,Z,T
 S T=$O(^ATXAX("B","SURVEILLANCE FLU CVX CODES",0))
 S C=0,X=0 F  S X=$O(^AUPNVIMM("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVIMM(X,0)),U) D
 .Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Z=$P(^AUTTIMM(Y,0),U,3)
 .Q:'$D(^ATXAX(T,21,"B",Z))
 .;get lot and manufacturer
 .S C=1_U_Z_U_$$VAL^XBDIQ1(9000010.11,X,.05) I $P(^AUPNVIMM(X,0),U,5),$D(^AUTTIML($P(^AUPNVIMM(X,0),U,5),0)) S C=C_U_$$VAL^XBDIQ1(9999999.41,$P(^AUPNVIMM(X,0),U,5),.02)
 .S Z=$$VALI^XBDIQ1(9000010.11,X,1201)
 .S $P(C,U,5)=$S(Z:$P(Z,".",1),1:$$VD^APCLV(V))
 .Q
 I C Q C
 S T=$O(^ATXAX("B","SURVEILLANCE CPT FLU",0))
 S C=0,X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVCPT(X,0)),U) D
 .Q:'Y
 .Q:'$$ICD^ATXCHK(Y,T,1)
 .S C=1_U_$$VAL^XBDIQ1(9000010.18,X,.01)
 I C Q C
 S T=$O(^ATXAX("B","BGP FLU IZ PROCEDURES",0))
 S C=0,X=0 F  S X=$O(^AUPNVPRC("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVPRC(X,0)),U) D
 .Q:'Y
 .Q:'$$ICD^ATXCHK(Y,T,0)
 .S C=1_U_$$VAL^XBDIQ1(9000010.08,X,.01)
 I C Q C
 S T=$O(^ATXAX("B","BGP FLU IZ DXS",0))
 S C=0,X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVPOV(X,0)),U) D
 .Q:'Y
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S C=1_U_$$VAL^XBDIQ1(9000010.07,X,.01)
 I C Q C
 Q C
ILIDX ;
 Q:"AORSH"'[$P(^AUPNVSIT(APCLV,0),U,7)
 I $P(^AUPNVSIT(APCLV,0),U,7)="H" S ^TMP($J,"APCLHTOT",APCLASUF,APCLDATE)=$G(^TMP($J,"APCLHTOT",APCLASUF,APCLDATE))+1
 S APCLCLIN=$$CLINIC^APCLV(APCLV,"I")  ;get clinic code
 S X=0,P=0 F  S X=$O(^AUPNVPRV("AD",APCLV,X)) Q:X'=+X!(P)  D
 .Q:'$D(^AUPNVPRV(X,0))
 .S Y=$P(^AUPNVPRV(X,0),U)
 .S Z=$$VALI^XBDIQ1(200,Y,53.5)
 .Q:'Z
 .I $P($G(^DIC(7,Z,9999999)),U,1)=13 S P=1
 I P G ILIDX1
 I $P(^AUPNVSIT(APCLV,0),U,7)'="H" Q:APCLCLIN=""
 I $P(^AUPNVSIT(APCLV,0),U,7)'="H" Q:'$D(^ATXAX(APCLCTAX,21,"B",APCLCLIN))  ;not in clinic taxonomy
ILIDX1 ;
 I $P(^AUPNVSIT(APCLV,0),U,7)'="H" S ^TMP($J,"APCLLOCT",APCLASUF,APCLDATE)=$G(^TMP($J,"APCLLOCT",APCLASUF,APCLDATE))+1   ;total number of visits
 ;CHECK SURVEILLANCE ILI NO TMP NEEDED FIRST
 ;THEN CHECK SURVEILLANCE ILI AND SEE IF TMP >=100
 S C=0
 K G,Y,Z S G="",Z=""
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X  D
 .S T=$P(^AUPNVPOV(X,0),U)
 .I $$ICD^ATXCHK(T,APCLTTAX,9) S C=C+1,Y(C)=$$VAL^XBDIQ1(9000010.07,X,.01) Q
 .I $$ICD^ATXCHK(T,APCLDTAX,9),$$TMP100(APCLV) S C=C+1,Y(C)=$$VAL^XBDIQ1(9000010.07,X,.01)
 Q:'$D(Y)
 S X=0 F  S X=$O(Y(X)) Q:X'=+X  S G=G_U_Y(X)
 S $P(G,U,1)=1
 Q
TMP100(V) ;EP
 NEW %,M,J
 S %=""
 S M=0 F  S M=$O(^AUPNVMSR("AD",V,M)) Q:M'=+M  D
 .Q:$P($G(^AUPNVMSR(M,2)),U,1)  ;ENTERED IN ERROR
 .Q:$$VAL^XBDIQ1(9000010.01,M,.01)'="TMP"
 .S J=$P(^AUPNVMSR(M,0),U,4)
 .Q:J<100
 .S %=1
 Q %
 ;
H1N1DX ;
 Q:"AORSH"'[$P(^AUPNVSIT(APCLV,0),U,7)  ;just want outpatient with dx
 S APCLCLIN=$$CLINIC^APCLV(APCLV,"I")
 S G=0
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X!(G)  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE H1N1 DX",0)),9) S G=1,D=$$VAL^XBDIQ1(9000010.07,X,.01)
 Q:'G
 S G=1_U_D
 Q
HASSRD7(APCLV) ;EP
 NEW X,P,D,Y,Z,APCLCLIN,T,G,C
 I "AORSH"'[$P(^AUPNVSIT(APCLV,0),U,7) Q ""  ;just want outpatient with dx
 S C=0
 K G,Y S G=""
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE SEV RESP DIS DXS",0)),9) S C=C+1,Y(C)=$$VAL^XBDIQ1(9000010.07,X,.01)
 I '$D(Y) Q ""
 S X=0 F  S X=$O(Y(X)) Q:X'=+X  S G=G_U_Y(X)
 S $P(G,U,1)=1
 Q G
HASAVM(V) ;EP
 NEW C,X,Y,Z,T,L,M,N
 S T=$O(^ATXAX("B","FLU ANTIVIRAL MEDS",0))
 S C="",X=0 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X!(C)  S Y=$P($G(^AUPNVMED(X,0)),U) D
 .Q:'Y
 .Q:'$D(^PSDRUG(Y,0))
 .S Z=0
 .S N=$P(^PSDRUG(Y,0),U)
 .I $D(^ATXAX(T,21,"B",Y)) S Z=1
 .I N["OSELTAMIVIR" S Z=1
 .I N["ZANAMIVIR" S Z=1
 .I N["RIMANTADINE" S Z=1
 .I N["AMANTADINE" S Z=1
 .I Z=1 S C=1_U_N_U_$P(^AUPNVMED(X,0),U,7)
 .Q
 Q C
WRITE ; use XBGSAVE to save the temp global (APCLDATA) to a delimited
 ; file that is exported to the IE system
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBGL="APCLDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="ILI SURVEILLANCE EXPORT"
 S APCLASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="FLU_"_APCLASU_"_"_$$DATE(DT)_".txt"
 S XBS1="SURVEILLANCE ILI SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT ILI file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT ILI file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to IHS/CDC",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 ;SET LOG MULTIPLE
 K ^APCLDATA($J)
 D SET^APCLSIL4
 Q
 ;
DATE(D) ;EP
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
JDATE(D) ;EP - get date
 I $G(D)="" Q ""
 NEW A
 S A=$$FMTE^XLFDT(D)
 Q $E(D,6,7)_$$UP^XLFSTR($P(A," ",1))_(1700+$E(D,1,3))
 ;
UID(APCLA) ;Given DFN return unique patient record id.
 I '$G(APCLA) Q ""
 I '$D(^AUPNPAT(APCLA)) Q ""
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(APCLA))_APCLA
 ;
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
 ;
EP ;EP - called from option to create search template using ILI logic
 G ^APCLSIL3
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
STOPD ;EP
 D STOPD^APCLSIL3
 Q
PURGE ;
 D PURGE^APCLSIL3
