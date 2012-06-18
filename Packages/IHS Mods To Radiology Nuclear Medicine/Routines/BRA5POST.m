BRA5POST ;IHS/ITSC/CLS - IHS POST INIT FOR RAD/NUC MED 5.0
 ;;5.0;Radiology/Nuclear Medicine;;Feb 20, 2004
EN ;
 D KEY,VAR1,VAR2,RAD Q
KEY ;add 'RA OVERALL' key to the RA OVERALL option
 N IENS,SKIEN,FDA,ERR
 S IENS=$$FIND1^DIC(19,"","","RA OVERALL")
 Q:'IENS  ;quit if option doesn't exist
 S FDA(19,IENS_",",3)="RA OVERALL"
 D FILE^DIE("S","FDA","ERR")
 ;I $G(ERR("DIERR",1)) W ! ZW ERR  ;IHS/CIA/PLS for debugging use
 Q
VAR1 ;modify internal variable and mumps code
 N IENS,SKIEN,FDA,ERR
 S IENS=$$FIND1^DIC(78.7,"","","DATE OF BIRTH (AGE yrs)")
 Q:'IENS  ;quit if option doesn't exist
 S FDA(78.7,IENS_",",5)="RAZDOB"
 S FDA(78.7,IENS_",",100)="S RADOB=$P(RAY0,""^"",3),RADOB=$E(RADOB,4,5)_""-""_$E(RADOB,6,7)_""-""_(1700+$E(RADOB,1,3)),DFN=RADFN D DEM^VADPT S RAZDOB=RADOB_""   (""_VADM(4)_"")"""
 D FILE^DIE("S","FDA","ERR")
 ;I $G(ERR("DIERR",1)) W ! ZW ERR  ;IHS/CIA/PLS for debugging use
 Q
VAR2 ;modify internal variable and mumps code
 N IENS,SKIEN,FDA,ERR
 S IENS=$$FIND1^DIC(78.7,"","","CHART# OF PATIENT (IHS)")
 Q:'IENS  ;quit if option doesn't exist
 S FDA(78.7,IENS_",",5)="RAS"
 S FDA(78.7,IENS_",",100)="S RAS=$$SSN^RAUTL"
 D FILE^DIE("S","FDA","ERR")
 ;I $G(ERR("DIERR",1)) W ! ZW ERR  ;IHS/CIA/PLS for debugging use
 Q
RAD D LINK("RA EVSEND OR","RA IHS HOOK")  ;IHS/CIA/PLS 17-Jan-2002
 Q
 ;
LINK(P,C) ;
 ;Input: P-Parent protocol
 ;       C-Child protocol
 N IENARY,PIEN,AIEN,FDA,ERR
 Q:'$L(P)!('$L(C))
 S IENARY(1)=$$FIND1^DIC(101,"","",P)
 S AIEN=$$FIND1^DIC(101,"","",C)
 Q:'IENARY(1)!'AIEN
 S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 D UPDATE^DIE("S","FDA","IENARY","ERR")
 ;I $G(ERR("DIERR",1)) W ! ZW ERR  ;IHS/CIA/PLS for debugging use
 Q
