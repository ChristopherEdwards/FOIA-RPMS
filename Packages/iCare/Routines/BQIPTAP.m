BQIPTAP ;PRXM/HC/DLS - Scheduled Visits (Pending); 07 Nov 2005  10:37 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,DFN,DRANGE) ; EP - BQI PATIENT SCHEDULED APPTS
 ;Description
 ;  Retrieves all pending scheduled visits for a patient.
 ;
 ;Input
 ;  DFN - Patient IEN
 ;  DRANGE - Future date to pull future appointments up to and including.
 ;
 ;Output
 ;  DATA - Name of global in which data is stored.
 ;
 N UID,X,BQII,ARRAY,I,CSTCD
 N APDATA,APDTTM,APCLIN,APCLIN,CLIEN,DEFPRV,FMDTTM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTAP",UID))
 K @DATA
 K ^TMP("BQIPTAPT",UID)
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTAP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 ;
 S ARRAY="^TMP(""BQIPTAPT"",UID,"
 D PEND^BSDU2(DFN,0,.ARRAY)
 S DRANGE=$$DATE^BQIUL1($G(DRANGE))
 I DRANGE="" S DRANGE=9999999
 S DRANGE=DRANGE+.2401
 S I=1
 F  S I=$O(^TMP("BQIPTAPT",UID,I)) Q:'I  D
 . S APDATA=^TMP("BQIPTAPT",UID,I)
 . S APDTTM=$P(APDATA,"^"),APCLIN=$P(APDATA,"^",2)
 . S APDTTM=$TR($E(APDTTM,1,7)_$E(APDTTM,9,18),"@"," ")
 . S FMDTTM=$$DATE^BQIUL1(APDTTM)
 . Q:FMDTTM>DRANGE
 . F  Q:$E(APCLIN,$L(APCLIN))'=" "  S APCLIN=$E(APCLIN,1,($L(APCLIN)-1))
 . S CLIEN=^TMP("BQIPTAPT",UID,I,0),DEFPRV=$$DCPRV(CLIEN)
 . S CSTCD="" I CLIEN'="" S CSTCD=$$GET1^DIQ(40.7,CLIEN_",",1,"E")
 . S BQII=BQII+1,@DATA@(BQII)=$$FMTE^BQIUL1($P(APDATA,"^"))_"^"_APCLIN_" "_CSTCD_"^"_DEFPRV_$C(30)
 ;
 ; Drop down to DONE
 ;
DONE ; -- exit code
 K ^TMP("BQIPTAPT",UID)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
HDR ;
 S @DATA@(BQII)="D00015AP_DATE^T00050AP_CLIN^T00050DEF_PRV"_$C(30)
 Q
 ;
DCPRV(CLIEN) ;EP - Loop thru Clinic Providers and Return Default Provider.
 ; DCY returns as the name of the default clinic provider.
 N DCX,DCY,FOUND
 S (DCX,FOUND)=0
 S DCY=$P($G(^SC(CLIEN,0)),U,13)
 I DCY="" D
 . F  S DCX=$O(^SC(CLIEN,"PR",DCX)) Q:'DCX!FOUND  D
 .. I $P($G(^SC(CLIEN,"PR",DCX,0)),U,2)=1 S DCY=+^SC(CLIEN,"PR",DCX,0),FOUND=1
 I $G(DCY) S DCY=$$GET1^DIQ(200,DCY,.01)
 Q $G(DCY)
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
