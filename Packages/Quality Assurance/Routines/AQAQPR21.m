AQAQPR21 ;IHS/ANMC/LJF - PROCEDURES BY PROVIDER; [ 05/27/92  11:28 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;>>> initialize variables  <<<
 S X="ERR^AQAQPR2",@^%ZOSF("TRAP") X ^%ZOSF("BRK")  ;allow break
 K ^UTILITY("AQAQPR2",$J)
 S AQAQDT=AQAQBDT-.0001,AQAQEND=AQAQEDT+.2400
 ;
 ;>>> loop thru visit file by date and screen visit
 F  S AQAQDT=$O(^AUPNVSIT("B",AQAQDT)) Q:AQAQDT=""  Q:AQAQDT>AQAQEND  D
 .S AQAQVDFN=0
 .F  S AQAQVDFN=$O(^AUPNVSIT("B",AQAQDT,AQAQVDFN)) Q:AQAQVDFN=""  D
 ..Q:'$D(^AUPNVSIT(AQAQVDFN,0))  S AQAQV=^(0)
 ..Q:$P(AQAQV,U,11)=1            ;deleted visit
 ..Q:$P(AQAQV,U,9)<3             ;must have prov,pov, & proc entries
 ..Q:"AHIS"'[$P(AQAQV,U,7)       ;service category
 ..Q:$P(AQAQV,U,6)'=DUZ(2)       ;location of encounter
 ..D FINDPROC                    ;get procedures for this visit
 ..Q                             ;get next visit
 ;
NEXT ;>>> go to print rtn <<<
 G ^AQAQPR22
 ;
 ;>>> end of main rtn <<<
 ;
FINDPROC ;***> SUBRTN to get procedures for visits that passed screens
 S (AQAQPDFN,AQAQPRV)=0
 F  S AQAQPDFN=$O(^AUPNVPRC("AD",AQAQVDFN,AQAQPDFN)) Q:AQAQPDFN=""  D
 .Q:'$D(^AUPNVPRC(AQAQPDFN,0))  S AQAQP=^(0)
 .S AQAQICD=$P(^ICD0($P(AQAQP,U),0),U)     ;icd code number
 .S AQAQICDN=$P(^ICD0($P(AQAQP,U),0),U,4)  ;icd narrative
 .I $P(AQAQV,U,7)="H" S AQAQPRV=$P(AQAQP,U,11)   ;oper prov for hosp
 .E  D FINDPROV                   ;get primary provider for visit
 .Q:AQAQPRV=0  Q:AQAQPRV=""       ;bad visit-no primary provider
 .I AQAQTYP=1,AQAQSRT'="" Q:+AQAQSRT'=AQAQPRV  ;not provider asked for
 .S AQAQCLS=$P(^DIC(6,AQAQPRV,0),U,4)  ;provider class
 .I AQAQTYP=2 Q:+AQAQSRT'=AQAQCLS  ;not prov class asked for
 .S AQAQCAT=$P($G(^AQAQC(AQAQPRV,0)),U,2)  ;staff category
 .I AQAQTYP=3 Q:AQAQSRT'=AQAQCAT  ;not category asked for
 .S AQAQX=$P(^DIC(6,AQAQPRV,0),U,4)
 .S:AQAQX'="" AQAQX=$P(^DIC(7,AQAQX,0),U)
 .S AQAQPRV=$P(^DIC(16,AQAQPRV,0),U)_" ("_AQAQX_")"
 .;
 .S AQAQSTR=AQAQPDFN_U_AQAQICDN            ;set data in ^utility
 .S ^UTILITY("AQAQPR2",$J,AQAQPRV,+AQAQICD,AQAQDT,AQAQVDFN)=AQAQSTR Q
 Q                                         ;return to main rtn loop
 ;
 ;
FINDPROV ;***> SUBRTN to find primary provider for ambulatory visits
 S AQAQRDFN=0
 F  S AQAQRDFN=$O(^AUPNVPRV("AD",AQAQVDFN,AQAQRDFN)) Q:AQAQRDFN=""  D
 .Q:'$D(^AUPNVPRV(AQAQRDFN,0))  S AQAQR=^(0)
 .Q:$P(AQAQR,U,4)'="P"          ;find another if not primary provider
 .S AQAQPRV=$P(AQAQR,U)         ;get provider pointer
 Q                              ;return to procedure subrtn
 ;
 ;
HOSPERR ;***> SUBRTN to find all prov for inpt proc without oper provider
 S AQAQRDFN=0
 F  S AQAQRDFN=$O(^AUPNVPRV("AD",AQAQVDFN,AQAQRDFN)) Q:AQAQRDFN=""  D
 .Q:'$D(^AUPNVPRV(AQAQRDFN,0))  S AQAQR=^(0)
 .S AQAQSTR=AQAQVDFN_U_AQAQICDN_U_AQAQPDFN_U_AQAQDT
 .S ^UTILITY("AQAQPR2",$J,"zz",AQAQICD,AQAQVDFN,AQAQRDFN)=AQAQSTR Q
 Q                    ;return to procedure subrtn
