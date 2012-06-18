DGMTU2 ;ALB/RMO - Income Utilities ;28 JAN 1992 11:00 am
 ;;5.3;Registration;**33**;Aug 13, 1993
 ;
GETIENS(DFN,DGPRI,DGDT) ;Look-up individual annual income and income relation
 ;                 Input  -- DFN    Patient file IEN
 ;                           DGPRI  Patient Relation IEN
 ;                           DGDT   Date/Time
 ;                 Output -- DGINI  Individual Annual Income IEN
 ;                           DGIRI  Income Relation IEN
 ;                           DGERR  1=ERROR and 0=NO ERROR
 S DGERR=0
 S DGINI=$$GETIN(DFN,DGPRI,DGDT) S:DGINI<0 DGERR=1
 I 'DGERR S DGIRI=$$GETIR(DFN,DGINI) S:DGIRI<0 DGERR=1
 Q
 ;
GETIN(DFN,DGPRI,DGDT) ;Look-up individual annual income
 ;                Add a new entry if one is not found
 ;                 Input  -- DFN    Patient file IEN
 ;                           DGPRI  Patient Relation IEN
 ;                           DGDT   Date/Time
 ;                 Output -- Individual Annual Income IEN 
 N DGINI,DGLY
 S DGLY=$$LYR^DGMTSCU1(DGDT)
 S DGINI=+$$IAI^DGMTU3(DGPRI,DGLY)
 I '$D(^DGMT(408.21,DGINI,0)) S DGINI=$$ADDIN(DFN,DGPRI,DGLY)
GETINQ Q $S(DGINI>0:DGINI,1:-1)
 ;
ADDIN(DFN,DGPRI,DGLY) ;Add a new individual annual income entry
 ;                 Input  -- DFN    Patient file IEN
 ;                           DGPRI  Patient Relation IEN
 ;                           DGLY   Last Year
 ;                 Output -- New Individual Annual Income IEN 
 N DA,DD,DGINI,DGNOW,DIC,DIK,DINUM,DLAYGO,DO,X,Y,%
 D NOW^%DTC S DGNOW=%
 S X=DGLY,(DIC,DIK)="^DGMT(408.21,",DIC(0)="L",DLAYGO=408.21
 D FILE^DICN S DGINI=+Y
 I DGINI>0 L +^DGMT(408.21,DGINI) S $P(^DGMT(408.21,DGINI,0),"^",2)=DGPRI,^("USR")=DUZ_"^"_DGNOW,DA=DGINI D IX1^DIK L -^DGMT(408.21,DGINI)
ADDINQ Q $S(DGINI>0:DGINI,1:-1)
 ;
GETIR(DFN,DGINI) ;Look-up income relation
 ;                Add a new entry if one is not found
 ;                 Input  -- DFN    Patient file IEN
 ;                           DGINI  Individual Annual Income IEN
 ;                 Output -- Income Relation IEN
 N DGIRI
 S DGIRI=+$O(^DGMT(408.22,"AIND",DGINI,0))
 I '$D(^DGMT(408.22,DGIRI,0)) S DGIRI=$$ADDIR(DFN,DGINI)
GETIRQ Q $S(DGIRI>0:DGIRI,1:-1)
 ;
ADDIR(DFN,DGINI) ;Add a new income relation entry
 ;                 Input  -- DFN    Patient file IEN
 ;                           DGINI  Individual Annual Income IEN
 ;                 Output -- New Income Relation IEN
 N DA,DD,DGIRI,DIC,DIK,DINUM,DLAYGO,DO,X,Y
 S X=DFN,(DIC,DIK)="^DGMT(408.22,",DIC(0)="L",DLAYGO=408.22
 D FILE^DICN S DGIRI=+Y
 I DGIRI>0 L +^DGMT(408.22,DGIRI) S $P(^DGMT(408.22,DGIRI,0),"^",2)=DGINI,DA=DGIRI D IX1^DIK L -^DGMT(408.22,DGIRI)
ADDIRQ Q $S(DGIRI>0:DGIRI,1:-1)
