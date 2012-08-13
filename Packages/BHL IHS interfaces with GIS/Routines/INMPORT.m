INMPORT ; cmi/flag/maw - IN Import GIS Package ; 
 ;;3.01;BHL IHS Interfaces with GIS;**2,11,14,15**;OCT 15, 2002
 ;
 ;
 ;
 ;this routine will import a GIS package from the ^INXPORT global
 ;it will then populate the SCRIPT GENERATOR FIELD, SEGMENT, and
 ;MESSAGE files and also the INTERFACE TRANSACTION TYPE, DESTINATION,
 ;and BACKGROUND PROCESS files
 ;
MAIN ;PEP - this is the main routine driver
 I $O(^INXPORT(""))="" D  Q
 . W !,"Global ^INXPORT is missing, please restore and rerun"
 S KFM="K DIE,DR,DIC,DA,DD,DO,DIK"
 D NS
 D ADD01
 D MSG
 D EOJ
 Q
 ;
NS ;-- parse the INXPORT global get package name        
 S INMT=$O(^INXPORT(""))
 Q:INMT=""
 S INST=$O(^INXPORT(INMT,""))
 Q:INST=""
 S INPKG=$O(^INXPORT(INMT,INST,""))
 I INPKG="" S INPKG="CORE"
 I '$O(^INRHNS("B",INPKG,"")) D
 . K DD,DO
 . S DIC(0)="L",DIC="^INRHNS(",X=INPKG
 . D FILE^DICN
 . S INNS=+Y
 . S DA(1)=INNS
 . K DIC,DD,DO
 . S DIC(0)="L"
 . S DIC="^INRHNS("_DA(1)_",1,",X=INST,DIC("P")=$P(^DD(4007,1,0),U,2)
 . D FILE^DICN
 S INNS=$O(^INRHNS("B",INPKG,""))
 S INSTOK=$$STCK(INNS,INST)
 S INMPRE="^INXPORT(INMT,INST,INPKG)"
 Q
 ;
MSG ;-- Import the fields from the INXPORT global
 D ADDTT
 D ADDD
 D ADDBP
 S INMDA=0
 F  S INMDA=$O(@INMPRE@(INMDA)) Q:'INMDA  D
 . D FD(INMDA)
 . D SD(INMDA)
 . S INOUT=$S($G(@INMPRE@(INMDA,"INOUT"))="IN":1,1:0)
 . D MD(INMDA)
 Q
 ;
FD(MDA)          ;-- parse the fields out of the message and check exist
 ;add all fields first then go back and add sub fields if necessary
 S INFDA=0 F  S INFDA=$O(@INMPRE@(MDA,"FD",INFDA)) Q:'INFDA  D
 . S INFDEF=$G(@INMPRE@(MDA,"FD",INFDA))
 . S INF01=$P(INFDEF,U)
 . S INF02=$P(INFDEF,U,2)
 . S INF03=$P(INFDEF,U,3)
 . S INF3=$P(INFDEF,U,4)
 . S INF5=$G(@INMPRE@(MDA,"FD",INFDA,"OUT"))
 . S INY=+$$CHKF(INF01,INF02,INF03,INF3,INF5)
 . Q:'INY
 . I $D(@INMPRE@(MDA,"FD",INFDA,"SUB")) D
 .. S INFS=0 F  S INFS=$O(@INMPRE@(MDA,"FD",INFDA,"SUB",INFS)) Q:'INFS  D
 ... S INFSD=$G(@INMPRE@(MDA,"FD",INFDA,"SUB",INFS))
 ... S INFS01=$P(INFSD,U)
 ... S INFS02=$P(INFSD,U,2)
 ... S INFSB=$$FSUB(INY,INFS01,INFS02)
 K @INMPRE@(MDA,"FD")
 Q
 ;
