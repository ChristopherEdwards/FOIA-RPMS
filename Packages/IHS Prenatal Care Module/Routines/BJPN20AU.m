BJPN20AU ;GDIT/HS/BEE-Prenatal Care Module 2.0 Post Install (Cont.) ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
AUD(AUD,FILE,FLIEN) ;EP - File audit file entries
 ;
 NEW IBY,IONDT,AFLD
 ;
 ;Pull person who modified
 S IBY=$P($G(AUD),U,4)
 I IBY="",FILE="90680.01" D
 . S IBY=$P($G(AUD(1.04,"I")),U,2)
 . S:IBY="" IBY=$P($G(AUD(1.03,"I")),U,2)
 . S:IBY="" IBY=DUZ
 I IBY="",FILE="9000011" D
 . S IBY=$P($G(AUD(1.03,"I")),U,2)
 . S:IBY="" IBY=DUZ
 ;
 ;Pull date/time modified
 S IONDT=$P($G(AUD),U,3)
 I IONDT="",FILE="90680.01" D
 . S IONDT=$P($G(AUD(1.03,"I")),U,2)
 . S:IONDT="" IONDT=$P($G(AUD(1.01,"I")),U,2)
 . S:IONDT="" IONDT=$$HTFM^DILIBF($J)
 I IONDT="",FILE="9000011" D
 . S IONDT=$P($G(AUD(.03,"I")),U,2)
 . S:IONDT="" IONDT=$$HTFM^DILIBF($J)
 ;
 ;Loop through each entry to be audited
 S AFLD="" F  S AFLD=$O(AUD(AFLD)) Q:AFLD=""  D
 . ;
 . NEW AIEN,DTYPE,IOVALUE,INVALUE,XOVALUE,XNVALUE,DTYPE,NEW
 . ;
 . ;Pull the values
 . S IOVALUE=$P($G(AUD(AFLD,"I")),U)
 . S INVALUE=$P($G(AUD(AFLD,"I")),U,2)
 . S XOVALUE=$P($G(AUD(AFLD,"X")),U)
 . S XNVALUE=$P($G(AUD(AFLD,"X")),U,2)
 . S DTYPE=$P($G(^DD(FILE,AFLD,0)),U,2) Q:DTYPE=""
 . ;
 . ;Create the base entry
 . S AIEN=$$ADD(FILE,FLIEN,IONDT,IBY) Q:'+AIEN
 . ;
 . ;Determine if a new entry
 . S NEW="" I FILE="9000011",AFLD=".01" S NEW="A"
 . I FILE="90680.01",AFLD=".12" S NEW="A"
 . ;
 . ;Save old value if populated
 . I IOVALUE]"" D
 .. S ^DIA(FILE,AIEN,2)=XOVALUE
 .. S ^DIA(FILE,AIEN,2.1)=IOVALUE_U_DTYPE
 . ;
 . ;Save new value
 . S ^DIA(FILE,AIEN,3)=XNVALUE
 . S ^DIA(FILE,AIEN,3.1)=INVALUE_U_DTYPE
 . ;
 . ;Update top entry
 . S $P(^DIA(FILE,AIEN,0),U,2,4)=IONDT_U_AFLD_U_IBY_U_NEW
 ;
 Q
 ;
ADD(%F,FLIEN,ONDT,BY) ;EP - Credit audit entry
 NEW Y
 S Y=$O(^DIA(%F,"A"),-1) I 'Y S ^DIA(%F,0)=$P(^DIC(%F,0),U)_" AUDIT^1.1I"
 F Y=Y+1:1 I '$D(^DIA(%F,Y)) D LOCK^DILF("^DIA(%F,Y)") I  Q:'$D(^DIA(%F,Y))  L -^DIA(%F,Y)
 S ^DIA(%F,Y,0)=FLIEN L -^DIA(%F,Y)
 S $P(^DIA(%F,0),U,3,4)=Y_U_($P(^DIA(%F,0),U,4)+1)
 ;
 S ^DIA(%F,"C",ONDT,Y)="",^DIA(%F,"D",BY,Y)="",^DIA(%F,"B",FLIEN,Y)=""
 Q Y
 ;
OFF(DIFILE,DIFIELD) ;Temporarily turn off auditing for field for file
 ;
 NEW DIOLD,D,DA,DIMODE,DIE,DR
 ;
 ;Handle subfields
 I DIFIELD["," D  I (DIFILE="")!(DIFIELD="") Q
 . S DIFILE=+$P(^DD(DIFILE,$P(DIFIELD,","),0),U,2),DIFIELD=$P(DIFIELD,",",2)
 ;
 S DIOLD=$G(^DD(DIFILE,DIFIELD,"AUDIT")) I DIOLD="" Q DIOLD  ;It's already off
 ;
 ;Skip computed fields - not used for BJPN conversion
 S D=$P($G(^DD(DIFILE,DIFIELD,"AUDIT",0)),U,2) Q:D["C" ""
 ;
 ;Skip word processing fields - not used for BJPN conversion
 I D Q:$P($G(^DD(+D,.01,0)),U,2)["W" ""
 ;
 ;Skip number field
 I DIFIELD=".001" Q ""
 ;
 ;Turn off auditing for field
 S DIMODE="@"
 S DR="1.1////"_DIMODE,DIE="^DD("_DIFILE_",",DA(1)=DIFILE,DA=DIFIELD
 D ^DIE
 ;
 Q DIOLD
 ;
ON(DIFILE,DIFIELD,DIMODE) ;Turn auditing for field for back on
 ;
 NEW DIOLD,D,DA,DIE,DR
 ;
 ;Handle subfields
 I DIFIELD["," D  I (DIFILE="")!(DIFIELD="") Q
 . S DIFILE=+$P(^DD(DIFILE,$P(DIFIELD,","),0),U,2),DIFIELD=$P(DIFIELD,",",2)
 ;
 S DIOLD=$G(^DD(DIFILE,DIFIELD,"AUDIT")) I DIOLD=$G(DIMODE) Q  ;It's already on
 ;
 ;Skip computed fields - not used for BJPN conversion
 S D=$P($G(^DD(DIFILE,DIFIELD,"AUDIT",0)),U,2) Q:D["C"
 ;
 ;Skip word processing fields - not used for BJPN conversion
 I D Q:$P($G(^DD(+D,.01,0)),U,2)["W" ""
 ;
 ;Skip number field
 I DIFIELD=".001" Q
 ;
 ;Turn on auditing for field
 S:$G(DIMODE)="" DIMODE="y"
 S DR="1.1////"_DIMODE,DIE="^DD("_DIFILE_",",DA(1)=DIFILE,DA=DIFIELD
 D ^DIE
 Q
