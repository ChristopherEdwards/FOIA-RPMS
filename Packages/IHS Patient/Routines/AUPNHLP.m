AUPNHLP ; IHS/CMI/LAB - EXECUTABLE HELP ROUTINES FOR IHS DICTIONARIES ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
RRNUMED ;EXECUTABLE HELP FOR R.R. RET. NUMBER EDIT
 G RRNUM1:'$D(^AUPNRRE(DA,0)) S AG("PFX")=$P(^AUPNRRE(DA,0),"^",3) G RRNUM1:AG("PFX")="",RRNUM1:'$D(^AUTTRRP(AG("PFX"),0)) S AG("PFX")=$P(^(0),"^",1)
 I AG("PFX")="H"!(AG("PFX")="MH")!(AG("PFX")="WH")!(AG("PFX")="WCH")!(AG("PFX")="PH")!(AG("PFX")="JA") W !,"The number must be 6 characters long.",! K AG("PFX") Q
RRNUM1 W !,"The number must be 6 or 9 characters long.",! K AG("PFX") Q