SD(MDA)          ;-- lets setup the segments
 S INSDA=0 F  S INSDA=$O(@INMPRE@(MDA,"SD",INSDA)) Q:'INSDA  D
 . S INSGDT=$G(@INMPRE@(MDA,"SD",INSDA))
 . S INS01=$P(INSGDT,U)
 . S INS02=$P(INSGDT,U,2)
 . S INY=$$CHKS(INS01,INS02)
 . Q:'INY
 . S INSFDA=0 F  S INSFDA=$O(@INMPRE@(MDA,"SD",INSDA,"FD",INSFDA)) Q:'INSFDA  D
 .. S INSFDT=$G(@INMPRE@(MDA,"SD",INSDA,"FD",INSFDA))
 .. S INSF01=$P(INSFDT,U)
 .. S INSFIEN=$O(^INTHL7F("B",INSF01,0))
 .. Q:'INSFIEN
 .. S INSF02=$P(INSFDT,U,2)
 .. S INSF03=$P(INSFDT,U,3)
 .. S INSFLD=$$SEGF(INY,INSFIEN,INSF01,INSF02,INSF03)
 K @INMPRE@(MDA,"SD")
 Q
 ;
MD(MDA) ;-- setup the message
 S INMDT=$G(@INMPRE@(MDA,"MD"))
 S INM01=$P($P(INMDT,";"),"///",2)
 S INLKST=$G(@INMPRE@(MDA,"MD","ROU"))
 S INY=$$CHKM(INM01,$P(INMDT,";",2,99)_INLKST)
 D CHARUP^BHLU(INY)
 S INMTT=0 F  S INMTT=$O(@INMPRE@(MDA,"MD","TT",INMTT)) Q:'INMTT  D
 . S INMTTE=$G(@INMPRE@(MDA,"MD","TT",INMTT))
 . S INTCHK=$$CHKMT(INY,INMTTE)
 K @INMPRE@(MDA,"MD","TT")
 S INMOM=0 F  S INMOM=$O(@INMPRE@(MDA,"MD","OIMC",INMOM)) Q:'INMOM  D
 . S INOME=$G(@INMPRE@(MDA,"MD","OIMC",INMOM))
 . S INOCHK=$$CHKOM(INY,INOME)
 K @INMPRE@(MDA,"MD","OIMC")
 S INMCL=0 F  S INMCL=$O(@INMPRE@(MDA,"MD","MCFL",INMCL)) Q:'INMCL  D
 . S INMCLE=$G(@INMPRE@(MDA,"MD","MCFL",INMCL))
 . S INMCCHK=$$CHKMC(INY,INMCLE)
 K @INMPRE@(MDA,"MD","OIMC")
 S INMDS=0 F  S INMDS=$O(@INMPRE@(MDA,"MD","DESC",INMDS)) Q:'INMDS  D
 . S INDESC=$G(@INMPRE@(MDA,"MD","DESC",INMDS))
 . S INMADS=$$CHKDS(INY,INDESC)
 K @INMPRE@(MDA,"MD","DESC")
 S INMSG=0 F  S INMSG=$O(@INMPRE@(MDA,"MD","SEG",INMSG)) Q:'INMSG  D
 . S INMSGD=$G(@INMPRE@(MDA,"MD","SEG",INMSG))
 . S INMSGN=$P(INMSGD,U)
 . S INMSGS=$P(INMSGD,U,2)
 . S INMSGR=$P(INMSGD,U,3)
 . S INMSGOF=$P(INMSGD,U,4)
 . S INMSGFL=$P(INMSGD,U,5)
 . S INMSGP=$P(INMSGD,U,6)
 . S INMSGM=$P(INMSGD,U,7)
 . S INMSGPS=$P(INMSGD,U,8)
 . S INMSGU=$P(INMSGD,U,9)
 . S INMSY=$$CHKMS(INY,INMSGN,INMSGS,INMSGR,INMSGOF,INMSGFL,INMSGP,INMSGM,INMSGPS,INMSGU)
 . K ^INTLH7M(INY,1,INMSY,5)  ;remove existing seg m code
 . S INMSGO=0 F  S INMSGO=$O(@INMPRE@(MDA,"MD","SEG",INMSG,"OMC",INMSGO)) Q:'INMSGO  D
 .. S INMSGOD=$G(@INMPRE@(MDA,"MD","SEG",INMSG,"OMC",INMSGO))
 .. S INMSGOMC=$$CHKSOM(INY,INMSY,INMSGOD)
 K @INMPRE@(MDA,"MD")
 D COMPILE^BHLU(INY)
 Q
 ;
