BHLZ01I ;cmi/sitka/maw - Process Inbound Z01 Event  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will process the inbound ihs drug file update
 ;
MAIN ;-- this is the main routine driver
 D ^BHLSETI
 S INA("MFAERR")="S"
 S INA("MCID")=$G(INV("MSH10"))
 S INA("KTYP")="CE"
 D MFI
 D MFE
 I BHLNDC="" S INA("MFAERR")="U" D ACK,EOJ^BHLSETI Q
 D ZFD
 D LOOK
 Q:'$L($T(@BHLMWT))
 D @BHLMWT
 D ACK
 D EOJ^BHLSETI
 Q
 ;
MFI ;-- get data out of MFI segment
 S INA("MFI")=$G(INV("MFI1"))
 Q
 ;
MFE ;-- get data out of MFE segment
 S INA("DORLE")=$G(INV("MFE1"))
 S INA("PRIMKEY")=$G(INV("MFE4"))
 S BHLMWT=$G(INA("DORLE"))
 S BHLNDCE=$P(INA("PRIMKEY"),CS)
 Q:BHLNDCE=""
 S BHLNDC=$P(BHLNDCE,"-")_$P(BHLNDCE,"-",2)_$P(BHLNDCE,"-",3)
 Q
 ;
ZFD ;-- get data out of ZFD segment
 S BHLDGN=$G(INV("ZFD1"))
 S BHLWL=$G(INV("ZFD2"))
 S BHLMXD=$G(INV("ZFD3"))
 S BHLDEAS=$G(INV("ZFD4"))
 S BHLSSIG=$G(INV("ZFD5"))
 S BHLOU=$G(INV("ZFD6"))
 S BHLPPOU=$G(INV("ZFD7"))
 S BHLDU=$G(INV("ZFD8"))
 S BHLPPDU=$G(INV("ZFD9"))
 S BHLDUPOU=$G(INV("ZFD10"))
 S BHLNF=$G(INV("ZFD11"))
 S BHLIAD=$G(INV("ZFD12"))
 S BHLMSGE=$G(INV("ZFD13"))
 S BHLCHEMO=$G(INV("ZFD14"))
 Q
 ;
LOOK ;-- look up the entry in the drug file
 S BHLDIEN=$O(^PSDRUG("ZNDC",BHLNDC,0))
 Q
 ;
MUP ;-- update the drug file or add if not existent
 I 'BHLDIEN D  Q
 . S DIC=50,DIC(0)="L",X=BHLDGN
 . S DIC("DR")="3///"_BHLDEAS_";4///"_BHLMXD_";5///"_BHLSSIG
 . S DIC("DR")=DIC("DR")_";8///"_BHLWL_";12///"_BHLOU_";12///"_BHLOU
 . S DIC("DR")=DIC("DR")_";13///"_BHLPPOU_";14.5///"_BHLDU
 . S DIC("DR")=DIC("DR")_";15///"_BHLDUPOU_";16///"_BHLPPDU
 . S DIC("DR")=DIC("DR")_";51///"_BHLNF_";100///"_BHLIAD
 . S DIC("DR")=DIC("DR")_";101///"_BHLMSGE_";202///"_BHLCHEMO
 . D FILE^DICN
 . I Y<0 S INA("MFAERR")="U"
 S DIE=50,DA=BHLDIEN
 S DR="3///"_BHLDEAS_";4///"_BHLMXD_";5///"_BHLSSIG
 S DR=DR_";8///"_BHLWL_";12///"_BHLOU_";12///"_BHLOU
 S DR=DR_";13///"_BHLPPOU_";14.5///"_BHLDU
 S DR=DR_";15///"_BHLDUPOU_";16///"_BHLPPDU
 S DR=DR_";51///"_BHLNF_";100///"_BHLIAD
 S DR=DR_";101///"_BHLMSGE_";202///"_BHLCHEMO
 D ^DIE
 I $D(Y) S INA("MFAERR")="U"
 Q
 ;
MDL ;-- delete the record (deactivate)
 D MDC
 Q
 ;
MDC ;-- deactivate the record
 I 'BHLDIEN S Y=-1 Q
 S DIE=50,DA=BHLDIEN,DR="100///"_BHLIAD
 D ^DIE
 I $D(Y) S INA("MFAERR")="U"
 Q
 ;
ACK ;-- send the acknowledgement event
 S INA("INORIGID")=$G(INV("MSH10"))
 S INA("INSTAT")=$S(INA("MFAERR")="U":"AE",1:"AA")
 S INDA=$S(BHLDIEN:BHLDIEN,1:1)
 S X="BHL ACK DRUG MASTER TABLE UPDATE",DIC=101 D EN^XQOR
 Q
 ;
