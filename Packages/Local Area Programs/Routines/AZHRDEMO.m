AZHRDEMO ;SANITIZE VA PATIENT FILE [ 04/25/90  9:21 AM ]
 ;MODIFIED ^AZHDDEMO ROUTINE; IHS/DRPMS/RAW 4/20/90
 ;Modified to translate Vowels only in name changes; RAW/DRPMS; 4/16/90
 ;Modified for cities within New Mexico RFD 8-3-88
 ;Modified to kill SSN indexes and change SSN to different number RFD 3-20-89
 ;Modified to translate the patient name RFD/CMB 3-21-89
 W !!,"You can't enter this routine at the top"
 Q 
START ;
 W !!,"All the Last Names of the Patient, both Parents, EOC, NOK"
 W !,"and Other Names will translated (Vowels Only)."
 W !,"First Names will be randomly selected from a table generated"
 W !,"from the VA Patient file, (10% of Total Patients)."
 W !,"Addresses and Cities will also be randomly selected from a"
 W !,"table generated.  The City table will be composed of all the"
 W !,"Communities within the State determined by the Site entered"
 W !,"in the RPMS SITE file."
 W !!,"This routine will sanitize ^DPT by replacing all names, other names,",!,"parents names and mailing addresses with randomly generated substitutes."
 W !,"Will also change the SSN stored in DPT and kill off all indexes set by the SSN data.",!
 W !!,"Do you want to CONTINUE? NO//" R ANS:60
 I ANS=""!(ANS="NO")!(ANS="N") G END
 D INIT
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:DFN'=+DFN  D MAIN
 D END
 Q
INIT ;
 S (MF,SSNMOD,SSN)="",U="^"
 K ^DPT("BS"),^DPT("BS5"),^DPT("SSN"),^AZHRRAND
 S FROM="AEIOUY",TO="EAYUOI"
 D ^AZHRDEM1
 S STCOD=$P(^AUTTLOC(DUZ(2),0),U,14),ZIP=$P(^AUTTLOC(DUZ(2),0),U,15)
 Q
MAIN ;
 S MF=$P(^DPT(DFN,0),U,2) 
 D PNAME 
 D:$D(^DPT(DFN,.24)) PARENTS 
 D CTST D OTHNAME D SSN 
 D:$D(^DPT(DFN,.33)) EMERCON 
 D:$D(^DPT(DFN,.21)) NOK
 Q
PNAME ;EDIT OF PATIENTS NAME
 S AZHRDIC="^DPT("_DFN_",0)",K=1,J=1
 I MF="F" D FEMALEL
 I MF="M" D MALEL
 S DA=DFN,DIE="^DPT(",DR=".01///"_NAME D ^DIE
 W !!,NAME,?30,DFN
 Q
PARENTS ;
 S AZHRDIC="^DPT("_DFN_",.24)",K=1,J=3,FATHER="",MOTHER=""
 D MALEL S:MLN'="" FATHER=NAME
 D FEMALEL S:FLN'="" MOTHER=NAME
 S ^DPT(DFN,.24)=FATHER_"^^"_MOTHER
 W !,?5,FATHER,!,?5,MOTHER
 Q
CTST ;
 D ADDR
 S ^DPT(DFN,.11)=ADDR_"^^^"_CITY_"^"_STCOD_"^"_ZIP
 W !,?5,ADDR,!,?5,CITY," ,",STCOD," ",ZIP
 Q
OTHNAME ;
 S OTDFN=0 F L=0:0 S OTDFN=$O(^DPT(DFN,.01,OTDFN)) Q:OTDFN'=+OTDFN  S AZHRDIC="^DPT("_DFN_",.01,"_OTDFN_",0)",J=1,K=1 D:MF="F" FEMALEL D:MF="M" MALEL D OTHDIE
 Q
OTHDIE ;
 S DA=OTDFN,DIE="^DPT("_DFN_",.01,",DA(1)=DFN,DR=".01///"_NAME D ^DIE
 W !,?5,NAME
 Q
SSN ;TAG TO SANITIZE THE SSN OF PATIENT
 S SSN=$P(^DPT(DFN,0),U,9) Q:SSN=""
 S SSNMOD=SSN S SSN=$E(SSNMOD,1,3) F I=9:-1:4 S SSN=SSN_$E(SSNMOD,I,I)
 S DA=DFN,DIE="^DPT(",DR=".09///"_SSN D ^DIE
 W !,?5,SSN
 Q
EMERCON ;
 S AZHRDIC="^DPT("_DFN_",.33)",K=1,J=1
 D FEMALEL,ADDR Q:FLN=""
 S X(1)=NAME,X(3)=ADDR,X(6)=CITY,X(7)=STCOD,X(8)=ZIP
 W !,?5,NAME,!,?5,ADDR,!,?5,CITY," ,",STCOD," ",ZIP
 F I=1,3,6,7,8 S $P(^DPT(DFN,.33),U,I)=X(I)
 Q
NOK ;
 S AZHRDIC="^DPT("_DFN_",.21)",K=1,J=1
 D MALEL,ADDR Q:MLN=""
 S X(1)=NAME,X(3)=ADDR,X(6)=CITY,X(7)=STCOD,X(8)=ZIP
 W !,?5,NAME,!,?5,ADDR,!,?5,CITY," ,",STCOD," ",ZIP
 F I=1,3,6,7,8 S $P(^DPT(DFN,.21),U,I)=X(I)
 Q
FEMALEL ;
 S LN1=$P($P(@AZHRDIC,U,J),",",1)
 S FLN=$TR(LN1,FROM,TO)
 S X=^AZHRRAND("F",0)-1,FFN=^AZHRRAND("F",$R(X)+1)
 S NAME=FLN_","_FFN
 Q
MALEL ;
 S LN1=$P($P(@AZHRDIC,U,K),",",1)
 S MLN=$TR(LN1,FROM,TO)
 S X=^AZHRRAND("M",0)-1,MFN=^AZHRRAND("M",$R(X)+1)
 S NAME=MLN_","_MFN
 Q
ADDR ;
 S X=^AZHRRAND("A",0)-1,ADDR=^AZHRRAND("A",$R(X)+1)
 S X=^AZHRRAND("S",0)-1,CITY=^AZHRRAND("S",$R(X)+1)
 Q
END ;END OF ROUTINE
 K MF,SSN,SSNMOD,LN,LN1,FROM,TO,MOTHER,FATHER,DFN,OTDFN,CITY,ADDR,ANS,FFN,FLN,L,MFN,MLN,NAME,STCOD,X,AZHRDIC,I,J,K,ZIP
 K ^DPT("BS"),^DPT("BS5"),^DPT("SSN"),^AZHRRAND
 W !!,"End of routine to sanitize Demo database"
 Q