STCK(NS,ST) ;-- check to see if the site already exists if not add it
 S INNDA=0 F  S INNDA=$O(^INRHNS(NS,1,INNDA)) Q:'INNDA!($G(INIEN))  D
 . I $G(^INRHNS(NS,1,INNDA,0))=ST S INIEN=INNDA Q
 I '$G(INIEN) Q $$ADD(NS,ST)
 Q INIEN
 ;
ADD(NMS,SIT)       ;-- add the site to the namespace file
 X KFM
 S DIC="^INRHNS("_NMS_",1,",DIC(0)="L"
 S DIC("P")=$P(^DD(4007,1,0),U,2),X=SIT
 D FILE^DICN
 K DIC
 Q +Y
 ;
CHKF(F01,F02,F03,F3,F5)          ;-- check for field add/update
 X KFM
 I $O(^INTHL7F("B",F01,0)) Q $$UPDF(F01,F02,F03,F3,F5)
 S DIC="^INTHL7F(",DIC(0)="L",X=F01
 S DIC("DR")=".02///"_F02_";.03///"_F03_";3///"_F3_";5///"_F5
 D FILE^DICN
 S FLDI=+Y
 Q FLDI
 ;
CHKS(S01,S02)      ;-- check for seg existence add/update
 X KFM
 I $O(^INTHL7S("B",S01,0)) Q $O(^INTHL7S("B",S01,0))
 S DIC="^INTHL7S(",DIC(0)="L",X=S01
 S DIC("DR")=".02///"_S02
 D FILE^DICN
 Q +Y
 ;
CHKM(M01,MDT)      ;-- check for message process add/update
 X KFM
 I $O(^INTHL7M("B",M01,0)) D  Q MIEN
 . S MIEN=$O(^INTHL7M("B",M01,0))
 . S DIE="^INTHL7M(",DA=MIEN,DR=MDT
 . D DIE
 Q $$MADD(M01,MDT)
 ;
CHKMS(MS01,GN,GS,GR,GOF,GFL,GP,GM,GPS,GU)        ;-- check for msg segment mult
 X KFM
 S SGIEN=$O(^INTHL7S("B",GN,0))
 S MSGIEN=$O(^INTHL7M("SEG",SGIEN,MS01,0))
 I MSGIEN D
 . S DIK="^INTHL7M("_MS01_",1,",DA(1)=MS01,DA=MSGIEN
 . K ^INTHL7M(MS01,1,MSGIEN,1)
 . D ^DIK
 . Q
 . S DIE="^INTHL7M("_MS01_",1,"_MSGIEN_",",DA(1)=MS01,DA=MSGIEN
 . S DR=".02///"_GS_";.03///"_GR_";.04///"_GOF_";.05///"_GFL
 . S DR=DR_";.07///"_GP_";.08///"_GM_";.11///"_GPS_";.12///"_GU
 . S DIC("P")=$P(^DD(4011,1,0),U,2)
 . D DIE
 Q $$MSADD(MS01,SGIEN,GN,GS,GR,GOF,GFL,GP,GM,GPS,GU)
 ;
MSADD(MSGI,MSGN,AGN,AGS,AGR,AGOF,AGFL,AGP,AGM,AGPS,AGU)        ;-- add segment
 X KFM
 S DIC="^INTHL7M("_MSGI_",1,",DIC(0)="L",DA(1)=MSGI,X=MSGN
 S DIC("DR")=".02///"_AGS_";.03///"_AGR_";.04///"_AGOF_";.05///"_AGFL
 S DIC("DR")=DIC("DR")_";.07///"_AGP_";.08///"_AGM_";.11///"_AGPS
 S DIC("DR")=DIC("DR")_";.12///"_AGU
 S DIC("P")=$P(^DD(4011,1,0),U,2)
 D FILE^DICN
 Q +Y
 ;
UPDF(FL01,FL02,FL03,FL3,FL5)  ;-- update an existing field 
 X KFM
 S INFIEN=$O(^INTHL7F("B",FL01,0))
 S DIE="^INTHL7F(",DA=INFIEN
 S DR=".02///"_FL02_";.03///"_FL03_";3///"_FL3_";5///"_FL5
 D DIE
 Q INFIEN
 ;
