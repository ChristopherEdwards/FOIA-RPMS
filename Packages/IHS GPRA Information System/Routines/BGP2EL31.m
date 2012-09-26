BGP2EL31 ; IHS/CMI/LAB - measure 1,2,3,4 05 Apr 2010 1:44 PM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
IELDFSA ;EP
 S (BGPD1,BGPD2,BGPD3,BGPD4,BGPD5)=0
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7)=0
 I BGPAGEB<55 S BGPSTOP=1 Q
 I 'BGPACTCL S BGPSTOP=1 Q
 S BGPD1=1
 I BGPAGEB>54,BGPAGEB<65 S BGPD2=1
 I BGPAGEB>64,BGPAGEB<75 S BGPD3=1
 I BGPAGEB>74,BGPAGEB<85 S BGPD4=1
 I BGPAGEB>84 S BGPD5=1
 S BGPVALUE=$$FUNCTION^BGP2EL4(DFN,BGPBDATE,BGPEDATE)
 I $P(BGPVALUE,U) S BGPN1=1
 S BGPVALUE=$S($P(BGPVALUE,U,2)="":"",BGPN1:"YES: ",1:"NO: ")_$P(BGPVALUE,U,2)
 S BGPVALUE="AC|||"_BGPVALUE
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,T,BGPG
 Q
IELDASA ;EP
 S (BGPD1,BGPD2,BGPD3,BGPD4,BGPD5)=0
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7)=0
 I BGPAGEB<55 S BGPSTOP=1 Q
 I 'BGPACTCL S BGPSTOP=1 Q
 S BGPD1=1
 I BGPAGEB>54,BGPAGEB<65 S BGPD2=1
 I BGPAGEB>64,BGPAGEB<75 S BGPD3=1
 I BGPAGEB>74,BGPAGEB<85 S BGPD4=1
 I BGPAGEB>84 S BGPD5=1
 S BGPHOSPL=""
 S BGPN1=$$V2ASTH^BGP2D31(DFN,BGP365,BGPEDATE)
 I BGPN1 S BGPHOSPL=$$HOSP^BGP2D31(DFN,BGP365,BGPEDATE) I BGPHOSPL S BGPN2=1
 S BGPVALUE="AC"_"|||"_$S(BGPN1:$$LAST^BGP2D31(DFN,BGP365,BGPEDATE),1:"")_" "_$S(BGPHOSPL:"H "_$$DATE^BGP2UTL($P(BGPHOSPL,U,2)),1:"")
 K X,Y,Z,%,A,B,C,D,E,H,BDATE,EDATE,P,V,S,F,T,BGPG
 Q
IELDPHA ;EP - PHN
 S (BGPD1,BGPD2,BGPD3,BGPD4,BGPD5)=0
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7)=0
 I BGPAGEB<55 S BGPSTOP=1 Q
 S BGPD1=1
 I BGPAGEB>54,BGPAGEB<65 S BGPD2=1
 I BGPAGEB>64,BGPAGEB<75 S BGPD3=1
 I BGPAGEB>74,BGPAGEB<85 S BGPD4=1
 I BGPAGEB>84 S BGPD5=1
 S BGPVALUE=$$PHNV^BGP2EL4(DFN,BGP365,BGPEDATE,BGPHOME)
 S BGPN1=BGPVALUE
 S BGPVALUE="UP|||"_$P(BGPVALUE,U)_" all PHN; "_$P(BGPVALUE,U,7)_" home; "_$P(BGPVALUE,U,6)_" driver all; "_$P(BGPVALUE,U,12)_" driver home"
 Q
