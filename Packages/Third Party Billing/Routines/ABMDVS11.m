ABMDVS11 ; IHS/ASDST/DMJ - PCC VISIT STUFF, LABORATORY ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;Original;JLG
 ;New version to get the CPT codes etc out of V LAB file.
 ;
 ;note: Lab CPT file must be populated with cpt data
 ;
 ;IHS/DSD/JLG - 05/21/98 -  NCA-0598-180077
 ;             Modified to set correspond diagnosis if only one POV
 ;IHS/DSD/MRS - 08/13/99 - NOIS XFA-0498-200014 Patch 3 #9
 ;             Modified to get revenue code from file 81 or 81.1
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ;
 Q:ABMIDONE
START ;START HERE
 D LAB("^AUPNVLAB")    ;Chem and hema
 D LAB("^AUPNVMIC")    ;Micro
 D LAB("^AUPNVPTH")    ;Pathology
 D LAB("^AUPNVBB")     ;Blood Bank
 D LAB("^AUPNVCYT")    ;Cyto (does not actually exist as of 10/11/96)
 Q
 ;
LAB(VFILE) ;VFILE is the V file global name
 ;This subrtn goes thru the visits in the V file 
 ;The info that is needed is CPT code, revenue code from CPT string,
 ;units, and charge.  Units should always be 1.  Charge is from the
 ;fee schedule file
 N L,T,L11,L12,COLDATE,ORDPROV,CPTSTR,CPT,MODIFIER,FILEN
 S L=0 F  S L=$O(@VFILE@("AD",ABMVDFN,L)) Q:'L  D
 .;T first piece is test, S is site
 .S T=$G(@VFILE@(+L,0)) Q:'T
 .S L11=$G(@VFILE@(L,11))
 .Q:"OAD"[$P(L11,U,9)         ;Is the test verified
 .Q:$P(L11,U,11)=0             ;Make sure it is billable
 .S L12=$G(@VFILE@(L,12))
 .Q:$P(L12,U,8)]""            ;Quit if it has a parent
 .S COLDATE=+L12
 .S ORDPROV=$P(L12,U,2)
 .Q:'$D(@VFILE@(L,14))
 .S CPTSTR=$P(@VFILE@(L,14),U,2)
 .S FILEN=$P(+$P(@VFILE@(0),U,2),".",2)
 .S:VFILE["VLAB"&($P(@VFILE@(+L,0),U,4)'="") RESULT=$P(@VFILE@(+L,0),U,4)
 .D CPTSTR
 Q
 ;
CPTSTR ;Parse CPTSTR and edit claim
 ;Top delimiter is ; between CPT's.  Each CPT is of the form
 ;CPT code|cost|rev code|action code|modifier|qualifier
 ;Each modifier and qualifier can be multiple separated by ,
 ;Note that rev code being passed by lab is not revenue code
 N ABMI,J,REVCODE,X
 F ABMI=1:1 S X=$P(CPTSTR,";",ABMI) Q:X=""  D
 .S ABMSRC=FILEN_"|"_L_","_ABMI_"|CPT"
 .S CPT=$P(X,"|",1)
 .S M=$P(X,"|",5)
 .F J=1:1 S MODIFIER(J)=$P(M,",",J) I MODIFIER(J)="" K MODIFIER(J) Q
 .S REVCODE=$P($$IHSCPT^ABMCVAPI(CPT,ABMP("VDT")),U,3)  ;CSV-c
 .I 'REVCODE D
 ..N CPTCTIEN
 ..S CPTCTIEN=$P($$CPT^ABMCVAPI(CPT,ABMP("VDT")),U,4)  ;CSV-c
 ..Q:'CPTCTIEN
 ..S REVCODE=$P($$IHSCAT^ABMCVAPI(CPTCTIEN,ABMP("VDT")),U)  ;CSV-c
 .S:'REVCODE REVCODE=300
 .D CLAIM
 K M
 Q
 ;
CLAIM ;-- claim file stuff
 N FEE
 ;ABMP("FEE") gets set in ABMDE2X1 or ABMDE2X5 which are called from
 ;ABMDVST
 ;S FEE=$P($G(^ABMDFEE(+ABMP("FEE"),17,CPT,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S FEE=$P($$ONE^ABMFEAPI(+ABMP("FEE"),17,CPT,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 I ($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"),('FEE) Q
 S DIC("P")=$P(^DD(9002274.3,37,0),U,2)
 K DIC,DD,DO
 S X=CPT,DIC="^ABMDCLM("_DUZ(2)_","_ABMP("CDFN")_",37,"
 S DIC("DR")=".02////"_REVCODE_";.03////1;.04////"_FEE_";.05////"_COLDATE_";.17////"_ABMSRC
 I +$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",CPT,0))'=0 D
 .Q:ABMP("EXP")'=22
 .Q:'$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",CPT))
 .S ABMIIEN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",CPT,0))
 .Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,ABMIIEN,0)),U,2)'="Y"
 .I +$G(RESULT) S DIC("DR")=DIC("DR")_";.21////"_RESULT
 I $D(ABMP("CORRSDIAG")) S DIC("DR")=DIC("DR")_";.09////1"
 I $D(MODIFIER) F J=1:1:3 Q:'$D(MODIFIER(J))  D
 .S DIC("DR")=DIC("DR")_";"_((5+J)/100)_"////"_MODIFIER(J)
 S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),"ASRC",ABMSRC,0))
 I DA,'$D(@(DIC_DA_",0)")) S DA=""    ;For duplicates problem
 S DA(1)=ABMP("CDFN")
 I DA>0 D
 .K DR
 .S DIE=DIC
 .S DR=".01///"_X_";"_DIC("DR")
 .D ^DIE
 E  D
 .S DIC(0)="LE"
 .S DIC("P")=$P(^DD(9002274.3,37,0),U,2)
 .K DD,DO
 .K DD,DO D FILE^DICN
 Q