FSUB(FDA,FS01,FS02)          ;-- check the subfields also
 X KFM
 S INFSIEN=$O(^INTHL7F("B",FS01,0))
 I '$D(^INTHL7F(FDA,10)) Q $$FSUBADD(FDA,INFSIEN,FS02)
 K INMTCH
 S INFS=$O(^INTHL7F(FDA,10,"B",INFSIEN,0))
 I $G(INFS) D  Q INFS
 . Q:$P($G(^INTHL7F(FDA,10,INFS,0)),U,2)=FS02
 . S DIE="^INTHL7F("_FDA_",10,"_INFS_","
 . S DIC("P")=$P(^DD(4012,10,0),U,2)
 . S DA(1)=FDA,DA=INFS,DR=".02///"_FS02
 . D DIE
 . K DIE
 S INFSIEN=$O(^INTHL7F("B",FS01,0))
 S FSIEN=$$FSUBADD(FDA,INFSIEN,FS02)
 Q FSIEN
 ;
FSUBADD(FIEN,FSL01,FSL02)    ;-- add the subfile
 X KFM
 S DA(1)=FIEN,DIC="^INTHL7F("_DA(1)_",10,",X=FSL01
 S DIC(0)="L",DIC("P")=$P(^DD(4012,10,0),U,2)
 S DIC("DR")=".02///"_FSL02
 D FILE^DICN
 Q +Y
 ;
SEGF(SIEN,SFIEN,SF01,SF02,SF03)    ;-- check for fld exist add/upd
 X KFM
 I '$D(^INTHL7S(SIEN,1)) Q $$SFADD(SIEN,SFIEN,SF02,SF03)
 S SFLIEN=$O(^INTHL7S(SIEN,1,"B",SFIEN,0))
 I 'SFLIEN Q $$SFADD(SIEN,SFIEN,SF02,SF03)
 S DIE="^INTHL7S("_SIEN_",1,"_SFLIEN_",",DA(1)=SIEN,DA=SFLIEN
 I $P($G(^INTHL7S(SIEN,1,SFLIEN,0)),U,2)=SF02 Q SFLIEN
 S DR=".02///"_SF02_";.03///"_SF03
 D DIE
 Q SFLIEN
 ;
SFADD(SN,S01,S02,S03)    ;-- add the field to the segment
 X KFM
 S DIC="^INTHL7S("_SN_",1,",DIC(0)="L",DA(1)=SN,X=S01
 S DIC("P")=$P(^DD(4010,1,0),U,2)
 S DIC("DR")=".02///"_S02_";.03///"_S03
 D FILE^DICN
 Q +Y
 ;
MADD(MA01,MADT)    ;-- add the message
 X KFM
 S DIC="^INTHL7M(",DIC(0)="L",X=MA01
 S DIC("DR")=MADT
 D FILE^DICN
 Q +Y
 ;
CHKOM(MSG,OMC)     ;-- replace outgoing mumps code
 K ^INTHL7M(INY,6)  ;kill off existing outgoing m code
 X KFM
 S DIC="^INTHL7M("_MSG_",6,",DIC(0)="L",DA(1)=MSG,X=OMC
 S DIC("P")=$P(^DD(4011,6,0),U,2)
 D FILE^DICN
 Q +Y
 ;
CHKMC(MSG,MCL)     ;-- replace mumps code for lookup
 K ^INTHL7M(INY,4)  ;kill off existing mumps code for lookup
 X KFM
 S DIC="^INTHL7M("_MSG_",4,",DIC(0)="L",DA(1)=MSG,X=MCL
 S DIC("P")=$P(^DD(4011,4,0),U,2)
 D FILE^DICN
 Q +Y
 ;
CHKDS(MSG,DSC)     ;-- replace description
 K ^INTHL7M(INY,3)  ;kill of existing description
 X KFM
 S DIC="^INTHL7M("_MSG_",3,",DIC(0)="L",DA(1)=MSG,X=DSC
 S DIC("P")=$P(^DD(4011,3,0),U,2)
 D FILE^DICN
 Q +Y
 ;
CHKMT(MSG,MTT)     ;-- add tt to msg
 X KFM
 S MTIEN=$O(^INRHT("B",MTT,0))
 I 'MTIEN Q 0
 I '$O(^INTHL7M(MSG,2,"B",MTIEN,0)) Q $$ADDT(MSG,MTIEN)
 Q $O(^INTHL7M(MSG,2,"B",MTIEN,0))
 ;
