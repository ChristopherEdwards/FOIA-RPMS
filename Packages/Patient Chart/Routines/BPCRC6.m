BPCRC6 ; IHS/OIT/MJL - FHL-12/26/96 - REFERRED CARE GUI ROUTINES ;
 ;;1.5;BPC;;MAY 26, 2005
 ;
EDIT ; EP CALLED FROM BPCRC3 (EDITS REFERRED CARE RECORD)
 D MODREF I BPCERR S RESULT(1)=-1,RESULT(2)="ERROR OCCURRED WHILE MODIFYING DATA!" Q
 S RESULT(1)=1,RESULT(2)=BPCRIEN_U_BPCREFN_U_BPCPURP_U_BPCPRNAM_U_BPCPROV_U_BPCIDAT_U_BPCEBDAT_U
 Q
MODREF ;
 L +^BMCREF(0):10 I '$T S BPCERR=1 Q
 K BPCFDA,BPCEMSG S BPCFDR="BPCFDA(1)",BPCIENS=BPCRIEN_","
 S BPCFDA(1,90001,BPCIENS,.01)=BPCIDAT
 S BPCFDA(1,90001,BPCIENS,.03)=BPCPIEN
 S BPCFDA(1,90001,BPCIENS,.04)=BPCRTYPE
 S BPCFDA(1,90001,BPCIENS,.05)=BPCFAC
 S BPCFDA(1,90001,BPCIENS,.06)=BPCPROV
 S BPCFDA(1,90001,BPCIENS,.07)=BPCPVEND
 S BPCFDA(1,90001,BPCIENS,.08)=BPCTOIHS
 S BPCFDA(1,90001,BPCIENS,.09)=BPCTOPRV
 S BPCFDA(1,90001,BPCIENS,.11)=BPCPAYOR
 S BPCFDA(1,90001,BPCIENS,.12)=BPCICD
 S BPCFDA(1,90001,BPCIENS,.13)=BPCCPT
 S BPCFDA(1,90001,BPCIENS,.14)=BPCPTYPE
 S BPCFDA(1,90001,BPCIENS,.21)=BPCDRG
 S BPCFDA(1,90001,BPCIENS,.23)=BPCCLIN
 S BPCFDA(1,90001,BPCIENS,.27)=BPCCDAT ;DATE LAST MODIFIED FOR EDITS
 S BPCFDA(1,90001,BPCIENS,.32)=BPCPRIOR
 S BPCFDA(1,90001,BPCIENS,.34)=BPCSNDA
 S BPCFDA(1,90001,BPCIENS,1105)=BPCEBDAT
 S BPCFDA(1,90001,BPCIENS,1107)=BPCEEDAT
 S BPCFDA(1,90001,BPCIENS,1109)=BPCLOS
 S BPCFDA(1,90001,BPCIENS,1111)=BPCNOVIS
 S BPCFDA(1,90001,BPCIENS,1201)=BPCPURP
 S BPCFDA(1,90001,BPCIENS,1301)=BPCSNOTE
 S BPCFDA(1,90001,BPCIENS,1302)=BPCWDAYS
 D FILE^DIE("",BPCFDR,"BPCEMSG")
 I $D(BPCEMSG("DIERR")) S BPCERR=1
 L -^BMCREF(0)
 I 'BPCERR D MODLSCAT
 I 'BPCERR D MODHX
 I 'BPCERR D MODDXS
 I 'BPCERR D MODPXS
 Q
MODDXS ;
 K BPCARY
 S BPCX="" F  S BPCX=$O(^BMCDX("AD",BPCRIEN,BPCX)) Q:BPCX=""  S BPCARY(BPCX)=""
 I $D(BPCARY) S DIK="^BMCDX(" D DEL
 K BPCARY,DA
 Q:BPCDXS=""
 D SETDXS^BPCRC5
 Q
MODPXS ;
 K BPCARY
 S BPCX="" F  S BPCX=$O(^BMCPX("AD",BPCRIEN,BPCX)) Q:BPCX=""  S BPCARY(BPCX)=""
 I $D(BPCARY) S DIK="^BMCPX(" D DEL
 K BPCARY,DA
 Q:BPCPRCS=""
 D SETPRCS^BPCRC5
 Q
MODHX ;
 K BPCARY
 S BPCX=0 F  S BPCX=$O(^BMCREF(BPCRIEN,1,BPCX)) Q:BPCX=""  S BPCARY(BPCX)=""
 I $D(BPCARY) S BPCSUB="1",DA(1)=BPCRIEN,DIK="^BMCREF("_DA(1)_","_BPCSUB_"," D DEL
 K BPCARY,DA
 Q:BPCHXS=""
 D ADDHX
 Q
MODLSCAT ;
 K BPCARY
 S BPCX="" F  S BPCX=$O(^BMCREF(BPCRIEN,21,"B",BPCX)) Q:BPCX=""  S BPCQ="" F  S BPCQ=$O(^BMCREF(BPCRIEN,21,"B",BPCX,BPCQ)) Q:BPCQ=""  S BPCARY(BPCQ)=""
 I $D(BPCARY) S BPCSUB="21",DA(1)=BPCRIEN,DIK="^BMCREF("_DA(1)_","_BPCSUB_"," D DEL
 K BPCARY,DA
 Q:BPCLSCAT=""
 D ADDLSCAT
 Q
DEL ;
 S DA="" F  S DA=$O(BPCARY(DA)) Q:DA=""  D ^DIK
 Q
ADDHX ;
 K ^BPCTMP($J),BPCEMSG
 F BPCQ=1:1:$L(BPCHXS,BPCS2) S BPCX=$P(BPCHXS,BPCS2,BPCQ),^BPCTMP($J,BPCQ,0)=BPCX
 S BPCROOT="^BPCTMP("_$J_")"
 D WP^DIE(90001,BPCRIEN_",",1,"",BPCROOT,"BPCEMSG")
 I $D(BPCEMSG("DIERR")) S BPCERR=1
 K ^BPCTMP($J)
 Q
ADDLSCAT ;
 L +^BMCREF(0):10 I '$T S BPCERR=1 Q
 K BPCFDA,BPCEMSG S BPCFDR="BPCFDA(1)",BPCIENS=BPCRIEN_","
 S BPCSUB=1 F BPCQ=1:1:$L(BPCLSCAT,BPCS2) S BPCX=$P(BPCLSCAT,BPCS2,BPCQ),BPCSUB=BPCSUB+1,BPCXR="BPCFDA(1,90001.21,"_""""_"+"_BPCSUB_","_BPCIENS_""""_",.01)" S @BPCXR=BPCX
 D UPDATE^DIE("",BPCFDR,"BPCIEN","BPCEMSG")
 L -^BMCREF(0)
 Q