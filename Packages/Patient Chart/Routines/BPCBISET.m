BPCBISET ; IHS/OIT/MJL - GUI V IMMUNIZATION VISIT CREATION ;
 ;;1.5;BPC;;MAY 26, 2005
 ;;
GETVISIT(BGUARRAY,BIDATA,BIDUZ2) ;EP CALL
 ;                          FROM REMOTE PROC: BPC IMM VISIT SAVE
 ;BGUARRAY is return array
 ;BPCPDATA is Imm or Skin Array for BIRPC3 Call
 ;BIDUZ2 is DUZ(2) 
EN ;ENTRY POINT FOR TESTING
 ;S BIDATA="I|25241|140|P||3020131.12|||A|True|||||1|||"
 ;S BIDATA="S|25241|3|||3020205.12|131||A|True||O||3020208||||2"
 ;S BIDATA="S|25241|3|||3020205.12|131||A|True||O||||||2"
 ;S BIDATA="S|25241|3|||3020205.12||||False|14505|N|0|3020211||||2"
 ;S BIDATA="I|25241|113|C||3020515.12|2248||A|True|||||-1|||1860^2248"
 ;S BIDUZ2=2248
 S JOB=$J,XWBWRAP=1,BPCGUI=1
 S BPCU=$C(124)
 S BGUARRAY="^XTMP(""BPCIV"","_$J_")"
 K @BGUARRAY
 ;
 ;check patient IEN
 S BPCERR=0
 S BPCPIEN=$P($G(BIDATA),BPCU,2)
 S DFN=BPCPIEN  ;needed to fix Imm call error
 I BPCPIEN="" D  Q:BPCERR
 .S ^XTMP("BPCIV",JOB,1)=-1,^(2)="PATIENT IEN NOT SENT!"
 .D KILL
 .S BPCERR=1
 .Q
 ;
 ;check patient
 S BPCERR=0
 I '$D(^AUPNPAT(BPCPIEN,0)) D  Q:BPCERR
 .S ^XTMP("BPCIV",JOB,1)=-1,^XTMP(2)="PATIENT IEN IS NOT DEFINED!"
 .D KILL
 .S BPCERR=1
 .Q
 ;
 ;check for DUZ(2)
 S BPCERR=0,BIERR=""
 I '$G(BIDUZ2) D  Q:BPCERR
 .S ^XTMP("BPCIV",JOB,1)=-1,^(2)="LOCATION (DUZ(2)) NOT SENT!"
 .D KILL
 .S BPCERR=1
 .Q
 ;call to BIRPC3 Immunization routine
 ;     1 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;     2 - BIDATA  (req) String of data for the Visit to be added.
 ;     3 - BIDUZ2  (req) User DUZ(2) for Site Parameters.
 ;     see routine for BIDATA Array specifics
FJ D ADDEDIT^BIRPC3(.BIERR,BIDATA,BIDUZ2)
 I $L(BIERR)>1 D  Q:BPCERR
 .S BPCU=$C(31)
 .S ^XTMP("BPCIV",JOB,1)=-1,^(2)=$P(BIERR,BPCU,3)
 .D KILL
 .S BPCERR=1
 .Q
 ;
 S ^XTMP("BPCIV",JOB,1)=1,^(2)="IMMUNIZATION SAVED!"
 Q
 ;
KILL ;kill variables
 K BPCPIEN,BIDATA,BIDUZ2B,BPCCTR,BPCU,BPCERR,BIERR
 Q
 ;