ADDT(MSG,TT)       ;-- add the transaction to the message
 X KFM
 S DIC="^INTHL7M("_MSG_",2,",DA(1)=MSG,DIC(0)="L",X=TT
 S DIC("P")=$P(^DD(4011,2,0),U,2)
 D FILE^DICN
 Q +Y
 ;
CHKSOM(MS,MSEG,OMC)          ;-- add m code to segment
 K ^INTHL7M(MS,1,MSEG,1)  ;remove existing seg m code
 X KFM
 S DIC="^INTHL7M("_MS_",1,"_MSEG_",5,",DIC(0)="L",DA(1)=MS,DA=MSEG
 S DIC("P")=$P(^DD(4011.01,5,0),U,2)
 S X=OMC
 D FILE^DICN
 Q +Y
 ;
ADD01 ;
 S INADD01=""
 D ADDTT
 D ADDD
 D ADDBP
 K INADD01
 Q
ADDD ;-- add all destinations in namespace first    
 S INADA=0
 F  S INADA=$O(@INMPRE@("DEST",INADA)) Q:'INADA  D
 .S INADDT=$G(@INMPRE@("DEST",INADA))
 .S INAD01=$P($P(INADDT,";"),"///",2)
 .S INAD02=$P($P(INADDT,";",2),"///",2)
 .S:INAD02]"" INAD02=$O(^INRHT("B",INAD02,0))
 .S INADDR=$P(INADDT,";",2,99)
 .I INAD02 S $P(INADDR,";")=".02////"_INAD02
 .X KFM
 .S INDIEN=$O(^INRHD("B",INAD01,0))
 .I 'INDIEN D  Q:INDIEN<0
 ..S DIC="^INRHD(",DIC(0)="L",X=INAD01
 ..D FILE^DICN
 ..S INDIEN=+Y
 .Q:$D(INADD01)
 .S DA=INDIEN
 .S DIE="^INRHD("
 .S DR=INADDR
 .D DIE
 .I INAD02,'$P(^INRHD(INDIEN,0),U,2) S $P(^(0),U,2)=INAD02
 Q
 ;
ADDTT ;-- add all transactions in namespace first    
 S INADA=0
 F  S INADA=$O(@INMPRE@("TT",INADA)) Q:'INADA  D
 .S INADDT=$G(@INMPRE@("TT",INADA))
 .S INAD01=$P($P(INADDT,";"),"///",2)
 .S INADDR=$P(INADDT,";",2,99)
 .X KFM
 .S INDIEN=$O(^INRHT("B",INAD01,0))
 .I 'INDIEN D  Q:INDIEN<0
 ..S DIC="^INRHT(",DIC(0)="L",X=INAD01
 ..D FILE^DICN
 ..S INDIEN=+Y
 .Q:$D(INADD01)
 .S DA=INDIEN
 .N INTP5
 .S INTP5=$P($G(^INRHT(INDIEN,0)),U,5)
 .S DIE="^INRHT("
 .S DR=INADDR
 .D DIE
 .I $G(INTP5)="A" D
 .. S $P(^INRHT(INDIEN,0),U,5)="A"
 Q
 ;
ADDBP ;-- add all transactions in namespace first    
 S INADA=0
 F  S INADA=$O(@INMPRE@("BP",INADA)) Q:'INADA  D
 .S INADDT=$G(@INMPRE@("BP",INADA))
 .S INAD01=$P($P(INADDT,";"),"///",2)
 .S INADDR=$P(INADDT,";",2,99)
 .X KFM
 .S INDIEN=$O(^INTHPC("B",INAD01,0))
 .I 'INDIEN D  Q:INDIEN<0
 ..S DIC="^INTHPC(",DIC(0)="L",X=INAD01
 ..D FILE^DICN
 ..S INDIEN=+Y
 .Q:$D(INADD01)
 .S DIE="^INTHPC(",DA=INDIEN
 .S DR=INADDR
 .D DIE
 Q
 ;
EOJ ;-- kill variables and quit
 D EN^XBVK("IN")
 Q
 ;
DIE K Y
 D ^DIE
 K DA,DR,DIE,DIC,DINUM,Y
 Q
