ACHSYROR ; IHS/ITSC/PMF - KILLS OFF DATA SO REGISTERS CAN BE REOPENED ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; Kills off data so Registers can be reopened if the DCR was run
 ; by mistake, or a P.O. positively-absolutely needs to be cut before
 ; tomorrow.
 ;
 ; This should only be run by an experienced CHS programmer.
 ;
 ; Kernel variables must be defined.
 ;
 I DUZ(0)'["@" W !!,"Sorry, your Fileman Access does not allow you to perform this option!" G END
 I '$D(DUZ(2)) D ^XBSITE I '$D(DUZ(2)) W !!,"Your SITE DUZ(2) is not defined. Cannot REOPEN REGISTERS!!" Q
 G END:'$$DIR^XBDIR("Y","Ready to open registers","Y","","","",2)
 S ACHSFY=0,ACHSFL=1
START ;
 S ACHSFY=$O(^ACHS(9,DUZ(2),"FY",ACHSFY))
 G END:ACHSFY=""
 S ACHSREG=$P($G(^ACHS(9,DUZ(2),"FY",ACHSFY,"W",0)),U,3)
 S:ACHSREG="" ACHSREG="UNDEFINED"
 S ACHSDT=$P($G(^ACHS(9,DUZ(2),"FY",ACHSFY,"W",ACHSREG,0)),U,2)
 I ACHSFL=1,ACHSDT="" W !!,"Registers for ",$$FMTE^XLFDT(DT)," have not been closed! Can't re-open!" G END
 S ACHSFL=0
 I ACHSDT'=DT W !!,"Sorry...but I can't open a register that was closed before ",$$FMTE^XLFDT(DT)," (today)." G END
 S $P(^ACHS(9,DUZ(2),"FY",ACHSFY,"W",ACHSREG,0),U,2)=""
 S ACHSDT=9999999-ACHSDT
 K ^ACHS(9,DUZ(2),"FY",ACHSFY,"AR",ACHSDT,ACHSREG)
 W !!,"REGISTER ",ACHSREG," FOR ",ACHSFY," HAS BEEN RE-OPENED!"
 G START
END ;
 I $$DIR^XBDIR("E","Press RETURN....","","","","",4)
 K ACHSFL,ACHSFY,ACHSREG,ACHSDT,DIR
 Q
 ;
