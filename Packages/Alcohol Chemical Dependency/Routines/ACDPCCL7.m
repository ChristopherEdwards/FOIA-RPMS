ACDPCCL7 ;IHS/ADC/EDE/KML - PCC LINK - EDIT ENTRY;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 D MAIN
 Q
 ;
MAIN ;
 S X=$O(ACDPCCL(ACDDFNP,ACDVIEN,""))
 I X="CS" D CS Q
 D IIFTDC
 Q
 ;
IIFTDC ;
 D VFILES
 D VISIT
 S DIK="^ACDVIS("_ACDVIEN_",21,",DA=1,DA(1)=ACDVIEN D DIK^ACDFMC
 Q
 ;
VFILES ; DELETE V FILE ENTRIES
 S ACDY=0
 F  S ACDY=$O(^ACDVIS(ACDVIEN,21,1,11,ACDY)) Q:'ACDY  I $D(^(ACDY,0)) S X=^(0) D
 .  S ACDVF=$P(X,U)
 .  S ACDVFE=$P(X,U,2)
 . ;S X=$$DEL^APCDALVR(ACDVF,ACDVFE)
 .  S X=$$DEL(ACDVF,ACDVFE)
 .  I X D ERROR^ACDPCCL("Error code="_X_" encountered while deleting V File entry",3) Q
 .  Q
 Q
 ;
VISIT ; DELETE VISIT IF DEPENDENT ENTRY COUNT = 0
 Q:'$D(^ACDVIS(ACDVIEN,21,1,0))  ;         corrupt cdmis visit
 S X=^ACDVIS(ACDVIEN,21,1,0)
 NEW AUPNVSIT
 S AUPNVSIT=$P(X,U,2)
 Q:$P(^AUPNVSIT(AUPNVSIT,0),U,9)
 D DEL^AUPNVSIT
 Q
 ;
CS ;
 S ACDCSIEN=0
 F  S ACDCSIEN=$O(ACDPCCL(ACDDFNP,ACDVIEN,"CS",ACDCSIEN)) Q:'ACDCSIEN  D CS2 K ACDPCCL(ACDDFNP,ACDVIEN,"CS",ACDCSIEN)
 I '$O(ACDPCCL(ACDDFNP,ACDVIEN,"")) K ACDPCCL(ACDDFNP,ACDVIEN)
 ; *** The kills above will preclude any CS entry ever being added
 ; *** back by the add logic in ^ACDPCCL5.  Might rethink this.
 Q
 ;
CS2 ;
 I $D(^ACDVIS(ACDVIEN,21,"AC",ACDCSIEN)) S ACDDMIEN=$O(^(ACDCSIEN,0)),ACDVMIEN=$O(^(ACDDMIEN,0)) D
 .  S ACDPCCV=$P($G(^ACDVIS(ACDVIEN,21,ACDDMIEN,0)),U,2)
 .  Q:'ACDPCCV  ;                          quit if no PCC visit ien
 .  S X=$G(^ACDVIS(ACDVIEN,21,ACDDMIEN,11,ACDVMIEN,0))
 .  S ACDVCPT=$P(X,U,2) ;                  get ^AUPNVCPT ien
 .  Q:'ACDVCPT
 .  I ACDPCCL(ACDDFNP,ACDVIEN,"CS",ACDCSIEN)="D" D CSDEL Q
 . ;if CS entry deleted delete AUPNVCPT entry and ACDVIS mult entry
 .  S ACDCSIEN=$P(X,U,3) ;                 get ^ACDCS ien
 .  Q:'ACDCSIEN
 .  S X=+$G(^AUPNVCPT(ACDVCPT,0)) ;        get CPT code from PCC
 .  Q:'X
 .  S Y=$P($G(^ACDCS(ACDCSIEN,0)),U,2) ;   get ^ACDSERV ien
 .  Q:'Y
 .  S Y=$P($G(^ACDSERV(Y,0)),U,5) ;        get CPT code from CDMIS
 .  Q:'Y
 .  Q:X=Y  ;                               quit if CPT codes same
 .  S APCDALVR("APCDLOOK")=ACDVCPT
 .  S APCDALVR("APCDTCPT")=Y
 .  S APCDALVR("APCDVSIT")=ACDPCCV
 .  S APCDALVR("APCDATMP")="[APCDALVR 9000010.18 (MOD)]"
 .  D ^APCDALVR
 .  I $D(APCDALVR("APCDAFLG")) D ERROR^ACDPCCL("Error flag="_APCDALVR("APCDAFLG")_" returned by APCDALVR while modifying the V CPT file.",3)
 .  K APCDALVR
 .  Q
 Q
 ;
CSDEL ; DELETED CS ENTRY
 S X=$$DEL(9000010.18,ACDVCPT)
 I X D ERROR^ACDPCCL("Error code="_X_" encountered while deleting V File entry",3)
 I $D(^ACDVIS(ACDVIEN,21,"AC",ACDCSIEN)) S ACDDMIEN=$O(^(ACDCSIEN,0)),ACDVMIEN=$O(^(ACDDMIEN,0)) D
 S DIK="^ACDVIS("_ACDVIEN_",21,"_ACDDMIEN_",11,",DA=ACDVMIEN,DA(1)=ACDDMIEN,DA(2)=ACDVIEN
 D DIK^ACDFMC
 Q
 ;
 ; ***** CHG CALL TO $$DEL^APCDALVR WHEN RELEASED *****
DEL(DIK,DA) ; DELETE ONE V FILE ENTRY
 ;
 ; Meaning of returned values are:
 ;    0 = v file entry deleted
 ;    1 = data global invalid
 ;    2 = no 0th node for data global
 ;    3 = specified file is not a v file
 ;    4 = specified entry is not in specified v file
 ;
 S:DIK DIK=$G(^DIC(DIK,0,"GL")) ;    get data gbl if file #
 I DIK'?1"^".E1"(".E Q 1  ;          data gbl invalid
 S X=$E(DIK,$L(DIK)) ;               get last chr of gbl
 I X'="(",X'="," Q 1  ;              data gbl invalid
 I '$D(@(DIK_"0)")) Q 2  ;           no 0th node for data gbl
 S X=+$P(@(DIK_"0)"),U,2) ;          get file #
 I $P(X,".")'=9000010 Q 3  ;         not a v file
 I X=9000010 Q 3  ;                  not a v file
 I '$D(@(DIK_DA_",0)")) Q 4  ;       entry not in v file
 D DIK^ACDFMC ;                      delete v file entry
 Q 0
