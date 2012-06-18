AQAQPR31 ;IHS/ANMC/LJF - DISCHARGES BY PROVIDER & DX; [ 05/27/92  11:21 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;>>> initialize variables  <<<
 S X="ERR^AQAQPR3",@^%ZOSF("TRAP") X ^%ZOSF("BRK")  ;allow break
 K ^UTILITY("AQAQPR3",$J)
 S AQAQDT=AQAQBDT-.0001,AQAQEND=AQAQEDT+.2400
 ;
 ;>>> loop thru visit file by date and screen visit
LOOP F  S AQAQDT=$O(^AUPNVINP("B",AQAQDT)) Q:AQAQDT=""  Q:AQAQDT>AQAQEND  D
 .S AQAQHDFN=0
 .F  S AQAQHDFN=$O(^AUPNVINP("B",AQAQDT,AQAQHDFN)) Q:AQAQHDFN=""  D
 ..Q:'$D(^AUPNVINP(AQAQHDFN,0))  S AQAQH=^(0)
 ..S AQAQVDFN=$P(AQAQH,U,3) Q:AQAQVDFN=""  ;visit dfn
 ..S AQAQV=^AUPNVSIT(AQAQVDFN,0) ;visit node
 ..Q:$P(AQAQV,U,11)=1            ;deleted visit
 ..Q:$P(AQAQV,U,9)<3             ;must have prov,pov, & proc entries
 ..Q:$P(AQAQV,U,7)'="H"          ;service category
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
 G ^AQAQPR32
 ;
 ;>>> end of main rtn <<<
 ;
FINDDX ;***> SUBRTN to get diagnoses for visits that passed screens
 S (AQAQPDFN)=0
 F  S AQAQPDFN=$O(^AUPNVPOV("AD",AQAQVDFN,AQAQPDFN)) Q:AQAQPDFN=""  D
 .Q:'$D(^AUPNVPOV(AQAQPDFN,0))  S AQAQP=^(0)
 .I AQAQCDX=1 Q:$P(AQAQP,U,12)'="P"        ;check for primary vs sec
 .S AQAQICD=$P(^ICD9($P(AQAQP,U),0),U)     ;icd code number
 .;
 .S AQAQSTR=AQAQPDFN_U_AQAQHDFN      ;set string into ^utility
 .I AQAQICD'?1"V".E S AQAQICD=+AQAQICD  ;to coallate numbers correctly
 .S ^UTILITY("AQAQPR3",$J,AQAQPRV,AQAQICD,AQAQDT,AQAQVDFN)=AQAQSTR Q
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
