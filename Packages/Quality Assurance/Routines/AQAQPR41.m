AQAQPR41 ;IHS/ANMC/LJF - OUTPT DX BY PROVIDER; [ 05/27/92  11:16 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;>>> initialize variables  <<<
 S X="ERR^AQAQPR4",@^%ZOSF("TRAP") X ^%ZOSF("BRK")  ;allow break
 K ^UTILITY("AQAQPR4",$J)
 S AQAQDT=AQAQBDT-.0001,AQAQEND=AQAQEDT+.2400
 ;
 ;>>> loop thru visit file by date and screen visit
LOOP F  S AQAQDT=$O(^AUPNVSIT("B",AQAQDT)) Q:AQAQDT=""  Q:AQAQDT>AQAQEND  D
 .S AQAQVDFN=0
 .F  S AQAQVDFN=$O(^AUPNVSIT("B",AQAQDT,AQAQVDFN)) Q:AQAQVDFN=""  D
 ..Q:'$D(^AUPNVSIT(AQAQVDFN,0))  S AQAQV=^(0)
 ..Q:$P(AQAQV,U,11)=1            ;deleted visit
 ..Q:$P(AQAQV,U,9)<3             ;must have prov,pov, & proc entries
 ..Q:"AHIS"'[$P(AQAQV,U,7)       ;service category
 ..Q:$P(AQAQV,U,6)'=DUZ(2)       ;location of encounter
 ..D FINDPROV                    ;get primary provider
 ..Q:AQAQPRV=0  Q:AQAQPRV=""       ;bad visit-no primary provider
 ..I AQAQTYP=1,AQAQSRT'="" Q:+AQAQSRT'=AQAQPRV  ;not provider asked for
 ..S AQAQCLS=$P(^DIC(6,AQAQPRV,0),U,4)          ;provider class
 ..I AQAQTYP=2 Q:+AQAQSRT'=AQAQCLS              ;not class asked for
 ..S AQAQCAT=$P($G(^AQAQC(AQAQPRV,0)),U,2)      ;staff category
 ..I AQAQTYP=3 Q:AQAQSRT'=AQAQCAT               ;not category asked for
 ..S:AQAQCLS'="" AQAQCLS=$P(^DIC(7,AQAQCLS,0),U)  ;class name
 ..S AQAQPRV=$P(^DIC(16,AQAQPRV,0),U)_" ("_AQAQCLS_")"
 ..D FINDDX                      ;get diagnoses for this visit
 ..Q                             ;get next visit
 ;
NEXT ;>>> go to print rtn <<<
 G ^AQAQPR42
 ;
 ;>>> end of main rtn <<<
 ;
FINDDX ;***> SUBRTN to get diagnoses for visits that passed screens
 S AQAQPDFN=0
 F  S AQAQPDFN=$O(^AUPNVPOV("AD",AQAQVDFN,AQAQPDFN)) Q:AQAQPDFN=""  D
 .Q:'$D(^AUPNVPOV(AQAQPDFN,0))  S AQAQP=^(0)
 .S AQAQICD=$P(^ICD9($P(AQAQP,U),0),U)     ;icd code number
 .D GETGRP     ;find dx category for icd code
 .;
 .;**> increment count for diagnostic category
 .S ^UTILITY("AQAQPR4",$J,AQAQPRV,AQAQGRP)=$G(^UTILITY("AQAQPR4",$J,AQAQPRV,AQAQGRP))+1 Q
 Q                                         ;return to main rtn loop
 ;
 ;
FINDPROV ;***> SUBRTN to find primary provider for ambulatory visits
 S (AQAQRDFN,AQAQPRV)=0
 F  S AQAQRDFN=$O(^AUPNVPRV("AD",AQAQVDFN,AQAQRDFN)) Q:AQAQRDFN=""  D
 .Q:'$D(^AUPNVPRV(AQAQRDFN,0))  S AQAQR=^(0)
 .Q:$P(AQAQR,U,4)'="P"          ;find another if not primary provider
 .S AQAQPRV=$P(AQAQR,U)         ;get provider pointer
 Q                              ;return to main rtn loop
 ;
 ;
GETGRP ;***> SUBRTN to get diagnostic category
 S AQAQG=$O(^AQACGM("B",+$P(AQAQICD,"."),0)) Q:AQAQG=""
 S AQAQGRP=$P($G(^AQACGM(AQAQG,0)),U,2)  ;group pointer
 S AQAQGN=$G(^AQACCAT(AQAQGRP,0)),AQAQRNG=$P(AQAQGN,U)
 S AQAQGRP="("_AQAQRNG_") "_$P(AQAQGN,U,2)  ;(range)_name
 Q
