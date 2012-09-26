AMEREDDY ; IHS/OIT/SCR - Sub-routine for ER VISIT EDIT of DX information - Overflow from ^AMEREDDX
 ;;3.0;ER VISIT SYSTEM;**3**;DEC 07, 2011;Build 11
 ; SYNC V POV WITH UPDATED DX LIST IN ER VISIT FILE
 ;  
UPVPOV(AMERNDX,AMERODX,AMERNNAR,AMERONAR,AMERDA) ; If a secondary V POV record is edited, sync the corresponding V POV record
 I $G(AMERNDX)'="",$G(AMERNNAR)'="",$G(AMERODX)'="",$G(AMERDA)
 E  Q
 N DIE,DIC,DA,DR,X,Y,Z,%,VIEN,IEN,CSIEN,NOW,STAT,PRVIEN,PS,DFN
 S VIEN=$P($G(^AMERVSIT(AMERDA,0)),U,3) I 'VIEN Q
 I AMERODX=.9999 S OIEN=$O(^ICD9("BA",".9999",0))
 E  S OIEN=+$$CODEN^ICDCODE(AMERODX)
 I OIEN<1 Q
 I AMERNDX=.9999 S IIEN=$O(^ICD9("BA",".9999",0))
 E  S IIEN=+$$CODEN^ICDCODE(AMERNDX)
 I IIEN<1 Q
 S IEN=0
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:'IEN  I +$G(^AUPNVPOV(IEN,0))=OIEN Q
 I 'IEN Q
 S DR="",DA=IEN,DIE="^AUPNVPOV("
EPX ; EP - UPDATE V POV PROPERTIES VIA DIE
 S DFN=$P($G(^AUPNVSIT(VIEN,0)),U,5) I 'DFN Q
 S CSIEN=$P($G(^AUPNVSIT(VIEN,0)),U,8)
 S NOW=$$NOW^XLFDT
 S PRVIEN=$P($G(^AMERVSIT(AMERDA,6)),U,3)
 S PS="S"
 S %=$P($G(^AMERVSIT(AMERDA,5.1)),U,2)
 I %=OIEN S PS="P"
 S DR=""
 I AMERODX'="",AMERNDX'=AMERODX S DR=".01////^S X=IIEN"
 I $D(^AUPNVPOV(DA)),$P(^AUPNVPOV(DA,0),U,2)="" D
 . I DR'="" S DR=DR_";"
 . S DR=DR_".02////^S X=DFN"
 . Q
 I $D(^AUPNVPOV(DA)),$P(^AUPNVPOV(DA,0),U,3)="" D
 . I DR'="" S DR=DR_";"
 . S DR=DR_".03////^S X=VIEN"
 . Q
 I AMERNNAR'=AMERONAR D
 . S NIEN=$$NARR(AMERNNAR) I 'NIEN Q
 . I DR'="" S DR=DR_";"
 . S DR=DR_".04////^S X=NIEN"
 . Q
 I DR'="" S DR=DR_";"
 S DR=DR_".12////^S X=PS;1201////^S X=NOW;1203////^S X=CSIEN;1204////^S X=PRVIEN;"
EPY L +^AUPNVPOV(DA):1 I  D ^DIE L -^AUPNVPOV(DA)
 Q
 ; 
NARR(X) ; RETURN THE IEN OF A PROVIDER NARRATIVE ENTRY - IF NECESSARY CREAT THE ENTRY
 I $G(X)'=""
 E  Q
 N DIC,DLAYGO,Y
 S (DIC,DLAYGO)=9999999.27,DIC(0)="LX"
 D ^DIC I Y=-1 Q ""
 Q +Y
 ; 
DELVPOV(AMERDA,DIEN) ; DELETE THE V POV ENTRY CORRESPONDING TO THE DELETED ER VISIT FILE DX THAT WILL BE DELETED
 I $G(AMERDA),$G(DIEN)
 E  Q
 N DIK,DA,X,Y,Z,%,IIEN,VIEN,IEN,STOP,NIEN,NARR
 S IIEN=+$G(^AMERVSIT(AMERDA,5,DIEN,0)) I 'IIEN Q
 S VIEN=$P($G(^AMERVSIT(AMERDA,0)),U,3) I 'VIEN Q
 S NARR=$G(^AMERVSIT(AMERDA,5,DIEN,1)) I NARR="" Q
 S NIEN=$O(^AUTNPOV("B",NARR,0)) I 'NIEN Q
 S DA=0,STOP=0
 F  Q:STOP  S DA=$O(^AUPNVPOV("AD",VIEN,DA)) Q:'DA  D
 . I +$G(^AUPNVPOV(DA,0))'=IIEN Q
 . I $P($G(^AUPNVPOV(DA,0)),U,4)'=NIEN Q
 . S STOP=1
 . Q
 I 'DA Q
 S DIK="^AUPNVPOV("
 D ^DIK
 Q
 ; 
ADDVPOV(ICD,AMERNNAR,AMERDA) ; EP - ADD NEW V POV ENTRY CORRESPONDING TO NEW ER VISIT FILE DX
 I $G(ICD)'="",$G(AMERNNAR)'="",$G(AMERDA)
 E  Q
 N X,Y,Z,%,DIC,DIE,DA,DR,DLAYGO,VIEN,IIEN,IEN,NIEN,DFN,OIEN
 S VIEN=$P($G(^AMERVSIT(AMERDA,0)),U,3) I 'VIEN Q
 I ICD=.9999 S IIEN=$O(^ICD9("BA",.9999,0))
 E  S IIEN=+$$CODEN^ICDCODE(ICD) I 'IIEN Q
 I IIEN<1 Q
 S IEN=""
 I ICD'=.9999 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:'IEN  I +$G(^AUPNVPOV(IEN,0))=IIEN Q
 I IEN Q  ; THE DX IS ALREADY IN THERE SO QUIT
 S (DIC,DIE,DLAYGO)=9000010.07,DIC(0)="L"
 S X="""`"_IIEN_""""
 D ^DIC I Y=-1 Q
 S OIEN=IIEN,DA=+Y
 D EPX ;  ADD DX TO V POV
 Q
 ; 
