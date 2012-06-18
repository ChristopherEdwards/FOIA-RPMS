AQAQMCC ;IHS/ANMC/LJF - CALCULATE MISSING CREDENTIALS; [ 04/03/95  8:15 AM ]
 ;;2.2;STAFF CREDENTIALS;**4,7**;01 OCT 1992
 ;
 ;
 ;>>>> BEGIN OF MAIN RTOUTINE
 K ^UTILITY("AQAQMC",$J)
 ;
 ;***> loop thru credentials file
 S AQAQ=0
 F  S AQAQ=$O(^AQAQC(AQAQ)) Q:AQAQ'=+AQAQ  D
 .;
 .;**> screen by sort criteria
 .I $D(^DIC(6,AQAQ,"I")),^("I")'="" Q:$P(^("I"),U)'>DT  ;inactive
 .S AQAQS0=$G(^AQAQC(AQAQ,0)),AQAQMS=""
 .S AQAQNM=$P(AQAQS0,U),AQAQCAT=$P(AQAQS0,U,2)
 .I AQAQTYP=2,AQAQSRT'="ALL" Q:$P(^DIC(6,AQAQNM,0),U,4)'=+AQAQSRT
 .I AQAQTYP=3,AQAQSRT'="ALL" Q:AQAQCAT'=AQAQSRT
 .S AQAQSR=$S(AQAQTYP=1:1,AQAQTYP=3:AQAQCAT,1:$P(^DIC(6,AQAQNM,0),U,4))
 .;
 .;**> check for missing credentials
 .F AQAQP=5,7,11 D EDUCACHK
 .F AQAQP=13,14,15,16,18,19 D OTHRCHK
 .S AQAQP=$P(^AQAQC(AQAQ,2),U,6)
 .I AQAQP=""!(AQAQP="N") S AQAQMS=AQAQMS_"P" ;IHS/OKCRDC/BJH 10/5/93 PATCH 4
 .I '$D(^AQAQML("C",AQAQ)) S AQAQMS=AQAQMS_"Z" ;PATCH #7
 .;
 .;**> set node for provider if any credentials are missing
 .Q:AQAQMS=""  ;all okay
 .S AQAQNM=$P(^DIC(16,AQAQNM,0),U)
 .S AQAQRE=$P(AQAQS0,U,3) D LASTREAP
 .S ^UTILITY("AQAQMC",$J,AQAQSR,AQAQNM,AQAQ)=AQAQCAT_U_AQAQRE_U_AQAQMS
 ;
 ;***> go to print routine
 G ^AQAQMCP
 ;
 ;>>>> END OF MAIN ROUTINE <<<<
 ;
 ;
EDUCACHK ;***> SUBRTN to check for missing education credentials
 Q:$P(AQAQS0,U,AQAQP)="NA"
 I $P(AQAQS0,U,AQAQP)'="Y" S AQAQMS=AQAQMS_$P($T(CODE),";;",AQAQP-3) Q
 I $P(AQAQS0,U,AQAQP+1)'="Y" S AQAQMS=AQAQMS_$P($T(CODE),";;",AQAQP-2)
 Q
 ;
OTHRCHK ;***> SUBRTN to check for other missing credentials
 Q:$P(AQAQS0,U,AQAQP)="Y"  Q:$P(AQAQS0,U,AQAQP)="NA"
 S AQAQMS=AQAQMS_$P($T(CODE),";;",AQAQP-3) Q
 ;
LASTREAP ;***> SUBRTN to find last reappointment application date
 S AQAQX=0
 F  S AQAQX=$O(^AQAQC(AQAQ,"R","B",AQAQX)) Q:AQAQX=""  D
 .I '$O(^AQAQC(AQAQ,"R","B",AQAQX)) S AQAQRE=AQAQX
 Q
 ;
CODE ;;A;;B;;C;;D;;E;;F;;G;;H;;I;;J;;K;;L;;M;;N;;O
