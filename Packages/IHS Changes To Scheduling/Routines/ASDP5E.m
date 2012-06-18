ASDP5E ; IHS/ANMC/LJF - PATCH 5 CALLS; [ 06/22/2000  3:26 PM ]
 ;5.0;IHS SCHEDULING;**5**;MAR 25, 1999
 ;
ENV ;EP; environment check called by patch 5 kids build
 I $T(VCN^AUPNVSIT)="" D  Q
 . S XPDQUIT=2        ;abort install; save global
 . W !!,"AUPN patch #4 not installed; required for MAS patch 5.",!
 W !!,"ENVIRONMENT CHECK OKAY.",!
 Q
